import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_radio_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/index.dart';
import 'indoor_outdoor_new_widget.dart' show IndoorOutdoorNewWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
