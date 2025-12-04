import '/backend/supabase/supabase.dart';

import '/flutter_flow/flutter_flow_theme.dart';

import '/flutter_flow/flutter_flow_util.dart';

import 'dart:ui';

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import 'ph_action_model.dart';

export 'ph_action_model.dart';

class PhActionWidget extends StatefulWidget {
  const PhActionWidget({
    super.key,
    required this.towerID,
    required this.phValue,
    required this.timestamp,
    this.historyID,
    required this.phCallBack,
  });

  final UsertowerdetailsRow? towerID;

  final double? phValue;

  final DateTime? timestamp;

  final int? historyID;

  final Future Function()? phCallBack;

  @override
  State<PhActionWidget> createState() => _PhActionWidgetState();
}

class _PhActionWidgetState extends State<PhActionWidget> {
  late PhActionModel _model;

  // Local state for smooth sliding without waiting for model updates

  late double currentSliderValue;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);

    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();

    _model = createModel(context, () => PhActionModel());

    // Initialize local value

    currentSliderValue = widget.phValue ?? 6.5;

    _model.phAdjustmentValue = currentSliderValue;

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void _showPhInfoPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const PhInfoPopup(),
    );
  }

  // --- HELPER: Get Color based on pH ---

  Color _getPhColor(double value) {
    if (value < 5.5) return const Color(0xFFF1C40F); // Acidic Yellow/Orange

    if (value > 6.5) return const Color(0xFF3498DB); // Alkaline Blue

    return const Color(0xFF2ECC71); // Sweet Spot Green
  }

  // --- HELPER: Get Status Text ---

  String _getPhStatus(double value) {
    if (value < 5.5) return "Too Acidic";

    if (value > 6.5) return "Too Alkaline";

    return "Sweet Spot (Optimal)";
  }

  // --- HELPER: Get Status Icon ---

  IconData _getPhIcon(double value) {
    if (value >= 5.5 && value <= 6.5) return Icons.check_circle_outline;

    return Icons.water_drop_outlined;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate color for current state

    final dynamicColor = _getPhColor(currentSliderValue);

    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 400.0,
          height: 380.0,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 15.0,
                color: dynamicColor.withOpacity(0.2),
                offset: const Offset(0.0, 5.0),
              )
            ],
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: dynamicColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- 1. Header Row ---

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: dynamicColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.science_outlined,
                              color: dynamicColor, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Target pH',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.readexPro(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                                fontSize: 18.0,
                              ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.info_outline_rounded,
                            color: FlutterFlowTheme.of(context).secondaryText,
                            size: 18,
                          ),
                          onPressed: () {
                            HapticFeedback.selectionClick();

                            _showPhInfoPopup();
                          },
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24,
                      ),
                    ),
                  ],
                ),

                // --- 2. Big Data Display ---

                Column(
                  children: [
                    Text(
                      currentSliderValue.toStringAsFixed(1),
                      style: GoogleFonts.outfit(
                        fontSize: 64,
                        fontWeight: FontWeight.w800,
                        color: dynamicColor,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: dynamicColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: dynamicColor.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_getPhIcon(currentSliderValue),
                              color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            _getPhStatus(currentSliderValue),
                            style: GoogleFonts.readexPro(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // --- 3. Custom Gradient Slider ---

                SizedBox(
                  height: 60,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // The Gradient Track Background

                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFF1C40F), // Yellow (5)

                              Color(0xFF2ECC71), // Green (6.5)

                              Color(0xFF3498DB), // Blue (8)
                            ],
                            stops: [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),

                      // Range Markers

                      const Positioned(
                        left: 10,
                        bottom: 0,
                        child: Text("5.0",
                            style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ),

                      const Positioned(
                        right: 10,
                        bottom: 0,
                        child: Text("8.0",
                            style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ),

                      // The Actual Slider (Invisible Track)

                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.transparent,
                          inactiveTrackColor: Colors.transparent,
                          thumbColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 14.0, elevation: 5),
                          overlayColor: dynamicColor.withOpacity(0.2),
                          overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 24.0),
                        ),
                        child: Slider(
                          value: currentSliderValue,
                          min: 5.0,
                          max: 8.0,
                          divisions: 30,
                          onChanged: (newValue) {
                            // Haptic feedback when entering/leaving sweet spot

                            if ((newValue >= 5.5 && newValue <= 6.5) &&
                                !(currentSliderValue >= 5.5 &&
                                    currentSliderValue <= 6.5)) {
                              HapticFeedback.mediumImpact();
                            }

                            setState(() {
                              currentSliderValue = newValue;

                              _model.phAdjustmentValue = newValue;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // --- 4. Update Button ---

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      HapticFeedback.lightImpact();

                      await PhEchistoryTable().insert({
                        'tower_id': widget.towerID?.towerId,
                        'timestamp': supaSerialize<DateTime>(widget.timestamp),
                        'ph_value': _model.phAdjustmentValue,
                      });

                      await SupaFlow.client.rpc('refresh_usertowerdetails');

                      Navigator.pop(context);

                      await Future.delayed(const Duration(milliseconds: 1000));

                      await widget.phCallBack?.call();

                      safeSetState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dynamicColor,
                      elevation: 4,
                      shadowColor: dynamicColor.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Update Tower',
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            font: GoogleFonts.readexPro(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            color: Colors.white,
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

// =========================================================

// pH INFO POPUP - Educational Modal

// =========================================================

class PhInfoPopup extends StatefulWidget {
  const PhInfoPopup({super.key});

  @override
  State<PhInfoPopup> createState() => _PhInfoPopupState();
}

class _PhInfoPopupState extends State<PhInfoPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showChecklist = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context)
              .secondaryBackground
              .withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle

              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "Understanding pH",
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.readexPro(fontWeight: FontWeight.bold),
                      letterSpacing: 0.0,
                    ),
              ),

              const SizedBox(height: 8),

              Text(
                "Why 5.5 - 6.5 is the Magic Number",
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      letterSpacing: 0.0,
                    ),
              ),

              const SizedBox(height: 30),

              // Animated Visualization

              Center(
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context)
                          .alternate
                          .withOpacity(0.3),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: NutrientCurvePainter(
                            animationValue: _controller.value,
                            primaryColor: FlutterFlowTheme.of(context).primary,
                            lockoutColor: FlutterFlowTheme.of(context).error,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 20,
                                bottom: 10,
                                child: Text(
                                  "5.0",
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 20,
                                bottom: 10,
                                child: Text(
                                  "8.0",
                                  style: TextStyle(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    "Sweet Spot (5.5 - 6.5)",
                                    style: TextStyle(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Maximum Absorption Info

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: FlutterFlowTheme.of(context).primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Maximum Absorption",
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    font: GoogleFonts.readexPro(
                                        fontWeight: FontWeight.bold),
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          "In aeroponics, nutrients dissolve best in slightly acidic water. This allows your roots to drink freely.",
                          style:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Nutrient Lockout Warning

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.cancel,
                    color: FlutterFlowTheme.of(context).error,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nutrient Lockout",
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    font: GoogleFonts.readexPro(
                                        fontWeight: FontWeight.bold),
                                    letterSpacing: 0.0,
                                  ),
                        ),
                        Text(
                          "If pH is too high (> 7.0), nutrients solidify and your plants starve, even if you add more fertilizer.",
                          style:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- pH Drift Info Section ---
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Why does my pH keep rising?",
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    font: GoogleFonts.readexPro(
                                        fontWeight: FontWeight.bold),
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "The pH Swing - This is Normal!",
                      style: FlutterFlowTheme.of(context).labelMedium.override(
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "In aeroponics, pH naturally rises as plants consume nutrients. This is called 'The Swing.' It's good to let pH drift from 5.5 up to 6.2 before bringing it back down. This prevents you from adding chemicals every hour and shocking your plants.",
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Measurement Checklist (Collapsible) ---
              InkWell(
                onTap: () => setState(() => _showChecklist = !_showChecklist),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context)
                          .alternate
                          .withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "How to Measure pH Correctly",
                        style: GoogleFonts.readexPro(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: FlutterFlowTheme.of(context).primaryText,
                        ),
                      ),
                      Icon(
                        _showChecklist ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ],
                  ),
                ),
              ),
              if (_showChecklist)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildChecklistItem("1. Stir First",
                          "Aeroponic reservoirs can have hot spots. Stir the water before measuring."),
                      const SizedBox(height: 12),
                      _buildChecklistItem("2. Calibrate",
                          "When was the last time you calibrated your meter? If it's been > 1 month, do it now."),
                      const SizedBox(height: 12),
                      _buildChecklistItem("3. Two-Point Check",
                          "If the number looks weird, re-test. Digital meters drift."),
                      const SizedBox(height: 12),
                      _buildChecklistItem("4. Liquid vs. Meter",
                          "Drops are harder to read but never lose calibration. Meters are precise but drift."),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              // --- Did You Know? Carousel ---
              const PhTipCarousel(),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER: Build Checklist Item ---
  Widget _buildChecklistItem(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 16,
          color: FlutterFlowTheme.of(context).primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.readexPro(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: GoogleFonts.readexPro(
                  fontSize: 11,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =========================================================

// CUSTOM PAINTER - Animated Bell Curve

// =========================================================

class NutrientCurvePainter extends CustomPainter {
  final double animationValue;

  final Color primaryColor;

  final Color lockoutColor;

  NutrientCurvePainter({
    required this.animationValue,
    required this.primaryColor,
    required this.lockoutColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    final shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        lockoutColor.withOpacity(0.2),
        primaryColor,
        primaryColor,
        lockoutColor.withOpacity(0.2)
      ],
      stops: const [0.0, 0.4, 0.6, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    paint.shader = shader;

    final path = Path();

    path.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      double x = (i - size.width / 2) / (size.width / 5);

      double yBase = math.exp(-x * x);

      double ripple = math.sin((i / 15) + (animationValue * 2 * math.pi)) * 3;

      double amplitude = yBase * 0.8;

      double y = size.height - (amplitude * size.height) + (ripple * yBase);

      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);

    path.close();

    canvas.drawPath(path, paint);

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..shader = LinearGradient(
        colors: [
          lockoutColor.withOpacity(0.5),
          primaryColor,
          lockoutColor.withOpacity(0.5)
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant NutrientCurvePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// =========================================================
// pH DRIFT INFO POPUP - The "Swing" Concept
// =========================================================

class PhDriftInfoPopup extends StatelessWidget {
  const PhDriftInfoPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context)
              .secondaryBackground
              .withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Why does my pH keep rising?",
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      font: GoogleFonts.readexPro(fontWeight: FontWeight.bold),
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                "The pH Swing - This is Normal!",
                style: FlutterFlowTheme.of(context).labelMedium.override(
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 20),

              // Sine Wave Visualization
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
                  ),
                ),
                child: CustomPaint(
                  painter: PhDriftWavePainter(
                    primaryColor: FlutterFlowTheme.of(context).primary,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "5.5 → 6.2 → 5.5",
                          style: GoogleFonts.readexPro(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Let it drift naturally",
                          style: GoogleFonts.readexPro(
                            fontSize: 11,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                "In aeroponics, pH naturally rises as plants consume nutrients. This is called 'The Swing.' It's good to let pH drift from 5.5 up to 6.2 before bringing it back down. This prevents you from adding chemicals every hour and shocking your plants.",
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// pH DRIFT WAVE PAINTER
// =========================================================

class PhDriftWavePainter extends CustomPainter {
  final Color primaryColor;

  PhDriftWavePainter({required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = primaryColor;

    final path = Path();
    final centerY = size.height / 2;
    final amplitude = size.height * 0.3;

    for (double i = 0; i <= size.width; i++) {
      double x = i;
      double y = centerY + amplitude * math.sin((i / size.width) * 4 * math.pi);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant PhDriftWavePainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor;
  }
}

// =========================================================
// DID YOU KNOW? TIP CAROUSEL
// =========================================================

class PhTipCarousel extends StatefulWidget {
  const PhTipCarousel({super.key});

  @override
  State<PhTipCarousel> createState() => _PhTipCarouselState();
}

class _PhTipCarouselState extends State<PhTipCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _tips = [
    {
      'icon': '🧪',
      'title': 'Order Matters',
      'text':
          'Always mix nutrients into the water before adjusting pH. Nutrients often lower pH naturally.',
    },
    {
      'icon': '⚠️',
      'title': 'Safety First',
      'text':
          'Never mix pH UP and pH DOWN directly in the same cup. They can react violently. Add them to the reservoir separately.',
    },
    {
      'icon': '🌡️',
      'title': 'Temperature',
      'text':
          'Hot water changes pH readings. Try to keep your reservoir below 75°F (24°C).',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 100,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: _tips.length,
            itemBuilder: (context, index) {
              final tip = _tips[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          tip['icon']!,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tip['title']!,
                          style: GoogleFonts.readexPro(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tip['text']!,
                      style: GoogleFonts.readexPro(
                        fontSize: 11,
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _tips.length,
            (index) => Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).alternate,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
