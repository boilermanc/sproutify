import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget for displaying user's XP and Level
class XpLevelDisplayWidget extends StatelessWidget {
  const XpLevelDisplayWidget({
    super.key,
    required this.level,
    required this.totalXp,
    this.showProgressBar = true,
    this.compact = false,
  });

  final int level;
  final int totalXp;
  final bool showProgressBar;
  final bool compact;

  /// Calculate XP for next level
  /// Level formula: Level = FLOOR(SQRT(total_xp / 100)) + 1
  /// So XP needed for level N: (N-1)^2 * 100
  int _getXpForLevel(int lvl) {
    return ((lvl - 1) * (lvl - 1) * 100);
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    final xpForCurrentLevel = _getXpForLevel(level);
    final xpForNextLevel = _getXpForLevel(level + 1);
    final xpProgress = totalXp - xpForCurrentLevel;
    final xpNeeded = xpForNextLevel - xpForCurrentLevel;
    final xpPercentage = xpNeeded > 0 ? (xpProgress / xpNeeded) : 0.0;

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: theme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Lv $level',
                  style: theme.bodySmall.override(
                    fontFamily: GoogleFonts.readexPro().fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0,
                    color: theme.primary,
                  ),
                ),
              ],
            ),
          ),
          if (showProgressBar) ...[
            const SizedBox(width: 8),
            SizedBox(
              width: 60,
              child: LinearProgressIndicator(
                value: xpPercentage.clamp(0.0, 1.0),
                backgroundColor: theme.alternate,
                valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.star,
              size: 18,
              color: theme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'Level $level',
              style: theme.bodyMedium.override(
                fontFamily: GoogleFonts.readexPro().fontFamily,
                fontWeight: FontWeight.w600,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '• $totalXp XP',
              style: theme.bodySmall.override(
                fontFamily: GoogleFonts.readexPro().fontFamily,
                letterSpacing: 0,
                color: theme.secondaryText,
              ),
            ),
          ],
        ),
        if (showProgressBar) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: xpPercentage.clamp(0.0, 1.0),
                  backgroundColor: theme.alternate,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${xpProgress.toStringAsFixed(0)} / $xpNeeded',
                style: theme.bodySmall.override(
                  fontFamily: GoogleFonts.readexPro().fontFamily,
                  fontSize: 10,
                  letterSpacing: 0,
                  color: theme.secondaryText,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

