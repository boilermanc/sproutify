import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'dart:async';
import 'plant_catalog_widget.dart' show PlantCatalogWidget;
import 'package:flutter/material.dart';

class PlantCatalogModel extends FlutterFlowModel<PlantCatalogWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for searchPlantName widget.
  final searchPlantNameKey = GlobalKey();
  FocusNode? searchPlantNameFocusNode;
  TextEditingController? searchPlantNameTextController;
  String? searchPlantNameSelectedOption;
  String? Function(BuildContext, String?)?
      searchPlantNameTextControllerValidator;
  Completer<ApiCallResponse>? apiRequestCompleter;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    searchPlantNameFocusNode?.dispose();
  }

  /// Additional helper methods.
  Future waitForApiRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(const Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = apiRequestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
