import '/flutter_flow/flutter_flow_theme.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dialog displaying community guidelines that users must accept before posting
class CommunityGuidelinesDialog extends StatefulWidget {
  const CommunityGuidelinesDialog({
    super.key,
    this.onAccepted,
  });

  final VoidCallback? onAccepted;

  @override
  State<CommunityGuidelinesDialog> createState() =>
      _CommunityGuidelinesDialogState();
}

class _CommunityGuidelinesDialogState extends State<CommunityGuidelinesDialog> {
  bool _hasScrolledToBottom = false;
  final ScrollController _scrollController = ScrollController();
  bool _isAccepting = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScrollPosition);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_checkScrollPosition);
    _scrollController.dispose();
    super.dispose();
  }

  void _checkScrollPosition() {
    if (_scrollController.hasClients) {
      final isAtBottom = _scrollController.offset >=
          _scrollController.position.maxScrollExtent - 50;
      if (isAtBottom != _hasScrolledToBottom) {
        setState(() {
          _hasScrolledToBottom = isAtBottom;
        });
      }
    }
  }

  Future<void> _acceptGuidelines() async {
    setState(() {
      _isAccepting = true;
    });

    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        throw Exception('User must be authenticated');
      }

      // Update profile with acceptance timestamp
      await SupaFlow.client.from('profiles').update({
        'community_guidelines_accepted_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      if (mounted) {
        Navigator.of(context).pop(true);
        widget.onAccepted?.call();
      }
    } catch (e) {
      print('Error accepting guidelines: $e');
      if (mounted) {
        setState(() {
          _isAccepting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to save acceptance. Please try again.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16.0),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600.0),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 28.0,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      'Community Guidelines',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.readexPro(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to the Sproutify community! To keep our gardening community safe and enjoyable for everyone, please follow these guidelines when posting.',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            font: GoogleFonts.readexPro(),
                            letterSpacing: 0.0,
                          ),
                    ),
                    const SizedBox(height: 24.0),
                    _buildSection(
                      icon: Icons.favorite,
                      title: 'Be Respectful',
                      items: [
                        'Treat fellow gardeners with kindness and respect',
                        'No harassment, bullying, or personal attacks',
                        'No hate speech or discrimination of any kind',
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    _buildSection(
                      icon: Icons.local_florist,
                      title: 'Keep It Relevant',
                      items: [
                        'Posts should be related to gardening, tower gardens, plants, or growing',
                        'No spam, advertisements, or self-promotion',
                        'No off-topic content',
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    _buildSection(
                      icon: Icons.block,
                      title: 'No Objectionable Content',
                      items: [
                        'No nudity, sexual content, or explicit material',
                        'No graphic violence or gore',
                        'No illegal activities or content',
                        'No content that promotes self-harm',
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    _buildSection(
                      icon: Icons.shield,
                      title: 'No Abusive Behavior',
                      items: [
                        'Do not impersonate others',
                        'Do not share others\' personal information',
                        'Do not post misleading or false information',
                        'Do not attempt to scam or deceive other users',
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color:
                            FlutterFlowTheme.of(context).error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context)
                              .error
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.gavel,
                                color: FlutterFlowTheme.of(context).error,
                                size: 20.0,
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                'Enforcement',
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      color: FlutterFlowTheme.of(context).error,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'We have zero tolerance for objectionable content and abusive behavior. Violations may result in content removal, temporary suspension, or permanent account termination.',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.readexPro(),
                                      letterSpacing: 0.0,
                                    ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'We review all reported content within 24 hours. If you see something that violates these guidelines, please use the Report feature.',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.readexPro(),
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context)
                            .primary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Text(
                              'By posting in the Sproutify community, you agree to follow these guidelines. We reserve the right to remove any content and suspend any user who violates these terms.',
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Last updated: December 2024',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.readexPro(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            fontSize: 10.0,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            // Footer with accept button
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  if (!_hasScrolledToBottom)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 20.0,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            'Scroll to read all guidelines',
                            style:
                                FlutterFlowTheme.of(context).bodySmall.override(
                                      font: GoogleFonts.readexPro(),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      letterSpacing: 0.0,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _hasScrolledToBottom && !_isAccepting
                          ? _acceptGuidelines
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FlutterFlowTheme.of(context).primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 0,
                      ),
                      child: _isAccepting
                          ? const SizedBox(
                              height: 20.0,
                              width: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              _hasScrolledToBottom
                                  ? 'I Agree to These Guidelines'
                                  : 'Scroll to Accept',
                              style: FlutterFlowTheme.of(context)
                                  .titleSmall
                                  .override(
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
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: FlutterFlowTheme.of(context).primary,
              size: 24.0,
            ),
            const SizedBox(width: 8.0),
            Text(
              title,
              style: FlutterFlowTheme.of(context).titleMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight: FontWeight.w600,
                    ),
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, right: 8.0),
                    child: Container(
                      width: 6.0,
                      height: 6.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(),
                            letterSpacing: 0.0,
                          ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}


