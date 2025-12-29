import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'manage_goals_widget.dart' show ManageGoalsWidget;
import 'package:flutter/material.dart';

class ManageGoalsModel extends FlutterFlowModel<ManageGoalsWidget> {
  ///  Local state fields for this component.

  List<int> selectedGoalID = [];
  void addToSelectedGoalID(int item) => selectedGoalID.add(item);
  void removeFromSelectedGoalID(int item) => selectedGoalID.remove(item);
  void removeAtIndexFromSelectedGoalID(int index) =>
      selectedGoalID.removeAt(index);
  void insertAtIndexInSelectedGoalID(int index, int item) =>
      selectedGoalID.insert(index, item);
  void updateSelectedGoalIDAtIndex(int index, Function(int) updateFn) =>
      selectedGoalID[index] = updateFn(selectedGoalID[index]);

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Backend Call - Query Rows] action in manageGoals widget.
  List<UserGardeningGoalsRow>? userGoals4433;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
