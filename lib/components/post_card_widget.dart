import '/flutter_flow/flutter_flow_theme.dart';
import '/models/index.dart';
import '/services/community_service.dart';
import '/backend/supabase/supabase.dart';
import '/components/xp_level_display_widget.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Reusable post card widget for displaying community posts
class PostCardWidget extends StatefulWidget {
  const PostCardWidget({
    super.key,
    required this.post,
    this.onLikeChanged,
    this.onTap,
    this.showFullCaption = false,
  });

  final CommunityPost post;
  final VoidCallback? onLikeChanged;
  final VoidCallback? onTap;
  final bool showFullCaption;

  @override
  State<PostCardWidget> createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  bool _isLiked = false;
  int _likesCount = 0;
  bool _isLiking = false;
  String? _username;
  String? _profilePhotoUrl;
  bool _isLoadingProfile = true;
  bool _isFollowing = false;
  bool _isFollowingLoading = false;
  Map<String, dynamic>? _userGamification;

  @override
  void initState() {
    super.initState();
    _likesCount = widget.post.likesCount;
    _loadUserProfile();
    _checkIfLiked();
    _checkIfFollowing();
    _loadUserGamification();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await ProfilesTable().querySingleRow(
        queryFn: (q) => q.eq('id', widget.post.userId),
      );

      if (!mounted) return;

      if (profile.isNotEmpty) {
        final userProfile = profile.first;
        setState(() {
          // Use same display name logic as CommunityService
          if (userProfile.username != null &&
              userProfile.username!.isNotEmpty) {
            _username = userProfile.username;
          } else {
            final name =
                '${userProfile.firstName ?? ''} ${userProfile.lastName ?? ''}'
                    .trim();
            _username = name.isNotEmpty
                ? name
                : (userProfile.email?.split('@').first ?? 'User');
          }
          _profilePhotoUrl = userProfile.avatarUrl;
          _isLoadingProfile = false;
        });
      } else {
        setState(() {
          _username = 'User';
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
      if (mounted) {
        setState(() {
          _username = 'User';
          _isLoadingProfile = false;
        });
      }
    }
  }

  Future<void> _checkIfLiked() async {
    try {
      final isLiked = await CommunityService.hasUserLikedPost(
        postId: widget.post.id,
      );
      if (mounted) {
        setState(() {
          _isLiked = isLiked;
        });
      }
    } catch (e) {
      print('Error checking if liked: $e');
    }
  }

  Future<void> _checkIfFollowing() async {
    try {
      final isFollowing = await CommunityService.isFollowingUser(
        userId: widget.post.userId,
      );
      if (mounted) {
        setState(() {
          _isFollowing = isFollowing;
        });
      }
    } catch (e) {
      print('Error checking if following: $e');
    }
  }

  Future<void> _loadUserGamification() async {
    try {
      final gamification = await CommunityService.getUserGamification(
        userId: widget.post.userId,
      );
      if (mounted) {
        setState(() {
          _userGamification = gamification;
        });
      }
    } catch (e) {
      print('Error loading user gamification: $e');
    }
  }

  Future<void> _toggleFollow() async {
    if (_isFollowingLoading) return;

    final shouldFollow = !_isFollowing;

    setState(() {
      _isFollowingLoading = true;
      _isFollowing = shouldFollow;
    });

    try {
      if (shouldFollow) {
        await CommunityService.followUser(userId: widget.post.userId);
      } else {
        await CommunityService.unfollowUser(userId: widget.post.userId);
      }

      if (mounted) {
        setState(() {
          _isFollowingLoading = false;
        });
      }
    } catch (e) {
      print('Error toggling follow: $e');

      if (mounted) {
        setState(() {
          _isFollowing = !shouldFollow;
          _isFollowingLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to update follow status. Please try again.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  TextStyle _followButtonTextStyle(BuildContext context) {
    return FlutterFlowTheme.of(context).bodySmall.override(
          font: GoogleFonts.readexPro(
            fontWeight: FontWeight.w600,
          ),
          color: _isFollowing
              ? FlutterFlowTheme.of(context).secondaryText
              : Colors.white,
          letterSpacing: 0.0,
        );
  }

  Future<void> _toggleLike() async {
    if (_isLiking) return;

    if (widget.post.id.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invalid post ID. Please try again.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLiking = true;
    });

    try {
      final result = await CommunityService.toggleLike(
        postId: widget.post.id,
      );

      if (mounted) {
        setState(() {
          _isLiked = result['is_liked'] as bool;
          _likesCount = result['likes_count'] as int;
          _isLiking = false;
        });

        // Notify parent widget if callback provided
        widget.onLikeChanged?.call();
      }
    } catch (e) {
      print('Error toggling like: $e');
      if (mounted) {
        setState(() {
          _isLiking = false;
        });
      }

      // Show error message with actual error details
      if (mounted) {
        final errorMessage = e.toString().contains('Exception:')
            ? e.toString().split('Exception:').last.trim()
            : 'Failed to update like. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: FlutterFlowTheme.of(context).error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return 'just now';
    return timeago.format(timestamp);
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'U';
    final parts = name.trim().split(' ').where((part) => part.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4.0,
              color: Color(0x33000000),
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: User info and timestamp
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile photo or initials
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      shape: BoxShape.circle,
                    ),
                    child:
                        _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: _profilePhotoUrl!,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => Center(
                                    child: Text(
                                      _getInitials(_username),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            font: GoogleFonts.readexPro(),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  _getInitials(_username),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        font: GoogleFonts.readexPro(),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        letterSpacing: 0.0,
                                      ),
                                ),
                              ),
                  ),
                  const SizedBox(width: 12.0),
                  // Username and timestamp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_isLoadingProfile)
                          Container(
                            width: 80.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).alternate,
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          )
                        else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        _username ?? 'User',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              letterSpacing: 0.0,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (widget.post.isFeatured)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 6.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0,
                                            vertical: 2.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.star,
                                                size: 12.0,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 2.0),
                                              Text(
                                                widget.post.featuredType
                                                        .isNotEmpty
                                                    ? widget.post.featuredType
                                                        .split('_')
                                                        .where((word) => word.isNotEmpty)
                                                        .map((word) =>
                                                            word[0]
                                                                .toUpperCase() +
                                                            word.substring(1))
                                                        .join(' ')
                                                    : 'Featured',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodySmall
                                                    .override(
                                                      font:
                                                          GoogleFonts.readexPro(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      color: Colors.white,
                                                      fontSize: 10.0,
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (_userGamification != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: XpLevelDisplayWidget(
                                    level: _userGamification!['current_level']
                                            as int? ??
                                        1,
                                    totalXp: _userGamification!['total_xp']
                                            as int? ??
                                        0,
                                    showProgressBar: false,
                                    compact: true,
                                  ),
                                ),
                            ],
                          ),
                        const SizedBox(height: 2.0),
                        Text(
                          _formatTimestamp(widget.post.createdAt),
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                font: GoogleFonts.readexPro(),
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  // Follow button - only show if not your own post
                  if (!_isLoadingProfile &&
                      currentUserUid != widget.post.userId)
                    InkWell(
                      onTap: _toggleFollow,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: _isFollowing
                              ? FlutterFlowTheme.of(context).secondaryBackground
                              : FlutterFlowTheme.of(context).primary,
                          borderRadius: BorderRadius.circular(16.0),
                          border: _isFollowing
                              ? Border.all(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  width: 1.0,
                                )
                              : null,
                        ),
                        child: _isFollowingLoading
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16.0,
                                    height: 16.0,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        FlutterFlowTheme.of(context).primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    _isFollowing ? 'Following' : 'Follow',
                                    style: _followButtonTextStyle(context),
                                  ),
                                ],
                              )
                            : Text(
                                _isFollowing ? 'Following' : 'Follow',
                                style: _followButtonTextStyle(context),
                              ),
                      ),
                    ),
                ],
              ),
            ),
            // Post Image
            widget.post.photoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.post.photoUrl,
                      width: double.infinity,
                      height: 300.0,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: double.infinity,
                        height: 300.0,
                        color: FlutterFlowTheme.of(context).alternate,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: 300.0,
                        color: FlutterFlowTheme.of(context).alternate,
                        child: Icon(
                          Icons.image_not_supported,
                          color: FlutterFlowTheme.of(context).secondaryText,
                          size: 48.0,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            // Caption and Actions
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Like button and count
                  Row(
                    children: [
                      InkWell(
                        onTap: _toggleLike,
                        child: _isLiking
                            ? SizedBox(
                                width: 24.0,
                                height: 24.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              )
                            : Icon(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: _isLiked
                                    ? FlutterFlowTheme.of(context).error
                                    : FlutterFlowTheme.of(context)
                                        .secondaryText,
                                size: 24.0,
                              ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        '$_likesCount',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w600,
                              ),
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Caption
                  if (widget.post.caption.isNotEmpty)
                    Text(
                      widget.post.caption,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(),
                            letterSpacing: 0.0,
                          ),
                      maxLines: widget.showFullCaption ? null : 2,
                      overflow:
                          widget.showFullCaption ? null : TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
