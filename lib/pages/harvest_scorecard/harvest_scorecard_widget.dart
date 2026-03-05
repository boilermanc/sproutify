import '/auth/supabase_auth/auth_util.dart';

import '/backend/supabase/supabase.dart';

import '/flutter_flow/flutter_flow_icon_button.dart';

import '/flutter_flow/flutter_flow_theme.dart';

import '/flutter_flow/flutter_flow_util.dart';

import '/flutter_flow/flutter_flow_animations.dart';


import 'dart:async';

import '/index.dart';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_animate/flutter_animate.dart';


import 'harvest_scorecard_model.dart';

export 'harvest_scorecard_model.dart';

class HarvestScorecardWidget extends StatefulWidget {
  const HarvestScorecardWidget({super.key});

  static String routeName = 'harvestScorecard';

  static String routePath = '/harvestScorecard';

  @override
  State<HarvestScorecardWidget> createState() => _HarvestScorecardWidgetState();
}

class _HarvestScorecardWidgetState extends State<HarvestScorecardWidget>
    with TickerProviderStateMixin {
  late HarvestScorecardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<Map<String, dynamic>>? _dataFuture;

  final animationsMap = {
    'containerOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        FadeEffect(curve: Curves.easeInOut, delay: 0.ms, duration: 600.ms),
        MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.ms,
            duration: 600.ms,
            begin: const Offset(0, 50),
            end: const Offset(0, 0)),
      ],
    ),
    'cardsOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effectsBuilder: () => [
        FadeEffect(curve: Curves.easeInOut, delay: 200.ms, duration: 600.ms),
        MoveEffect(
            curve: Curves.easeInOut,
            delay: 200.ms,
            duration: 600.ms,
            begin: const Offset(0, 30),
            end: const Offset(0, 0)),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => HarvestScorecardModel());

    _loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final plants = await UserplantdetailsTable().queryRows(
      queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
    );

    final plantIds = <int>[];
    final plantNameMap = <int, String>{};
    for (final p in plants) {
      final plantId = p.userPlantId;
      final name = p.plantName ?? 'Plant #$plantId';
      if (plantId != null) {
        plantIds.add(plantId);
        plantNameMap[plantId] = name;
      }
    }

    List<UserplantActionsRow> actions = [];
    if (plantIds.isNotEmpty) {
      actions = await UserplantActionsTable().queryRows(
        queryFn: (q) => q
            .inFilter('user_plant_id', plantIds)
            .order('action_date', ascending: false),
      );
    }

    return {
      'plantNameMap': plantNameMap,
      'actions': actions,
    };
  }

  void _loadData() {
    _dataFuture = _fetchData();
  }

  void _refreshData() {
    safeSetState(() {
      _loadData();
    });
  }

  String _getMotivationalMessage(double rate, int total) {
    if (total == 0) return "Start your first harvest!";

    if (rate >= 90) return "Master Gardener Status! 🏆";

    if (rate >= 75) return "You're crushing it! 🌱";

    if (rate >= 50) return "Doing great, keep growing! 🌿";

    return "Every mistake is a lesson. 🍂";
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
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed(HomePageWidget.routeName);
            },
          ),
          title: Text(
            'Scorecard',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 22.0,
                ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh,
                  color: FlutterFlowTheme.of(context).secondaryText),
              onPressed: _refreshData,
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: FutureBuilder<Map<String, dynamic>>(
            future: _dataFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final plantNameMap = snapshot.data!['plantNameMap'] as Map<int, String>;
              final actions = snapshot.data!['actions'] as List<UserplantActionsRow>;

              int goodHarvests = 0;
              int wasteHarvests = 0;
              int pestIssues = 0;
              int didntGrow = 0;

              for (final a in actions) {
                final t = a.actionType;
                if (t == 'Harvested_Good' || t == 'Harvested') {
                  goodHarvests++;
                } else if (t == 'Harvested_Waste') {
                  wasteHarvests++;
                } else if (t == 'Pest') {
                  pestIssues++;
                } else if (t == 'Waste') {
                  didntGrow++;
                }
              }

              final int totalOutcomes =
                  goodHarvests + wasteHarvests + didntGrow;
              final double successRate = totalOutcomes > 0
                  ? (goodHarvests / totalOutcomes * 100)
                  : 0.0;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              borderRadius: BorderRadius.circular(24.0),
                              border: Border.all(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Stack(
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      SizedBox(
                                        width: 160.0,
                                        height: 160.0,
                                        child: CircularProgressIndicator(
                                          value: 1.0,
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          strokeWidth: 4.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 160.0,
                                        height: 160.0,
                                        child: CircularProgressIndicator(
                                          value: successRate / 100,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          strokeWidth: 8.0,
                                          strokeCap: StrokeCap.round,
                                        ),
                                      ).animate().scale(
                                          duration: 800.ms,
                                          curve: Curves.easeOutBack),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '${successRate.toStringAsFixed(0)}%',
                                            style: FlutterFlowTheme.of(context)
                                                .displayMedium
                                                .override(
                                                  font: GoogleFonts.outfit(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 48.0,
                                                  ),
                                                ),
                                          )
                                              .animate()
                                              .fadeIn(delay: 400.ms)
                                              .slideY(begin: 0.2, end: 0),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'SUCCESS RATE',
                                                style: FlutterFlowTheme.of(context)
                                                    .labelSmall
                                                    .override(
                                                      font: GoogleFonts.readexPro(
                                                        letterSpacing: 2.0,
                                                      ),
                                                    ),
                                              ),
                                              const SizedBox(width: 4),
                                              GestureDetector(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  _showInfoSheet(
                                                    context,
                                                    'Success Rate',
                                                    'Your success rate is the percentage of successful harvests out of all plant outcomes (harvested, composted, and failed). Pest reports are tracked separately and don\'t affect this score.',
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.info_outline_rounded,
                                                  size: 14,
                                                  color: FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  Text(
                                    _getMotivationalMessage(
                                        successRate, totalOutcomes),
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyLarge
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                  ).animate().fadeIn(delay: 600.ms),
                                ],
                              ),
                            ),
                          ).animateOnPageLoad(
                              animationsMap['containerOnPageLoadAnimation']!),
                          const SizedBox(height: 32.0),
                          Row(
                            children: [
                              Text(
                                'BREAKDOWN',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  _showInfoSheet(
                                    context,
                                    'Breakdown',
                                    'These counts come from the actions you log on your plants.\n\n'
                                    'Harvested — Plants you successfully harvested.\n\n'
                                    'Composted — Harvests that went to waste or compost.\n\n'
                                    'Pests — Times you recorded a pest issue.\n\n'
                                    'Failed — Plants that didn\'t grow or were removed.',
                                  );
                                },
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  size: 14,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Wrap(
                            spacing: 16.0,
                            runSpacing: 16.0,
                            children: [
                              _buildStatCard(
                                  context,
                                  'Harvested',
                                  goodHarvests,
                                  Icons.check_circle_outline_rounded,
                                  FlutterFlowTheme.of(context).success),
                              _buildStatCard(
                                  context,
                                  'Composted',
                                  wasteHarvests,
                                  Icons.delete_outline_rounded,
                                  const Color(0xFFE89A3C)),
                              _buildStatCard(
                                  context,
                                  'Pests',
                                  pestIssues,
                                  Icons.bug_report_outlined,
                                  FlutterFlowTheme.of(context).error),
                              _buildStatCard(
                                  context,
                                  'Failed',
                                  didntGrow,
                                  Icons.do_not_disturb_on_outlined,
                                  FlutterFlowTheme.of(context).secondaryText),
                            ],
                          ).animateOnPageLoad(
                              animationsMap['cardsOnPageLoadAnimation']!),
                          const SizedBox(height: 32.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'RECENT ACTIVITY',
                                style: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .override(
                                      font: GoogleFonts.readexPro(
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              ),
                              Icon(Icons.history,
                                  size: 16,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          if (actions.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.eco_outlined,
                                      size: 48,
                                      color: FlutterFlowTheme.of(context)
                                          .alternate,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No activity yet.\nStart tracking your harvests!',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.readexPro(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                            ),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:
                                  actions.length > 5 ? 5 : actions.length,
                              itemBuilder: (context, index) {
                                final action = actions[index];

                                final plantId =
                                    action.userPlantId ?? 0;

                                final type =
                                    action.actionType ?? 'Unknown';

                                final date = action.actionDate;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                        color: FlutterFlowTheme.of(context)
                                            .alternate,
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 4),
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _getIconForType(type),
                                          size: 20,
                                          color:
                                              _getColorForType(context, type),
                                        ),
                                      ),
                                      title: Text(
                                        plantNameMap[plantId] ??
                                            'Plant #$plantId',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                      ),
                                      subtitle: Text(
                                        type.replaceAll('_', ' '),
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall,
                                      ),
                                      trailing: Text(
                                        date != null
                                            ? DateFormat('MMM d').format(date)
                                            : '',
                                        style: FlutterFlowTheme.of(context)
                                            .labelSmall,
                                      ),
                                    ),
                                  ),
                                )
                                    .animate()
                                    .fadeIn(delay: (400 + (index * 100)).ms)
                                    .slideX(begin: 0.1, end: 0);
                              },
                            ),
                          const SizedBox(height: 24.0),
                        ],
                      ),
                    ),
                  );
            },
          ),
        ),
      ),
    );
  }

  void _showInfoSheet(BuildContext context, String title, String description) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(height: 1.5),
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    if (type.contains('Good') || type == 'Harvested') {
      return Icons.check_circle_outline_rounded;
    }

    if (type.contains('Waste') || type == 'Composted') {
      return Icons.delete_outline_rounded;
    }

    if (type == 'Pest') return Icons.bug_report_outlined;

    return Icons.circle_outlined;
  }

  Color _getColorForType(BuildContext context, String type) {
    if (type.contains('Good') || type == 'Harvested') {
      return FlutterFlowTheme.of(context).success;
    }

    if (type.contains('Waste') || type == 'Composted') return const Color(0xFFE89A3C);

    if (type == 'Pest') return FlutterFlowTheme.of(context).error;

    return FlutterFlowTheme.of(context).secondaryText;
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    int count,
    IconData icon,
    Color accentColor,
  ) {
    double cardWidth = (MediaQuery.sizeOf(context).width - 48 - 16) / 2;

    return Container(
      width: cardWidth,
      constraints: const BoxConstraints(minHeight: 110.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: accentColor,
              size: 26.0,
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.readexPro(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ),
                Text(
                  count.toString(),
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                        color: accentColor,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
