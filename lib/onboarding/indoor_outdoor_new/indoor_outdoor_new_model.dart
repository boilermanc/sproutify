import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'indoor_outdoor_new_widget.dart' show IndoorOutdoorNewWidget;
import 'package:flutter/material.dart';

class IndoorOutdoorNewModel extends FlutterFlowModel<IndoorOutdoorNewWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for insideOutside widget.
  FormFieldController<String>? insideOutsideValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Additional helper methods.
  String? get insideOutsideValue => insideOutsideValueController?.value;
}
