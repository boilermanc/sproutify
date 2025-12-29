import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'add_plant_cost_widget.dart' show AddPlantCostWidget;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddPlantCostModel extends FlutterFlowModel<AddPlantCostWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for plantCost widget.
  FocusNode? plantCostFocusNode;
  TextEditingController? plantCostTextController;
  String? Function(BuildContext, String?)? plantCostTextControllerValidator;
  // Stores action output result for [Backend Call - Update Row(s)] action in addCostButton widget.
  List<UserplantsRow>? addedPlantCost0011;
  Completer<List<UserplantsRow>>? requestCompleter;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    plantCostFocusNode?.dispose();
    plantCostTextController?.dispose();
  }

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
