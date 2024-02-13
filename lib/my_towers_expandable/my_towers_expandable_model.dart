import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/components/ec_action/ec_action_widget.dart';
import '/pages/components/ec_info/ec_info_widget.dart';
import '/pages/components/no_towers/no_towers_widget.dart';
import '/pages/components/ph_action/ph_action_widget.dart';
import '/pages/components/ph_info/ph_info_widget.dart';
import 'my_towers_expandable_widget.dart' show MyTowersExpandableWidget;
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyTowersExpandableModel
    extends FlutterFlowModel<MyTowersExpandableWidget> {
  ///  Local state fields for this page.

  double? phValue;

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
