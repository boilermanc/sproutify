import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'add_your_product_widget.dart' show AddYourProductWidget;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddYourProductModel extends FlutterFlowModel<AddYourProductWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for enterCost widget.
  FocusNode? enterCostFocusNode;
  TextEditingController? enterCostTextController;
  String? Function(BuildContext, String?)? enterCostTextControllerValidator;
  // State field(s) for enterQuantity widget.
  FocusNode? enterQuantityFocusNode;
  TextEditingController? enterQuantityTextController;
  String? Function(BuildContext, String?)? enterQuantityTextControllerValidator;
  Completer<List<ProductsRow>>? requestCompleter;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    enterCostFocusNode?.dispose();
    enterCostTextController?.dispose();

    enterQuantityFocusNode?.dispose();
    enterQuantityTextController?.dispose();
  }

  /// Additional helper methods.
  Future waitForRequestCompleted({
    double minWait = 0,
    double maxWait = double.infinity,
  }) async {
    final stopwatch = Stopwatch()..start();
    while (true) {
      await Future.delayed(Duration(milliseconds: 50));
      final timeElapsed = stopwatch.elapsedMilliseconds;
      final requestComplete = requestCompleter?.isCompleted ?? false;
      if (timeElapsed > maxWait || (requestComplete && timeElapsed > minWait)) {
        break;
      }
    }
  }
}
