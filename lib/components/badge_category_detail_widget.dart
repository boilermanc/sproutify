import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget for displaying detailed view of badges in a specific category
class BadgeCategoryDetailWidget extends StatelessWidget {
  const BadgeCategoryDetailWidget({
    super.key,
    required this.categoryName,
    required this.badges,
    this.categoryInfo,
  });

  final String categoryName;
  final List<dynamic> badges;
  final Map<String, dynamic>? categoryInfo;

  static String routeName = 'badge_category_detail';
  static String routePath = '/badge_category_detail';

  String _formatCategoryName(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _getHowToEarnText(Map<String, dynamic> badge) {
    final triggerType = badge['trigger_type'] as String? ?? '';
    final triggerThreshold = badge['trigger_threshold'] as int?;
    final currentProgress = badge['current_progress'] as int? ?? 0;
    final isEarned = badge['status'] == 'earned';

    if (isEarned) {
      return '✓ You have earned this badge!';
    }

    if (triggerThreshold == null || triggerThreshold == 0) {
      return 'This badge is awarded manually or through special events.';
    }

    switch (triggerType.toLowerCase()) {
      case 'harvest_count':
        return 'Harvest $triggerThreshold plant${triggerThreshold > 1 ? 's' : ''} to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'post_count':
        return 'Create $triggerThreshold post${triggerThreshold > 1 ? 's' : ''} in the community to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'plant_count':
        return 'Add $triggerThreshold plant${triggerThreshold > 1 ? 's' : ''} to your garden to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'tower_count':
        return 'Set up $triggerThreshold tower${triggerThreshold > 1 ? 's' : ''} to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'likes_given':
        return 'Like $triggerThreshold post${triggerThreshold > 1 ? 's' : ''} to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'likes_received':
        return 'Receive $triggerThreshold like${triggerThreshold > 1 ? 's' : ''} on your posts to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'followers_count':
        return 'Gain $triggerThreshold follower${triggerThreshold > 1 ? 's' : ''} to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'following_count':
        return 'Follow $triggerThreshold user${triggerThreshold > 1 ? 's' : ''} to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'badges_earned':
        return 'Earn $triggerThreshold badge${triggerThreshold > 1 ? 's' : ''} to unlock this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'days_active':
        return 'Be active for $triggerThreshold day${triggerThreshold > 1 ? 's' : ''} to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'ph_logged':
        return 'Log pH readings $triggerThreshold time${triggerThreshold > 1 ? 's' : ''} to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'ec_logged':
        return 'Log EC readings $triggerThreshold time${triggerThreshold > 1 ? 's' : ''} to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'cost_logged':
        return 'Log costs $triggerThreshold time${triggerThreshold > 1 ? 's' : ''} to earn this badge.\nProgress: $currentProgress / $triggerThreshold';
      
      case 'manual':
        return 'This badge is awarded manually by administrators.';
      
      default:
        return 'Complete the required action to earn this badge.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final formattedCategoryName = _formatCategoryName(categoryName);
    final earnedCount = categoryInfo?['earned'] as int? ?? 0;
    final totalCount = categoryInfo?['total'] as int? ?? badges.length;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primary,
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
            HapticFeedback.lightImpact();
            context.safePop();
          },
        ),
        title: Text(
          formattedCategoryName,
          style: theme.headlineMedium.override(
            fontFamily: GoogleFonts.readexPro().fontFamily,
            color: Colors.white,
            fontSize: 22.0,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [],
        centerTitle: true,
        elevation: 2.0,
      ),
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            // Category Progress Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.secondaryBackground,
                border: Border(
                  bottom: BorderSide(
                    color: theme.alternate,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progress',
                        style: theme.bodySmall.override(
                          fontFamily: GoogleFonts.readexPro().fontFamily,
                          letterSpacing: 0,
                          color: theme.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$earnedCount of $totalCount badges earned',
                        style: theme.titleMedium.override(
                          fontFamily: GoogleFonts.readexPro().fontFamily,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${((earnedCount / totalCount) * 100).toInt()}%',
                        style: theme.titleLarge.override(
                          fontFamily: GoogleFonts.readexPro().fontFamily,
                          fontWeight: FontWeight.bold,
                          color: theme.primary,
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Badges List
            Expanded(
              child: badges.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            size: 64,
                            color: theme.secondaryText,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No badges in this category',
                            style: theme.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: badges.length,
                      itemBuilder: (context, index) {
                        final badge = badges[index];
                        final isEarned = badge['status'] == 'earned';
                        final howToEarn = _getHowToEarnText(badge);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isEarned
                                  ? theme.primary.withOpacity(0.3)
                                  : theme.alternate,
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Badge Icon
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: isEarned
                                        ? theme.primary.withOpacity(0.1)
                                        : theme.alternate.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isEarned
                                          ? theme.primary
                                          : theme.alternate,
                                      width: 2,
                                    ),
                                  ),
                                  child: badge['icon_url'] != null &&
                                          (badge['icon_url'] as String)
                                              .isNotEmpty
                                      ? ClipOval(
                                          child: Image.network(
                                            badge['icon_url'] as String,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(
                                              Icons.emoji_events,
                                              size: 32,
                                              color: isEarned
                                                  ? theme.primary
                                                  : theme.secondaryText,
                                            ),
                                          ),
                                        )
                                      : Icon(
                                          Icons.emoji_events,
                                          size: 32,
                                          color: isEarned
                                              ? theme.primary
                                              : theme.secondaryText,
                                        ),
                                ),
                                const SizedBox(width: 16),
                                // Badge Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Badge Name
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              badge['name'] as String? ??
                                                  'Unknown Badge',
                                              style: theme.titleMedium.override(
                                                fontFamily: GoogleFonts
                                                    .readexPro()
                                                    .fontFamily,
                                                fontWeight: FontWeight.w600,
                                                letterSpacing: 0,
                                              ),
                                            ),
                                          ),
                                          if (isEarned)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: theme.primary
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                'Earned',
                                                style: theme.bodySmall.override(
                                                  fontFamily: GoogleFonts
                                                      .readexPro()
                                                      .fontFamily,
                                                  color: theme.primary,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Badge Description
                                      if (badge['description'] != null &&
                                          (badge['description'] as String)
                                              .isNotEmpty)
                                        Text(
                                          badge['description'] as String,
                                          style: theme.bodyMedium.override(
                                            fontFamily: GoogleFonts.readexPro()
                                                .fontFamily,
                                            letterSpacing: 0,
                                          ),
                                        ),
                                      const SizedBox(height: 8),
                                      // How to Earn
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isEarned
                                              ? theme.primary.withOpacity(0.05)
                                              : theme.alternate.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              isEarned
                                                  ? Icons.check_circle
                                                  : Icons.info_outline,
                                              size: 20,
                                              color: isEarned
                                                  ? theme.primary
                                                  : theme.secondaryText,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                howToEarn,
                                                style: theme.bodySmall.override(
                                                  fontFamily: GoogleFonts
                                                      .readexPro()
                                                      .fontFamily,
                                                  letterSpacing: 0,
                                                  color: isEarned
                                                      ? theme.primaryText
                                                      : theme.secondaryText,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Progress Bar (if not earned and has progress)
                                      if (!isEarned &&
                                          badge['required_progress'] != null &&
                                          (badge['required_progress'] as int) >
                                              0 &&
                                          badge['progress_percentage'] != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 12),
                                          child: Column(
                                            children: [
                                              LinearProgressIndicator(
                                                value: ((badge['progress_percentage']
                                                            as num) /
                                                        100)
                                                    .clamp(0.0, 1.0),
                                                backgroundColor: theme.alternate,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                  theme.primary,
                                                ),
                                                minHeight: 6,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${badge['current_progress'] ?? 0} / ${badge['required_progress']}',
                                                style: theme.bodySmall.override(
                                                  fontFamily: GoogleFonts
                                                      .readexPro()
                                                      .fontFamily,
                                                  fontSize: 11,
                                                  letterSpacing: 0,
                                                  color: theme.secondaryText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      // XP Value
                                      if (badge['xp_value'] != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 16,
                                                color: theme.primary,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${badge['xp_value']} XP',
                                                style: theme.bodySmall.override(
                                                  fontFamily: GoogleFonts
                                                      .readexPro()
                                                      .fontFamily,
                                                  color: theme.primary,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

