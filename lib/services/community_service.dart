import '/backend/supabase/supabase.dart';
import '/backend/supabase/storage/storage.dart';
import '/flutter_flow/upload_data.dart';
import '/models/index.dart';
import '/auth/supabase_auth/auth_util.dart';

/// Service class for community-related operations
class CommunityService {
  static const String _bucketName = 'community-posts';
  static const int _defaultPostLimit = 20;

  /// Fetch recent posts from the community
  /// 
  /// [limit] - Maximum number of posts to fetch (default: 20)
  /// Returns a list of CommunityPost models
  static Future<List<CommunityPost>> getRecentPosts({
    int limit = _defaultPostLimit,
  }) async {
    try {
      final response = await SupaFlow.client
          .from('community_posts')
          .select()
          .eq('is_approved', true)
          .eq('is_hidden', false)
          .order('created_at', ascending: false)
          .limit(limit);

      final List<dynamic> posts = response as List<dynamic>;
      return posts
          .map((post) => CommunityPost.fromMap(
              Map<String, dynamic>.from(post as Map)))
          .toList();
    } catch (e) {
      print('Error fetching recent posts: $e');
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
      final userId = currentUserUid;
      if (userId.isEmpty) {
        throw Exception('User must be authenticated to create a post');
      }

      final response = await SupaFlow.client.rpc('create_community_post', params: {
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
      final response = await SupaFlow.client.rpc('get_personalized_feed', params: {
        'p_user_id': userId,
        'p_feed_type': 'following',
        'p_limit': limit,
      });

      if (response == null) {
        return [];
      }

      final List<dynamic> posts = response as List<dynamic>;
      return posts
          .map((post) => _mapFeedPostToCommunityPost(post as Map<String, dynamic>))
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
      final response = await SupaFlow.client.rpc('get_personalized_feed', params: {
        'p_user_id': userId,
        'p_feed_type': 'popular',
        'p_limit': limit,
      });

      if (response == null) {
        return [];
      }

      final List<dynamic> posts = response as List<dynamic>;
      return posts
          .map((post) => _mapFeedPostToCommunityPost(post as Map<String, dynamic>))
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
      final response = await SupaFlow.client
          .from('community_posts')
          .select()
          .eq('is_approved', true)
          .eq('is_hidden', false)
          .eq('is_featured', true)
          .order('created_at', ascending: false)
          .limit(limit);

      final List<dynamic> posts = response as List<dynamic>;
      return posts
          .map((post) => CommunityPost.fromMap(
              Map<String, dynamic>.from(post as Map)))
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
      final response = await SupaFlow.client.rpc('get_personalized_feed', params: {
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

      final mappedPosts = posts
          .map((post) => _mapFeedPostToCommunityPost(post as Map<String, dynamic>))
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
    // Map the feed post structure to CommunityPost structure
    // The get_personalized_feed function returns: id, user_id (not post_id, post_user_id)
    // But it might also be called with different field names, so we check both
    return CommunityPost.fromMap({
      'id': post['post_id'] ?? post['id'] ?? '',
      'user_id': post['post_user_id'] ?? post['user_id'] ?? '',
      'photo_url': post['photo_url'],
      'photo_aspect_ratio': post['photo_aspect_ratio'] ?? 1.0,
      'caption': post['caption'],
      'tower_id': post['tower_id'],
      'location_city': post['location_city'],
      'location_state': post['location_state'],
      'is_featured': post['is_featured'] ?? false,
      'featured_type': post['featured_type'],
      'is_approved': true,
      'is_hidden': false,
      'view_count': post['view_count'] ?? 0,
      'likes_count': post['likes_count'] ?? 0,
      'comments_count': post['comments_count'] ?? 0,
      'shares_count': 0,
      'reports_count': 0,
      'created_at': post['created_at'],
      'updated_at': post['created_at'] ?? post['updated_at'],
    });
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
  static String _getDisplayName(String? username, String? firstName, String? lastName) {
    if (username != null && username.isNotEmpty) {
      return username;
    }
    final name = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    return name.isNotEmpty ? name : 'User';
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

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);

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

      return Map<String, dynamic>.from(response as Map);
    } catch (e) {
      print('Error fetching user gamification: $e');
      return null;
    }
  }
}

