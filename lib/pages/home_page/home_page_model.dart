import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (fetchNewNotfications)] action in HomePage widget.
  ApiCallResponse? apiResultoqk;
  // Stores action output result for [Backend Call - Query Rows] action in HomePage widget.
  List<ProfilesRow>? profile2244;
  Stream<List<GardeningInspirationalMessagesRow>>?
      dailyInspirationSupabaseStream;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
