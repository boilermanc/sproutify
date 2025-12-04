import '/flutter_flow/flutter_flow_util.dart';
import 'trial_timeline_page_widget.dart' show TrialTimelinePageWidget;
import 'package:flutter/material.dart';

class TrialTimelinePageModel extends FlutterFlowModel<TrialTimelinePageWidget> {
  /// State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
