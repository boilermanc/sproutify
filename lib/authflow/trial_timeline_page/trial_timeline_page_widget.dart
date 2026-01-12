import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'trial_timeline_page_model.dart';
export 'trial_timeline_page_model.dart';

class TrialTimelinePageWidget extends StatefulWidget {
  const TrialTimelinePageWidget({super.key});

  static String routeName = 'TrialTimelinePage';
  static String routePath = '/trialTimeline';

  @override
  State<TrialTimelinePageWidget> createState() =>
      _TrialTimelinePageWidgetState();
}

class _TrialTimelinePageWidgetState extends State<TrialTimelinePageWidget> {
  late TrialTimelinePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrialTimelinePageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Header with close button
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        context.goNamed('HomePage');
                      },
                      child: Icon(
                        Icons.close_rounded,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 28.0,
                      ),
                    ),
                  ],
                ),
              ),

              // Main content - scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Sproutify logo/icon
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                          child: Container(
                            width: 120.0,
                            height: 120.0,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDF8EA),
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(
                                'assets/images/Sproutify.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        // Title
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 32.0, 0.0, 0.0),
                          child: Text(
                            'How your Sproutify\nfree trial works',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.readexPro(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),

                        // Timeline section
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Timeline Item 1 - Today
                              _buildTimelineItem(
                                context: context,
                                icon: Icons.eco_rounded,
                                iconColor: const Color(0xFF2F6D23),
                                iconBgColor: const Color(0xFFDAE5D7),
                                title: 'Today',
                                description: 'Get unlimited access + daily growing tips in your inbox',
                                isFirst: true,
                                isLast: false,
                              ),

                              // Timeline Item 2 - Days 1-6
                              _buildTimelineItem(
                                context: context,
                                icon: Icons.email_outlined,
                                iconColor: const Color(0xFF2F6D23),
                                iconBgColor: const Color(0xFFDAE5D7),
                                title: 'Days 1-6',
                                description: 'We\'ll email you tips & check on your garden progress',
                                isFirst: false,
                                isLast: false,
                              ),

                              // Timeline Item 3 - Day 7
                              _buildTimelineItem(
                                context: context,
                                icon: Icons.calendar_today_rounded,
                                iconColor: const Color(0xFF2F6D23),
                                iconBgColor: const Color(0xFFDAE5D7),
                                title: 'Day 7',
                                description: 'Your subscription begins. Cancel anytime before to avoid charges.',
                                isFirst: false,
                                isLast: true,
                              ),
                            ],
                          ),
                        ),

                        // Features preview
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F8F5),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'What you\'ll get access to:',
                                    style: GoogleFonts.readexPro(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2F6D23),
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                  const SizedBox(height: 12.0),
                                  _buildFeatureRow(context, 'Unlimited tower & plant tracking'),
                                  _buildFeatureRow(context, 'pH & EC logging'),
                                  _buildFeatureRow(context, 'Harvest tracking & analytics'),
                                  _buildFeatureRow(context, 'AI gardening assistant'),
                                  _buildFeatureRow(context, 'Daily tips via email'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom button
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 24.0),
                child: FFButtonWidget(
                  onPressed: () {
                    // Mark that user has seen the trial timeline
                    FFAppState().update(() {
                      FFAppState().hasSeenTrialTimeline = true;
                    });
                    // Complete setup and go to home
                    context.goNamed('HomePage');
                  },
                  text: 'Start Your Free Trial',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 56.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: GoogleFonts.readexPro(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                    ),
                    elevation: 2.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
    required bool isFirst,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline connector and icon
        Column(
          children: [
            // Icon circle
            Container(
              width: 48.0,
              height: 48.0,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: iconColor,
                  width: 2.0,
                ),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24.0,
              ),
            ),
            // Connector line (only if not last item)
            if (!isLast)
              Container(
                width: 2.0,
                height: 60.0,
                color: const Color(0xFFDAE5D7),
              ),
          ],
        ),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 4.0, 0.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.readexPro(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: GoogleFonts.readexPro(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                if (!isLast) const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureRow(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 6.0, 0.0, 0.0),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: Color(0xFF2F6D23),
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.readexPro(
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
                color: FlutterFlowTheme.of(context).primaryText,
                letterSpacing: 0.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
