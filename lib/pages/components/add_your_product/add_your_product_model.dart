import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'add_your_product_widget.dart' show AddYourProductWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddYourProductModel extends FlutterFlowModel<AddYourProductWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for enterCost widget.
  FocusNode? enterCostFocusNode;
  TextEditingController? enterCostController;
  String? Function(BuildContext, String?)? enterCostControllerValidator;
  // State field(s) for enterQuantity widget.
  FocusNode? enterQuantityFocusNode;
  TextEditingController? enterQuantityController;
  String? Function(BuildContext, String?)? enterQuantityControllerValidator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    enterCostFocusNode?.dispose();
    enterCostController?.dispose();

    enterQuantityFocusNode?.dispose();
    enterQuantityController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
