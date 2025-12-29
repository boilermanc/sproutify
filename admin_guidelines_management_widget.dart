import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Adjust these imports to match your admin build's structure
// import '/backend/supabase/supabase.dart';
// import '/flutter_flow/flutter_flow_theme.dart';

/// Admin widget for managing community guidelines acceptance
///
/// Features:
/// - View acceptance statistics
/// - See users who haven't accepted
/// - Reset acceptance for specific users (e.g., after guideline updates)
/// - Bulk operations
class AdminGuidelinesManagementWidget extends StatefulWidget {
  const AdminGuidelinesManagementWidget({super.key});

  @override
  State<AdminGuidelinesManagementWidget> createState() =>
      _AdminGuidelinesManagementWidgetState();
}

class _AdminGuidelinesManagementWidgetState
    extends State<AdminGuidelinesManagementWidget> {
  Map<String, dynamic>? _statistics;
  List<Map<String, dynamic>> _usersNotAccepted = [];
  List<Map<String, dynamic>> _recentAcceptances = [];
  bool _isLoading = true;
  String _viewMode = 'stats'; // 'stats', 'not_accepted', 'recent'

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.wait([
        _loadStatistics(),
        _loadUsersNotAccepted(),
        _loadRecentAcceptances(),
      ]);
    } catch (e) {
      print('Error loading data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadStatistics() async {
    try {
      // Get total users
      final totalUsersResponse = await SupaFlow.client
          .from('profiles')
          .select('id', const FetchOptions(count: CountOption.exact));

      final totalUsers = totalUsersResponse.count ?? 0;

      // Get users who accepted
      final acceptedResponse = await SupaFlow.client
          .from('profiles')
          .select('id', const FetchOptions(count: CountOption.exact))
          .not('community_guidelines_accepted_at', 'is', null);

      final acceptedCount = acceptedResponse.count ?? 0;
      final notAcceptedCount = totalUsers - acceptedCount;
      final acceptanceRate =
          totalUsers > 0 ? (acceptedCount / totalUsers * 100) : 0.0;

      setState(() {
        _statistics = {
          'total_users': totalUsers,
          'accepted': acceptedCount,
          'not_accepted': notAcceptedCount,
          'acceptance_rate': acceptanceRate,
        };
      });
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  Future<void> _loadUsersNotAccepted() async {
    try {
      final response = await SupaFlow.client
          .from('profiles')
          .select('id, email, username, first_name, last_name, created_at')
          .isFilter('community_guidelines_accepted_at', null)
          .order('created_at', ascending: false)
          .limit(100);

      final List<dynamic> users = response as List<dynamic>;
      setState(() {
        _usersNotAccepted = users
            .map((user) => Map<String, dynamic>.from(user as Map))
            .toList();
      });
    } catch (e) {
      print('Error loading users not accepted: $e');
    }
  }

  Future<void> _loadRecentAcceptances() async {
    try {
      final response = await SupaFlow.client
          .from('profiles')
          .select(
              'id, email, username, first_name, last_name, community_guidelines_accepted_at')
          .not('community_guidelines_accepted_at', 'is', null)
          .order('community_guidelines_accepted_at', ascending: false)
          .limit(50);

      final List<dynamic> users = response as List<dynamic>;
      setState(() {
        _recentAcceptances = users
            .map((user) => Map<String, dynamic>.from(user as Map))
            .toList();
      });
    } catch (e) {
      print('Error loading recent acceptances: $e');
    }
  }

  Future<void> _resetAcceptance(String userId, String userEmail) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Guidelines Acceptance'),
        content: Text(
          'Reset guidelines acceptance for $userEmail?\n\n'
          'They will be required to accept again before posting.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.orange,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await SupaFlow.client
          .from('profiles')
          .update({'community_guidelines_accepted_at': null}).eq('id', userId);

      _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Acceptance reset successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error resetting acceptance: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _bulkResetAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset All Acceptances'),
        content: const Text(
          'This will reset guidelines acceptance for ALL users. '
          'They will all be required to accept again before posting.\n\n'
          'Use this when guidelines are updated.\n\n'
          'Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Reset All'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await SupaFlow.client
          .from('profiles')
          .update({'community_guidelines_accepted_at': null});

      _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All acceptances reset successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error bulk resetting: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reset all: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          'Guidelines Management',
          style: FlutterFlowTheme.of(context).headlineSmall.override(
                font: GoogleFonts.readexPro(
                  fontWeight: FontWeight.w600,
                ),
                letterSpacing: 0.0,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            )
          : Column(
              children: [
                // View mode tabs
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      _buildTabButton('stats', 'Statistics'),
                      const SizedBox(width: 8.0),
                      _buildTabButton('not_accepted', 'Not Accepted'),
                      const SizedBox(width: 8.0),
                      _buildTabButton('recent', 'Recent'),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
    );
  }

  Widget _buildTabButton(String value, String label) {
    final isSelected = _viewMode == value;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _viewMode = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w600,
                  ),
                  color: isSelected
                      ? Colors.white
                      : FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_viewMode) {
      case 'stats':
        return _buildStatisticsView();
      case 'not_accepted':
        return _buildNotAcceptedView();
      case 'recent':
        return _buildRecentView();
      default:
        return _buildStatisticsView();
    }
  }

  Widget _buildStatisticsView() {
    if (_statistics == null) {
      return const Center(child: Text('Loading statistics...'));
    }

    final stats = _statistics!;
    final totalUsers = stats['total_users'] as int;
    final accepted = stats['accepted'] as int;
    final notAccepted = stats['not_accepted'] as int;
    final acceptanceRate = stats['acceptance_rate'] as double;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Users',
                  totalUsers.toString(),
                  Icons.people,
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildStatCard(
                  'Accepted',
                  accepted.toString(),
                  Icons.check_circle,
                  FlutterFlowTheme.of(context).success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12.0),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Not Accepted',
                  notAccepted.toString(),
                  Icons.warning,
                  FlutterFlowTheme.of(context).error,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: _buildStatCard(
                  'Acceptance Rate',
                  '${acceptanceRate.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  FlutterFlowTheme.of(context).tertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          // Progress bar
          Text(
            'Acceptance Progress',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w600,
                  ),
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 12.0),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: LinearProgressIndicator(
              value: acceptanceRate / 100,
              minHeight: 24.0,
              backgroundColor: FlutterFlowTheme.of(context).alternate,
              valueColor: AlwaysStoppedAnimation<Color>(
                FlutterFlowTheme.of(context).success,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            '$accepted of $totalUsers users have accepted',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  font: GoogleFonts.readexPro(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 24.0),
          // Actions
          Text(
            'Actions',
            style: FlutterFlowTheme.of(context).titleMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w600,
                  ),
                  letterSpacing: 0.0,
                ),
          ),
          const SizedBox(height: 12.0),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _bulkResetAll,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset All Acceptances'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                side: BorderSide(
                  color: FlutterFlowTheme.of(context).error,
                ),
                foregroundColor: FlutterFlowTheme.of(context).error,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Use this when guidelines are updated to require all users to re-accept.',
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.readexPro(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: FlutterFlowTheme.of(context).alternate,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24.0),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  label,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.readexPro(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            value,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.readexPro(
                    fontWeight: FontWeight.w600,
                  ),
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotAcceptedView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          color: FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: FlutterFlowTheme.of(context).error,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  '${_usersNotAccepted.length} users have not accepted guidelines',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(),
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _usersNotAccepted.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 64.0,
                        color: FlutterFlowTheme.of(context).success,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'All users have accepted!',
                        style:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  font: GoogleFonts.readexPro(),
                                  letterSpacing: 0.0,
                                ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _usersNotAccepted.length,
                  itemBuilder: (context, index) {
                    final user = _usersNotAccepted[index];
                    return _buildUserCard(user, showReset: false);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRecentView() {
    return _recentAcceptances.isEmpty
        ? const Center(child: Text('No recent acceptances'))
        : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _recentAcceptances.length,
            itemBuilder: (context, index) {
              final user = _recentAcceptances[index];
              return _buildUserCard(user, showReset: true);
            },
          );
  }

  Widget _buildUserCard(Map<String, dynamic> user, {required bool showReset}) {
    final userId = user['id'] as String? ?? '';
    final email = user['email'] as String? ?? 'No email';
    final username = user['username'] as String?;
    final firstName = user['first_name'] as String?;
    final lastName = user['last_name'] as String?;
    final acceptedAt = user['community_guidelines_accepted_at'] as String?;
    final createdAt = user['created_at'] as String?;

    String displayName = username ??
        (firstName != null && lastName != null
            ? '$firstName $lastName'
            : email.split('@').first);

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          child: Text(
            displayName[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          displayName,
          style: FlutterFlowTheme.of(context).titleSmall.override(
                font: GoogleFonts.readexPro(
                  fontWeight: FontWeight.w600,
                ),
                letterSpacing: 0.0,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              email,
              style: FlutterFlowTheme.of(context).bodySmall.override(
                    font: GoogleFonts.readexPro(),
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            if (acceptedAt != null) ...[
              const SizedBox(height: 4.0),
              Text(
                'Accepted: ${_formatDate(acceptedAt)}',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.readexPro(),
                      color: FlutterFlowTheme.of(context).success,
                      letterSpacing: 0.0,
                    ),
              ),
            ] else if (createdAt != null) ...[
              const SizedBox(height: 4.0),
              Text(
                'Joined: ${_formatDate(createdAt)}',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      font: GoogleFonts.readexPro(),
                      color: FlutterFlowTheme.of(context).secondaryText,
                      letterSpacing: 0.0,
                    ),
              ),
            ],
          ],
        ),
        trailing: showReset && acceptedAt != null
            ? IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _resetAcceptance(userId, email),
                tooltip: 'Reset acceptance',
                color: FlutterFlowTheme.of(context).error,
              )
            : null,
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

