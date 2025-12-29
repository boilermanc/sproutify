import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'name_tower_new_widget.dart' show NameTowerNewWidget;
import 'package:flutter/material.dart';

class NameTowerNewModel extends FlutterFlowModel<NameTowerNewWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for nameYourTower widget.
  FocusNode? nameYourTowerFocusNode;
  TextEditingController? nameYourTowerTextController;
  String? Function(BuildContext, String?)? nameYourTowerTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nameYourTowerFocusNode?.dispose();
    nameYourTowerTextController?.dispose();
  }
}
