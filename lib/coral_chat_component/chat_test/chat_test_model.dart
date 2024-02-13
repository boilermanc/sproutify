import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'chat_test_widget.dart' show ChatTestWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatTestModel extends FlutterFlowModel<ChatTestWidget> {
  ///  Local state fields for this page.

  String? answer;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for inputFiled widget.
  FocusNode? inputFiledFocusNode;
  TextEditingController? inputFiledController;
  String? Function(BuildContext, String?)? inputFiledControllerValidator;
  // Stores action output result for [Backend Call - API (Coral Chat)] action in Button widget.
  ApiCallResponse? apiResult4a5;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    inputFiledFocusNode?.dispose();
    inputFiledController?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
