import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import 'dart:async';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'harvest_scorecard_model.dart';
export 'harvest_scorecard_model.dart';

class HarvestScorecardWidget extends StatefulWidget {
  const HarvestScorecardWidget({super.key});

  static String routeName = 'harvestScorecard';
  static String routePath = '/harvestScorecard';

  @override
  State<HarvestScorecardWidget> createState() => _HarvestScorecardWidgetState();
}

class _HarvestScorecardWidgetState extends State<HarvestScorecardWidget> {
  late HarvestScorecardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<UserplantdetailsRow>>? _userPlantsFuture;
  Future<List<UserplantActionsRow>>? _actionsFuture;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HarvestScorecardModel());
    _loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  void _loadData() {
    _userPlantsFuture = UserplantdetailsTable().queryRows(
      queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
    );
    _actionsFuture = UserplantActionsTable().queryRows(
      queryFn: (q) => q.order('action_date', ascending: false),
    );
  }

  void _refreshData() {
    setState(() {
      _loadData();
    });
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
        backgroundColor: FlutterFlowTheme.of(context).alternate,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed(HomePageWidget.routeName);
            },
          ),
          title: Text(
            'Harvest Scorecard',
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
          actions: [
            IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () {
                _refreshData();
              },
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: FutureBuilder<List<UserplantdetailsRow>>(
            future: _userPlantsFuture,
            builder: (context, userPlantsSnapshot) {
              if (!userPlantsSnapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      FlutterFlowTheme.of(context).primary,
                    ),
                  ),
                );
              }

              final userPlantIds = <int>[];
              try {
                final plants = userPlantsSnapshot.data ?? <UserplantdetailsRow>[];
                for (final p in plants) {
                  final plantId = p.getField<int>('user_plant_id');
                  if (plantId != null) {
                    userPlantIds.add(plantId);
                  }
                }
              } catch (e) {
                print('Error extracting user plant IDs: $e');
              }

              return FutureBuilder<List<UserplantActionsRow>>(
                future: _actionsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    );
                  }

                  // Filter actions to only include those for current user's plants
                  // Use try-catch to safely handle any null check errors
                  List<UserplantActionsRow> allActions;
                  try {
                    allActions = snapshot.data ?? <UserplantActionsRow>[];
                  } catch (e) {
                    print('Error accessing snapshot data: $e');
                    allActions = <UserplantActionsRow>[];
                  }
                  
                  // Create a set of all user plant IDs for faster lookup
                  final userPlantIdsSet = userPlantIds.toSet();
                  
                  // Filter actions to only those belonging to user's plants
                  // This includes archived plants since we query all userplants
                  // Also filter out any actions with null userPlantId or actionType
                  final actions = <UserplantActionsRow>[];
                  try {
                    for (final a in allActions) {
                      // Use getField to safely check for null values without throwing
                      final plantId = a.getField<int>('user_plant_id');
                      final actionType = a.getField<String>('action_type');
                      if (plantId != null && 
                          actionType != null && 
                          userPlantIdsSet.contains(plantId)) {
                        actions.add(a);
                      }
                    }
                  } catch (e) {
                    print('Error filtering actions: $e');
                  }
                  
                  // Check for unmatched actions (for debugging)
                  final unmatchedActions = <UserplantActionsRow>[];
                  try {
                    for (final a in allActions) {
                      // Use getField to safely check for null values without throwing
                      final plantId = a.getField<int>('user_plant_id');
                      if (plantId != null && !userPlantIdsSet.contains(plantId)) {
                        unmatchedActions.add(a);
                      }
                    }
                  } catch (e) {
                    print('Error checking unmatched actions: $e');
                  }
                  if (unmatchedActions.isNotEmpty) {
                    print('WARNING: Found ${unmatchedActions.length} actions with user_plant_ids not in user plants list');
                    print('This might indicate archived plants are not being included in the query');
                  }
              
              // Debug: Print all action types to see what we're getting
              print('=== HARVEST SCORECARD DEBUG ===');
              print('User Plant IDs: $userPlantIds');
              print('Total all actions: ${allActions.length}');
              print('Total filtered actions: ${actions.length}');
              try {
                print('All action types: ${actions.map((a) {
                  final actionType = a.getField<String>('action_type') ?? 'Unknown';
                  final plantId = a.getField<int>('user_plant_id') ?? 0;
                  return '$actionType (plant_id: $plantId)';
                }).toList()}');
                print('Good harvests count: ${actions.where((a) {
                  final actionType = a.getField<String>('action_type');
                  return actionType == 'Harvested_Good';
                }).length}');
              } catch (e) {
                print('Error in debug print: $e');
              }
              print('==============================');
              
              // Calculate statistics
              // Handle both old format ("Harvested") and new format ("Harvested_Good", "Harvested_Waste")
              // Old "Harvested" actions are counted as good harvests for backwards compatibility
              int goodHarvests = 0;
              int wasteHarvests = 0;
              int pestIssues = 0;
              int didntGrow = 0;
              
              try {
                for (final a in actions) {
                  final actionType = a.getField<String>('action_type');
                  print('DEBUG: Processing action with type: "$actionType"');
                  if (actionType == 'Harvested_Good' || actionType == 'Harvested') {
                    print('  -> Counted as good harvest');
                    goodHarvests++;
                  } else if (actionType == 'Harvested_Waste') {
                    print('  -> Counted as waste harvest');
                    wasteHarvests++;
                  } else if (actionType == 'Pest') {
                    print('  -> Counted as pest issue');
                    pestIssues++;
                  } else if (actionType == 'Waste') {
                    print('  -> Counted as didn\'t grow');
                    didntGrow++;
                  } else {
                    print('  -> NOT COUNTED (unknown type)');
                  }
                }
              } catch (e) {
                print('Error calculating statistics: $e');
              }
              
              // int totalHarvests = goodHarvests + wasteHarvests; // Unused for now
              int totalWaste = wasteHarvests + pestIssues + didntGrow;
              int totalPlants = actions.length;
              
              double successRate = totalPlants > 0 
                  ? (goodHarvests / totalPlants * 100) 
                  : 0.0;

              // Wrap widget building in try-catch to handle any null check errors
              try {
                return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Summary Card
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 10.0, 10.0, 10.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Your Harvest Performance',
                                style: FlutterFlowTheme.of(context)
                                    .headlineLarge
                                    .override(
                                      font: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        goodHarvests.toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .displaySmall
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              color: FlutterFlowTheme.of(context)
                                                  .success,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      Text(
                                        'Good Harvests',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(),
                                              color: FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        totalWaste.toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .displaySmall
                                            .override(
                                              font: GoogleFonts.outfit(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              color: FlutterFlowTheme.of(context)
                                                  .error,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      Text(
                                        'Waste',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(),
                                              color: FlutterFlowTheme.of(context)
                                                  .secondaryBackground,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'Success Rate',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight: FontWeight.w600,
                                            ),
                                            letterSpacing: 0.0,
                                          ),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      '${successRate.toStringAsFixed(1)}%',
                                      style: FlutterFlowTheme.of(context)
                                          .displayMedium
                                          .override(
                                            font: GoogleFonts.outfit(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            color: successRate >= 70
                                                ? FlutterFlowTheme.of(context)
                                                    .success
                                                : successRate >= 50
                                                    ? FlutterFlowTheme.of(context)
                                                        .warning
                                                    : FlutterFlowTheme.of(context)
                                                        .error,
                                            letterSpacing: 0.0,
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
                    
                    // Breakdown Cards
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 10.0),
                      child: Column(
                        children: [
                          // Good Harvests
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).tertiary,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: FlutterFlowTheme.of(context).success,
                                    size: 32.0,
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Good Harvests',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          'Successfully harvested and used',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.readexPro(),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    goodHarvests.toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 10.0),
                          
                          // Waste Harvests
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).tertiary,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: FlutterFlowTheme.of(context).warning,
                                    size: 32.0,
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Harvested Waste',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          'Harvested but overgrown/not good',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.readexPro(),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    wasteHarvests.toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 10.0),
                          
                          // Pest Issues
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).tertiary,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.bug_report,
                                    color: FlutterFlowTheme.of(context).error,
                                    size: 32.0,
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pest Issues',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          'Plants lost to pests',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.readexPro(),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    pestIssues.toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 10.0),
                          
                          // Didn't Grow Well
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).tertiary,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: FlutterFlowTheme.of(context).warning,
                                    size: 32.0,
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Didn\'t Grow Well',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyLarge
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                        Text(
                                          'Plants that didn\'t thrive',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.readexPro(),
                                                letterSpacing: 0.0,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    didntGrow.toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .headlineMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          letterSpacing: 0.0,
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
              );
              } catch (e, stackTrace) {
                print('Error building harvest scorecard widget: $e');
                print('Stack trace: $stackTrace');
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48.0,
                          color: FlutterFlowTheme.of(context).error,
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          'Error loading harvest scorecard',
                          style: FlutterFlowTheme.of(context).headlineSmall,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Please try refreshing',
                          style: FlutterFlowTheme.of(context).bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

