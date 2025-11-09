import '/flutter_flow/flutter_flow_theme.dart';
import '/models/index.dart';
import '/services/community_service.dart';
import '/backend/supabase/supabase.dart';
import '/components/xp_level_display_widget.dart';
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

      if (profile.isNotEmpty) {
        final userProfile = profile.first;
        setState(() {
          _username = userProfile.username ??
              '${userProfile.firstName ?? ''} ${userProfile.lastName ?? ''}'.trim();
          if (_username!.isEmpty) {
            _username = userProfile.email?.split('@').first ?? 'User';
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
      setState(() {
        _username = 'User';
        _isLoadingProfile = false;
      });
    }
  }

  Future<void> _checkIfLiked() async {
    try {
      final isLiked = await CommunityService.hasUserLikedPost(
        postId: widget.post.id,
      );
      setState(() {
        _isLiked = isLiked;
      });
    } catch (e) {
      print('Error checking if liked: $e');
    }
  }

  Future<void> _checkIfFollowing() async {
    try {
      final isFollowing = await CommunityService.isFollowingUser(
        userId: widget.post.userId,
      );
      setState(() {
        _isFollowing = isFollowing;
      });
    } catch (e) {
      print('Error checking if following: $e');
    }
  }

  Future<void> _loadUserGamification() async {
    try {
      final gamification = await CommunityService.getUserGamification(
        userId: widget.post.userId,
      );
      setState(() {
        _userGamification = gamification;
      });
    } catch (e) {
      print('Error loading user gamification: $e');
    }
  }

  Future<void> _toggleFollow() async {
    if (_isFollowingLoading) return;

    setState(() {
      _isFollowingLoading = true;
    });

    try {
      if (_isFollowing) {
        await CommunityService.unfollowUser(userId: widget.post.userId);
      } else {
        await CommunityService.followUser(userId: widget.post.userId);
      }
      setState(() {
        _isFollowing = !_isFollowing;
        _isFollowingLoading = false;
      });
    } catch (e) {
      print('Error toggling follow: $e');
      setState(() {
        _isFollowingLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update follow status. Please try again.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  Future<void> _toggleLike() async {
    if (_isLiking) return;

    setState(() {
      _isLiking = true;
    });

    try {
      final result = await CommunityService.toggleLike(
        postId: widget.post.id,
      );

      setState(() {
        _isLiked = result['is_liked'] as bool;
        _likesCount = result['likes_count'] as int;
        _isLiking = false;
      });

      // Notify parent widget if callback provided
      widget.onLikeChanged?.call();
    } catch (e) {
      print('Error toggling like: $e');
      setState(() {
        _isLiking = false;
      });
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update like. Please try again.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
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
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
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
              padding: EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Profile photo or initials
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primary,
                      shape: BoxShape.circle,
                    ),
                    child: _profilePhotoUrl != null && _profilePhotoUrl!.isNotEmpty
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
                  SizedBox(width: 12.0),
                  // Username and timestamp
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                      ),
                                    ),
                                    if (widget.post.isFeatured)
                                      Padding(
                                        padding: EdgeInsets.only(left: 6.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 6.0,
                                            vertical: 2.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 12.0,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 2.0),
                                              Text(
                                                widget.post.featuredType.isNotEmpty
                                                    ? widget.post.featuredType
                                                        .split('_')
                                                        .map((word) => word[0]
                                                            .toUpperCase() +
                                                            word.substring(1))
                                                        .join(' ')
                                                    : 'Featured',
                                                style: FlutterFlowTheme.of(context)
                                                    .bodySmall
                                                    .override(
                                                      font: GoogleFonts.readexPro(
                                                        fontWeight: FontWeight.w600,
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
                                XpLevelDisplayWidget(
                                  level: _userGamification!['current_level'] as int? ?? 1,
                                  totalXp: _userGamification!['total_xp'] as int? ?? 0,
                                  showProgressBar: false,
                                  compact: true,
                                ),
                            ],
                          ),
                        SizedBox(height: 2.0),
                        Text(
                          _formatTimestamp(widget.post.createdAt),
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                font: GoogleFonts.readexPro(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                                letterSpacing: 0.0,
                              ),
                        ),
                      ],
                    ),
                  ),
                  // Follow button
                  if (!_isLoadingProfile)
                    InkWell(
                      onTap: _toggleFollow,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
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
                            ? SizedBox(
                                width: 16.0,
                                height: 16.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              )
                            : Text(
                                _isFollowing ? 'Following' : 'Follow',
                                style: FlutterFlowTheme.of(context)
                                    .bodySmall
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      color: _isFollowing
                                          ? FlutterFlowTheme.of(context).secondaryText
                                          : Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                      ),
                    ),
                ],
              ),
            ),
            // Post Image
            ClipRRect(
              borderRadius: BorderRadius.only(
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
            ),
            // Caption and Actions
            Padding(
              padding: EdgeInsets.all(12.0),
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
                                _isLiked ? Icons.favorite : Icons.favorite_border,
                                color: _isLiked
                                    ? FlutterFlowTheme.of(context).error
                                    : FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '$_likesCount',
                        style: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w600,
                              ),
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  // Caption
                  if (widget.post.caption.isNotEmpty)
                    Text(
                      widget.post.caption,
                      style: FlutterFlowTheme.of(context)
                          .bodyMedium
                          .override(
                            font: GoogleFonts.readexPro(),
                            letterSpacing: 0.0,
                          ),
                      maxLines: widget.showFullCaption ? null : 2,
                      overflow: widget.showFullCaption
                          ? null
                          : TextOverflow.ellipsis,
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

