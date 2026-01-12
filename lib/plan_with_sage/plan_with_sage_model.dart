import '/flutter_flow/flutter_flow_util.dart';
import 'plan_with_sage_widget.dart' show PlanWithSageWidget;
import 'package:flutter/material.dart';

class PlanWithSageModel extends FlutterFlowModel<PlanWithSageWidget> {
  /// State fields for stateful widgets in this page.
  final unfocusNode = FocusNode();

  /// State field for the chat input
  FocusNode? chatInputFocusNode;
  TextEditingController? chatInputController;
  String? Function(BuildContext, String?)? chatInputControllerValidator;

  /// Stores the conversation messages
  List<Map<String, String>> messages = [];

  /// Stores the generated plan plants list
  List<Map<String, dynamic>> generatedPlan = [];

  /// Plan metadata from n8n response
  String? planName;
  String? planDescription;
  int totalSlotsUsed = 0;

  /// Loading state for AI response
  bool isLoading = false;

  /// Whether a plan has been generated
  bool hasPlan = false;

  /// Plan name for saving
  TextEditingController? planNameController;
  FocusNode? planNameFocusNode;

  /// Scroll controller for chat messages
  ScrollController? chatScrollController;

  @override
  void initState(BuildContext context) {
    chatInputController ??= TextEditingController();
    chatInputFocusNode ??= FocusNode();
    planNameController ??= TextEditingController();
    planNameFocusNode ??= FocusNode();
    chatScrollController ??= ScrollController();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    chatInputFocusNode?.dispose();
    chatInputController?.dispose();
    planNameFocusNode?.dispose();
    planNameController?.dispose();
    chatScrollController?.dispose();
  }
}
