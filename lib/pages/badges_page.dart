import '/components/badge_collection_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BadgesPage extends StatelessWidget {
  const BadgesPage({
    super.key,
    this.userId,
  });

  final String? userId;

  static String routeName = 'badges';
  static String routePath = '/badges';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30.0,
          borderWidth: 1.0,
          buttonSize: 60.0,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 30.0,
          ),
          onPressed: () async {
            HapticFeedback.lightImpact();
            context.safePop();
          },
        ),
        title: Text(
          'My Badges',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                fontFamily: GoogleFonts.readexPro().fontFamily,
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
              ),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 2.0,
      ),
      body: SafeArea(
        top: true,
        child: BadgeCollectionWidget(
          userId: userId,
        ),
      ),
    );
  }
}

