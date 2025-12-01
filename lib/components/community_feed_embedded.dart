import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/models/index.dart';
import '/services/community_service.dart';
import '/components/post_card_widget.dart';
import '/components/create_post_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Embedded community feed widget for home page
class CommunityFeedEmbedded extends StatefulWidget {
  const CommunityFeedEmbedded({super.key});

  @override
  State<CommunityFeedEmbedded> createState() => _CommunityFeedEmbeddedState();
}

class _CommunityFeedEmbeddedState extends State<CommunityFeedEmbedded> {
  List<CommunityPost> _posts = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  double _communityDragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    // Defer loading slightly to avoid blocking initial render
    // Use postFrameCallback to ensure UI is rendered first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Small delay to ensure Supabase is ready, but not too long
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) {
            _loadPosts();
          }
        });
      }
    });
  }

  Future<void> _loadPosts() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await CommunityService.getRecentPosts(limit: 10);
      if (mounted) {
        setState(() {
          _posts = posts;
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      print('Error loading posts: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _refreshPosts() async {
    if (!mounted) return;
    setState(() {
      _isRefreshing = true;
    });
    await _loadPosts();
  }

  void _expandToFullPage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE0F0F2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 8.0),
                  child: Container(
                    width: 40.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .secondaryText
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ),
                // Header
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 8.0, 16.0, 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Community Feed',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  letterSpacing: 0.0,
                                ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreatePostWidget(
                                    onPostCreated: () {
                                      _loadPosts();
                                    },
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primary,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Icon(
                                Icons.add_photo_alternate,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          if (_isRefreshing)
                            SizedBox(
                              width: 16.0,
                              height: 16.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  FlutterFlowTheme.of(context).primary,
                                ),
                              ),
                            )
                          else
                            InkWell(
                              onTap: _refreshPosts,
                              child: Icon(
                                Icons.refresh,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 20.0,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Posts List
                Expanded(
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlutterFlowTheme.of(context).primary,
                            ),
                          ),
                        )
                      : _posts.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    size: 48.0,
                                  ),
                                  const SizedBox(height: 16.0),
                                  Text(
                                    'No posts yet',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.readexPro(),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Be the first to share your garden!',
                                    style: FlutterFlowTheme.of(context)
                                        .bodySmall
                                        .override(
                                          font: GoogleFonts.readexPro(),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _refreshPosts,
                              child: ListView.builder(
                                controller: scrollController,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                itemCount: _posts.length,
                                itemBuilder: (context, index) {
                                  final post = _posts[index];
                                  return PostCardWidget(
                                    post: post,
                                    onLikeChanged: () {
                                      _loadPosts();
                                    },
                                    onTap: () {
                                      // Already in full page view
                                    },
                                  );
                                },
                              ),
                            ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < 0) {
          // Dragging up
          setState(() {
            _communityDragOffset += details.delta.dy;
          });
        }
      },
      onVerticalDragEnd: (details) {
        if (_communityDragOffset < -80) {
          // Threshold reached, expand to full page
          _expandToFullPage();
        }
        // Reset position
        setState(() {
          _communityDragOffset = 0.0;
        });
      },
      child: Transform.translate(
        offset: Offset(0.0, _communityDragOffset.clamp(-50.0, 0.0)),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F0F2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with drag handle
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 8.0),
                child: Column(
                  children: [
                    // Drag handle with arrow icon
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 0.0, 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: FlutterFlowTheme.of(context)
                                .secondaryText
                                .withOpacity(0.6),
                            size: 24.0,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Community Feed',
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                font: GoogleFonts.readexPro(
                                  fontWeight: FontWeight.w600,
                                ),
                                letterSpacing: 0.0,
                              ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Create Post Button
                            InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreatePostWidget(
                                      onPostCreated: () {
                                        // Refresh posts after creating
                                        _loadPosts();
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: const Icon(
                                  Icons.add_photo_alternate,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            // Refresh Button
                            if (_isRefreshing)
                              SizedBox(
                                width: 16.0,
                                height: 16.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              )
                            else
                              InkWell(
                                onTap: _refreshPosts,
                                child: Icon(
                                  Icons.refresh,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 20.0,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Posts List
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                )
              else if (_posts.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_outline,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 48.0,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'No posts yet',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(),
                              letterSpacing: 0.0,
                            ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Be the first to share your garden!',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.readexPro(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                )
              else
                SizedBox(
                  height: 400.0,
                  child: RefreshIndicator(
                    onRefresh: _refreshPosts,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: _posts.length,
                      itemBuilder: (context, index) {
                        final post = _posts[index];
                        return PostCardWidget(
                          post: post,
                          onLikeChanged: () {
                            // Refresh posts when like changes
                            _loadPosts();
                          },
                          onTap: () {
                            // Navigate to full community feed
                            context.pushNamed('community');
                          },
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
