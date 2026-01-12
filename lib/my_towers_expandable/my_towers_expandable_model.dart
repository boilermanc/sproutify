import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dart:async';
import 'my_towers_expandable_widget.dart' show MyTowersExpandableWidget;
import 'package:flutter/material.dart';

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
