import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'name_tower_widget.dart' show NameTowerWidget;
import 'package:flutter/material.dart';

class NameTowerModel extends FlutterFlowModel<NameTowerWidget> {
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
