import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tower_catalog_model.dart';
export 'tower_catalog_model.dart';

class TowerCatalogWidget extends StatefulWidget {
  const TowerCatalogWidget({super.key});

  static String routeName = 'towerCatalog';
  static String routePath = '/towerCatalog';

  @override
  State<TowerCatalogWidget> createState() => _TowerCatalogWidgetState();
}

class _TowerCatalogWidgetState extends State<TowerCatalogWidget> {
  late TowerCatalogModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TowerCatalogModel());

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
      child: PopScope(
        canPop: false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          appBar: AppBar(
            backgroundColor: FlutterFlowTheme.of(context).primary,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Your Tower',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.outfit(
                          fontWeight: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontWeight,
                          fontStyle: FlutterFlowTheme.of(context)
                              .headlineMedium
                              .fontStyle,
                        ),
                        color: Colors.white,
                        fontSize: 24.0,
                        letterSpacing: 0.0,
                        fontWeight: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontWeight,
                        fontStyle: FlutterFlowTheme.of(context)
                            .headlineMedium
                            .fontStyle,
                      ),
                ),
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    HapticFeedback.lightImpact();

                    context.pushNamed(HomePageWidget.routeName);
                  },
                  child: Icon(
                    Icons.close,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    size: 24.0,
                  ),
                ),
              ],
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
                // Show loading indicator
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

                List<TowerBrandsRow> allBrands = snapshot.data!;
                
                // Get unique brand names for filter chips
                final uniqueBrandNames = allBrands
                    .map((brand) => brand.brandName ?? 'Unknown')
                    .toSet()
                    .toList()
                  ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

                // Filter brands based on selection
                List<TowerBrandsRow> filteredBrands = _model.selectedBrandFilter == null
                    ? allBrands
                    : allBrands.where((brand) => 
                        brand.brandName == _model.selectedBrandFilter).toList();

                // Sort filtered brands alphabetically by brand name
                filteredBrands.sort((a, b) {
                  final nameA = (a.brandName ?? '').toLowerCase();
                  final nameB = (b.brandName ?? '').toLowerCase();
                  return nameA.compareTo(nameB);
                });

                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Expandable filter card
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).alternate,
                            width: 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4.0,
                              offset: const Offset(0.0, 2.0),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Filter header (always visible)
                            InkWell(
                              onTap: () {
                                safeSetState(() {
                                  _model.isFilterExpanded = !_model.isFilterExpanded;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.filter_list,
                                          color: FlutterFlowTheme.of(context).primary,
                                          size: 20.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          'Filter by Brand',
                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                fontFamily: 'Readex Pro',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0,
                                              ),
                                        ),
                                        if (_model.selectedBrandFilter != null) ...[
                                          const SizedBox(width: 8.0),
                                          Container(
                                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.of(context).primary,
                                              borderRadius: BorderRadius.circular(12.0),
                                            ),
                                            child: Text(
                                              _model.selectedBrandFilter!,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    AnimatedRotation(
                                      turns: _model.isFilterExpanded ? 0.5 : 0.0,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        size: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Expandable content with smooth animation
                            AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: _model.isFilterExpanded
                                  ? Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                                      child: Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: [
                                          // "All" filter chip
                                          FilterChip(
                                            label: const Text('All'),
                                            selected: _model.selectedBrandFilter == null,
                                            onSelected: (selected) {
                                              safeSetState(() {
                                                _model.selectedBrandFilter = null;
                                                _model.isFilterExpanded = false;
                                              });
                                            },
                                            selectedColor: FlutterFlowTheme.of(context).primary,
                                            checkmarkColor: Colors.white,
                                            labelStyle: TextStyle(
                                              color: _model.selectedBrandFilter == null
                                                  ? Colors.white
                                                  : FlutterFlowTheme.of(context).primaryText,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          // Individual brand filter chips
                                          ...uniqueBrandNames.map((brandName) {
                                            final isSelected = _model.selectedBrandFilter == brandName;
                                            return FilterChip(
                                              label: Text(
                                                brandName,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              selected: isSelected,
                                              onSelected: (selected) {
                                                safeSetState(() {
                                                  _model.selectedBrandFilter = selected ? brandName : null;
                                                  _model.isFilterExpanded = false;
                                                });
                                              },
                                              selectedColor: FlutterFlowTheme.of(context).primary,
                                              checkmarkColor: Colors.white,
                                              labelStyle: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : FlutterFlowTheme.of(context).primaryText,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Grid of towers
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 20.0),
                        child: filteredBrands.isEmpty
                            ? Center(
                                child: Text(
                                  'No towers found',
                                  style: FlutterFlowTheme.of(context).bodyMedium,
                                ),
                              )
                            : GridView.builder(
                                padding: EdgeInsets.zero,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16.0,
                                  mainAxisSpacing: 16.0,
                                  childAspectRatio: 0.9,
                                ),
                                scrollDirection: Axis.vertical,
                                itemCount: filteredBrands.length,
                                itemBuilder: (context, gridViewIndex) {
                                  final gridViewTowerBrandsRow =
                                      filteredBrands[gridViewIndex];
                                  return InkWell(
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
                                            gridViewTowerBrandsRow.id,
                                            ParamType.int,
                                          ),
                                          'brandName': serializeParam(
                                            gridViewTowerBrandsRow.brandName,
                                            ParamType.String,
                                          ),
                                          'allowCustomName': serializeParam(
                                            gridViewTowerBrandsRow.allowCustomName,
                                            ParamType.bool,
                                          ),
                                        }.withoutNulls,
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE6EAF0),
                                        borderRadius: BorderRadius.circular(16.0),
                                        border: Border.all(
                                          color: const Color(0xCCE5DBDB),
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: gridViewTowerBrandsRow.brandLogoUrl != null &&
                                                    gridViewTowerBrandsRow.brandLogoUrl!.isNotEmpty
                                                ? Image.network(
                                                    gridViewTowerBrandsRow.brandLogoUrl!,
                                                    width: 120.0,
                                                    height: 120.0,
                                                    fit: BoxFit.contain,
                                                  )
                                                : Image.asset(
                                                    'assets/images/Tower_Garden_Clip_100x100.png',
                                                    width: 120.0,
                                                    height: 120.0,
                                                    fit: BoxFit.contain,
                                                  ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(
                                                12.0, 12.0, 12.0, 0.0),
                                            child: Text(
                                              gridViewTowerBrandsRow.brandName ?? 'Tower',
                                              textAlign: TextAlign.center,
                                              style: FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.readexPro(
                                                      fontWeight: FontWeight.w600,
                                                      fontStyle: FlutterFlowTheme.of(context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                    ),
                                                    fontSize: 16.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w600,
                                                    fontStyle: FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
