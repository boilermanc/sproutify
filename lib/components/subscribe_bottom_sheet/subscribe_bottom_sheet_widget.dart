import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app_state.dart';
import '/config/env.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/revenue_cat_util.dart' as revenue_cat;
import '/pages/subscription_page/subscription_page_widget.dart';

/// Returns `true` if the user has an active trial or subscription.
/// If not, shows the subscribe bottom sheet and returns `false`.
Future<bool> checkSubscriptionAccess(BuildContext context) async {
  if (!Env.enableFeatureGating) return true;
  final status = FFAppState().subscriptionStatus;
  if (status == 'trial' || status == 'active') return true;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    enableDrag: true,
    builder: (context) => const SubscribeBottomSheetWidget(),
  );
  return false;
}

class SubscribeBottomSheetWidget extends StatefulWidget {
  const SubscribeBottomSheetWidget({super.key});

  @override
  State<SubscribeBottomSheetWidget> createState() =>
      _SubscribeBottomSheetWidgetState();
}

class _SubscribeBottomSheetWidgetState extends State<SubscribeBottomSheetWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isRestoring = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _restorePurchases() async {
    setState(() => _isRestoring = true);
    try {
      await revenue_cat.restorePurchases();
      final customerInfo = revenue_cat.customerInfo;
      if (customerInfo != null &&
          customerInfo.entitlements.active.isNotEmpty) {
        FFAppState().update(() {
          FFAppState().subscriptionStatus = 'active';
        });
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Purchases restored successfully!',
                style: GoogleFonts.readexPro(),
              ),
              backgroundColor: FlutterFlowTheme.of(context).success,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No active subscription found.',
                style: GoogleFonts.readexPro(),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Unable to restore purchases. Please try again.',
              style: GoogleFonts.readexPro(),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationController,
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        snap: true,
        snapSizes: const [0.75, 0.95],
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      0.0, 12.0, 0.0, 8.0),
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

                // Title
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 16.0, 24.0, 0.0),
                  child: Text(
                    'Unlock Full Access',
                    style: GoogleFonts.outfit(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      color: FlutterFlowTheme.of(context).primaryText,
                    ),
                  ),
                ),

                // Subtitle
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 8.0, 24.0, 0.0),
                  child: Text(
                    'Subscribe to get everything you need to grow',
                    style: GoogleFonts.readexPro(
                      fontSize: 14.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                  ),
                ),

                const SizedBox(height: 8.0),

                Divider(
                  thickness: 1.0,
                  color: FlutterFlowTheme.of(context)
                      .secondaryText
                      .withOpacity(0.15),
                ),

                // Benefits list
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 16.0, 24.0, 0.0),
                    children: [
                      _buildBenefitRow(
                        context,
                        Icons.yard_rounded,
                        'Add plants & towers',
                        'Track everything you grow',
                      ),
                      _buildBenefitRow(
                        context,
                        Icons.water_drop_rounded,
                        'Log pH & EC readings',
                        'Monitor your water quality',
                      ),
                      _buildBenefitRow(
                        context,
                        Icons.smart_toy_rounded,
                        'Sage AI assistant',
                        'Get personalized growing advice',
                      ),
                      _buildBenefitRow(
                        context,
                        Icons.people_rounded,
                        'Community posting',
                        'Share photos and connect with growers',
                      ),
                      _buildBenefitRow(
                        context,
                        Icons.analytics_rounded,
                        'Costs & harvest tracking',
                        'See your ROI and growth trends',
                      ),
                    ],
                  ),
                ),

                // Subscribe button
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 16.0, 24.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                      context.pushNamed(SubscriptionPageWidget.routeName);
                    },
                    text: 'View Plans',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 50.0,
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          24.0, 0.0, 24.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle: GoogleFonts.readexPro(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
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

                // Restore purchases link
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 12.0, 24.0, 0.0),
                  child: InkWell(
                    onTap: _isRestoring ? null : _restorePurchases,
                    child: Text(
                      _isRestoring
                          ? 'Restoring...'
                          : 'Restore Purchases',
                      style: GoogleFonts.readexPro(
                        fontSize: 14.0,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

                // Safe area bottom padding
                SafeArea(
                  top: false,
                  child: const SizedBox(height: 16.0),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBenefitRow(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48.0,
            height: 48.0,
            decoration: const BoxDecoration(
              color: Color(0xFFDAE5D7),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: const Color(0xFF2F6D23),
              size: 24.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.readexPro(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  subtitle,
                  style: GoogleFonts.readexPro(
                    fontSize: 13.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
