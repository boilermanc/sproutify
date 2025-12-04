import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'trial_benefits_page_model.dart';
export 'trial_benefits_page_model.dart';

class TrialBenefitsPageWidget extends StatefulWidget {
  const TrialBenefitsPageWidget({super.key});

  static String routeName = 'TrialBenefitsPage';
  static String routePath = '/trialBenefits';

  @override
  State<TrialBenefitsPageWidget> createState() =>
      _TrialBenefitsPageWidgetState();
}

class _TrialBenefitsPageWidgetState extends State<TrialBenefitsPageWidget> {
  late TrialBenefitsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TrialBenefitsPageModel());
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
                            'Unlock the full\nSproutify experience',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.readexPro(
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: FlutterFlowTheme.of(context).primaryText,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),

                        // Benefits list
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 40.0, 0.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Benefit 1 - Tower Management
                              _buildBenefitItem(
                                context: context,
                                icon: Icons.yard_rounded,
                                iconColor: const Color(0xFF2F6D23),
                                iconBgColor: const Color(0xFFDAE5D7),
                                title: 'Unlimited tower & plant tracking',
                                subtitle: 'Manage all your gardens in one place',
                              ),

                              const SizedBox(height: 20.0),

                              // Benefit 2 - pH & EC
                              _buildBenefitItem(
                                context: context,
                                icon: Icons.water_drop_rounded,
                                iconColor: const Color(0xFF2F6D23),
                                iconBgColor: const Color(0xFFDAE5D7),
                                title: 'pH & EC tracking',
                                subtitle: 'Monitor nutrient levels with ease',
                              ),

                              const SizedBox(height: 20.0),

                              // Benefit 3 - Harvest Analytics
                              _buildBenefitItem(
                                context: context,
                                icon: Icons.analytics_rounded,
                                iconColor: const Color(0xFF2F6D23),
                                iconBgColor: const Color(0xFFDAE5D7),
                                title: 'Harvest tracking & analytics',
                                subtitle: 'See your ROI and growth trends',
                              ),

                              const SizedBox(height: 20.0),

                              // Benefit 4 - AI Assistant
                              _buildBenefitItem(
                                context: context,
                                icon: Icons.smart_toy_rounded,
                                iconColor: const Color(0xFF2F6D23),
                                iconBgColor: const Color(0xFFDAE5D7),
                                title: 'AI gardening assistant',
                                subtitle: 'Get personalized growing advice',
                              ),

                              const SizedBox(height: 20.0),

                              // Benefit 5 - Community
                              _buildBenefitItem(
                                context: context,
                                icon: Icons.people_rounded,
                                iconColor: const Color(0xFF2F6D23),
                                iconBgColor: const Color(0xFFDAE5D7),
                                title: 'Grower community',
                                subtitle: 'Connect and share with fellow gardeners',
                              ),

                              const SizedBox(height: 20.0),

                              // Benefit 6 - Daily Tips
                              _buildBenefitItem(
                                context: context,
                                icon: Icons.email_rounded,
                                iconColor: const Color(0xFF2F6D23),
                                iconBgColor: const Color(0xFFDAE5D7),
                                title: 'Daily growing tips',
                                subtitle: 'Expert advice delivered to your inbox',
                              ),
                            ],
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
                    context.pushNamed('TrialTimelinePage');
                  },
                  text: 'Learn More',
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

  Widget _buildBenefitItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon circle
        Container(
          width: 56.0,
          height: 56.0,
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 28.0,
          ),
        ),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.readexPro(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: FlutterFlowTheme.of(context).primaryText,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: GoogleFonts.readexPro(
                    fontSize: 14.0,
                    fontWeight: FontWeight.normal,
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
