import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'coral_chat_widget.dart' show CoralChatWidget;
import 'package:flutter/material.dart';

class CoralChatModel extends FlutterFlowModel<CoralChatWidget> {
  ///  Local state fields for this page.

  String? answer;

  ///  State fields for stateful widgets in this page.

  // State field(s) for inputFiled widget.
  FocusNode? inputFiledFocusNode;
  TextEditingController? inputFiledTextController;
  String? Function(BuildContext, String?)? inputFiledTextControllerValidator;
  // Stores action output result for [Backend Call - API (Coral Chat)] action in Button widget.
  ApiCallResponse? apiResult4a5;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    inputFiledFocusNode?.dispose();
    inputFiledTextController?.dispose();
  }
}
