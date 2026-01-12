import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
// Adjust these imports to match your admin build's structure
// import '/services/community_service.dart';
// import '/backend/supabase/supabase.dart';
// import '/flutter_flow/flutter_flow_theme.dart';

/// Admin moderation page for reviewing reported posts
///
/// This widget allows admins to:
/// - View all reported posts
/// - See report reasons and details
/// - Hide/restore posts
/// - Resolve reports
///
/// Note: Add admin authentication check before allowing access to this page
class AdminModerationWidget extends StatefulWidget {
  const AdminModerationWidget({super.key});

  @override
  State<AdminModerationWidget> createState() => _AdminModerationWidgetState();
}

class _AdminModerationWidgetState extends State<AdminModerationWidget> {
  List<Map<String, dynamic>> _reportedPosts = [];
  bool _isLoading = true;
  String _filter = 'unresolved'; // 'all', 'unresolved', 'resolved'

  @override
  void initState() {
    super.initState();
    _loadReportedPosts();
  }

  Future<void> _loadReportedPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch posts with reports
      // Adjust Supabase client reference to match your admin build
      final reportsResponse = await SupaFlow.client
          .from('post_reports')
          .select('''
            *,
            community_posts!inner(*)
          ''')
          .eq('is_resolved', _filter == 'resolved')
          .order('created_at', ascending: false);

      final List<dynamic> reports = reportsResponse as List<dynamic>;

      // Group reports by post
      final Map<String, Map<String, dynamic>> postsMap = {};

      for (final report in reports) {
        final reportMap = report as Map<String, dynamic>;
        final post = reportMap['community_posts'] as Map<String, dynamic>;
        final postId = post['id'] as String;

        if (!postsMap.containsKey(postId)) {
          postsMap[postId] = {
            'post': post,
            'reports': <Map<String, dynamic>>[],
            'reports_count': 0,
          };
        }

        postsMap[postId]!['reports']!.add(reportMap);
        postsMap[postId]!['reports_count'] =
            (postsMap[postId]!['reports_count'] as int) + 1;
      }

      setState(() {
        _reportedPosts = postsMap.values.toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading reported posts: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading reports: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updatePostStatus({
    required String postId,
    required bool isHidden,
    bool? isApproved,
  }) async {
    try {
      final updates = <String, dynamic>{
        'is_hidden': isHidden,
      };
      if (isApproved != null) {
        updates['is_approved'] = isApproved;
      }

      await SupaFlow.client
          .from('community_posts')
          .update(updates)
          .eq('id', postId);

      // Reload the list
      _loadReportedPosts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isHidden
                ? 'Post hidden successfully'
                : 'Post restored successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error updating post status: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update post: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _deletePost(String postId) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Post'),
        content: const Text(
          'Are you sure you want to permanently delete this post? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await SupaFlow.client.from('community_posts').delete().eq('id', postId);

      _loadReportedPosts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error deleting post: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete post: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _resolveReports(String postId) async {
    try {
      await SupaFlow.client
          .from('post_reports')
          .update({'is_resolved': true}).eq('post_id', postId);

      _loadReportedPosts();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reports marked as resolved'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error resolving reports: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resolve reports: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          'Moderation Queue',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                font: GoogleFonts.readexPro(
                  fontWeight: FontWeight.w600,
                ),
                letterSpacing: 0.0,
              ),
        ),
        actions: [
          // Filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                _buildFilterButton('all', 'All'),
                const SizedBox(width: 8.0),
                _buildFilterButton('unresolved', 'Unresolved'),
                const SizedBox(width: 8.0),
                _buildFilterButton('resolved', 'Resolved'),
              ],
            ),
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadReportedPosts,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            )
          : _reportedPosts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'No reported posts',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.readexPro(),
                                  letterSpacing: 0.0,
                                ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _filter == 'unresolved'
                            ? 'All reports have been resolved!'
                            : 'No posts match the current filter.',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadReportedPosts,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _reportedPosts.length,
                    itemBuilder: (context, index) {
                      final item = _reportedPosts[index];
                      final post = item['post'] as Map<String, dynamic>;
                      final reports =
                          item['reports'] as List<Map<String, dynamic>>;
                      final reportsCount = item['reports_count'] as int;
                      final isHidden = post['is_hidden'] as bool? ?? false;

                      return _buildReportedPostCard(
                        post: post,
                        reports: reports,
                        reportsCount: reportsCount,
                        isHidden: isHidden,
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildFilterButton(String value, String label) {
    final isSelected = _filter == value;
    return InkWell(
      onTap: () {
        setState(() {
          _filter = value;
        });
        _loadReportedPosts();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: isSelected
              ? FlutterFlowTheme.of(context).primary
              : FlutterFlowTheme.of(context).alternate,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          label,
          style: FlutterFlowTheme.of(context).bodySmall.override(
                font: GoogleFonts.readexPro(
                  fontWeight: FontWeight.w600,
                ),
                color: isSelected
                    ? Colors.white
                    : FlutterFlowTheme.of(context).secondaryText,
                letterSpacing: 0.0,
              ),
        ),
      ),
    );
  }

  Widget _buildReportedPostCard({
    required Map<String, dynamic> post,
    required List<Map<String, dynamic>> reports,
    required int reportsCount,
    required bool isHidden,
  }) {
    final postId = post['id'] as String;
    final photoUrl = post['photo_url'] as String? ?? '';
    final caption = post['caption'] as String? ?? '';
    final createdAt = post['created_at'] as String?;
    final userId = post['user_id'] as String?;
    final createdAtDate =
        createdAt != null ? DateTime.tryParse(createdAt) : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: isHidden
              ? FlutterFlowTheme.of(context).error
              : FlutterFlowTheme.of(context).alternate,
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 4.0,
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0.0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post image
          if (photoUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: CachedNetworkImage(
                imageUrl: photoUrl,
                width: double.infinity,
                height: 200.0,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 200.0,
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
                  height: 200.0,
                  color: FlutterFlowTheme.of(context).alternate,
                  child: Icon(
                    Icons.image_not_supported,
                    size: 48.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badges and metadata
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: isHidden
                            ? FlutterFlowTheme.of(context)
                                .error
                                .withOpacity(0.1)
                            : FlutterFlowTheme.of(context)
                                .success
                                .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        isHidden ? 'Hidden' : 'Visible',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w600,
                              ),
                              color: isHidden
                                  ? FlutterFlowTheme.of(context).error
                                  : FlutterFlowTheme.of(context).success,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        '$reportsCount ${reportsCount == 1 ? 'report' : 'reports'}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w600,
                              ),
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    const Spacer(),
                    if (createdAtDate != null)
                      Text(
                        timeago.format(createdAtDate),
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              font: GoogleFonts.readexPro(),
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                  ],
                ),
                if (userId != null) ...[
                  const SizedBox(height: 8.0),
                  Text(
                    'User ID: ${userId.substring(0, 8)}...',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.readexPro(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ],
                const SizedBox(height: 12.0),
                // Caption
                if (caption.isNotEmpty) ...[
                  Text(
                    'Caption:',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.readexPro(
                            fontWeight: FontWeight.w600,
                          ),
                          letterSpacing: 0.0,
                        ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    caption,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.readexPro(),
                          letterSpacing: 0.0,
                        ),
                  ),
                  const SizedBox(height: 12.0),
                ],
                // Reports list
                Text(
                  'Report Reasons:',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FontWeight.w600,
                        ),
                        letterSpacing: 0.0,
                      ),
                ),
                const SizedBox(height: 8.0),
                ...reports.take(5).map((report) {
                  final reason = report['reason'] as String? ?? 'Unknown';
                  final info = report['additional_info'] as String?;
                  final reportDate = report['created_at'] as String?;
                  final reportDateParsed =
                      reportDate != null ? DateTime.tryParse(reportDate) : null;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context)
                          .alternate
                          .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.flag,
                          size: 20.0,
                          color: FlutterFlowTheme.of(context).error,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      reason.toUpperCase(),
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                  ),
                                  if (reportDateParsed != null)
                                    Text(
                                      timeago.format(reportDateParsed),
                                      style: FlutterFlowTheme.of(context)
                                          .bodySmall
                                          .override(
                                            font: GoogleFonts.readexPro(),
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                            fontSize: 10.0,
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                ],
                              ),
                              if (info != null && info.isNotEmpty) ...[
                                const SizedBox(height: 4.0),
                                Text(
                                  info,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                if (reports.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      '... and ${reports.length - 5} more reports',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.readexPro(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                const SizedBox(height: 16.0),
                // Action buttons
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _updatePostStatus(
                          postId: postId,
                          isHidden: !isHidden,
                        ),
                        icon: Icon(
                          isHidden ? Icons.visibility : Icons.visibility_off,
                          size: 18.0,
                        ),
                        label: Text(isHidden ? 'Restore' : 'Hide'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isHidden
                              ? FlutterFlowTheme.of(context).success
                              : FlutterFlowTheme.of(context).error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _resolveReports(postId),
                        icon: const Icon(Icons.check_circle, size: 18.0),
                        label: const Text('Resolve'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          side: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _deletePost(postId),
                        icon: const Icon(Icons.delete, size: 18.0),
                        label: const Text('Delete'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          side: BorderSide(
                            color: FlutterFlowTheme.of(context).error,
                          ),
                          foregroundColor: FlutterFlowTheme.of(context).error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


