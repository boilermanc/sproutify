import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'cultivate_bottom_model.dart';
export 'cultivate_bottom_model.dart';

class CultivateBottomWidget extends StatefulWidget {
  const CultivateBottomWidget({
    super.key,
    required this.userPlantID,
  });

  final int? userPlantID;

  @override
  State<CultivateBottomWidget> createState() => _CultivateBottomWidgetState();
}

class _CultivateBottomWidgetState extends State<CultivateBottomWidget> {
  late CultivateBottomModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CultivateBottomModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: 700.0,
            ),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12.0,
                  color: Color(0x33000000),
                  offset: Offset(
                    0.0,
                    5.0,
                  ),
                )
              ],
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Managing Your Plant',
                                    style: FlutterFlowTheme.of(context)
                                        .headlineLarge
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .headlineLarge
                                                    .fontStyle,
                                          ),
                                          fontSize: 24.0,
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .headlineLarge
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineLarge
                                                  .fontStyle,
                                        ),
                                  ),
                                  FlutterFlowIconButton(
                                    borderRadius: 8.0,
                                    buttonSize: 40.0,
                                    fillColor:
                                        FlutterFlowTheme.of(context).primary,
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: FlutterFlowTheme.of(context).info,
                                      size: 24.0,
                                    ),
                                    onPressed: () async {
                                      HapticFeedback.lightImpact();
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        // Show sub-options for harvest
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return Container(
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'How was your harvest?',
                                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                    SizedBox(height: 20.0),
                                    FFButtonWidget(
                                      onPressed: () async {
                                        HapticFeedback.lightImpact();
                                        await UserplantActionsTable().insert({
                                          'user_plant_id': widget.userPlantID,
                                          'action_type': 'Harvested_Good',
                                          'action_date': supaSerialize<DateTime>(getCurrentTimestamp),
                                        });
                                        await UserplantsTable().update(
                                          data: {'archived': true},
                                          matchingRows: (rows) => rows.eqOrNull(
                                            'user_plant_id',
                                            widget.userPlantID,
                                          ),
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Great harvest! Tracked successfully.'),
                                            backgroundColor: FlutterFlowTheme.of(context).success,
                                          ),
                                        );
                                      },
                                      text: 'Good - I ate/used it successfully',
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 50.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context).success,
                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          font: GoogleFonts.readexPro(),
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                        elevation: 2.0,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    SizedBox(height: 10.0),
                                    FFButtonWidget(
                                      onPressed: () async {
                                        HapticFeedback.lightImpact();
                                        await UserplantActionsTable().insert({
                                          'user_plant_id': widget.userPlantID,
                                          'action_type': 'Harvested_Waste',
                                          'action_date': supaSerialize<DateTime>(getCurrentTimestamp),
                                        });
                                        await UserplantsTable().update(
                                          data: {'archived': true},
                                          matchingRows: (rows) => rows.eqOrNull(
                                            'user_plant_id',
                                            widget.userPlantID,
                                          ),
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Harvest tracked.'),
                                            backgroundColor: FlutterFlowTheme.of(context).warning,
                                          ),
                                        );
                                      },
                                      text: 'Waste - Overgrown/Not good',
                                      options: FFButtonOptions(
                                        width: double.infinity,
                                        height: 50.0,
                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                        color: FlutterFlowTheme.of(context).warning,
                                        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                          font: GoogleFonts.readexPro(),
                                          color: Colors.white,
                                          letterSpacing: 0.0,
                                        ),
                                        elevation: 2.0,
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: FlutterFlowTheme.of(context).success,
                                size: 24.0,
                              ),
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '1. I harvested a plant I grew myself!',
                                      style: FlutterFlowTheme.of(context).labelLarge.override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                      child: Text(
                                        'Choose this option if your plant reached full growth and you\'ve collected your homegrown produce.',
                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                          font: GoogleFonts.readexPro(
                                            fontStyle: FontStyle.italic,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        await UserplantActionsTable().insert({
                          'user_plant_id': widget.userPlantID,
                          'action_type': 'Pest',
                          'action_date': supaSerialize<DateTime>(getCurrentTimestamp),
                        });
                        await UserplantsTable().update(
                          data: {'archived': true},
                          matchingRows: (rows) => rows.eqOrNull(
                            'user_plant_id',
                            widget.userPlantID,
                          ),
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Pest issue tracked.'),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.bug_report,
                                color: FlutterFlowTheme.of(context).error,
                                size: 24.0,
                              ),
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '2. The plant had a pest issue. I threw it away.',
                                      style: FlutterFlowTheme.of(context).labelLarge.override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                      child: Text(
                                        'Select this if pests invaded your plant and you decided it was best to discard it.',
                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                          font: GoogleFonts.readexPro(
                                            fontStyle: FontStyle.italic,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        await UserplantActionsTable().insert({
                          'user_plant_id': widget.userPlantID,
                          'action_type': 'Waste',
                          'action_date': supaSerialize<DateTime>(getCurrentTimestamp),
                        });
                        await UserplantsTable().update(
                          data: {'archived': true},
                          matchingRows: (rows) => rows.eqOrNull(
                            'user_plant_id',
                            widget.userPlantID,
                          ),
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Plant waste tracked.'),
                            backgroundColor: FlutterFlowTheme.of(context).warning,
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: FlutterFlowTheme.of(context).warning,
                                size: 24.0,
                              ),
                              SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '3. The plant did not grow well. I threw it away.',
                                      style: FlutterFlowTheme.of(context).labelLarge.override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                                      child: Text(
                                        'Use this option if your plant didn\'t thrive and you\'ve removed it from your garden.',
                                        style: FlutterFlowTheme.of(context).bodySmall.override(
                                          font: GoogleFonts.readexPro(
                                            fontStyle: FontStyle.italic,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: FlutterFlowTheme.of(context).secondaryText,
                                size: 24.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
