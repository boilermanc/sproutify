import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget for displaying the trial status banner
/// Shows days remaining in trial and allows navigation to paywall
class TrialBannerWidget extends StatelessWidget {
  const TrialBannerWidget({
    super.key,
    required this.daysRemaining,
    required this.onDismiss,
    required this.onSubscribe,
  });

  final int daysRemaining;
  final VoidCallback onDismiss;
  final VoidCallback onSubscribe;

  Color _getBannerColor(BuildContext context) {
    if (daysRemaining <= 2) {
      return Colors.red.shade50;
    } else if (daysRemaining <= 4) {
      return Colors.orange.shade50;
    } else {
      return Colors.blue.shade50;
    }
  }

  Color _getTextColor(BuildContext context) {
    if (daysRemaining <= 2) {
      return Colors.red.shade900;
    } else if (daysRemaining <= 4) {
      return Colors.orange.shade900;
    } else {
      return Colors.blue.shade900;
    }
  }

  Color _getButtonColor(BuildContext context) {
    if (daysRemaining <= 2) {
      return Colors.red.shade700;
    } else if (daysRemaining <= 4) {
      return Colors.orange.shade700;
    } else {
      return Colors.blue.shade700;
    }
  }

  String _getBannerMessage() {
    if (daysRemaining == 1) {
      return 'Last day of your free trial!';
    } else if (daysRemaining == 0) {
      return 'Your trial expires today!';
    } else {
      return '$daysRemaining days left in your free trial';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bannerColor = _getBannerColor(context);
    final textColor = _getTextColor(context);
    final buttonColor = _getButtonColor(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: bannerColor,
        border: Border(
          bottom: BorderSide(
            color: textColor.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: Icon and message
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    color: textColor,
                    size: 20.0,
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      _getBannerMessage(),
                      style: GoogleFonts.readexPro(
                        color: textColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Right side: Subscribe button and dismiss button
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Subscribe button
                InkWell(
                  onTap: onSubscribe,
                  child: Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        12.0, 6.0, 12.0, 6.0),
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Text(
                      'Subscribe',
                      style: GoogleFonts.readexPro(
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                // Dismiss button
                InkWell(
                  onTap: onDismiss,
                  child: Icon(
                    Icons.close_rounded,
                    color: textColor.withValues(alpha: 0.6),
                    size: 20.0,
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
