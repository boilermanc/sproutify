import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/add_plant_cost/add_plant_cost_widget.dart';
import '/components/bottom_plant_management/bottom_plant_management_widget.dart';
import '/components/cultivate_bottom/cultivate_bottom_widget.dart';
import '/components/cultivate_directions/cultivate_directions_widget.dart';
import '/components/no_plants/no_plants_widget.dart';
import '/components/plant_rating_selection/plant_rating_selection_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'dart:async';
import 'my_plant_expandable_copy_widget.dart' show MyPlantExpandableCopyWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
