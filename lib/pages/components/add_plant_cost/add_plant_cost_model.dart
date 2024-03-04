import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'add_plant_cost_widget.dart' show AddPlantCostWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddPlantCostModel extends FlutterFlowModel<AddPlantCostWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for plantCost widget.
  FocusNode? plantCostFocusNode;
  TextEditingController? plantCostController;
  String? Function(BuildContext, String?)? plantCostControllerValidator;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    plantCostFocusNode?.dispose();
    plantCostController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
