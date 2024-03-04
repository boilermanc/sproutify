import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_drop_down.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'review_component_widget.dart' show ReviewComponentWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ReviewComponentModel extends FlutterFlowModel<ReviewComponentWidget> {
  ///  Local state fields for this component.

  int? plantID;

  int? userID;

  ///  State fields for stateful widgets in this component.

  // State field(s) for plantRating widget.
  String? plantRatingValue;
  FormFieldController<String>? plantRatingValueController;
  // Stores action output result for [Backend Call - API (upsertRatings)] action in updatePlantRating widget.
  ApiCallResponse? apiResultvkw;

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
