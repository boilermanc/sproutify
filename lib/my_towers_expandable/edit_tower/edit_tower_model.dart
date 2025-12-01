import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'edit_tower_widget.dart' show EditTowerWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditTowerModel extends FlutterFlowModel<EditTowerWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for towerName widget.
  FocusNode? towerNameFocusNode;
  TextEditingController? towerNameTextController;
  String? Function(BuildContext, String?)? towerNameTextControllerValidator;
  // State field(s) for portCount widget.
  FocusNode? portCountFocusNode;
  TextEditingController? portCountTextController;
  String? Function(BuildContext, String?)? portCountTextControllerValidator;
  // State field(s) for location RadioButton widget.
  FormFieldController<String>? locationValueController;

  @override
  void initState(BuildContext context) {
    towerNameTextControllerValidator = _towerNameValidator;
    portCountTextControllerValidator = _portCountValidator;
  }

  @override
  void dispose() {
    towerNameFocusNode?.dispose();
    towerNameTextController?.dispose();
    portCountFocusNode?.dispose();
    portCountTextController?.dispose();
  }

  String? _towerNameValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Tower name is required';
    }
    if (val.trim().isEmpty) {
      return 'Tower name cannot be empty';
    }
    return null;
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
}



