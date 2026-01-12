import '/backend/supabase/supabase.dart';

import '/flutter_flow/flutter_flow_theme.dart';

import '/flutter_flow/flutter_flow_util.dart';

import 'dart:ui';

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';

import 'ec_action_model.dart';

export 'ec_action_model.dart';

class EcActionWidget extends StatefulWidget {
  const EcActionWidget({
    super.key,
    required this.towerID,
    required this.timestamp,
    this.historyID,
    this.ecValue,
    required this.updateCallback,
  });

  final UsertowerdetailsRow? towerID;

  final DateTime? timestamp;

  final int? historyID;

  final double? ecValue;

  final Future Function()? updateCallback;

  @override
  State<EcActionWidget> createState() => _EcActionWidgetState();
}

class _EcActionWidgetState extends State<EcActionWidget> {
  late EcActionModel _model;

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

    _model = createModel(context, () => EcActionModel());

    // Initialize local value

    currentSliderValue = widget.ecValue ?? 1.8;

    _model.ecAdjustmentValue = currentSliderValue;

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  void _showEcInfoPopup() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const EcInfoPopup(),
    );
  }

  // --- HELPER: Get Color based on EC ---

  Color _getEcColor(double value) {
    if (value < 1.5) return const Color(0xFFE74C3C); // Too Low - Red

    if (value > 2.5) return const Color(0xFFF39C12); // Too High - Orange

    return const Color(0xFF2ECC71); // Sweet Spot Green
  }

  // --- HELPER: Get Status Text ---

  String _getEcStatus(double value) {
    if (value < 1.5) return "Too Low";

    if (value > 2.5) return "Too High";

    if (value >= 1.5 && value <= 2.0) return "Optimal (Greens)";

    return "Optimal (Fruiting)";
  }

  // --- HELPER: Get Status Icon ---

  IconData _getEcIcon(double value) {
    if (value >= 1.5 && value <= 2.5) return Icons.check_circle_outline;

    return Icons.warning_amber_rounded;
  }

  @override
  Widget build(BuildContext context) {
    // Calculate color for current state

    final dynamicColor = _getEcColor(currentSliderValue);

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
                          child: Icon(Icons.electric_bolt_outlined,
                              color: dynamicColor, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Target EC',
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

                            _showEcInfoPopup();
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
                    const SizedBox(height: 4),
                    Text(
                      'mS/cm',
                      style: GoogleFonts.readexPro(
                        fontSize: 14,
                        color: FlutterFlowTheme.of(context).secondaryText,
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
                          Icon(_getEcIcon(currentSliderValue),
                              color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            _getEcStatus(currentSliderValue),
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
                              Color(0xFFE74C3C), // Red (1.0 - Too Low)

                              Color(0xFF2ECC71), // Green (1.5-2.5 - Optimal)

                              Color(0xFF2ECC71), // Green (continues)

                              Color(0xFFF39C12), // Orange (2.5+ - Too High)
                            ],
                            stops: [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),

                      // Range Markers

                      const Positioned(
                        left: 10,
                        bottom: 0,
                        child: Text("1.0",
                            style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ),

                      const Positioned(
                        right: 10,
                        bottom: 0,
                        child: Text("3.0",
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
                          min: 1.0,
                          max: 3.0,
                          divisions: 40,
                          onChanged: (newValue) {
                            // Haptic feedback when entering/leaving optimal range

                            if ((newValue >= 1.5 && newValue <= 2.5) &&
                                !(currentSliderValue >= 1.5 &&
                                    currentSliderValue <= 2.5)) {
                              HapticFeedback.mediumImpact();
                            }

                            setState(() {
                              currentSliderValue = newValue;

                              _model.ecAdjustmentValue = newValue;
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
                        'ec_value': _model.ecAdjustmentValue,
                      });

                      await SupaFlow.client.rpc('refresh_usertowerdetails');

                      Navigator.pop(context);

                      await Future.delayed(const Duration(milliseconds: 1000));

                      await widget.updateCallback?.call();

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

// EC INFO POPUP - Educational Modal

// =========================================================

class EcInfoPopup extends StatefulWidget {
  const EcInfoPopup({super.key});

  @override
  State<EcInfoPopup> createState() => _EcInfoPopupState();
}

class _EcInfoPopupState extends State<EcInfoPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
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
        child: SingleChildScrollView(
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
                  "Understanding EC",
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font:
                            GoogleFonts.readexPro(fontWeight: FontWeight.bold),
                        letterSpacing: 0.0,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Electrical Conductivity = Nutrient Strength",
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        letterSpacing: 0.0,
                      ),
                ),
                const SizedBox(height: 24),

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
                            painter: EcCurvePainter(
                              animationValue: _controller.value,
                              primaryColor: const Color(0xFF2ECC71), // Green
                              warningColor: const Color(0xFFF39C12), // Orange
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 20,
                                  bottom: 10,
                                  child: Text(
                                    "1.0",
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
                                    "3.0",
                                    style: TextStyle(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      "Sweet Spot (1.5 - 2.5 mS/cm)",
                                      style: TextStyle(
                                        color: Color(0xFF2ECC71),
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

                const SizedBox(height: 24),

                // Too Low Warning
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.trending_down,
                      color: Color(0xFF3498DB), // Blue
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Too Low (< 1.5)",
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.bold),
                                      letterSpacing: 0.0,
                                    ),
                          ),
                          Text(
                            "Your plants are hungry! Low EC means not enough nutrients are dissolved in the water.",
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Optimal Range
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF2ECC71), // Green
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Optimal (1.5 - 2.5)",
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.bold),
                                      letterSpacing: 0.0,
                                    ),
                          ),
                          Text(
                            "Perfect nutrient concentration. Your roots can absorb everything they need without stress.",
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Too High Warning
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Color(0xFFE74C3C), // Red
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Too High (> 2.5)",
                            style:
                                FlutterFlowTheme.of(context).bodyLarge.override(
                                      font: GoogleFonts.readexPro(
                                          fontWeight: FontWeight.bold),
                                      letterSpacing: 0.0,
                                    ),
                          ),
                          Text(
                            "Nutrient burn risk! Too much salt can damage roots and cause brown, crispy leaf tips.",
                            style: FlutterFlowTheme.of(context)
                                .labelMedium
                                .override(
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Tutorial Carousel
                const EcTutorialCarousel(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================================================

// EC CURVE PAINTER - Animated Visualization

// =========================================================

class EcCurvePainter extends CustomPainter {
  final double animationValue;
  final Color primaryColor;
  final Color warningColor;

  EcCurvePainter({
    required this.animationValue,
    required this.primaryColor,
    required this.warningColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 2.0;

    // Gradient: Blue (low) -> Green (optimal) -> Red (high)
    final shader = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        const Color(0xFF3498DB).withOpacity(0.3), // Blue (too low)
        primaryColor, // Green (optimal)
        primaryColor, // Green (optimal)
        const Color(0xFFE74C3C).withOpacity(0.3), // Red (too high)
      ],
      stops: const [0.0, 0.25, 0.75, 1.0],
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
          const Color(0xFF3498DB).withOpacity(0.5),
          primaryColor,
          const Color(0xFFE74C3C).withOpacity(0.5),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant EcCurvePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

// =========================================================

// EC TUTORIAL CAROUSEL

// =========================================================

class EcTutorialStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const EcTutorialStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

const List<EcTutorialStep> ecTutorialSteps = [
  EcTutorialStep(
    title: "Check Water First",
    description:
        "Always test your plain water before adding nutrients. Tap water can have minerals that affect your starting EC.",
    icon: Icons.water_drop,
    color: Color(0xFF3498DB), // Blue
  ),
  EcTutorialStep(
    title: "Mix Nutrients",
    description:
        "Add nutrients to your reservoir following the manufacturer's guide. Stir thoroughly to dissolve completely.",
    icon: Icons.blender,
    color: Color(0xFF9B59B6), // Purple
  ),
  EcTutorialStep(
    title: "Take the Reading",
    description:
        "Dip your EC meter and wait for a stable number. For most plants, aim for 1.5 - 2.5 mS/cm.",
    icon: Icons.speed,
    color: Color(0xFF2ECC71), // Green
  ),
  EcTutorialStep(
    title: "Too High? Dilute",
    description:
        "If EC is too high, add plain water to dilute. High EC can burn roots and block nutrient uptake.",
    icon: Icons.water,
    color: Color(0xFFF39C12), // Orange
  ),
  EcTutorialStep(
    title: "Too Low? Feed More",
    description:
        "Low EC means hungry plants. Add more nutrient solution in small amounts until you hit the target.",
    icon: Icons.local_florist,
    color: Color(0xFF1ABC9C), // Teal
  ),
];

class EcTutorialCarousel extends StatefulWidget {
  const EcTutorialCarousel({super.key});

  @override
  State<EcTutorialCarousel> createState() => _EcTutorialCarouselState();
}

class _EcTutorialCarouselState extends State<EcTutorialCarousel> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    if (page >= 0 && page < ecTutorialSteps.length) {
      HapticFeedback.selectionClick();
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Column(
        children: [
          // --- CAROUSEL ---
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: ecTutorialSteps.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final step = ecTutorialSteps[index];
                    return _EcTutorialCard(
                      step: step,
                      stepNumber: index + 1,
                      totalSteps: ecTutorialSteps.length,
                    );
                  },
                ),

                // Left Arrow
                Positioned(
                  left: 0,
                  child: _EcNavArrow(
                    icon: Icons.chevron_left,
                    onTap: _currentPage > 0
                        ? () => _goToPage(_currentPage - 1)
                        : null,
                  ),
                ),

                // Right Arrow
                Positioned(
                  right: 0,
                  child: _EcNavArrow(
                    icon: Icons.chevron_right,
                    onTap: _currentPage < ecTutorialSteps.length - 1
                        ? () => _goToPage(_currentPage + 1)
                        : null,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // --- DOTS INDICATOR ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              ecTutorialSteps.length,
              (index) => _EcDotIndicator(
                isActive: index == _currentPage,
                color: ecTutorialSteps[index].color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================

// EC TUTORIAL CARD

// =========================================================

class _EcTutorialCard extends StatelessWidget {
  final EcTutorialStep step;
  final int stepNumber;
  final int totalSteps;

  const _EcTutorialCard({
    required this.step,
    required this.stepNumber,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: step.color.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // --- ICON CONTAINER ---
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: step.color.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: step.color.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  step.icon,
                  color: step.color,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              // --- TEXT CONTENT ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Step Number Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: step.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Step $stepNumber of $totalSteps",
                        style: GoogleFonts.readexPro(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: step.color,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Title
                    Text(
                      step.title,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2D3436),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Description
                    Text(
                      step.description,
                      style: GoogleFonts.readexPro(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF636E72),
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
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

// EC NAVIGATION ARROW

// =========================================================

class _EcNavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _EcNavArrow({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
          shape: BoxShape.circle,
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: isEnabled ? const Color(0xFF2D3436) : const Color(0xFFB2BEC3),
          size: 20,
        ),
      ),
    );
  }
}

// =========================================================

// EC DOT INDICATOR

// =========================================================

class _EcDotIndicator extends StatelessWidget {
  final bool isActive;
  final Color color;

  const _EcDotIndicator({
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? color : const Color(0xFFDFE6E9),
        borderRadius: BorderRadius.circular(4),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }
}
