import '/backend/supabase/supabase.dart';
import '/faq/faq_answer/faq_answer_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'main_f_a_q_widget.dart' show MainFAQWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MainFAQModel extends FlutterFlowModel<MainFAQWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for faqSearchField widget.
  FocusNode? faqSearchFieldFocusNode;
  TextEditingController? faqSearchFieldTextController;
  String? Function(BuildContext, String?)?
      faqSearchFieldTextControllerValidator;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    faqSearchFieldFocusNode?.dispose();
    faqSearchFieldTextController?.dispose();

    tabBarController?.dispose();
  }
}
