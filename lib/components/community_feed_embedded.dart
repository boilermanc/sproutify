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

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await CommunityService.getRecentPosts(limit: 10);
      setState(() {
        _posts = posts;
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _isRefreshing = true;
    });
    await _loadPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFE0F0F2),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Community Feed',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
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
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primary,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(
                            Icons.add_photo_alternate,
                            color: Colors.white,
                            size: 20.0,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
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
          ),
          // Posts List
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            )
          else if (_posts.isEmpty)
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.people_outline,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    size: 48.0,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'No posts yet',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.readexPro(),
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: 8.0),
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
            Container(
              height: 400.0,
              child: RefreshIndicator(
                onRefresh: _refreshPosts,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
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
    );
  }

}

