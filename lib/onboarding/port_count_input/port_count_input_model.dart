import '/flutter_flow/flutter_flow_util.dart';
import 'port_count_input_widget.dart' show PortCountInputWidget;
import 'package:flutter/material.dart';

class PortCountInputModel extends FlutterFlowModel<PortCountInputWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for portCount widget.
  FocusNode? portCountFocusNode;
  TextEditingController? portCountTextController;
  String? Function(BuildContext, String?)? portCountTextControllerValidator;
  // State field(s) for customBrandName widget (conditional).
  FocusNode? customBrandNameFocusNode;
  TextEditingController? customBrandNameTextController;
  String? Function(BuildContext, String?)?
      customBrandNameTextControllerValidator;
  // State field(s) for brand selection
  int? selectedBrandID;
  String? selectedBrandName;
  bool selectedAllowCustomName = false;

  @override
  void initState(BuildContext context) {
    portCountTextControllerValidator = _portCountValidator;
    customBrandNameTextControllerValidator = _customBrandNameValidator;
  }

  @override
  void dispose() {
    portCountFocusNode?.dispose();
    portCountTextController?.dispose();
    customBrandNameFocusNode?.dispose();
    customBrandNameTextController?.dispose();
  }

  String? _portCountValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Port count is required';
    }

    final number = int.tryParse(val);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < 1) {
      return 'Port count must be at least 1';
    }

    if (number > 100) {
      return 'Port count cannot exceed 100';
    }

    return null;
  }

  String? _customBrandNameValidator(BuildContext context, String? val) {
    // Only validate if the widget is using custom brand name (i.e., "Other" was selected)
    if (val == null || val.isEmpty) {
      return 'Brand name is required';
    }

    if (val.length < 2) {
      return 'Brand name must be at least 2 characters';
    }

    return null;
  }
}
