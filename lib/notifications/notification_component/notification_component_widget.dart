import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:async';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'notification_component_model.dart';
export 'notification_component_model.dart';

class NotificationComponentWidget extends StatefulWidget {
  const NotificationComponentWidget({
    super.key,
    required this.userID,
  });

  final String? userID;

  @override
  State<NotificationComponentWidget> createState() =>
      _NotificationComponentWidgetState();
}

class _NotificationComponentWidgetState
    extends State<NotificationComponentWidget> with TickerProviderStateMixin {
  late NotificationComponentModel _model;

  // Local state for optimistic updates
  List<dynamic> _newNotifications = [];
  List<dynamic> _archivedNotifications = [];
  bool _isLoadingNew = true;
  bool _isLoadingArchived = true;
  String? _errorNew;
  String? _errorArchived;

  // Animation controllers
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationComponentModel());

    _model.tabBarController = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Load notifications
    _loadNewNotifications();
    _loadArchivedNotifications();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  Future<void> _loadNewNotifications() async {
    setState(() {
      _isLoadingNew = true;
      _errorNew = null;
    });

    try {
      final response = await GetNotificationsCall.call(
        userID: currentUserUid,
      );

      if (response.succeeded) {
        final jsonBody = response.jsonBody;
        setState(() {
          _newNotifications = jsonBody is List
              ? List.from(jsonBody)
              : jsonBody is Map
                  ? jsonBody.values.toList()
                  : <dynamic>[];
          _isLoadingNew = false;
        });
        _fadeController.forward(from: 0);
      } else {
        setState(() {
          _errorNew = 'Failed to load notifications';
          _isLoadingNew = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorNew = 'Something went wrong. Please try again.';
        _isLoadingNew = false;
      });
    }
  }

  Future<void> _loadArchivedNotifications() async {
    setState(() {
      _isLoadingArchived = true;
      _errorArchived = null;
    });

    try {
      final response = await GetArchiveNotificationsCall.call(
        userID: currentUserUid,
      );

      if (response.succeeded) {
        final jsonBody = response.jsonBody;
        setState(() {
          _archivedNotifications = jsonBody is List
              ? List.from(jsonBody)
              : jsonBody is Map
                  ? jsonBody.values.toList()
                  : <dynamic>[];
          _isLoadingArchived = false;
        });
      } else {
        setState(() {
          _errorArchived = 'Failed to load archived notifications';
          _isLoadingArchived = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorArchived = 'Something went wrong. Please try again.';
        _isLoadingArchived = false;
      });
    }
  }

  Future<void> _archiveNotification(dynamic notification, int index) async {
    final notificationId = getJsonField(notification, r'''$.notification_id''').toString();

    // Optimistic update - remove immediately with animation
    HapticFeedback.lightImpact();
    final removedItem = _newNotifications[index];
    setState(() {
      _newNotifications.removeAt(index);
    });

    // Make API call
    final result = await ArchiveNotificationsCall.call(
      userID: currentUserUid,
      notificationID: notificationId,
    );

    if (result.succeeded) {
      // Add to archived list
      setState(() {
        _archivedNotifications.insert(0, removedItem);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification archived'),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.white,
              onPressed: () => _unarchiveNotification(removedItem),
            ),
          ),
        );
      }
    } else {
      // Revert on failure
      setState(() {
        _newNotifications.insert(index, removedItem);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to archive notification'),
            backgroundColor: FlutterFlowTheme.of(context).error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  Future<void> _unarchiveNotification(dynamic notification) async {
    // For undo functionality - reload both lists
    await _loadNewNotifications();
    await _loadArchivedNotifications();
  }

  Future<void> _deleteNotification(dynamic notification, int index) async {
    final notificationId = getJsonField(notification, r'''$.notification_id''').toString();

    // Optimistic update
    HapticFeedback.lightImpact();
    final removedItem = _archivedNotifications[index];
    setState(() {
      _archivedNotifications.removeAt(index);
    });

    // Make API call
    final result = await DeleteNotficationsCall.call(
      userID: currentUserUid,
      notificationID: notificationId,
    );

    if (result.succeeded) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notification deleted'),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else {
      // Revert on failure
      setState(() {
        _archivedNotifications.insert(index, removedItem);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to delete notification'),
            backgroundColor: FlutterFlowTheme.of(context).error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  Future<void> _archiveAll() async {
    if (_newNotifications.isEmpty) return;

    HapticFeedback.mediumImpact();

    // Show confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive All'),
        content: Text('Archive all ${_newNotifications.length} notifications?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
            ),
            child: const Text('Archive All'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Archive all notifications
    final toArchive = List.from(_newNotifications);
    setState(() {
      _newNotifications.clear();
    });

    int successCount = 0;
    for (final notification in toArchive) {
      final result = await ArchiveNotificationsCall.call(
        userID: currentUserUid,
        notificationID: getJsonField(notification, r'''$.notification_id''').toString(),
      );
      if (result.succeeded) successCount++;
    }

    // Reload archived
    await _loadArchivedNotifications();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Archived $successCount notifications'),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  IconData _getNotificationIcon(String? type) {
    switch (type) {
      case 'badge_earned':
        return Icons.emoji_events;
      case 'follow':
        return Icons.person_add;
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.comment;
      case 'mention':
        return Icons.alternate_email;
      case 'harvest':
        return Icons.eco;
      case 'reminder':
        return Icons.alarm;
      case 'tip':
        return Icons.lightbulb;
      case 'achievement':
        return Icons.star;
      case 'system':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationIconColor(BuildContext context, String? type) {
    switch (type) {
      case 'badge_earned':
      case 'achievement':
        return const Color(0xFFFFB800); // Gold
      case 'follow':
        return const Color(0xFF2196F3); // Blue
      case 'like':
        return const Color(0xFFE91E63); // Pink
      case 'comment':
        return const Color(0xFFFF9800); // Orange
      case 'harvest':
        return const Color(0xFF4CAF50); // Green
      case 'reminder':
        return const Color(0xFF9C27B0); // Purple
      case 'tip':
        return const Color(0xFF00BCD4); // Cyan
      case 'system':
        return const Color(0xFF607D8B); // Blue Grey
      default:
        return FlutterFlowTheme.of(context).primary; // App primary color for default
    }
  }

  Color _getNotificationIconBackgroundColor(BuildContext context, String? type) {
    return _getNotificationIconColor(context, type).withAlpha(30);
  }

  @override
  void dispose() {
    _model.maybeDispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, 0.0),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              children: [
                // Tab bar with archive all button
                Row(
                  children: [
                    Expanded(
                      child: TabBar(
                        isScrollable: true,
                        labelColor: FlutterFlowTheme.of(context).secondary,
                        unselectedLabelColor:
                            FlutterFlowTheme.of(context).secondaryText,
                        labelStyle:
                            FlutterFlowTheme.of(context).titleMedium.override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                        unselectedLabelStyle: const TextStyle(),
                        indicatorColor: FlutterFlowTheme.of(context).primary,
                        padding: const EdgeInsets.all(4.0),
                        tabs: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.new_releases_outlined),
                              const Tab(text: ' New'),
                              if (_newNotifications.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(left: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '${_newNotifications.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inventory_2_outlined),
                              Tab(text: ' Archived'),
                            ],
                          ),
                        ],
                        controller: _model.tabBarController,
                        onTap: (i) async {
                          [() async {}, () async {}][i]();
                        },
                      ),
                    ),
                    // Archive All button - only show on New tab
                    if (_model.tabBarCurrentIndex == 0 && _newNotifications.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Semantics(
                          label: 'Archive all notifications',
                          button: true,
                          child: IconButton(
                            onPressed: _archiveAll,
                            icon: Icon(
                              Icons.done_all,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            tooltip: 'Archive All',
                          ),
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _model.tabBarController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // New notifications tab
                      _buildNotificationsList(
                        isNew: true,
                        notifications: _newNotifications,
                        isLoading: _isLoadingNew,
                        error: _errorNew,
                        onRefresh: _loadNewNotifications,
                        onAction: _archiveNotification,
                        actionLabel: 'Archive',
                        actionIcon: Icons.inventory_2_outlined,
                      ),
                      // Archived notifications tab
                      _buildNotificationsList(
                        isNew: false,
                        notifications: _archivedNotifications,
                        isLoading: _isLoadingArchived,
                        error: _errorArchived,
                        onRefresh: _loadArchivedNotifications,
                        onAction: _deleteNotification,
                        actionLabel: 'Delete',
                        actionIcon: FontAwesomeIcons.trashCan,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList({
    required bool isNew,
    required List<dynamic> notifications,
    required bool isLoading,
    required String? error,
    required Future<void> Function() onRefresh,
    required Future<void> Function(dynamic, int) onAction,
    required String actionLabel,
    required IconData actionIcon,
  }) {
    return Container(
      decoration: const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
        child: _buildContent(
          isNew: isNew,
          notifications: notifications,
          isLoading: isLoading,
          error: error,
          onRefresh: onRefresh,
          onAction: onAction,
          actionLabel: actionLabel,
          actionIcon: actionIcon,
        ),
      ),
    );
  }

  Widget _buildContent({
    required bool isNew,
    required List<dynamic> notifications,
    required bool isLoading,
    required String? error,
    required Future<void> Function() onRefresh,
    required Future<void> Function(dynamic, int) onAction,
    required String actionLabel,
    required IconData actionIcon,
  }) {
    // Loading state
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 50.0,
              height: 50.0,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading notifications...',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
          ],
        ),
      );
    }

    // Error state
    if (error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: FlutterFlowTheme.of(context).error,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (notifications.isEmpty) {
      return Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.8, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Icon(
                  isNew ? Icons.notifications_off_outlined : Icons.inventory_2_outlined,
                  size: 80,
                  color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isNew ? 'No new notifications' : 'No archived notifications',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                isNew
                    ? 'You\'re all caught up!'
                    : 'Archived notifications will appear here',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(),
                      color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.7),
                      letterSpacing: 0.0,
                    ),
                textAlign: TextAlign.center,
              ),
              if (isNew) ...[
                const SizedBox(height: 24),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.check_circle,
                    size: 48,
                    color: FlutterFlowTheme.of(context).secondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Notifications list with pull-to-refresh
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: FlutterFlowTheme.of(context).primary,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _NotificationListItem(
            key: ValueKey(getJsonField(notification, r'''$.notification_id''').toString()),
            notification: notification,
            index: index,
            onAction: () => onAction(notification, index),
            actionLabel: actionLabel,
            actionIcon: actionIcon,
            getNotificationIcon: _getNotificationIcon,
            getNotificationIconColor: _getNotificationIconColor,
            getNotificationIconBackgroundColor: _getNotificationIconBackgroundColor,
          );
        },
      ),
    );
  }
}

/// Extracted reusable notification list item widget
class _NotificationListItem extends StatefulWidget {
  const _NotificationListItem({
    super.key,
    required this.notification,
    required this.index,
    required this.onAction,
    required this.actionLabel,
    required this.actionIcon,
    required this.getNotificationIcon,
    required this.getNotificationIconColor,
    required this.getNotificationIconBackgroundColor,
  });

  final dynamic notification;
  final int index;
  final VoidCallback onAction;
  final String actionLabel;
  final IconData actionIcon;
  final IconData Function(String?) getNotificationIcon;
  final Color Function(BuildContext, String?) getNotificationIconColor;
  final Color Function(BuildContext, String?) getNotificationIconBackgroundColor;

  @override
  State<_NotificationListItem> createState() => _NotificationListItemState();
}

class _NotificationListItemState extends State<_NotificationListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 50).clamp(0, 200)),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    // Stagger animation based on index
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notificationType = getJsonField(
      widget.notification,
      r'''$.type''',
    )?.toString() ?? '';
    final isBadgeEarned = notificationType == 'badge_earned';
    final isAchievement = notificationType == 'achievement' || isBadgeEarned;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: Semantics(
        label: 'Notification: ${getJsonField(widget.notification, r'''$.title''')?.toString() ?? 'Notification'}',
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Dismissible(
            key: ValueKey(getJsonField(widget.notification, r'''$.notification_id''').toString()),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => widget.onAction(),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              decoration: BoxDecoration(
                color: widget.actionLabel == 'Delete'
                    ? FlutterFlowTheme.of(context).error
                    : FlutterFlowTheme.of(context).secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.actionIcon,
                color: Colors.white,
                size: 28,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
                boxShadow: [
                  BoxShadow(
                    blurRadius: isAchievement ? 8.0 : 4.0,
                    color: isAchievement
                        ? FlutterFlowTheme.of(context).primary.withOpacity(0.3)
                        : const Color(0x33000000),
                    offset: Offset(0.0, isAchievement ? 3.0 : 2.0),
                  )
                ],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: isAchievement
                      ? FlutterFlowTheme.of(context).primary
                      : FlutterFlowTheme.of(context).alternate,
                  width: isAchievement ? 2.0 : 1.0,
                ),
              ),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ExpandableNotifier(
                  initialExpanded: false,
                  child: ExpandablePanel(
                    header: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    // Notification type icon with colored background
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 8.0, 0.0),
                                      child: TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        duration: const Duration(milliseconds: 400),
                                        curve: Curves.elasticOut,
                                        builder: (context, value, child) {
                                          return Transform.scale(
                                            scale: value,
                                            child: child,
                                          );
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: widget.getNotificationIconBackgroundColor(context, notificationType),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            widget.getNotificationIcon(notificationType),
                                            color: widget.getNotificationIconColor(context, notificationType),
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        valueOrDefault<String>(
                                          getJsonField(widget.notification, r'''$.title''')?.toString(),
                                          'Notification',
                                        ),
                                        textAlign: TextAlign.start,
                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight: FontWeight.w600,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                          fontSize: 16.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          color: isAchievement
                                              ? FlutterFlowTheme.of(context).primary
                                              : FlutterFlowTheme.of(context).primaryText,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Action button
                              Align(
                                alignment: const AlignmentDirectional(0.0, 0.0),
                                child: Semantics(
                                  label: '${widget.actionLabel} notification',
                                  button: true,
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: widget.onAction,
                                    child: Container(
                                      width: 100.0,
                                      height: 25.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context).lineColor,
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            widget.actionIcon,
                                            color: FlutterFlowTheme.of(context).primaryText,
                                            size: 18.0,
                                          ),
                                          Align(
                                            alignment: const AlignmentDirectional(0.0, 0.0),
                                            child: Text(
                                              widget.actionLabel,
                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                ),
                                                color: FlutterFlowTheme.of(context).tertiary,
                                                fontSize: 14.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (functions.returnDateYYYYMMDD() != null &&
                                  functions.returnDateYYYYMMDD() != '')
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                  child: Text(
                                    valueOrDefault<String>(
                                      getJsonField(widget.notification, r'''$.formatted_time_created''')?.toString(),
                                      'Time Created',
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                      ),
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    collapsed: Container(),
                    expanded: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isAchievement
                              ? FlutterFlowTheme.of(context).primary.withOpacity(0.05)
                              : FlutterFlowTheme.of(context).primaryBackground,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(10.0, 5.0, 0.0, 5.0),
                                  child: Text(
                                    valueOrDefault<String>(
                                      getJsonField(widget.notification, r'''$.description''')?.toString(),
                                      'No description available',
                                    ),
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                      font: GoogleFonts.readexPro(
                                        fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                      ),
                                      color: isAchievement
                                          ? FlutterFlowTheme.of(context).primaryText
                                          : FlutterFlowTheme.of(context).secondaryText,
                                      fontSize: 16.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    theme: const ExpandableThemeData(
                      tapHeaderToExpand: true,
                      tapBodyToExpand: false,
                      tapBodyToCollapse: false,
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      hasIcon: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
