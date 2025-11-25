import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'ph_ec_chart_widget.dart' show PhEcChartWidget;
import 'package:flutter/material.dart';

class PhEcChartModel extends FlutterFlowModel<PhEcChartWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;

  // Stores the pH history data
  List<PhEchistoryRow>? phHistoryData;

  // Stores the EC history data
  List<PhEchistoryRow>? ecHistoryData;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    tabBarController?.dispose();
  }
}
