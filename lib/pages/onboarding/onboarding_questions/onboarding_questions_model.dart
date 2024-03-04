import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'onboarding_questions_widget.dart' show OnboardingQuestionsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OnboardingQuestionsModel
    extends FlutterFlowModel<OnboardingQuestionsWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // State field(s) for collectInfo widget.
  PageController? collectInfoController;

  int get collectInfoCurrentIndex => collectInfoController != null &&
          collectInfoController!.hasClients &&
          collectInfoController!.page != null
      ? collectInfoController!.page!.round()
      : 0;
  // State field(s) for isSelfSufficiencySelected widget.
  bool? isSelfSufficiencySelectedValue;
  // State field(s) for isHealthAndNutritionSelected widget.
  bool? isHealthAndNutritionSelectedValue;
  // State field(s) for isEnvironmentalSustainabilitySelected widget.
  bool? isEnvironmentalSustainabilitySelectedValue;
  // State field(s) for isEducationalFamilyEngagementSelected widget.
  bool? isEducationalFamilyEngagementSelectedValue;
  // State field(s) for isTherapeuticRecreationalSelected widget.
  bool? isTherapeuticRecreationalSelectedValue;
  // State field(s) for isHerbs widget.
  bool? isHerbsValue;
  // State field(s) for isLeafyGreens widget.
  bool? isLeafyGreensValue;
  // State field(s) for isEdible widget.
  bool? isEdibleValue;
  // State field(s) for isMedicianal widget.
  bool? isMedicianalValue;
  // State field(s) for isVegetables widget.
  bool? isVegetablesValue;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
