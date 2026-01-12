import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dart:async';
import 'my_plant_expandable_copy_widget.dart' show MyPlantExpandableCopyWidget;
import 'package:flutter/material.dart';

class MyPlantExpandableCopyModel
    extends FlutterFlowModel<MyPlantExpandableCopyWidget> {
  ///  Local state fields for this page.

  int? expandedIndex;

  ///  State fields for stateful widgets in this page.

  Completer<List<UserplantdetailsRow>>? requestCompleter;
  // Stores action output result for [Backend Call - Query Rows] action in myPlantExpandableCopy widget.
  List<UserplantdetailsRow>? userPlantsQuery7733;
  DateTime? datePicked;

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
