import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'onboarding_questions_copy2_widget.dart'
    show OnboardingQuestionsCopy2Widget;
import 'package:flutter/material.dart';

class OnboardingQuestionsCopy2Model
    extends FlutterFlowModel<OnboardingQuestionsCopy2Widget> {
  ///  State fields for stateful widgets in this page.

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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
