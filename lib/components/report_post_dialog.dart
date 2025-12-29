import '/flutter_flow/flutter_flow_theme.dart';
import '/services/community_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dialog for reporting a post
class ReportPostDialog extends StatefulWidget {
  const ReportPostDialog({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  State<ReportPostDialog> createState() => _ReportPostDialogState();
}

class _ReportPostDialogState extends State<ReportPostDialog> {
  String? _selectedReason;
  final TextEditingController _additionalInfoController =
      TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, String>> _reportReasons = [
    {'value': 'spam', 'label': 'Spam'},
    {'value': 'inappropriate', 'label': 'Inappropriate Content'},
    {'value': 'unrelated', 'label': 'Unrelated to Community'},
    {'value': 'other', 'label': 'Other'},
  ];

  @override
  void dispose() {
    _additionalInfoController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (_selectedReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a reason for reporting'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await CommunityService.reportPost(
        postId: widget.postId,
        reason: _selectedReason!,
        additionalInfo: _additionalInfoController.text.trim().isNotEmpty
            ? _additionalInfoController.text.trim()
            : null,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true); // Return true to indicate success

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Thank you for your report. We will review it shortly.'),
          backgroundColor: FlutterFlowTheme.of(context).success,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      final errorMessage = e.toString().contains('already reported')
          ? 'You have already reported this post'
          : 'Failed to submit report. Please try again.';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: FlutterFlowTheme.of(context).error,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Report Post',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FontWeight.w600,
                        ),
                        letterSpacing: 0.0,
                      ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              'Help us keep the community safe by reporting content that violates our guidelines.',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 24.0),
            // Reason selection
            Text(
              'Reason for reporting',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w600,
                    ),
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 12.0),
            ..._reportReasons.map((reason) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedReason = reason['value'];
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: _selectedReason == reason['value']
                          ? FlutterFlowTheme.of(context)
                              .primary
                              .withOpacity(0.1)
                          : FlutterFlowTheme.of(context)
                              .alternate
                              .withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: _selectedReason == reason['value']
                            ? FlutterFlowTheme.of(context).primary
                            : Colors.transparent,
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _selectedReason == reason['value']
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: _selectedReason == reason['value']
                              ? FlutterFlowTheme.of(context).primary
                              : FlutterFlowTheme.of(context).secondaryText,
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: Text(
                            reason['label']!,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.readexPro(),
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16.0),
            // Additional info (optional)
            Text(
              'Additional information (optional)',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w600,
                    ),
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _additionalInfoController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Provide any additional details...',
                hintStyle: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.readexPro(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
                filled: true,
                fillColor:
                    FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: FlutterFlowTheme.of(context).primary,
                    width: 2.0,
                  ),
                ),
                contentPadding: const EdgeInsets.all(16.0),
              ),
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(),
                    letterSpacing: 0.0,
                  ),
            ),
            const SizedBox(height: 24.0),
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Submit Report',
                        style: FlutterFlowTheme.of(context).titleSmall.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w600,
                              ),
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

