import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/ec_action/ec_action_widget.dart';
import '/components/ec_info/ec_info_widget.dart';
import '/components/no_towers/no_towers_widget.dart';
import '/components/ph_action/ph_action_widget.dart';
import '/components/ph_info/ph_info_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'dart:async';
import 'my_towers_expandable_widget.dart' show MyTowersExpandableWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyTowersExpandableModel
    extends FlutterFlowModel<MyTowersExpandableWidget> {
  ///  Local state fields for this page.

  double? phValue;

  bool? towerIsActive;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - Query Rows] action in myTowersExpandable widget.
  List<MyTowersRow>? isTowerActive4411;
  Completer<List<UsertowerdetailsRow>>? requestCompleter;
  // Stores action output result for [Backend Call - Query Rows] action in Container widget.
  List<MyTowersRow>? isTowerActive1199;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Additional helper methods.
  Future waitForRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
