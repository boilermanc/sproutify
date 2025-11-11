import '/flutter_flow/flutter_flow_theme.dart';
import '/services/community_service.dart';
import '/components/badge_card_widget.dart';
import '/components/badge_category_detail_widget.dart';
import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String? _userDisplayName;
  String? _userAvatarUrl;
  bool _isLoadingProfile = true;

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
    _loadUserProfile();
    _loadBadges();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profileUserId = widget.userId ?? currentUserUid;
      if (profileUserId.isEmpty) {
        setState(() {
          _userDisplayName = 'User';
          _isLoadingProfile = false;
        });
        return;
      }

      final profile = await ProfilesTable().querySingleRow(
        queryFn: (q) => q.eq('id', profileUserId),
      );

      if (profile.isNotEmpty) {
        final userProfile = profile.first;
        setState(() {
          // Use same display name logic as CommunityService
          if (userProfile.username != null && userProfile.username!.isNotEmpty) {
            _userDisplayName = userProfile.username;
          } else {
            final name = '${userProfile.firstName ?? ''} ${userProfile.lastName ?? ''}'.trim();
            _userDisplayName = name.isNotEmpty ? name : (userProfile.email?.split('@').first ?? 'User');
          }
          _userAvatarUrl = userProfile.avatarUrl;
          _isLoadingProfile = false;
        });
      } else {
        setState(() {
          _userDisplayName = 'User';
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() {
        _userDisplayName = 'User';
        _isLoadingProfile = false;
      });
    }
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
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
          // User Profile Header with Name and Avatar
          _buildUserProfileHeader(context),
          // User Stats Row (Level, XP, Badges)
          if (_badgeData != null && _badgeData!['user_stats'] != null)
            _buildUserStatsRow(context, _badgeData!['user_stats']),
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

  Widget _buildUserProfileHeader(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    
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
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60.0,
            height: 60.0,
            decoration: BoxDecoration(
              color: theme.primary,
              shape: BoxShape.circle,
            ),
            child: _userAvatarUrl != null && _userAvatarUrl!.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: _userAvatarUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Center(
                        child: Text(
                          _getInitials(_userDisplayName),
                          style: theme.bodyLarge.override(
                            fontFamily: GoogleFonts.readexPro().fontFamily,
                            color: theme.primaryBackground,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      _getInitials(_userDisplayName),
                      style: theme.bodyLarge.override(
                        fontFamily: GoogleFonts.readexPro().fontFamily,
                        color: theme.primaryBackground,
                        letterSpacing: 0.0,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          // Name
          Expanded(
            child: _isLoadingProfile
                ? Container(
                    width: 120.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: theme.alternate,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  )
                : Text(
                    _userDisplayName ?? 'User',
                    style: theme.headlineSmall.override(
                      fontFamily: GoogleFonts.readexPro().fontFamily,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatsRow(
      BuildContext context, Map<String, dynamic> stats) {
    final theme = FlutterFlowTheme.of(context);
    final totalXp = stats['total_xp'] as int? ?? 0;
    final currentLevel = stats['current_level'] as int? ?? 1;
    final totalBadgesEarned = stats['total_badges_earned'] as int? ?? 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        border: Border(
          bottom: BorderSide(
            color: theme.alternate,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, 'Level', currentLevel.toString()),
          _buildStatItem(context, 'XP', totalXp.toString()),
          _buildStatItem(context, 'Badges', totalBadgesEarned.toString()),
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
              // Category Header (Clickable)
              InkWell(
                onTap: () async {
                  HapticFeedback.lightImpact();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BadgeCategoryDetailWidget(
                        categoryName: category,
                        badges: categoryBadges,
                        categoryInfo: categoryInfo != null
                            ? Map<String, dynamic>.from(categoryInfo as Map)
                            : null,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12, top: index > 0 ? 24 : 0),
                  child: Row(
                    children: [
                      Expanded(
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
                      Icon(
                        Icons.chevron_right,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 24,
                      ),
                    ],
                  ),
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

