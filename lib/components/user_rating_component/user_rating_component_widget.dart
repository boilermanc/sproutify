import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'user_rating_component_model.dart';
export 'user_rating_component_model.dart';

class UserRatingComponentWidget extends StatefulWidget {
  const UserRatingComponentWidget({
    super.key,
    this.plantRatingNumber,
  });

  final int? plantRatingNumber;

  @override
  State<UserRatingComponentWidget> createState() =>
      _UserRatingComponentWidgetState();
}

class _UserRatingComponentWidgetState extends State<UserRatingComponentWidget> {
  late UserRatingComponentModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserRatingComponentModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      onRatingUpdate: (newValue) =>
          safeSetState(() => _model.ratingBarValue = newValue),
      itemBuilder: (context, index) => Icon(
        Icons.star_rounded,
        color: FlutterFlowTheme.of(context).success,
      ),
      direction: Axis.horizontal,
      initialRating: _model.ratingBarValue ??=
          widget!.plantRatingNumber!.toDouble(),
      unratedColor: FlutterFlowTheme.of(context).alternate,
      itemCount: 5,
      itemSize: 24.0,
      glowColor: FlutterFlowTheme.of(context).success,
    );
  }
}
