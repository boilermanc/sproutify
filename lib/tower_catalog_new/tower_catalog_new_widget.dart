import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import '/onboarding/port_count_input/port_count_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'tower_catalog_new_model.dart';
export 'tower_catalog_new_model.dart';

class TowerCatalogNewWidget extends StatefulWidget {
  const TowerCatalogNewWidget({super.key});

  static String routeName = 'towerCatalogNew';
  static String routePath = '/towerCatalogNew';

  @override
  State<TowerCatalogNewWidget> createState() => _TowerCatalogNewWidgetState();
}

class _TowerCatalogNewWidgetState extends State<TowerCatalogNewWidget> {
  late TowerCatalogNewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TowerCatalogNewModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Text(
            'Select Your Tower',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.outfit(
                    fontWeight: FontWeight.w600,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 24.0,
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.w600,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: FutureBuilder<List<TowerBrandsRow>>(
            future: TowerBrandsTable().queryRows(
              queryFn: (q) => q
                  .eqOrNull('is_active', true)
                  .order('display_order', ascending: true),
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
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
              List<TowerBrandsRow> listViewTowerBrandsRowList =
                  snapshot.data!;

              return ListView.builder(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 20.0),
                scrollDirection: Axis.vertical,
                itemCount: listViewTowerBrandsRowList.length,
                itemBuilder: (context, listViewIndex) {
                  final listViewTowerBrandsRow =
                      listViewTowerBrandsRowList[listViewIndex];
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        5.0, 0.0, 5.0, 10.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        HapticFeedback.lightImpact();

                        context.pushNamed(
                          PortCountInputWidget.routeName,
                          queryParameters: {
                            'towerBrandID': serializeParam(
                              listViewTowerBrandsRow.id,
                              ParamType.int,
                            ),
                            'brandName': serializeParam(
                              listViewTowerBrandsRow.brandName,
                              ParamType.String,
                            ),
                            'allowCustomName': serializeParam(
                              listViewTowerBrandsRow.allowCustomName,
                              ParamType.bool,
                            ),
                          }.withoutNulls,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6EAF0),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          border: Border.all(
                            color: const Color(0xCCE5DBDB),
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 10.0, 20.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        0.0, 10.0, 0.0, 0.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        'assets/images/Tower_Garden_Clip_100x100.png',
                                        width: 100.0,
                                        height: 100.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: const AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 10.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Flexible(
                                              child: Align(
                                                alignment:
                                                    const AlignmentDirectional(-1.0, 0.0),
                                                child: Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(20.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    listViewTowerBrandsRow
                                                            .brandName ??
                                                        'Tower',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .readexPro(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                          ),
                                                          fontSize: 18.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor: Colors.transparent,
                                              onTap: () async {
                                                HapticFeedback.lightImpact();

                                                context.pushNamed(
                                                  PortCountInputWidget.routeName,
                                                  queryParameters: {
                                                    'towerBrandID': serializeParam(
                                                      listViewTowerBrandsRow.id,
                                                      ParamType.int,
                                                    ),
                                                    'brandName': serializeParam(
                                                      listViewTowerBrandsRow
                                                          .brandName,
                                                      ParamType.String,
                                                    ),
                                                    'allowCustomName':
                                                        serializeParam(
                                                      listViewTowerBrandsRow
                                                          .allowCustomName,
                                                      ParamType.bool,
                                                    ),
                                                  }.withoutNulls,
                                                );
                                              },
                                              child: Icon(
                                                Icons.chevron_right,
                                                color: FlutterFlowTheme.of(
                                                        context)
                                                    .secondaryText,
                                                size: 24.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
