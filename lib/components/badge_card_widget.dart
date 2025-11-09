import '/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget for displaying a single badge (earned or locked)
class BadgeCardWidget extends StatelessWidget {
  const BadgeCardWidget({
    super.key,
    required this.badgeName,
    required this.badgeDescription,
    required this.isEarned,
    this.iconUrl,
    this.tier,
    this.rarity,
    this.xpValue,
    this.currentProgress,
    this.requiredProgress,
    this.progressPercentage,
    this.onTap,
  });

  final String badgeName;
  final String badgeDescription;
  final bool isEarned;
  final String? iconUrl;
  final String? tier;
  final String? rarity;
  final int? xpValue;
  final int? currentProgress;
  final int? requiredProgress;
  final double? progressPercentage;
  final VoidCallback? onTap;

  Color _getRarityColor(BuildContext context) {
    switch (rarity?.toLowerCase()) {
      case 'legendary':
        return Colors.purple;
      case 'epic':
        return Colors.deepPurple;
      case 'rare':
        return Colors.blue;
      case 'uncommon':
        return Colors.green;
      case 'common':
      default:
        return FlutterFlowTheme.of(context).secondaryText;
    }
  }

  Color _getTierColor(BuildContext context) {
    switch (tier?.toLowerCase()) {
      case 'diamond':
        return Colors.cyan;
      case 'platinum':
        return Colors.grey.shade300;
      case 'gold':
        return Colors.amber;
      case 'silver':
        return Colors.grey.shade400;
      case 'bronze':
        return Colors.brown.shade300;
      default:
        return FlutterFlowTheme.of(context).primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final rarityColor = _getRarityColor(context);
    final tierColor = _getTierColor(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isEarned
              ? theme.secondaryBackground
              : theme.primaryBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isEarned
                ? tierColor.withOpacity(0.5)
                : theme.alternate,
            width: isEarned ? 2 : 1,
          ),
          boxShadow: isEarned
              ? [
                  BoxShadow(
                    color: rarityColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Badge Icon
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: isEarned
                        ? tierColor.withOpacity(0.2)
                        : theme.alternate.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isEarned ? tierColor : theme.alternate,
                      width: 2,
                    ),
                  ),
                  child: iconUrl != null && iconUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            iconUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildDefaultIcon(context, isEarned),
                          ),
                        )
                      : _buildDefaultIcon(context, isEarned),
                ),
                if (!isEarned)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Badge Name
            Text(
              badgeName,
              style: theme.bodyMedium.override(
                fontFamily: GoogleFonts.readexPro().fontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0,
                color: isEarned
                    ? theme.primaryText
                    : theme.secondaryText,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Badge Description
            Text(
              badgeDescription,
              style: theme.bodySmall.override(
                fontFamily: GoogleFonts.readexPro().fontFamily,
                fontSize: 11,
                letterSpacing: 0,
                color: theme.secondaryText,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            // Progress Bar (if not earned and has progress)
            if (!isEarned &&
                requiredProgress != null &&
                requiredProgress! > 0 &&
                progressPercentage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    LinearProgressIndicator(
                      value: (progressPercentage! / 100).clamp(0.0, 1.0),
                      backgroundColor: theme.alternate,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.primary,
                      ),
                      minHeight: 4,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${currentProgress ?? 0} / $requiredProgress',
                      style: theme.bodySmall.override(
                        fontFamily: GoogleFonts.readexPro().fontFamily,
                        fontSize: 10,
                        letterSpacing: 0,
                        color: theme.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            // XP Value (if earned)
            if (isEarned && xpValue != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '+$xpValue XP',
                    style: theme.bodySmall.override(
                      fontFamily: GoogleFonts.readexPro().fontFamily,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                      color: theme.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultIcon(BuildContext context, bool isEarned) {
    return Icon(
      Icons.emoji_events,
      size: 32,
      color: isEarned
          ? FlutterFlowTheme.of(context).primary
          : FlutterFlowTheme.of(context).secondaryText,
    );
  }
}

