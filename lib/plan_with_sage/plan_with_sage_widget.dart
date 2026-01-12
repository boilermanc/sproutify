import 'dart:async';

import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'plan_with_sage_model.dart';
export 'plan_with_sage_model.dart';

const sageThinkingMessages = [
  "Seeding some thoughts...",
  "Growing some ideas...",
  "Tending to your request...",
  "Cultivating the perfect plan...",
  "Sprouting possibilities...",
  "Digging into your garden goals...",
  "Branching out options...",
  "Rooting through the plant catalog...",
  "Blooming with inspiration...",
  "Harvesting the best picks...",
];

class PlanWithSageWidget extends StatefulWidget {
  const PlanWithSageWidget({
    super.key,
    required this.towerId,
    required this.towerName,
    required this.portCount,
    this.indoorOutdoor,
  });

  final int? towerId;
  final String? towerName;
  final int? portCount;
  final String? indoorOutdoor;

  static String routeName = 'planWithSage';
  static String routePath = '/planWithSage';

  @override
  State<PlanWithSageWidget> createState() => _PlanWithSageWidgetState();
}

class _PlanWithSageWidgetState extends State<PlanWithSageWidget> {
  late PlanWithSageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Track current view: 'home', 'chat', 'plan'
  String _currentView = 'home';

  // Saved plans list
  List<SavedPlansRow> _savedPlans = [];
  bool _loadingSavedPlans = true;

  // Rotating thinking messages
  Timer? _thinkingMessageTimer;
  int _thinkingMessageIndex = 0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PlanWithSageModel());
    _loadSavedPlans();
  }

  @override
  void dispose() {
    _stopThinkingMessageTimer();
    _model.dispose();
    super.dispose();
  }

  void _startThinkingMessageTimer() {
    _thinkingMessageIndex = 0;
    _thinkingMessageTimer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) {
        if (mounted) {
          setState(() {
            _thinkingMessageIndex =
                (_thinkingMessageIndex + 1) % sageThinkingMessages.length;
          });
        }
      },
    );
  }

  void _stopThinkingMessageTimer() {
    _thinkingMessageTimer?.cancel();
    _thinkingMessageTimer = null;
  }

  Future<void> _loadSavedPlans() async {
    try {
      final plans = await SavedPlansTable().queryRows(
        queryFn: (q) => q
            .eqOrNull('user_id', currentUserUid)
            .eqOrNull('tower_id', widget.towerId)
            .order('created_at', ascending: false),
      );
      setState(() {
        _savedPlans = plans;
        _loadingSavedPlans = false;
      });
    } catch (e) {
      setState(() {
        _loadingSavedPlans = false;
      });
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _model.messages.add({'role': 'user', 'content': message});
      _model.isLoading = true;
      _model.chatInputController?.clear();
    });
    _startThinkingMessageTimer();

    // Scroll to bottom after adding user message
    _scrollToBottom();

    try {
      // Call the Sage Planner API with tower context
      final response = await SagePlannerCall.call(
        towerId: widget.towerId,
        towerName: widget.towerName,
        indoorOutdoor: widget.indoorOutdoor ?? 'Indoor',
        portCount: widget.portCount,
        userRequest: message,
      );

      if (response.succeeded) {
        // Check if we got a successful plan response
        final success = SagePlannerCall.success(response.jsonBody) ?? false;

        if (success) {
          // Extract plan data
          final planName = SagePlannerCall.planName(response.jsonBody);
          final description = SagePlannerCall.description(response.jsonBody);
          final plants = SagePlannerCall.plants(response.jsonBody);
          final totalSlots = SagePlannerCall.totalSlotsUsed(response.jsonBody) ?? 0;

          _stopThinkingMessageTimer();
          setState(() {
            _model.planName = planName;
            _model.planDescription = description;
            _model.totalSlotsUsed = totalSlots;
            _model.generatedPlan = plants != null
                ? List<Map<String, dynamic>>.from(
                    plants.map((p) => Map<String, dynamic>.from(p as Map)))
                : [];
            _model.hasPlan = true;
            _model.isLoading = false;

            // Add a success message to chat
            _model.messages.add({
              'role': 'assistant',
              'content': "I've created your plan: \"$planName\"! Tap below to view your personalized tower plan."
            });
          });

          _scrollToBottom();

          // Auto-navigate to plan view after a short delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              setState(() {
                _currentView = 'plan';
              });
            }
          });
        } else {
          _stopThinkingMessageTimer();
          setState(() {
            _model.messages.add({
              'role': 'assistant',
              'content': 'I had trouble creating a plan. Could you try rephrasing your request?'
            });
            _model.isLoading = false;
          });
          _scrollToBottom();
        }
      } else {
        _stopThinkingMessageTimer();
        setState(() {
          _model.messages.add({
            'role': 'assistant',
            'content': 'I apologize, but I encountered an issue. Could you try again?'
          });
          _model.isLoading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      _stopThinkingMessageTimer();
      setState(() {
        _model.messages.add({
          'role': 'assistant',
          'content': 'I apologize, but I encountered an issue. Could you try again?'
        });
        _model.isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_model.chatScrollController?.hasClients ?? false) {
        _model.chatScrollController!.animateTo(
          _model.chatScrollController!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _savePlan(String planName) async {
    if (planName.trim().isEmpty || _model.generatedPlan.isEmpty) return;

    try {
      await SavedPlansTable().insert({
        'user_id': currentUserUid,
        'tower_id': widget.towerId,
        'plan_name': planName.trim(),
        'plan_data': jsonEncode(_model.generatedPlan),
        'created_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Plan "$planName" saved!'),
          backgroundColor: FlutterFlowTheme.of(context).primary,
        ),
      );

      _loadSavedPlans();
      _model.planNameController?.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save plan. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deletePlan(int planId) async {
    try {
      await SavedPlansTable().delete(
        matchingRows: (row) => row.eqOrNull('id', planId),
      );
      _loadSavedPlans();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Plan deleted'),
          backgroundColor: FlutterFlowTheme.of(context).primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete plan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _loadSavedPlan(SavedPlansRow plan) {
    try {
      final planData = jsonDecode(plan.planData ?? '[]');
      setState(() {
        _model.generatedPlan = List<Map<String, dynamic>>.from(
          (planData as List).map((p) => Map<String, dynamic>.from(p as Map)),
        );
        _model.planName = plan.planName;
        _model.planDescription = null; // Saved plans don't store description
        _model.totalSlotsUsed = _model.generatedPlan.fold<int>(
          0, (sum, plant) => sum + ((plant['quantity'] as int?) ?? 1));
        _model.hasPlan = true;
        _currentView = 'plan';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load plan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: const Color(0xFF9C27B0),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              if (_currentView != 'home') {
                setState(() {
                  _currentView = 'home';
                });
              } else {
                context.safePop();
              }
            },
          ),
          title: Flexible(
            child: Text(
              'Plan with Sage',
              overflow: TextOverflow.ellipsis,
              style: FlutterFlowTheme.of(context).headlineMedium.override(
                    font: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                    ),
                    color: Colors.white,
                    fontSize: 24.0,
                    letterSpacing: 0.0,
                  ),
            ),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: _buildCurrentView(),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case 'chat':
        return _buildChatView();
      case 'plan':
        return _buildPlanView();
      default:
        return _buildHomeView();
    }
  }

  Widget _buildHomeView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tower info card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.grass,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 24.0,
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          widget.towerName ?? 'My Tower',
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                ),
                                fontSize: 20.0,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${widget.portCount ?? 0} ports available',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.readexPro(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Start new plan button
            InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _currentView = 'chat';
                  _model.messages.clear();
                  _model.generatedPlan.clear();
                  _model.hasPlan = false;
                });
                // Add initial Sage greeting
                _model.messages.add({
                  'role': 'assistant',
                  'content': "Hello! I'm Sage, your garden planning assistant. "
                      "I see you have ${widget.portCount} ports to fill in your ${widget.towerName}. "
                      "What would you like to grow? Tell me about your gardening goals - "
                      "for example, 'I want a salad garden' or 'Focus on Italian herbs'."
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9C27B0).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 28.0,
                    ),
                    const SizedBox(width: 12.0),
                    Text(
                      'Start New Plan',
                      style: FlutterFlowTheme.of(context).headlineSmall.override(
                            font: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                            ),
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32.0),

            // Saved plans section
            Text(
              'Saved Plans',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    font: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                    ),
                    fontSize: 18.0,
                  ),
            ),
            const SizedBox(height: 12.0),

            if (_loadingSavedPlans)
              const Center(
                child: CircularProgressIndicator(),
              )
            else if (_savedPlans.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).alternate,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 48.0,
                      color: FlutterFlowTheme.of(context).secondaryText,
                    ),
                    const SizedBox(height: 12.0),
                    Text(
                      'No saved plans yet',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Start a new plan with Sage to get started!',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            font: GoogleFonts.readexPro(),
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _savedPlans.length,
                itemBuilder: (context, index) {
                  final plan = _savedPlans[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _loadSavedPlan(plan);
                        },
                        leading: const Icon(
                          Icons.eco,
                          color: Color(0xFF9C27B0),
                        ),
                        title: Text(
                          plan.planName ?? 'Unnamed Plan',
                          style: FlutterFlowTheme.of(context).bodyLarge.override(
                                font: GoogleFonts.readexPro(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        ),
                        subtitle: Text(
                          dateTimeFormat('MMM d, y', plan.createdAt),
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                font: GoogleFonts.readexPro(),
                                color: FlutterFlowTheme.of(context).secondaryText,
                              ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Plan?'),
                                content: Text('Are you sure you want to delete "${plan.planName}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _deletePlan(plan.id);
                                    },
                                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatView() {
    return Column(
      children: [
        // Messages list
        Expanded(
          child: ListView.builder(
            controller: _model.chatScrollController,
            padding: const EdgeInsets.all(16.0),
            itemCount: _model.messages.length + (_model.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _model.messages.length && _model.isLoading) {
                return _buildLoadingBubble();
              }
              final message = _model.messages[index];
              final isUser = message['role'] == 'user';
              return _buildMessageBubble(message['content'] ?? '', isUser);
            },
          ),
        ),

        // Input area
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _model.chatInputController,
                  focusNode: _model.chatInputFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Tell Sage what you want to grow...',
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.readexPro(),
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: const BorderSide(
                        color: Color(0xFF9C27B0),
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (!_model.isLoading) {
                      _sendMessage(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF9C27B0),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _model.isLoading
                      ? null
                      : () => _sendMessage(_model.chatInputController?.text ?? ''),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(String message, bool isUser) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 36.0,
              height: 36.0,
              decoration: const BoxDecoration(
                color: Color(0xFF9C27B0),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 20.0,
              ),
            ),
            const SizedBox(width: 8.0),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF9C27B0) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16.0),
                  topRight: const Radius.circular(16.0),
                  bottomLeft: Radius.circular(isUser ? 16.0 : 4.0),
                  bottomRight: Radius.circular(isUser ? 4.0 : 16.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.readexPro(),
                      color: isUser ? Colors.white : Colors.black87,
                    ),
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 44.0),
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: const BoxDecoration(
              color: Color(0xFF9C27B0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 20.0,
            ),
          ),
          const SizedBox(width: 8.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(4.0),
                bottomRight: Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9C27B0)),
                  ),
                ),
                const SizedBox(width: 8.0),
                Text(
                  sageThinkingMessages[_thinkingMessageIndex],
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanView() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with plan name - GREEN THEME
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context).primary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.eco,
                    color: Colors.white,
                    size: 48.0,
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    _model.planName ?? 'Your Garden Plan',
                    style: FlutterFlowTheme.of(context).headlineSmall.override(
                          font: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                          ),
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  if (_model.planDescription != null) ...[
                    const SizedBox(height: 8.0),
                    Text(
                      _model.planDescription!,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.readexPro(),
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14.0,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 12.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.grid_view, color: Colors.white, size: 18.0),
                        const SizedBox(width: 8.0),
                        Text(
                          '${_model.totalSlotsUsed} / ${widget.portCount ?? 0} ports filled',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Plants section header
            Row(
              children: [
                Icon(Icons.grass, color: FlutterFlowTheme.of(context).primary, size: 24.0),
                const SizedBox(width: 8.0),
                Text(
                  'Your Plants',
                  style: FlutterFlowTheme.of(context).headlineSmall.override(
                        font: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                        fontSize: 20.0,
                      ),
                ),
                const Spacer(),
                Text(
                  '${_model.generatedPlan.length} varieties',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.readexPro(),
                        color: FlutterFlowTheme.of(context).secondaryText,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Plant cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _model.generatedPlan.length,
              itemBuilder: (context, index) {
                final plant = _model.generatedPlan[index];
                final plantName = plant['plant_name'] ?? 'Unknown Plant';
                final quantity = plant['quantity'] ?? 1;
                final placement = plant['best_placement'] ?? 'Any Level';
                final reason = plant['reason'] ?? '';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _showPlantDetailBottomSheet(plantName);
                    },
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Plant name and quantity
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Icon(
                                    Icons.eco,
                                    color: FlutterFlowTheme.of(context).primary,
                                    size: 24.0,
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plantName,
                                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                                              font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                                              fontSize: 16.0,
                                            ),
                                      ),
                                      const SizedBox(height: 2.0),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              placement,
                                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                                    font: GoogleFonts.readexPro(),
                                                    color: FlutterFlowTheme.of(context).secondaryText,
                                                  ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.info_outline,
                                            size: 16.0,
                                            color: FlutterFlowTheme.of(context).secondaryText,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Text(
                                    'x$quantity',
                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                          font: GoogleFonts.readexPro(fontWeight: FontWeight.bold),
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            if (reason.isNotEmpty) ...[
                              const SizedBox(height: 12.0),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  reason,
                                  style: FlutterFlowTheme.of(context).bodySmall.override(
                                        font: GoogleFonts.readexPro(),
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24.0),

            // Action buttons
            Row(
              children: [
                // Save button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      _showSavePlanDialog();
                    },
                    icon: const Icon(Icons.bookmark_add),
                    label: const Text('Save Plan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                // New plan button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _model.hasPlan = false;
                        _model.generatedPlan.clear();
                        _model.planName = null;
                        _model.planDescription = null;
                        _currentView = 'chat';
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('New Plan'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: FlutterFlowTheme.of(context).primary,
                      side: BorderSide(color: FlutterFlowTheme.of(context).primary),
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSavePlanDialog() {
    // Pre-fill with the plan name from Sage
    _model.planNameController?.text = _model.planName ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Plan'),
        content: TextField(
          controller: _model.planNameController,
          focusNode: _model.planNameFocusNode,
          decoration: InputDecoration(
            hintText: 'Enter plan name...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _savePlan(_model.planNameController?.text ?? '');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPlantDetailBottomSheet(String plantName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: Column(
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: 12.0),
              width: 40.0,
              height: 4.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryText.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            // Content
            Expanded(
              child: FutureBuilder<List<PlantsRow>>(
                future: PlantsTable().querySingleRow(
                  queryFn: (q) => q.eqOrNull('plant_name', plantName),
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                    );
                  }

                  final plantRows = snapshot.data!;
                  if (plantRows.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.eco,
                              size: 64.0,
                              color: FlutterFlowTheme.of(context).secondaryText,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              plantName,
                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                    font: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Plant details not found in catalog',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.readexPro(),
                                    color: FlutterFlowTheme.of(context).secondaryText,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final plant = plantRows.first;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Plant image
                        if (plant.plantImage != null)
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                plant.plantImage!,
                                width: double.infinity,
                                height: 180.0,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 180.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Icon(
                                    Icons.eco,
                                    size: 64.0,
                                    color: FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 16.0),

                        // Plant name
                        Text(
                          plant.plantName ?? plantName,
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                                font: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                              ),
                        ),
                        const SizedBox(height: 8.0),

                        // Short description
                        if (plant.shortDescription != null)
                          Text(
                            plant.shortDescription!,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                  font: GoogleFonts.readexPro(),
                                  color: FlutterFlowTheme.of(context).secondaryText,
                                ),
                          ),
                        const SizedBox(height: 16.0),

                        // Details grid
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildDetailRow('Growing Season', plant.growingSeason ?? 'N/A'),
                              _buildDetailRow('Harvest Method', plant.harvestMethod ?? 'N/A'),
                              _buildDetailRow('First Harvest', plant.firstHarvest ?? 'N/A'),
                              _buildDetailRow('Final Harvest', plant.finalHarvest ?? 'N/A'),
                              _buildDetailRow('Best Placement', plant.bestPlacement ?? 'N/A'),
                              _buildDetailRow('Indoor/Outdoor', plant.indoorOutdoor ?? 'N/A'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        // Add to My Plants button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              HapticFeedback.lightImpact();
                              await UserplantsTable().insert({
                                'plant_id': plant.plantId,
                                'user_id': currentUserUid,
                              });
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(
                                    content: Text('${plant.plantName} added to My Plants!'),
                                    backgroundColor: FlutterFlowTheme.of(this.context).success,
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add to My Plants'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: FlutterFlowTheme.of(context).primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),

                        // Close button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: FlutterFlowTheme.of(context).secondaryText,
                              side: BorderSide(color: FlutterFlowTheme.of(context).alternate),
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text('Close'),
                          ),
                        ),
                      ],
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(),
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
          ),
          Text(
            value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  font: GoogleFonts.readexPro(fontWeight: FontWeight.w600),
                ),
          ),
        ],
      ),
    );
  }
}
