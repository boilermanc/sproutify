import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/components/create_post_widget.dart';
import '/components/post_card_widget.dart';
import '/models/index.dart';
import '/services/community_service.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/pages/badges_page.dart';
import '/index.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'community_feed_model.dart';
export 'community_feed_model.dart';

class CommunityFeedWidget extends StatefulWidget {
  const CommunityFeedWidget({super.key});

  static String routeName = 'community';
  static String routePath = '/community';

  @override
  State<CommunityFeedWidget> createState() => _CommunityFeedWidgetState();
}

class _CommunityFeedWidgetState extends State<CommunityFeedWidget> {
  late CommunityFeedModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Feed state
  List<CommunityPost> _posts = [];
  bool _isLoading = true;
  int _selectedTab =
      0; // 0 = For You, 1 = Recent, 2 = Following, 3 = Popular, 4 = Featured

  // User gamification state
  Map<String, dynamic>? _userGamification;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CommunityFeedModel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      safeSetState(() {});
      _loadUserGamification();
      _loadPosts();
    });
  }

  Future<void> _loadUserGamification() async {
    try {
      final gamification = await CommunityService.getUserGamification();
      setState(() {
        _userGamification = gamification;
      });
    } catch (e) {
      print('Error loading user gamification: $e');
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = _selectedTab == 0
          ? await CommunityService.getForYouFeed(limit: 20)
          : _selectedTab == 1
              ? await CommunityService.getRecentPosts(limit: 20)
              : _selectedTab == 2
                  ? await CommunityService.getFollowingFeed(limit: 20)
                  : _selectedTab == 3
                      ? await CommunityService.getPopularFeed(limit: 20)
                      : await CommunityService.getFeaturedPosts(limit: 20);

      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading posts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshPosts() async {
    await _loadPosts();
  }

  void _onTabChanged(int index) {
    if (_selectedTab != index) {
      setState(() {
        _selectedTab = index;
      });
      _loadPosts();
    }
  }

  List<PopupMenuEntry<String>> _buildFeedTypeMenuItems() {
    final feedTypes = [
      {'name': 'For You', 'icon': Icons.people_outline, 'index': 0},
      {'name': 'Recent', 'icon': Icons.access_time, 'index': 1},
      {'name': 'Following', 'icon': Icons.people, 'index': 2},
      {'name': 'Popular', 'icon': Icons.trending_up, 'index': 3},
      {'name': 'Featured', 'icon': Icons.star, 'index': 4},
    ];

    return feedTypes.map((feedType) {
      final index = feedType['index'] as int;
      final isSelected = _selectedTab == index;
      return PopupMenuItem<String>(
        value: feedType['name'] as String,
        child: Row(
          children: [
            Icon(
              feedType['icon'] as IconData,
              color: isSelected
                  ? FlutterFlowTheme.of(context).primary
                  : FlutterFlowTheme.of(context).secondaryText,
              size: 20.0,
            ),
            SizedBox(width: 12.0),
            Text(
              feedType['name'] as String,
              style: TextStyle(
                color: isSelected
                    ? FlutterFlowTheme.of(context).primary
                    : FlutterFlowTheme.of(context).secondaryText,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildUserProfileRow(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final currentLevel = _userGamification?['current_level'] as int? ?? 1;
    final totalXp = _userGamification?['total_xp'] as int? ?? 0;
    final totalBadgesEarned = _userGamification?['badges_earned'] as int? ?? 0;

    if (_userGamification == null) {
      return SizedBox.shrink();
    }

    return InkWell(
      onTap: () async {
        HapticFeedback.lightImpact();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BadgesPage(),
          ),
        );
        // Refresh gamification data when returning from badges page
        _loadUserGamification();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: theme.primaryBackground,
          border: Border(
            bottom: BorderSide(
              color: theme.alternate,
              width: 1.0,
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
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    final theme = FlutterFlowTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: theme.titleLarge.override(
            fontFamily: GoogleFonts.readexPro().fontFamily,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          label,
          style: theme.bodySmall.override(
            fontFamily: GoogleFonts.readexPro().fontFamily,
            letterSpacing: 0.0,
            color: theme.secondaryText,
          ),
        ),
      ],
    );
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
          backgroundColor: FlutterFlowTheme.of(context).primary,
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
              // Navigate to HomePage route - this replaces current route with NavBarPage(HomePage)
              context.go(HomePageWidget.routePath);
            },
          ),
          title: Text(
            'Community',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.outfit(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 24.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [
            SizedBox(width: 8.0),
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30.0,
              ),
              onPressed: () async {
                HapticFeedback.lightImpact();
                // Show user search dialog
                showDialog(
                  context: context,
                  builder: (context) => UserSearchDialog(),
                );
              },
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            HapticFeedback.lightImpact();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePostWidget(
                  onPostCreated: () {
                    // Switch to Recent tab to ensure new post shows up
                    // (new posts always appear in Recent feed)
                    if (_selectedTab != 1) {
                      setState(() {
                        _selectedTab = 1; // Switch to Recent tab
                      });
                    }
                    // Refresh the feed after creating a post
                    _loadPosts();
                  },
                ),
              ),
            );
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8.0,
          child: Icon(
            Icons.add_photo_alternate,
            color: FlutterFlowTheme.of(context).info,
            size: 24.0,
          ),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // User Profile Row (Name, Avatar, Stats)
              _buildUserProfileRow(context),
              // Feed Type Indicator (clickable to open dropdown)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  border: Border(
                    bottom: BorderSide(
                      color: FlutterFlowTheme.of(context).alternate,
                      width: 1.0,
                    ),
                  ),
                ),
                child: PopupMenuButton<String>(
                  onSelected: (String value) {
                    final index = [
                      'For You',
                      'Recent',
                      'Following',
                      'Popular',
                      'Featured'
                    ].indexOf(value);
                    if (index != -1) {
                      _onTabChanged(index);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      _buildFeedTypeMenuItems(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedTab == 0
                            ? Icons.people_outline
                            : _selectedTab == 1
                                ? Icons.access_time
                                : _selectedTab == 2
                                    ? Icons.people
                                    : _selectedTab == 3
                                        ? Icons.trending_up
                                        : Icons.star,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 20.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        _selectedTab == 0
                            ? 'For You'
                            : _selectedTab == 1
                                ? 'Recent'
                                : _selectedTab == 2
                                    ? 'Following'
                                    : _selectedTab == 3
                                        ? 'Popular'
                                        : 'Featured',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.readexPro(
                                fontWeight: FontWeight.w600,
                              ),
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 0.0,
                            ),
                      ),
                      SizedBox(width: 4.0),
                      Icon(
                        Icons.arrow_drop_down,
                        color: FlutterFlowTheme.of(context).secondaryText,
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
              // Posts List
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            FlutterFlowTheme.of(context).primary,
                          ),
                        ),
                      )
                    : _posts.isEmpty
                        ? RefreshIndicator(
                            onRefresh: _refreshPosts,
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.6,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _selectedTab == 0
                                            ? Icons.people_outline
                                            : _selectedTab == 1
                                                ? Icons.person_add_outlined
                                                : _selectedTab == 2
                                                    ? Icons.people
                                                    : _selectedTab == 3
                                                        ? Icons.trending_up
                                                        : Icons.star_outline,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        size: 64.0,
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(
                                        _selectedTab == 0
                                            ? 'No posts yet'
                                            : _selectedTab == 1
                                                ? 'No recent posts'
                                                : _selectedTab == 2
                                                    ? 'No posts from people you follow'
                                                    : _selectedTab == 3
                                                        ? 'No popular posts'
                                                        : 'No featured posts',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyLarge
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Text(
                                        _selectedTab == 0
                                            ? 'Be the first to share your garden!'
                                            : _selectedTab == 1
                                                ? 'Start following people to see their posts here'
                                                : 'Popular posts will appear here based on engagement',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _refreshPosts,
                            child: ListView.builder(
                              padding: EdgeInsets.all(16.0),
                              itemCount: _posts.length,
                              itemBuilder: (context, index) {
                                final post = _posts[index];
                                return PostCardWidget(
                                  post: post,
                                  onLikeChanged: () {
                                    _loadPosts();
                                  },
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple user search dialog
class UserSearchDialog extends StatefulWidget {
  @override
  State<UserSearchDialog> createState() => _UserSearchDialogState();
}

class _UserSearchDialogState extends State<UserSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadCurrentUserId();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadCurrentUserId() {
    try {
      _currentUserId = currentUserUid;
    } catch (e) {
      print('Error loading current user: $e');
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    _performSearch(query);
  }

  Future<void> _performSearch(String query) async {
    if (query.length < 2) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final results =
          await CommunityService.searchUsers(query: query, limit: 20);
      setState(() {
        _searchResults =
            results.where((user) => user['id'] != _currentUserId).toList();
        _isSearching = false;
      });
    } catch (e) {
      print('Error searching users: $e');
      setState(() {
        _isSearching = false;
      });
    }
  }

  Future<void> _toggleFollow(String userId, bool isCurrentlyFollowing) async {
    try {
      if (isCurrentlyFollowing) {
        await CommunityService.unfollowUser(userId: userId);
      } else {
        await CommunityService.followUser(userId: userId);
      }
      // Refresh search results
      _onSearchChanged();
    } catch (e) {
      print('Error toggling follow: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update follow status. Please try again.'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
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
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Search users...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(),
            // Results
            Expanded(
              child: _isSearching
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    )
                  : _searchResults.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search,
                                size: 64.0,
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                _searchController.text.isEmpty
                                    ? 'Search for users'
                                    : 'No users found',
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      font: GoogleFonts.readexPro(),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.all(8.0),
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            final user = _searchResults[index];
                            return FutureBuilder<bool>(
                              future: CommunityService.isFollowingUser(
                                userId: user['id'] as String,
                              ),
                              builder: (context, snapshot) {
                                final isFollowing = snapshot.data ?? false;
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        FlutterFlowTheme.of(context).primary,
                                    backgroundImage:
                                        user['avatar_url'] != null &&
                                                (user['avatar_url'] as String)
                                                    .isNotEmpty
                                            ? NetworkImage(
                                                user['avatar_url'] as String)
                                            : null,
                                    child: user['avatar_url'] == null ||
                                            (user['avatar_url'] as String)
                                                .isEmpty
                                        ? Text(
                                            _getInitials(user['display_name']
                                                as String?),
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),
                                  title: Text(
                                    user['display_name'] as String,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  subtitle: user['username'] != null &&
                                          (user['username'] as String)
                                              .isNotEmpty
                                      ? Text(
                                          '@${user['username']}',
                                          style: FlutterFlowTheme.of(context)
                                              .bodySmall
                                              .override(
                                                font: GoogleFonts.readexPro(),
                                                letterSpacing: 0.0,
                                              ),
                                        )
                                      : null,
                                  trailing: TextButton(
                                    onPressed: () => _toggleFollow(
                                      user['id'] as String,
                                      isFollowing,
                                    ),
                                    child: Text(
                                      isFollowing ? 'Following' : 'Follow',
                                      style: TextStyle(
                                        color: isFollowing
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryText
                                            : FlutterFlowTheme.of(context)
                                                .primary,
                                      ),
                                    ),
                                  ),
                                );
                              },
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
