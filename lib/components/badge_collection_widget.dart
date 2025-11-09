import '/flutter_flow/flutter_flow_theme.dart';
import '/services/community_service.dart';
import '/components/badge_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget for displaying user's badge collection organized by category
class BadgeCollectionWidget extends StatefulWidget {
  const BadgeCollectionWidget({
    super.key,
    this.userId,
  });

  final String? userId;

  @override
  State<BadgeCollectionWidget> createState() => _BadgeCollectionWidgetState();
}

class _BadgeCollectionWidgetState extends State<BadgeCollectionWidget>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _badgeData;
  bool _isLoading = true;
  String _error = '';
  String _filter = 'all'; // 'all', 'earned', 'locked'
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _filter = 'all';
              break;
            case 1:
              _filter = 'earned';
              break;
            case 2:
              _filter = 'locked';
              break;
          }
        });
        _loadBadges();
      }
    });
    _loadBadges();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadBadges() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final data = await CommunityService.getUserBadges(
        userId: widget.userId,
        filter: _filter,
      );
      setState(() {
        _badgeData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load badges: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  String _formatCategoryName(String category) {
    return category
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
      ),
      child: Column(
        children: [
          // User Stats Header
          if (_badgeData != null && _badgeData!['user_stats'] != null)
            _buildUserStatsHeader(context, _badgeData!['user_stats']),
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: theme.primary,
            unselectedLabelColor: theme.secondaryText,
            indicatorColor: theme.primary,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Earned'),
              Tab(text: 'Locked'),
            ],
          ),
          // Content
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                    ),
                  )
                : _error.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48,
                              color: theme.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _error,
                              style: theme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadBadges,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _buildBadgeList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatsHeader(
      BuildContext context, Map<String, dynamic> stats) {
    final theme = FlutterFlowTheme.of(context);
    final totalXp = stats['total_xp'] as int? ?? 0;
    final currentLevel = stats['current_level'] as int? ?? 1;
    final totalBadgesEarned = stats['total_badges_earned'] as int? ?? 0;

    // Calculate XP for next level
    // Level formula: Level = FLOOR(SQRT(total_xp / 100)) + 1
    // So XP needed for level N: (N-1)^2 * 100
    final xpForCurrentLevel = ((currentLevel - 1) * (currentLevel - 1) * 100);
    final xpForNextLevel = (currentLevel * currentLevel * 100);
    final xpProgress = totalXp - xpForCurrentLevel;
    final xpNeeded = xpForNextLevel - xpForCurrentLevel;
    final xpPercentage = xpNeeded > 0 ? (xpProgress / xpNeeded) : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(
          bottom: BorderSide(
            color: theme.alternate,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(context, 'Level', currentLevel.toString()),
              _buildStatItem(context, 'XP', totalXp.toString()),
              _buildStatItem(
                  context, 'Badges', totalBadgesEarned.toString()),
            ],
          ),
          const SizedBox(height: 12),
          // XP Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Level $currentLevel',
                    style: theme.bodySmall.override(
                      fontFamily: GoogleFonts.readexPro().fontFamily,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0,
                    ),
                  ),
                  Text(
                    '${xpProgress.toStringAsFixed(0)} / $xpNeeded XP',
                    style: theme.bodySmall.override(
                      fontFamily: GoogleFonts.readexPro().fontFamily,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: xpPercentage.clamp(0.0, 1.0),
                backgroundColor: theme.alternate,
                valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.headlineSmall.override(
            fontFamily: GoogleFonts.readexPro().fontFamily,
            fontWeight: FontWeight.bold,
            letterSpacing: 0,
          ),
        ),
        Text(
          label,
          style: theme.bodySmall.override(
            fontFamily: GoogleFonts.readexPro().fontFamily,
            letterSpacing: 0,
            color: theme.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeList(BuildContext context) {
    if (_badgeData == null || _badgeData!['badges'] == null) {
      return Center(
        child: Text(
          'No badges found',
          style: FlutterFlowTheme.of(context).bodyMedium,
        ),
      );
    }

    final badges = _badgeData!['badges'] as List<dynamic>;
    final categories = _badgeData!['categories'] as List<dynamic>?;

    if (badges.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            const SizedBox(height: 16),
            Text(
              _filter == 'earned'
                  ? 'No badges earned yet'
                  : _filter == 'locked'
                      ? 'No locked badges'
                      : 'No badges available',
              style: FlutterFlowTheme.of(context).bodyMedium,
            ),
          ],
        ),
      );
    }

    // Group badges by category
    final Map<String, List<dynamic>> badgesByCategory = {};
    for (final badge in badges) {
      final category = badge['category'] as String? ?? 'Other';
      badgesByCategory.putIfAbsent(category, () => []).add(badge);
    }

    return RefreshIndicator(
      onRefresh: _loadBadges,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: badgesByCategory.length,
        itemBuilder: (context, index) {
          final category = badgesByCategory.keys.elementAt(index);
          final categoryBadges = badgesByCategory[category]!;
          final categoryInfo = categories?.firstWhere(
            (c) => c['category'] == category,
            orElse: () => null,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Header
              Padding(
                padding: EdgeInsets.only(bottom: 12, top: index > 0 ? 24 : 0),
                child: Row(
                  children: [
                    Text(
                      _formatCategoryName(category),
                      style: FlutterFlowTheme.of(context).titleMedium.override(
                            fontFamily: GoogleFonts.readexPro().fontFamily,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                          ),
                    ),
                    if (categoryInfo != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          '(${categoryInfo['earned']}/${categoryInfo['total']})',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: GoogleFonts.readexPro().fontFamily,
                                letterSpacing: 0,
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                      ),
                  ],
                ),
              ),
              // Badge Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: categoryBadges.length,
                itemBuilder: (context, badgeIndex) {
                  final badge = categoryBadges[badgeIndex];
                  final isEarned = badge['status'] == 'earned';
                  return BadgeCardWidget(
                    badgeName: badge['name'] as String? ?? 'Unknown',
                    badgeDescription:
                        badge['description'] as String? ?? 'No description',
                    isEarned: isEarned,
                    iconUrl: badge['icon_url'] as String?,
                    tier: badge['tier'] as String?,
                    rarity: badge['rarity'] as String?,
                    xpValue: badge['xp_value'] as int?,
                    currentProgress: badge['current_progress'] as int?,
                    requiredProgress: badge['required_progress'] as int?,
                    progressPercentage:
                        (badge['progress_percentage'] as num?)?.toDouble(),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

