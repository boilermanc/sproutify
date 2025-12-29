import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'what_i_like_to_grow_model.dart';
export 'what_i_like_to_grow_model.dart';

class WhatILikeToGrowWidget extends StatefulWidget {
  const WhatILikeToGrowWidget({super.key});

  @override
  State<WhatILikeToGrowWidget> createState() => _WhatILikeToGrowWidgetState();
}

class _WhatILikeToGrowWidgetState extends State<WhatILikeToGrowWidget> {
  late WhatILikeToGrowModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WhatILikeToGrowModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Widget _buildPreferenceCheckbox(
    BuildContext context,
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 12.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).alternate,
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 8.0, 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FontWeight.w800,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w800,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                ),
              ),
              Theme(
                data: ThemeData(
                  checkboxTheme: CheckboxThemeData(
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  unselectedWidgetColor:
                      FlutterFlowTheme.of(context).secondaryText,
                ),
                child: Checkbox(
                  value: value,
                  onChanged: (newValue) async {
                    HapticFeedback.lightImpact();
                    if (newValue != null) {
                      await onChanged(newValue);
                    }
                  },
                  side: BorderSide(
                    width: 2,
                    color: FlutterFlowTheme.of(context).secondaryText,
                  ),
                  activeColor: FlutterFlowTheme.of(context).primary,
                  checkColor: FlutterFlowTheme.of(context).info,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: 300.0,
            constraints: const BoxConstraints(
              maxHeight: 550.0,
            ),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(10.0, 30.0, 0.0, 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'What I Like To Grow',
                        style: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .override(
                              font: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .fontStyle,
                              ),
                              fontSize: 20.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .headlineMedium
                                  .fontStyle,
                            ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 0.0),
                        child: FlutterFlowIconButton(
                          borderRadius: 8.0,
                          buttonSize: 40.0,
                          fillColor: FlutterFlowTheme.of(context).primary,
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
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: 308.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FutureBuilder<
                            List<UserGardeningPlantPreferencesRow>>(
                          future:
                              UserGardeningPlantPreferencesTable().queryRows(
                            queryFn: (q) => q.eqOrNull(
                              'profile_id',
                              currentUserUid,
                            ),
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.hasData && snapshot.data != null) {
                              // Initialize checkbox states based on current preferences
                              final preferences = snapshot.data!;
                              _model.isHerbsValue =
                                  preferences.any((p) => p.plantTypeId == 1);
                              _model.isLeafyGreensValue =
                                  preferences.any((p) => p.plantTypeId == 2);
                              _model.isEdibleValue =
                                  preferences.any((p) => p.plantTypeId == 3);
                              _model.isMedicinalValue =
                                  preferences.any((p) => p.plantTypeId == 4);
                              _model.isVegetablesValue =
                                  preferences.any((p) => p.plantTypeId == 5);
                            } else if (!snapshot.hasData) {
                              // Show loading indicator
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildPreferenceCheckbox(
                                  context,
                                  'Herbs',
                                  _model.isHerbsValue ?? false,
                                  (value) async {
                                    safeSetState(() {
                                      _model.isHerbsValue = value;
                                    });
                                    if (value) {
                                      await UserGardeningPlantPreferencesTable()
                                          .insert({
                                        'profile_id': currentUserUid,
                                        'plant_type_id': 1,
                                      });
                                    } else {
                                      await UserGardeningPlantPreferencesTable()
                                          .delete(
                                        matchingRows: (rows) => rows
                                            .eqOrNull(
                                              'profile_id',
                                              currentUserUid,
                                            )
                                            .eqOrNull('plant_type_id', 1),
                                      );
                                    }
                                    safeSetState(() {});
                                  },
                                ),
                                _buildPreferenceCheckbox(
                                  context,
                                  'Leafy Greens',
                                  _model.isLeafyGreensValue ?? false,
                                  (value) async {
                                    safeSetState(() {
                                      _model.isLeafyGreensValue = value;
                                    });
                                    if (value) {
                                      await UserGardeningPlantPreferencesTable()
                                          .insert({
                                        'profile_id': currentUserUid,
                                        'plant_type_id': 2,
                                      });
                                    } else {
                                      await UserGardeningPlantPreferencesTable()
                                          .delete(
                                        matchingRows: (rows) => rows
                                            .eqOrNull(
                                              'profile_id',
                                              currentUserUid,
                                            )
                                            .eqOrNull('plant_type_id', 2),
                                      );
                                    }
                                    safeSetState(() {});
                                  },
                                ),
                                _buildPreferenceCheckbox(
                                  context,
                                  'Edible',
                                  _model.isEdibleValue ?? false,
                                  (value) async {
                                    safeSetState(() {
                                      _model.isEdibleValue = value;
                                    });
                                    if (value) {
                                      await UserGardeningPlantPreferencesTable()
                                          .insert({
                                        'profile_id': currentUserUid,
                                        'plant_type_id': 3,
                                      });
                                    } else {
                                      await UserGardeningPlantPreferencesTable()
                                          .delete(
                                        matchingRows: (rows) => rows
                                            .eqOrNull(
                                              'profile_id',
                                              currentUserUid,
                                            )
                                            .eqOrNull('plant_type_id', 3),
                                      );
                                    }
                                    safeSetState(() {});
                                  },
                                ),
                                _buildPreferenceCheckbox(
                                  context,
                                  'Medicinal',
                                  _model.isMedicinalValue ?? false,
                                  (value) async {
                                    safeSetState(() {
                                      _model.isMedicinalValue = value;
                                    });
                                    if (value) {
                                      await UserGardeningPlantPreferencesTable()
                                          .insert({
                                        'profile_id': currentUserUid,
                                        'plant_type_id': 4,
                                      });
                                    } else {
                                      await UserGardeningPlantPreferencesTable()
                                          .delete(
                                        matchingRows: (rows) => rows
                                            .eqOrNull(
                                              'profile_id',
                                              currentUserUid,
                                            )
                                            .eqOrNull('plant_type_id', 4),
                                      );
                                    }
                                    safeSetState(() {});
                                  },
                                ),
                                _buildPreferenceCheckbox(
                                  context,
                                  'Vegetables',
                                  _model.isVegetablesValue ?? false,
                                  (value) async {
                                    safeSetState(() {
                                      _model.isVegetablesValue = value;
                                    });
                                    if (value) {
                                      await UserGardeningPlantPreferencesTable()
                                          .insert({
                                        'profile_id': currentUserUid,
                                        'plant_type_id': 5,
                                      });
                                    } else {
                                      await UserGardeningPlantPreferencesTable()
                                          .delete(
                                        matchingRows: (rows) => rows
                                            .eqOrNull(
                                              'profile_id',
                                              currentUserUid,
                                            )
                                            .eqOrNull('plant_type_id', 5),
                                      );
                                    }
                                    safeSetState(() {});
                                  },
                                ),
                              ],
                            );
                          },
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
    );
  }
}
