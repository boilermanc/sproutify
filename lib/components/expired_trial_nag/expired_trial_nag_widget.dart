import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/subscription_page/subscription_page_widget.dart';

class ExpiredTrialNagWidget extends StatelessWidget {
  const ExpiredTrialNagWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80.0,
                height: 80.0,
                decoration: const BoxDecoration(
                  color: Color(0xFFEDF8EA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: Color(0xFF2F6D23),
                  size: 40.0,
                ),
              ),

              const SizedBox(height: 24.0),

              // Headline
              Text(
                'Your trial has ended',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),

              const SizedBox(height: 12.0),

              // Body text
              Text(
                'Subscribe to keep growing with everything you need — unlimited plants, towers, Sage AI, community, and more.',
                textAlign: TextAlign.center,
                style: GoogleFonts.readexPro(
                  fontSize: 14.0,
                  color: FlutterFlowTheme.of(context).secondaryText,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 32.0),

              // Subscribe CTA
              FFButtonWidget(
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

              const SizedBox(height: 16.0),

              // Continue with limited access
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: Text(
                  'Continue with limited access',
                  style: GoogleFonts.readexPro(
                    fontSize: 14.0,
                    color: FlutterFlowTheme.of(context).secondaryText,
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
