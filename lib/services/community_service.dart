import '/backend/supabase/supabase.dart';
import '/flutter_flow/upload_data.dart';
import '/models/index.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'dart:async';

/// Service class for community-related operations
class CommunityService {
  static const String _bucketName = 'community-posts';
  static const int _defaultPostLimit = 20;
  static const int _maxRetries = 2; // Reduced retries for faster failure
  static const Duration _retryDelay =
      Duration(milliseconds: 500); // Faster retry

  // Cache for profanity words (loaded from database)
  static List<String>? _cachedProfanityWords;
  static DateTime? _cacheTimestamp;
  static const Duration _cacheExpiry = Duration(hours: 1);

  /// Load profanity words from database (with caching)
  ///
  /// Returns a list of enabled profanity words
  static Future<List<String>> _loadProfanityWords() async {
    // Return cached words if still valid
    if (_cachedProfanityWords != null &&
        _cacheTimestamp != null &&
        DateTime.now().difference(_cacheTimestamp!) < _cacheExpiry) {
      return _cachedProfanityWords!;
    }

    try {
      final response = await SupaFlow.client
          .from('profanity_filter')
          .select('word')
          .eq('enabled', true);

      final List<dynamic> words = response as List<dynamic>;
      _cachedProfanityWords = words
          .map((item) => (item as Map<String, dynamic>)['word'] as String)
          .toList();
      _cacheTimestamp = DateTime.now();

      return _cachedProfanityWords!;
    } catch (e) {
      print('Error loading profanity words from database: $e');
      // Fallback to empty list if database query fails
      // This ensures the app continues to work even if the table doesn't exist yet
      return [];
    }
  }

  /// Clear the profanity words cache
  /// Call this when words are updated in the database
  static void clearProfanityCache() {
    _cachedProfanityWords = null;
    _cacheTimestamp = null;
  }

  /// Check if text contains profanity
  ///
  /// [text] - Text to check
  ///
  /// Returns true if profanity is detected
  static Future<bool> containsProfanity(String text) async {
    if (text.isEmpty) return false;

    final profanityWords = await _loadProfanityWords();
    if (profanityWords.isEmpty) return false; // No words loaded, allow post

    final lowerText = text.toLowerCase();
    for (final word in profanityWords) {
      if (lowerText.contains(word.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  /// Helper method to retry a function with exponential backoff
  static Future<T> _retryWithBackoff<T>(
    Future<T> Function() fn, {
    int maxRetries = _maxRetries,
    Duration initialDelay = _retryDelay,
  }) async {
    int attempt = 0;
    Exception? lastException;
    while (attempt < maxRetries) {
      try {
        return await fn();
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        attempt++;
        if (attempt >= maxRetries) {
          break;
        }
        // Wait before retrying - only delay after first attempt fails
        if (attempt > 0) {
          await Future.delayed(initialDelay * attempt);
        }
      }
    }
    throw lastException ?? Exception('Max retries exceeded');
  }

  /// Fetch recent posts from the community
  ///
  /// [limit] - Maximum number of posts to fetch (default: 20)
  /// Returns a list of CommunityPost models
  static Future<List<CommunityPost>> getRecentPosts({
    int limit = _defaultPostLimit,
  }) async {
    try {
      // Get list of blocked user IDs
      final blockedUserIds = await getBlockedUserIds();

      final response = await _retryWithBackoff(() async {
        return await SupaFlow.client
            .from('community_posts')
            .select()
            .eq('is_approved', true)
            .eq('is_hidden', false)
            .order('created_at', ascending: false)
            .limit(limit * 2); // Fetch more to account for filtering
      });

      final List<dynamic> posts = response as List<dynamic>;

      // Filter out posts from blocked users client-side
      final filteredPosts = blockedUserIds.isEmpty
          ? posts
          : posts.where((post) {
              final postMap = post as Map<String, dynamic>;
              final userId = postMap['user_id'] as String?;
              return userId != null && !blockedUserIds.contains(userId);
            }).toList();

      // Limit to requested amount after filtering
      final limitedPosts = filteredPosts.take(limit).toList();

      return limitedPosts
          .map((post) =>
              CommunityPost.fromMap(Map<String, dynamic>.from(post as Map)))
          .toList();
    } catch (e) {
      // Handle network errors gracefully
      if (e.toString().contains('HandshakeException') ||
          e.toString().contains('SocketException') ||
          e.toString().contains('Connection')) {
        print(
            'Network error fetching recent posts (this may be temporary): $e');
      } else {
        print('Error fetching recent posts: $e');
      }
      return [];
    }
  }

  /// Create a new community post
  ///
  /// [photoUrl] - URL of the uploaded photo
  /// [photoAspectRatio] - Aspect ratio of the photo (default: 1.0)
  /// [caption] - Optional caption text
  /// [towerId] - Optional tower ID reference
  /// [locationCity] - Optional city location
  /// [locationState] - Optional state location
  /// [plantIds] - Optional list of plant IDs to tag
  /// [hashtagTags] - Optional list of hashtag strings (without #)
  ///
  /// Returns the created post ID and badge information
  static Future<Map<String, dynamic>> createPost({
    required String photoUrl,
    double photoAspectRatio = 1.0,
    String? caption,
    int? towerId,
    String? locationCity,
    String? locationState,
    List<int>? plantIds,
    List<String>? hashtagTags,
  }) async {
    try {
      // Content filtering: Check caption for profanity
      if (caption != null && caption.isNotEmpty) {
        if (await containsProfanity(caption)) {
          throw Exception(
            'Your post contains inappropriate language. Please revise your caption and try again.',
          );
        }
      }
      final userId = currentUserUid;
      if (userId.isEmpty) {
        throw Exception('User must be authenticated to create a post');
      }

      final response =
          await SupaFlow.client.rpc('create_community_post', params: {
        'p_user_id': userId,
        'p_photo_url': photoUrl,
        'p_photo_aspect_ratio': photoAspectRatio,
        'p_caption': caption,
        'p_tower_id': towerId,
        'p_location_city': locationCity,
        'p_location_state': locationState,
        'p_plant_ids': plantIds ?? [],
        'p_hashtag_tags': hashtagTags ?? [],
      });

      if (response == null) {
        throw Exception('Failed to create post: No response from server');
      }

      final Map<String, dynamic> result =
          Map<String, dynamic>.from(response as Map);

      if (result['success'] == true) {
        return result;
      } else {
        throw Exception('Failed to create post: ${result['error']}');
      }
    } catch (e) {
      print('Error creating post: $e');
      rethrow;
    }
  }

  /// Toggle like on a post (like if not liked, unlike if already liked)
  ///
  /// [postId] - ID of the post to like/unlike
  ///
  /// Returns a map with 'is_liked' (bool) and 'likes_count' (int)
  static Future<Map<String, dynamic>> toggleLike({
    required String postId,
  }) async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        throw Exception('User must be authenticated to like a post');
      }

      final response = await SupaFlow.client.rpc('toggle_post_like', params: {
        'p_post_id': postId,
        'p_user_id': userId,
      });

      if (response == null) {
        throw Exception('Failed to toggle like: No response from server');
      }

      final Map<String, dynamic> result =
          Map<String, dynamic>.from(response as Map);

      if (result['success'] == true) {
        return {
          'is_liked': result['is_liked'] as bool,
          'likes_count': result['likes_count'] as int,
        };
      } else {
        throw Exception('Failed to toggle like: ${result['error']}');
      }
    } catch (e) {
      print('Error toggling like: $e');
      rethrow;
    }
  }

  /// Upload a photo to Supabase Storage
  ///
  /// [selectedFile] - The file to upload (SelectedFile from upload_data.dart)
  /// [userId] - Optional user ID, defaults to current user
  ///
  /// Returns the public URL of the uploaded photo
  static Future<String> uploadPhoto({
    required SelectedFile selectedFile,
    String? userId,
  }) async {
    try {
      final uploadUserId = userId ?? currentUserUid;
      if (uploadUserId.isEmpty) {
        throw Exception('User must be authenticated to upload a photo');
      }

      // Create storage path: {user_id}/post_{timestamp}.{ext}
      final timestamp = DateTime.now().microsecondsSinceEpoch;
      final extension = selectedFile.storagePath.split('.').last;
      final storagePath = '$uploadUserId/post_$timestamp.$extension';

      // Create a new SelectedFile with the correct storage path
      final fileToUpload = SelectedFile(
        storagePath: storagePath,
        filePath: selectedFile.filePath,
        bytes: selectedFile.bytes,
        dimensions: selectedFile.dimensions,
        blurHash: selectedFile.blurHash,
      );

      // Upload to storage
      final photoUrl = await uploadSupabaseStorageFile(
        bucketName: _bucketName,
        selectedFile: fileToUpload,
      );

      return photoUrl;
    } catch (e) {
      print('Error uploading photo: $e');
      rethrow;
    }
  }

  /// Check if the current user has liked a specific post
  ///
  /// [postId] - ID of the post to check
  ///
  /// Returns true if the user has liked the post, false otherwise
  static Future<bool> hasUserLikedPost({
    required String postId,
  }) async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        return false;
      }

      final response = await SupaFlow.client
          .from('post_likes')
          .select()
          .eq('post_id', postId)
          .eq('user_id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking if user liked post: $e');
      return false;
    }
  }

  /// Get user's community profile
  ///
  /// [userId] - Optional user ID, defaults to current user
  ///
  /// Returns UserCommunityProfile or null if not found
  static Future<UserCommunityProfile?> getUserProfile({
    String? userId,
  }) async {
    try {
      final profileUserId = userId ?? currentUserUid;
      if (profileUserId.isEmpty) {
        return null;
      }

      final response = await SupaFlow.client
          .from('user_community_profiles')
          .select()
          .eq('user_id', profileUserId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserCommunityProfile.fromMap(
          Map<String, dynamic>.from(response as Map));
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  /// Follow a user
  ///
  /// [userId] - ID of the user to follow
  ///
  /// Returns true if successful, false otherwise
  static Future<bool> followUser({
    required String userId,
  }) async {
    try {
      final currentUserId = currentUserUid;
      if (currentUserId.isEmpty) {
        throw Exception('User must be authenticated to follow someone');
      }

      if (currentUserId == userId) {
        throw Exception('Cannot follow yourself');
      }

      await SupaFlow.client.from('user_follows').insert({
        'follower_id': currentUserId,
        'following_id': userId,
      });

      return true;
    } catch (e) {
      print('Error following user: $e');
      // If already following, that's okay
      if (e.toString().contains('duplicate') ||
          e.toString().contains('unique')) {
        return true;
      }
      rethrow;
    }
  }

  /// Unfollow a user
  ///
  /// [userId] - ID of the user to unfollow
  ///
  /// Returns true if successful, false otherwise
  static Future<bool> unfollowUser({
    required String userId,
  }) async {
    try {
      final currentUserId = currentUserUid;
      if (currentUserId.isEmpty) {
        throw Exception('User must be authenticated to unfollow someone');
      }

      await SupaFlow.client
          .from('user_follows')
          .delete()
          .eq('follower_id', currentUserId)
          .eq('following_id', userId);

      return true;
    } catch (e) {
      print('Error unfollowing user: $e');
      rethrow;
    }
  }

  /// Check if the current user is following another user
  ///
  /// [userId] - ID of the user to check
  ///
  /// Returns true if following, false otherwise
  static Future<bool> isFollowingUser({
    required String userId,
  }) async {
    try {
      final currentUserId = currentUserUid;
      if (currentUserId.isEmpty) {
        return false;
      }

      final response = await SupaFlow.client
          .from('user_follows')
          .select()
          .eq('follower_id', currentUserId)
          .eq('following_id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking if following user: $e');
      return false;
    }
  }

  /// Get posts from users the current user is following
  ///
  /// [limit] - Maximum number of posts to fetch (default: 20)
  ///
  /// Returns a list of CommunityPost models
  static Future<List<CommunityPost>> getFollowingFeed({
    int limit = _defaultPostLimit,
  }) async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        return [];
      }

      // Use the get_personalized_feed function with 'following' type
      final response =
          await SupaFlow.client.rpc('get_personalized_feed', params: {
        'p_user_id': userId,
        'p_feed_type': 'following',
        'p_limit': limit,
      });

      if (response == null) {
        return [];
      }

      final List<dynamic> posts = response as List<dynamic>;

      // Filter out posts from blocked users
      final blockedUserIds = await getBlockedUserIds();
      final filteredPosts = blockedUserIds.isEmpty
          ? posts
          : posts.where((post) {
              final postMap = post as Map<String, dynamic>;
              final userId = postMap['user_id'] as String?;
              return userId != null && !blockedUserIds.contains(userId);
            }).toList();

      return filteredPosts
          .map((post) =>
              _mapFeedPostToCommunityPost(post as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching following feed: $e');
      return [];
    }
  }

  /// Get popular posts (sorted by engagement)
  ///
  /// [limit] - Maximum number of posts to fetch (default: 20)
  ///
  /// Returns a list of CommunityPost models
  static Future<List<CommunityPost>> getPopularFeed({
    int limit = _defaultPostLimit,
  }) async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        return [];
      }

      // Use the get_personalized_feed function with 'popular' type
      final response =
          await SupaFlow.client.rpc('get_personalized_feed', params: {
        'p_user_id': userId,
        'p_feed_type': 'popular',
        'p_limit': limit,
      });

      if (response == null) {
        return [];
      }

      final List<dynamic> posts = response as List<dynamic>;

      // Filter out posts from blocked users
      final blockedUserIds = await getBlockedUserIds();
      final filteredPosts = blockedUserIds.isEmpty
          ? posts
          : posts.where((post) {
              final postMap = post as Map<String, dynamic>;
              final userId = postMap['user_id'] as String?;
              return userId != null && !blockedUserIds.contains(userId);
            }).toList();

      return filteredPosts
          .map((post) =>
              _mapFeedPostToCommunityPost(post as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error fetching popular feed: $e');
      return [];
    }
  }

  /// Get featured posts
  ///
  /// [limit] - Maximum number of posts to fetch (default: 20)
  ///
  /// Returns a list of CommunityPost models that are featured
  static Future<List<CommunityPost>> getFeaturedPosts({
    int limit = _defaultPostLimit,
  }) async {
    try {
      // Get list of blocked user IDs
      final blockedUserIds = await getBlockedUserIds();

      final response = await SupaFlow.client
          .from('community_posts')
          .select()
          .eq('is_approved', true)
          .eq('is_hidden', false)
          .eq('is_featured', true)
          .order('created_at', ascending: false)
          .limit(limit * 2); // Fetch more to account for filtering

      final List<dynamic> posts = response as List<dynamic>;

      // Filter out posts from blocked users client-side
      final filteredPosts = blockedUserIds.isEmpty
          ? posts
          : posts.where((post) {
              final postMap = post as Map<String, dynamic>;
              final userId = postMap['user_id'] as String?;
              return userId != null && !blockedUserIds.contains(userId);
            }).toList();

      // Limit to requested amount after filtering
      final limitedPosts = filteredPosts.take(limit).toList();

      return limitedPosts
          .map((post) =>
              CommunityPost.fromMap(Map<String, dynamic>.from(post as Map)))
          .toList();
    } catch (e) {
      print('Error fetching featured posts: $e');
      return [];
    }
  }

  /// Get "For You" personalized feed (algorithm-based recommendations)
  ///
  /// [limit] - Maximum number of posts to fetch (default: 20)
  ///
  /// Returns a list of CommunityPost models sorted by relevance
  static Future<List<CommunityPost>> getForYouFeed({
    int limit = _defaultPostLimit,
  }) async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        // If no user, fall back to recent posts
        return await getRecentPosts(limit: limit);
      }

      // Use the get_personalized_feed function with 'for_you' type
      final response =
          await SupaFlow.client.rpc('get_personalized_feed', params: {
        'p_user_id': userId,
        'p_feed_type': 'for_you',
        'p_limit': limit,
      });

      if (response == null) {
        // If For You feed is empty, fall back to recent posts
        print('For You feed empty, falling back to recent posts');
        return await getRecentPosts(limit: limit);
      }

      final posts = response as List;
      if (posts.isEmpty) {
        // If no posts in For You feed, fall back to recent posts
        return await getRecentPosts(limit: limit);
      }

      // Filter out posts from blocked users
      final blockedUserIds = await getBlockedUserIds();
      final filteredPosts = blockedUserIds.isEmpty
          ? posts
          : posts.where((post) {
              final postMap = post as Map<String, dynamic>;
              final userId = postMap['user_id'] as String?;
              return userId != null && !blockedUserIds.contains(userId);
            }).toList();

      final mappedPosts = filteredPosts
          .map((post) =>
              _mapFeedPostToCommunityPost(post as Map<String, dynamic>))
          .toList();

      // If mapping resulted in empty list, fall back to recent posts
      if (mappedPosts.isEmpty) {
        print('For You feed mapping failed, falling back to recent posts');
        return await getRecentPosts(limit: limit);
      }

      return mappedPosts;
    } catch (e) {
      print('Error fetching For You feed: $e');
      // Fall back to recent posts on error
      try {
        return await getRecentPosts(limit: limit);
      } catch (fallbackError) {
        print('Error fetching recent posts as fallback: $fallbackError');
        return [];
      }
    }
  }

  /// Helper method to map feed post data to CommunityPost
  static CommunityPost _mapFeedPostToCommunityPost(Map<String, dynamic> post) {
    // Normalize RPC response into the flat structure CommunityPost expects.
    final normalized = <String, dynamic>{
      'id': post['post_id'] ?? post['id'] ?? '',
      'user_id': post['post_user_id'] ?? post['user_id'] ?? '',
      'photo_url': post['photo_url'],
      'photo_aspect_ratio': _parseDouble(post['photo_aspect_ratio']),
      'caption': post['caption'],
      'tower_id': _parseNullableInt(post['tower_id']),
      'location_city': post['location_city'],
      'location_state': post['location_state'],
      'is_featured': post['is_featured'] ?? false,
      'featured_type': post['featured_type'],
      'is_approved': true,
      'is_hidden': false,
      'view_count': _parseNullableInt(post['view_count']) ?? 0,
      'likes_count': _parseNullableInt(post['likes_count']) ?? 0,
      'comments_count': _parseNullableInt(post['comments_count']) ?? 0,
      'shares_count': 0,
      'reports_count': 0,
      'created_at': _normalizeDate(post['created_at']),
      'updated_at': _normalizeDate(post['updated_at'] ?? post['created_at']),
    };

    return CommunityPost.fromMap(normalized);
  }

  static double _parseDouble(dynamic value, [double fallback = 1.0]) {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? fallback;
    }
    return fallback;
  }

  static int? _parseNullableInt(dynamic value) {
    if (value == null) return null;
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static String? _normalizeDate(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is DateTime) {
      return value.toIso8601String();
    }
    return value.toString();
  }

  /// Search for users by username or name
  ///
  /// [query] - Search query string
  /// [limit] - Maximum number of results (default: 20)
  ///
  /// Returns a list of user profiles with basic info
  static Future<List<Map<String, dynamic>>> searchUsers({
    required String query,
    int limit = 20,
  }) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      // Search in profiles table for username, first_name, or last_name
      final response = await SupaFlow.client
          .from('profiles')
          .select('id, username, first_name, last_name, avatar_url')
          .or('username.ilike.%$query%,first_name.ilike.%$query%,last_name.ilike.%$query%')
          .limit(limit);

      final List<dynamic> users = response as List<dynamic>;
      return users
          .map((user) => {
                'id': user['id'] as String,
                'username': user['username'] as String? ?? '',
                'first_name': user['first_name'] as String? ?? '',
                'last_name': user['last_name'] as String? ?? '',
                'avatar_url': user['avatar_url'] as String?,
                'display_name': _getDisplayName(
                  user['username'] as String?,
                  user['first_name'] as String?,
                  user['last_name'] as String?,
                ),
              })
          .toList();
    } catch (e) {
      print('Error searching users: $e');
      return [];
    }
  }

  /// Helper method to get display name from user data
  /// Formats names as "First L." when both names exist, otherwise uses available name
  /// Falls back to username if available, then "Gardener" as final fallback
  static String _getDisplayName(
      String? username, String? firstName, String? lastName) {
    // If both first and last names exist, format as "First L."
    if (firstName != null &&
        firstName.isNotEmpty &&
        lastName != null &&
        lastName.isNotEmpty) {
      return '$firstName ${lastName[0]}.';
    }

    // If only first name exists
    if (firstName != null && firstName.isNotEmpty) {
      return firstName;
    }

    // If only last name exists
    if (lastName != null && lastName.isNotEmpty) {
      return lastName;
    }

    // If username is available (when names are missing)
    if (username != null && username.isNotEmpty) {
      return username;
    }

    // Final fallback
    return 'Gardener';
  }

  /// Get unread notifications count for the current user
  ///
  /// Returns the count of unread notifications
  static Future<int> getUnreadNotificationsCount() async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        return 0;
      }

      final response = await SupaFlow.client
          .from('community_notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false);

      final List<dynamic> notifications = response as List<dynamic>;
      return notifications.length;
    } catch (e) {
      print('Error fetching unread notifications count: $e');
      return 0;
    }
  }

  /// Get recent notifications for the current user
  ///
  /// [limit] - Maximum number of notifications to fetch (default: 20)
  /// [includeRead] - Whether to include read notifications (default: false)
  ///
  /// Returns a list of notification maps
  static Future<List<Map<String, dynamic>>> getNotifications({
    int limit = 20,
    bool includeRead = false,
  }) async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        return [];
      }

      var query = SupaFlow.client
          .from('community_notifications')
          .select()
          .eq('user_id', userId);

      if (!includeRead) {
        query = query.eq('is_read', false);
      }

      final response =
          await query.order('created_at', ascending: false).limit(limit);

      final List<dynamic> notifications = response as List<dynamic>;
      return notifications
          .map((notif) => Map<String, dynamic>.from(notif as Map))
          .toList();
    } catch (e) {
      print('Error fetching notifications: $e');
      return [];
    }
  }

  /// Mark a notification as read
  ///
  /// [notificationId] - ID of the notification to mark as read
  ///
  /// Returns true if successful
  static Future<bool> markNotificationAsRead({
    required String notificationId,
  }) async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        throw Exception('User must be authenticated');
      }

      await SupaFlow.client
          .from('community_notifications')
          .update({'is_read': true})
          .eq('id', notificationId)
          .eq('user_id', userId);

      return true;
    } catch (e) {
      print('Error marking notification as read: $e');
      rethrow;
    }
  }

  /// Get user badges with progress information
  ///
  /// [userId] - Optional user ID, defaults to current user
  /// [filter] - Filter type: 'all', 'earned', or 'locked' (default: 'all')
  ///
  /// Returns a map with 'user_stats', 'categories', and 'badges' arrays
  static Future<Map<String, dynamic>> getUserBadges({
    String? userId,
    String filter = 'all',
  }) async {
    try {
      final profileUserId = userId ?? currentUserUid;
      if (profileUserId.isEmpty) {
        throw Exception('User must be authenticated');
      }

      final response = await SupaFlow.client.rpc('get_user_badges', params: {
        'p_user_id': profileUserId,
        'p_filter': filter,
      });

      if (response == null) {
        throw Exception('Failed to fetch badges: No response from server');
      }

      return Map<String, dynamic>.from(response as Map);
    } catch (e) {
      print('Error fetching user badges: $e');
      rethrow;
    }
  }

  /// Get user gamification stats (XP, level, badges count)
  ///
  /// [userId] - Optional user ID, defaults to current user
  ///
  /// Returns a map with total_xp, current_level, badges_earned, etc.
  static Future<Map<String, dynamic>?> getUserGamification({
    String? userId,
  }) async {
    try {
      final profileUserId = userId ?? currentUserUid;
      if (profileUserId.isEmpty) {
        return null;
      }

      final response = await SupaFlow.client
          .from('user_gamification')
          .select()
          .eq('user_id', profileUserId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      final gamification = Map<String, dynamic>.from(response as Map);

      // Calculate actual badge count from user_badges table
      final badgeResponse = await SupaFlow.client
          .from('user_badges')
          .select('id')
          .eq('user_id', profileUserId);

      final actualBadgeCount = (badgeResponse as List).length;

      // Override the stored count with the actual count
      gamification['badges_earned'] = actualBadgeCount;

      return gamification;
    } catch (e) {
      print('Error fetching user gamification: $e');
      return null;
    }
  }

  /// Report a post for inappropriate content
  ///
  /// [postId] - ID of the post to report
  /// [reason] - Reason for reporting: 'spam', 'inappropriate', 'unrelated', or 'other'
  /// [additionalInfo] - Optional additional information about the report
  ///
  /// Returns true if successful
  static Future<bool> reportPost({
    required String postId,
    required String reason,
    String? additionalInfo,
  }) async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        throw Exception('User must be authenticated to report a post');
      }

      if (postId.isEmpty) {
        throw Exception('Post ID is required');
      }

      // Check if user has already reported this post
      final existingReport = await SupaFlow.client
          .from('post_reports')
          .select()
          .eq('user_id', userId)
          .eq('post_id', postId)
          .maybeSingle();

      if (existingReport != null) {
        throw Exception('You have already reported this post');
      }

      // Insert the report
      // Note: The database trigger (handle_post_report) will automatically:
      // 1. Increment reports_count on the post
      // 2. Auto-hide the post if reports_count >= 3
      await SupaFlow.client.from('post_reports').insert({
        'user_id': userId,
        'post_id': postId,
        'reason': reason,
        'additional_info': additionalInfo,
        'is_resolved': false,
      });

      return true;
    } catch (e) {
      print('Error reporting post: $e');
      rethrow;
    }
  }

  /// Block a user
  ///
  /// [userId] - ID of the user to block
  ///
  /// Returns true if successful
  static Future<bool> blockUser({
    required String userId,
  }) async {
    try {
      final blockerId = currentUserUid;
      if (blockerId.isEmpty) {
        throw Exception('User must be authenticated to block a user');
      }

      if (userId == blockerId) {
        throw Exception('You cannot block yourself');
      }

      // Check if already blocked
      final existingBlock = await SupaFlow.client
          .from('user_blocks')
          .select()
          .eq('blocker_id', blockerId)
          .eq('blocked_id', userId)
          .maybeSingle();

      if (existingBlock != null) {
        return true; // Already blocked
      }

      // Insert the block
      await SupaFlow.client.from('user_blocks').insert({
        'blocker_id': blockerId,
        'blocked_id': userId,
      });

      return true;
    } catch (e) {
      print('Error blocking user: $e');
      rethrow;
    }
  }

  /// Unblock a user
  ///
  /// [userId] - ID of the user to unblock
  ///
  /// Returns true if successful
  static Future<bool> unblockUser({
    required String userId,
  }) async {
    try {
      final blockerId = currentUserUid;
      if (blockerId.isEmpty) {
        throw Exception('User must be authenticated to unblock a user');
      }

      // Delete the block
      await SupaFlow.client
          .from('user_blocks')
          .delete()
          .eq('blocker_id', blockerId)
          .eq('blocked_id', userId);

      return true;
    } catch (e) {
      print('Error unblocking user: $e');
      rethrow;
    }
  }

  /// Check if a user is blocked by the current user
  ///
  /// [userId] - ID of the user to check
  ///
  /// Returns true if the user is blocked
  static Future<bool> isUserBlocked({
    required String userId,
  }) async {
    try {
      final blockerId = currentUserUid;
      if (blockerId.isEmpty || userId.isEmpty) {
        return false;
      }

      final response = await SupaFlow.client
          .from('user_blocks')
          .select()
          .eq('blocker_id', blockerId)
          .eq('blocked_id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('Error checking if user is blocked: $e');
      return false;
    }
  }

  /// Get list of blocked user IDs for the current user
  ///
  /// Returns a list of user IDs that are blocked
  static Future<List<String>> getBlockedUserIds() async {
    try {
      final blockerId = currentUserUid;
      if (blockerId.isEmpty) {
        return [];
      }

      final response = await SupaFlow.client
          .from('user_blocks')
          .select('blocked_id')
          .eq('blocker_id', blockerId);

      final List<dynamic> blocks = response as List<dynamic>;
      return blocks
          .map((block) =>
              (block as Map<String, dynamic>)['blocked_id'] as String)
          .toList();
    } catch (e) {
      print('Error fetching blocked users: $e');
      return [];
    }
  }

  /// Check if user has accepted community guidelines
  ///
  /// Returns true if user has accepted, false otherwise
  static Future<bool> hasAcceptedGuidelines() async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        return false;
      }

      final response = await SupaFlow.client
          .from('profiles')
          .select('community_guidelines_accepted_at')
          .eq('id', userId)
          .single();

      final acceptedAt = response['community_guidelines_accepted_at'];
      return acceptedAt != null;
    } catch (e) {
      print('Error checking guidelines acceptance: $e');
      return false;
    }
  }
}
