import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'ph_ec_chart_model.dart';
export 'ph_ec_chart_model.dart';

class PhEcChartWidget extends StatefulWidget {
  const PhEcChartWidget({
    super.key,
    required this.towerID,
  });

  final UsertowerdetailsRow? towerID;

  @override
  State<PhEcChartWidget> createState() => _PhEcChartWidgetState();
}

class _PhEcChartWidgetState extends State<PhEcChartWidget>
    with TickerProviderStateMixin {
  late PhEcChartModel _model;

  // Animation trigger flag
  bool _showChartData = false;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PhEcChartModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() {
      // Re-trigger animation when switching tabs
      if (!_model.tabBarController!.indexIsChanging) {
        setState(() => _showChartData = false);
        Future.delayed(const Duration(milliseconds: 100), () {
           if(mounted) safeSetState(() => _showChartData = true);
        });
      }
      safeSetState(() {});
    });

    _loadData();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _loadData() async {
    if (widget.towerID?.towerId == null) {
      print('DEBUG: No tower ID provided');
      return;
    }

    print('DEBUG: Loading data for tower_id: ${widget.towerID!.towerId}');

    try {
      final phData = await PhEchistoryTable().queryRows(
        queryFn: (q) => q
            .eq('tower_id', widget.towerID!.towerId!)
            .not('ph_value', 'is', null)
            .order('timestamp', ascending: true),
      );

      final ecData = await PhEchistoryTable().queryRows(
        queryFn: (q) => q
            .eq('tower_id', widget.towerID!.towerId!)
            .not('ec_value', 'is', null)
            .order('timestamp', ascending: true),
      );

      print('DEBUG: Loaded ${phData.length} pH records, ${ecData.length} EC records');

      // Show a snackbar with the count for visual feedback
      if (mounted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Loaded ${phData.length} pH records, ${ecData.length} EC records for tower ${widget.towerID!.towerId}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }

      safeSetState(() {
        _model.phHistoryData = phData;
        _model.ecHistoryData = ecData;
      });
    } catch (e) {
      print('DEBUG: Error loading data: $e');
    }

    // Trigger the "Grow" animation after data loads
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) safeSetState(() => _showChartData = true);
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // --- Header ---
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 40.0, 16.0, 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlutterFlowIconButton(
                  borderRadius: 12.0,
                  buttonSize: 44.0,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  borderColor: FlutterFlowTheme.of(context).alternate,
                  borderWidth: 1.0,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 24.0,
                  ),
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                ),
                Text(
                  'Water Quality',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        font: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
                // Empty box for spacing balance
                const SizedBox(width: 44.0),
              ],
            ),
          ),

          // --- Tabs ---
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              labelColor: FlutterFlowTheme.of(context).primary,
              unselectedLabelColor: FlutterFlowTheme.of(context).secondaryText,
              labelStyle: FlutterFlowTheme.of(context).titleSmall.override(
                    font: GoogleFonts.readexPro(fontWeight: FontWeight.bold),
                  ),
              indicatorColor: FlutterFlowTheme.of(context).primary,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(4),
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              controller: _model.tabBarController,
              tabs: const [
                Tab(text: 'pH Levels'),
                Tab(text: 'EC Levels'),
              ],
              onTap: (i) async {
                 // Animation reset logic handled in listener
              },
            ),
          ),

          // --- Charts Area ---
          Expanded(
            child: TabBarView(
              controller: _model.tabBarController,
              children: [
                _buildPhChart(),
                _buildEcChart(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILDER: pH CHART
  // ---------------------------------------------------------------------------
  Widget _buildPhChart() {
    if (_model.phHistoryData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_model.phHistoryData!.isEmpty) {
      return _buildEmptyState("No pH data recorded yet.");
    }

    // Calculate Min/Max for dynamic Y-Axis scaling
    final values = _model.phHistoryData!.map((e) => e.phValue ?? 7.0).toList();
    final maxY = values.reduce((curr, next) => curr > next ? curr : next) + 0.5;
    final minY = (values.reduce((curr, next) => curr < next ? curr : next) - 0.5).clamp(0.0, 14.0);

    // Create spots. If animation flag is false, flatten the spots to minY (looks like it grows up)
    final spots = _model.phHistoryData!.asMap().entries.map((entry) {
      final val = entry.value.phValue ?? 7.0;
      return FlSpot(entry.key.toDouble(), _showChartData ? val : minY);
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            padding: const EdgeInsets.fromLTRB(16, 24, 24, 0),
            child: LineChart(
              _mainChartData(
                context,
                spots,
                minY.toDouble(),
                maxY.toDouble(),
                [const Color(0xFF00C6FF), const Color(0xFF0072FF)], // pH Colors (Blue/Cyan)
                _model.phHistoryData!,
              ),
              duration: const Duration(milliseconds: 800), // Animation duration
              curve: Curves.easeInOutCubic, // Animation curve
            ),
          ),
          const SizedBox(height: 20),
          if (_model.phHistoryData!.isNotEmpty)
            _buildStatsSummary(
              'pH Statistics',
              values.reduce((a, b) => a < b ? a : b).toStringAsFixed(1),
              values.reduce((a, b) => a > b ? a : b).toStringAsFixed(1),
              (values.reduce((a, b) => a + b) / values.length).toStringAsFixed(1),
              const Color(0xFF0072FF),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BUILDER: EC CHART
  // ---------------------------------------------------------------------------
  Widget _buildEcChart() {
    if (_model.ecHistoryData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_model.ecHistoryData!.isEmpty) {
      return _buildEmptyState("No EC data recorded yet.");
    }

    // Calculate Min/Max
    final values = _model.ecHistoryData!.map((e) => e.ecValue ?? 0.0).toList();
    final maxY = values.reduce((curr, next) => curr > next ? curr : next) + 0.2;
    final minY = (values.reduce((curr, next) => curr < next ? curr : next) - 0.2).clamp(0.0, 10.0);

    final spots = _model.ecHistoryData!.asMap().entries.map((entry) {
      final val = entry.value.ecValue ?? 0.0;
      return FlSpot(entry.key.toDouble(), _showChartData ? val : minY);
    }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 300,
            padding: const EdgeInsets.fromLTRB(16, 24, 24, 0),
            child: LineChart(
              _mainChartData(
                context,
                spots,
                minY.toDouble(),
                maxY.toDouble(),
                [const Color(0xFF96E6A1), const Color(0xFFD4FC79)], // EC Colors (Green/Lime)
                _model.ecHistoryData!,
              ),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutCubic,
            ),
          ),
          const SizedBox(height: 20),
          if (_model.ecHistoryData!.isNotEmpty)
            _buildStatsSummary(
              'EC Statistics',
              values.reduce((a, b) => a < b ? a : b).toStringAsFixed(1),
              values.reduce((a, b) => a > b ? a : b).toStringAsFixed(1),
              (values.reduce((a, b) => a + b) / values.length).toStringAsFixed(1),
              const Color(0xFF96E6A1),
            ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHARED CHART CONFIGURATION
  // ---------------------------------------------------------------------------
  LineChartData _mainChartData(
    BuildContext context,
    List<FlSpot> spots,
    double minY,
    double maxY,
    List<Color> gradientColors,
    List<dynamic> historyData, // Pass original data for dates
  ) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: (maxY - minY) / 5 == 0 ? 1 : (maxY - minY) / 4,
        getDrawingHorizontalLine: (value) => FlLine(
          color: FlutterFlowTheme.of(context).alternate.withValues(alpha: 0.5),
          strokeWidth: 1,
          dashArray: [5, 5], // Dashed lines
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            interval: (spots.length / 4).ceilToDouble(), // Don't crowd X axis
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= historyData.length || value.toInt() < 0) return const SizedBox();
              final date = historyData[value.toInt()].timestamp;
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  DateFormat('M/d').format(date),
                  style: FlutterFlowTheme.of(context).labelSmall,
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (maxY - minY) / 4,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toStringAsFixed(1),
                style: FlutterFlowTheme.of(context).labelSmall,
                textAlign: TextAlign.left,
              );
            },
            reservedSize: 35,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (spots.length - 1).toDouble(),
      minY: minY,
      maxY: maxY,

      // INTERACTIVITY CONFIGURATION
      lineTouchData: LineTouchData(
        enabled: true,
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (spot) => FlutterFlowTheme.of(context).secondaryBackground,
          tooltipRoundedRadius: 8,
          tooltipPadding: const EdgeInsets.all(12),
          tooltipBorder: BorderSide(color: FlutterFlowTheme.of(context).alternate),
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final index = barSpot.x.toInt();
              final date = historyData[index].timestamp;
              return LineTooltipItem(
                '${barSpot.y.toStringAsFixed(1)}\n',
                TextStyle(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: DateFormat('MMM d, h:mm a').format(date),
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).secondaryText,
                      fontSize: 10,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
        getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: gradientColors.last,
                strokeWidth: 2,
                dashArray: [5, 5]
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    strokeWidth: 3,
                    strokeColor: gradientColors.last,
                  );
                },
              ),
            );
          }).toList();
        },
      ),

      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          curveSmoothness: 0.35, // Smoother curve
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false), // Hide default dots for cleaner look
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList()
                ..add(Colors.transparent), // Fade to bottom
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSummary(String title, String min, String max, String avg, Color accentColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12.0,
            color: Color(0x1A000000),
            offset: Offset(0.0, 4.0),
          )
        ],
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                    font: GoogleFonts.readexPro(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem('Minimum', min),
              Container(width: 1, height: 30, color: FlutterFlowTheme.of(context).alternate),
              _statItem('Average', avg),
              Container(width: 1, height: 30, color: FlutterFlowTheme.of(context).alternate),
              _statItem('Maximum', max),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: FlutterFlowTheme.of(context).labelSmall.override(
            font: GoogleFonts.readexPro(),
            color: FlutterFlowTheme.of(context).secondaryText,
            letterSpacing: 0.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: FlutterFlowTheme.of(context).titleMedium.override(
            font: GoogleFonts.readexPro(fontWeight: FontWeight.bold),
            color: FlutterFlowTheme.of(context).primaryText,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insights_rounded, size: 64, color: FlutterFlowTheme.of(context).alternate),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
