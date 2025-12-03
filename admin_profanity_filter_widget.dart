import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Adjust these imports to match your admin build's structure
// import '/backend/supabase/supabase.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/services/community_service.dart'; // If available in admin build

/// Admin widget for managing profanity filter words
///
/// Features:
/// - View all profanity words with filters
/// - Add new words
/// - Edit existing words (enable/disable, severity, context)
/// - Delete words
/// - Clear cache after updates
class AdminProfanityFilterWidget extends StatefulWidget {
  const AdminProfanityFilterWidget({super.key});

  @override
  State<AdminProfanityFilterWidget> createState() =>
      _AdminProfanityFilterWidgetState();
}

class _AdminProfanityFilterWidgetState
    extends State<AdminProfanityFilterWidget> {
  List<Map<String, dynamic>> _profanityWords = [];
  bool _isLoading = true;
  String _filter = 'all'; // 'all', 'enabled', 'disabled'
  String _severityFilter = 'all'; // 'all', 'low', 'medium', 'high'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfanityWords();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProfanityWords() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Adjust Supabase client reference to match your admin build
      final response = await SupaFlow.client
          .from('profanity_filter')
          .select()
          .order('word', ascending: true);

      final List<dynamic> words = response as List<dynamic>;

      setState(() {
        _profanityWords = words
            .map((word) => Map<String, dynamic>.from(word as Map))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profanity words: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading words: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addWord({
    required String word,
    String severity = 'medium',
    String? context,
  }) async {
    try {
      await SupaFlow.client.from('profanity_filter').insert({
        'word': word.toLowerCase().trim(),
        'severity': severity,
        'context': context ?? 'general',
        'enabled': true,
      });

      _loadProfanityWords();
      _clearCache();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Word added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error adding word: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add word: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _updateWord({
    required String id,
    bool? enabled,
    String? severity,
    String? context,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (enabled != null) updates['enabled'] = enabled;
      if (severity != null) updates['severity'] = severity;
      if (context != null) updates['context'] = context;

      await SupaFlow.client
          .from('profanity_filter')
          .update(updates)
          .eq('id', id);

      _loadProfanityWords();
      _clearCache();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Word updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error updating word: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update word: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteWord(String id, String word) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Word'),
        content: Text('Are you sure you want to delete "$word"?'),
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
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await SupaFlow.client.from('profanity_filter').delete().eq('id', id);

      _loadProfanityWords();
      _clearCache();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Word deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error deleting word: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete word: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearCache() {
    // If CommunityService is available in admin build:
    // CommunityService.clearProfanityCache();

    // Otherwise, the cache will expire naturally after 1 hour
    // Or you can call a webhook/API endpoint to clear it
    print('Cache should be cleared (or will expire in 1 hour)');
  }

  void _showAddWordDialog() {
    final wordController = TextEditingController();
    String selectedSeverity = 'medium';
    String selectedContext = 'general';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Profanity Word'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: wordController,
                  decoration: const InputDecoration(
                    labelText: 'Word',
                    hintText: 'Enter word to filter',
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedSeverity,
                  decoration: const InputDecoration(
                    labelText: 'Severity',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedSeverity = value!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedContext,
                  decoration: const InputDecoration(
                    labelText: 'Context',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'general', child: Text('General')),
                    DropdownMenuItem(
                        value: 'hate_speech', child: Text('Hate Speech')),
                    DropdownMenuItem(
                        value: 'violence', child: Text('Violence')),
                    DropdownMenuItem(value: 'drugs', child: Text('Drugs')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedContext = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (wordController.text.trim().isNotEmpty) {
                  _addWord(
                    word: wordController.text.trim(),
                    severity: selectedSeverity,
                    context: selectedContext,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditWordDialog(Map<String, dynamic> word) {
    final wordId = word['id'] as String;
    bool enabled = word['enabled'] as bool? ?? true;
    String severity = word['severity'] as String? ?? 'medium';
    String context = word['context'] as String? ?? 'general';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Edit: ${word['word']}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Enabled'),
                  value: enabled,
                  onChanged: (value) {
                    setDialogState(() {
                      enabled = value;
                    });
                  },
                ),
                const SizedBox(height: 8.0),
                DropdownButtonFormField<String>(
                  value: severity,
                  decoration: const InputDecoration(
                    labelText: 'Severity',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      severity = value!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: context,
                  decoration: const InputDecoration(
                    labelText: 'Context',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'general', child: Text('General')),
                    DropdownMenuItem(
                        value: 'hate_speech', child: Text('Hate Speech')),
                    DropdownMenuItem(
                        value: 'violence', child: Text('Violence')),
                    DropdownMenuItem(value: 'drugs', child: Text('Drugs')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      context = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateWord(
                  id: wordId,
                  enabled: enabled,
                  severity: severity,
                  context: context,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredWords {
    var filtered = _profanityWords;

    // Filter by enabled/disabled
    if (_filter == 'enabled') {
      filtered = filtered.where((w) => w['enabled'] == true).toList();
    } else if (_filter == 'disabled') {
      filtered = filtered.where((w) => w['enabled'] == false).toList();
    }

    // Filter by severity
    if (_severityFilter != 'all') {
      filtered =
          filtered.where((w) => w['severity'] == _severityFilter).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((w) {
        final word = (w['word'] as String? ?? '').toLowerCase();
        final context = (w['context'] as String? ?? '').toLowerCase();
        return word.contains(query) || context.contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        automaticallyImplyLeading: true,
        title: Text(
          'Profanity Filter Management',
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
            onPressed: _loadProfanityWords,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddWordDialog,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Search and filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search words...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 12.0),
                // Filter chips
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('all', 'All', _filter),
                            const SizedBox(width: 8.0),
                            _buildFilterChip('enabled', 'Enabled', _filter),
                            const SizedBox(width: 8.0),
                            _buildFilterChip('disabled', 'Disabled', _filter),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip(
                                'all', 'All Severity', _severityFilter),
                            const SizedBox(width: 8.0),
                            _buildFilterChip('low', 'Low', _severityFilter),
                            const SizedBox(width: 8.0),
                            _buildFilterChip(
                                'medium', 'Medium', _severityFilter),
                            const SizedBox(width: 8.0),
                            _buildFilterChip('high', 'High', _severityFilter),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Stats
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            color: FlutterFlowTheme.of(context).alternate.withOpacity(0.3),
            child: Row(
              children: [
                Text(
                  'Total: ${_profanityWords.length} | ',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FontWeight.w600,
                        ),
                        letterSpacing: 0.0,
                      ),
                ),
                Text(
                  'Enabled: ${_profanityWords.where((w) => w['enabled'] == true).length} | ',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.readexPro(),
                        color: FlutterFlowTheme.of(context).success,
                        letterSpacing: 0.0,
                      ),
                ),
                Text(
                  'Showing: ${_filteredWords.length}',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.readexPro(),
                        letterSpacing: 0.0,
                      ),
                ),
              ],
            ),
          ),
          // Words list
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  )
                : _filteredWords.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.filter_list_off,
                              size: 64.0,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'No words found',
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    font: GoogleFonts.readexPro(),
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Try adjusting your filters or add a new word',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.readexPro(),
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadProfanityWords,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: _filteredWords.length,
                          itemBuilder: (context, index) {
                            final word = _filteredWords[index];
                            return _buildWordCard(word);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String value, String label, String currentFilter) {
    final isSelected = currentFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (currentFilter == _filter) {
            _filter = value;
          } else {
            _severityFilter = value;
          }
        });
      },
      selectedColor: FlutterFlowTheme.of(context).primary,
      labelStyle: TextStyle(
        color: isSelected
            ? Colors.white
            : FlutterFlowTheme.of(context).secondaryText,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  Widget _buildWordCard(Map<String, dynamic> word) {
    final wordText = word['word'] as String? ?? '';
    final enabled = word['enabled'] as bool? ?? true;
    final severity = word['severity'] as String? ?? 'medium';
    final context = word['context'] as String? ?? 'general';
    final wordId = word['id'] as String;

    Color severityColor;
    switch (severity) {
      case 'high':
        severityColor = Colors.red;
        break;
      case 'medium':
        severityColor = Colors.orange;
        break;
      case 'low':
        severityColor = Colors.blue;
        break;
      default:
        severityColor = FlutterFlowTheme.of(context).secondaryText;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: enabled
              ? FlutterFlowTheme.of(context).success
              : FlutterFlowTheme.of(context).secondaryText,
          child: Icon(
            enabled ? Icons.check : Icons.close,
            color: Colors.white,
            size: 20.0,
          ),
        ),
        title: Text(
          wordText,
          style: FlutterFlowTheme.of(context).titleMedium.override(
                font: GoogleFonts.readexPro(
                  fontWeight: FontWeight.w600,
                ),
                letterSpacing: 0.0,
                decoration: enabled ? null : TextDecoration.lineThrough,
                color: enabled
                    ? FlutterFlowTheme.of(context).primaryText
                    : FlutterFlowTheme.of(context).secondaryText,
              ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4.0),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    severity.toUpperCase(),
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.readexPro(
                            fontWeight: FontWeight.w600,
                          ),
                          color: severityColor,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color:
                        FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    context.replaceAll('_', ' ').toUpperCase(),
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          font: GoogleFonts.readexPro(
                            fontWeight: FontWeight.w600,
                          ),
                          color: FlutterFlowTheme.of(context).primary,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditWordDialog(word),
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteWord(wordId, wordText),
              tooltip: 'Delete',
              color: FlutterFlowTheme.of(context).error,
            ),
          ],
        ),
      ),
    );
  }
}
