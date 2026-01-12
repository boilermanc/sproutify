import '/auth/supabase_auth/auth_util.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'my_costs_model.dart';
export 'my_costs_model.dart';

class MyCostsWidget extends StatefulWidget {
  const MyCostsWidget({super.key});

  static String routeName = 'myCosts';
  static String routePath = '/myCosts';

  @override
  State<MyCostsWidget> createState() => _MyCostsWidgetState();
}

class _MyCostsWidgetState extends State<MyCostsWidget>
    with SingleTickerProviderStateMixin {
  late MyCostsModel _model;
  late TabController _tabController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyCostsModel());
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Fetch category costs by querying Supabase directly
  Future<List<Map<String, dynamic>>> _fetchCategoryCosts() async {
    try {
      final supabase = Supabase.instance.client;

      // Get all categories
      final categories = await supabase
          .from('categories')
          .select('categoryid, categoryname')
          .order('categoryname');

      // Get user's product purchases
      final userProducts = await supabase
          .from('userproducts')
          .select('productid, userpurchasecost')
          .eq('userid', currentUserUid)
          .or('archive.is.null,archive.eq.false');

      // Get all products with their categories
      final products =
          await supabase.from('products').select('productid, categoryid');

      // Calculate costs per category
      final Map<int, double> costsByCategory = {};

      for (final userProduct in userProducts) {
        final productId = userProduct['productid'] as int?;
        final cost =
            (userProduct['userpurchasecost'] as num?)?.toDouble() ?? 0.0;

        if (productId != null) {
          // Find the product's category
          final product = products.firstWhere(
            (p) => p['productid'] == productId,
            orElse: () => {},
          );

          final categoryId = product['categoryid'] as int?;
          if (categoryId != null) {
            costsByCategory[categoryId] =
                (costsByCategory[categoryId] ?? 0.0) + cost;
          }
        }
      }

      // Build final result
      final result = <Map<String, dynamic>>[];
      for (final category in categories) {
        final categoryId = category['categoryid'] as int;
        final categoryName = category['categoryname'] as String;
        final cost = costsByCategory[categoryId] ?? 0.0;

        result.add({
          'categoryid': categoryId,
          'categoryname': categoryName,
          'cost': cost,
        });
      }

      return result;
    } catch (e) {
      print('Error fetching category costs: $e');
      rethrow;
    }
  }

  // Helper function to get icon based on category name
  IconData _getCategoryIcon(String categoryName) {
    final lowerName = categoryName.toLowerCase();
    if (lowerName.contains('nutrient')) {
      return Icons.water_drop; // Water drop for nutrients/liquids
    } else if (lowerName.contains('medium') || lowerName.contains('soil')) {
      return Icons.grass; // Grass for growing medium
    } else if (lowerName.contains('accessor')) {
      return Icons.build; // Tools/build for accessories
    } else if (lowerName.contains('chemical')) {
      return Icons.science; // Science flask for chemicals
    } else if (lowerName.contains('seed')) {
      return Icons.eco; // Leaf for seeds
    } else if (lowerName.contains('light')) {
      return Icons.lightbulb; // Light bulb for lighting
    } else if (lowerName.contains('pump') || lowerName.contains('equipment')) {
      return Icons.settings; // Settings/gear for equipment
    } else {
      return Icons.category_outlined; // Default icon
    }
  }

  // Helper widget to build animated cost card
  Widget _buildCostCard({
    required String title,
    required String monthlyCost,
    required String quarterlyCost,
    required String yearlyCost,
    required Color color,
    required IconData icon,
  }) {
    final costs = [monthlyCost, quarterlyCost, yearlyCost];
    final labels = ['Monthly', 'Quarterly', 'Yearly'];
    final selectedCost = costs[_tabController.index];

    return AnimatedBuilder(
      animation: _tabController.animation!,
      builder: (context, child) {
        return TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: Tween<double>(begin: 0.95, end: 1.0),
          builder: (context, double scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(24.0),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Icon(
                                  icon,
                                  color: Colors.white,
                                  size: 28.0,
                                ),
                              ),
                              Icon(
                                Icons.trending_up,
                                color: Colors.white.withOpacity(0.8),
                                size: 20.0,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            title,
                            style: GoogleFonts.outfit(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '\$',
                                style: GoogleFonts.outfit(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4.0),
                              Flexible(
                                child: Text(
                                  selectedCost,
                                  style: GoogleFonts.outfit(
                                    fontSize: 36.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'this ${labels[_tabController.index].toLowerCase()}',
                            style: GoogleFonts.readexPro(
                              fontSize: 13.0,
                              color: Colors.white.withOpacity(0.75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Fetch purchases for a specific category
  Future<List<Map<String, dynamic>>> _fetchCategoryPurchases(
      int categoryId) async {
    try {
      final supabase = Supabase.instance.client;

      // Get all products in this category
      final products = await supabase
          .from('products')
          .select('productid, productname')
          .eq('categoryid', categoryId);

      if (products.isEmpty) {
        return [];
      }

      final productIds = products.map((p) => p['productid'] as int).toList();
      final productMap = <int, String>{};
      for (final product in products) {
        final id = product['productid'] as int?;
        final name = product['productname'] as String?;
        if (id != null && name != null) {
          productMap[id] = name;
        }
      }

      // Get all user's purchases and filter by product IDs client-side
      final userProducts = await supabase
          .from('userproducts')
          .select(
              'productid, userpurchasecost, userpurchasedate, userpurchasedquantity')
          .eq('userid', currentUserUid)
          .or('archive.is.null,archive.eq.false')
          .order('userpurchasedate', ascending: false);

      // Filter to only products in this category and combine with product names
      final result = <Map<String, dynamic>>[];
      for (final purchase in userProducts) {
        final productId = purchase['productid'] as int?;
        if (productId != null && productIds.contains(productId)) {
          result.add({
            'productname': productMap[productId] ?? 'Unknown Product',
            'userpurchasecost': purchase['userpurchasecost'] as double? ?? 0.0,
            'userpurchasedate': purchase['userpurchasedate'],
            'userpurchasedquantity':
                purchase['userpurchasedquantity'] as int? ?? 1,
          });
        }
      }

      return result;
    } catch (e) {
      print('Error fetching category purchases: $e');
      return [];
    }
  }

  // Show bottom sheet with purchases for a category
  Future<void> _showCategoryPurchases(
      int categoryId, String categoryName) async {
    final purchases = await _fetchCategoryPurchases(categoryId);

    if (!mounted) return;

    // Only show if there are purchases
    if (purchases.isEmpty) {
      return;
    }

    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24.0),
            ),
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) {
              return Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                    width: 40.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).alternate,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName,
                                style: GoogleFonts.outfit(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              Text(
                                '${purchases.length} ${purchases.length == 1 ? 'purchase' : 'purchases'}',
                                style: GoogleFonts.readexPro(
                                  fontSize: 14.0,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: FlutterFlowTheme.of(context).secondaryText,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Purchases list
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16.0),
                      itemCount: purchases.length,
                      itemBuilder: (context, index) {
                        final purchase = purchases[index];
                        final productName =
                            purchase['productname'] as String? ?? 'Unknown';
                        final cost =
                            purchase['userpurchasecost'] as double? ?? 0.0;
                        final date = purchase['userpurchasedate'] as DateTime?;
                        final quantity =
                            purchase['userpurchasedquantity'] as int? ?? 1;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          decoration: BoxDecoration(
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context).alternate,
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName,
                                        style: GoogleFonts.readexPro(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                        ),
                                      ),
                                      if (date != null) ...[
                                        const SizedBox(height: 4.0),
                                        Text(
                                          dateTimeFormat('MMM d, y', date),
                                          style: GoogleFonts.readexPro(
                                            fontSize: 12.0,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                      ],
                                      if (quantity > 1) ...[
                                        const SizedBox(height: 4.0),
                                        Text(
                                          'Quantity: $quantity',
                                          style: GoogleFonts.readexPro(
                                            fontSize: 12.0,
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryText,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '\$',
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary,
                                          ),
                                        ),
                                        Text(
                                          cost.toStringAsFixed(2),
                                          style: GoogleFonts.outfit(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // Helper widget to build category item
  Widget _buildCategoryItem(int categoryId, String categoryName, String cost) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 400),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: () async {
                    await _showCategoryPurchases(categoryId, categoryName);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context).primary,
                                FlutterFlowTheme.of(context)
                                    .primary
                                    .withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Icon(
                            _getCategoryIcon(categoryName),
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName,
                                style: GoogleFonts.readexPro(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Yearly total',
                                style: GoogleFonts.readexPro(
                                  fontSize: 12.0,
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '\$',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        FlutterFlowTheme.of(context).tertiary,
                                  ),
                                ),
                                Text(
                                  cost,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed(HomePageWidget.routeName);
            },
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Costs',
                style: GoogleFonts.outfit(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: FlutterFlowTheme.of(context).primaryText,
                ),
              ),
              Text(
                'Track your investments',
                style: GoogleFonts.readexPro(
                  fontSize: 12.0,
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ],
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              // Time Period Tabs
              Container(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  padding: const EdgeInsets.all(4.0),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (_) => setState(() {}),
                    indicator: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).primary,
                          FlutterFlowTheme.of(context).primary.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        FlutterFlowTheme.of(context).secondaryText,
                    labelStyle: GoogleFonts.outfit(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle: GoogleFonts.outfit(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                    tabs: const [
                      Tab(text: 'Monthly'),
                      Tab(text: 'Quarterly'),
                      Tab(text: 'Yearly'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Cost Cards Grid
                      FutureBuilder<List<ApiCallResponse>>(
                        future: Future.wait([
                          TotalPlantCostPerUserCall.call(
                              userID: currentUserUid),
                          TotalSupplyCostPerUserCall.call(
                              userID: currentUserUid),
                        ]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }

                          final plantResponse = snapshot.data![0];
                          final supplyResponse = snapshot.data![1];

                          final plantJsonBody = plantResponse.jsonBody;
                          final plantCostData =
                              plantJsonBody is List && plantJsonBody.isNotEmpty
                                  ? plantJsonBody[0]
                                  : plantJsonBody is Map
                                      ? plantJsonBody
                                      : <String, dynamic>{};

                          final supplyJsonBody = supplyResponse.jsonBody;
                          final supplyCostData = supplyJsonBody is List &&
                                  supplyJsonBody.isNotEmpty
                              ? supplyJsonBody[0]
                              : supplyJsonBody is Map
                                  ? supplyJsonBody
                                  : <String, dynamic>{};

                          return Column(
                            children: [
                              _buildCostCard(
                                title: 'Plant Costs',
                                monthlyCost: valueOrDefault<String>(
                                  getJsonField(
                                          plantCostData, r'''$.monthly_cost''')
                                      ?.toString(),
                                  '0',
                                ),
                                quarterlyCost: valueOrDefault<String>(
                                  getJsonField(plantCostData,
                                          r'''$.quarterly_cost''')
                                      ?.toString(),
                                  '0',
                                ),
                                yearlyCost: valueOrDefault<String>(
                                  getJsonField(
                                          plantCostData, r'''$.yearly_cost''')
                                      ?.toString(),
                                  '0',
                                ),
                                color: FlutterFlowTheme.of(context).primary,
                                icon: Icons.eco,
                              ),
                              const SizedBox(height: 16.0),
                              _buildCostCard(
                                title: 'Supply Costs',
                                monthlyCost: valueOrDefault<String>(
                                  getJsonField(
                                          supplyCostData, r'''$.monthly_cost''')
                                      ?.toString(),
                                  '0',
                                ),
                                quarterlyCost: valueOrDefault<String>(
                                  getJsonField(supplyCostData,
                                          r'''$.quarterly_cost''')
                                      ?.toString(),
                                  '0',
                                ),
                                yearlyCost: valueOrDefault<String>(
                                  getJsonField(
                                          supplyCostData, r'''$.yearly_cost''')
                                      ?.toString(),
                                  '0',
                                ),
                                color: FlutterFlowTheme.of(context).tertiary,
                                icon: Icons.inventory_2_outlined,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24.0),
                      // Category Breakdown Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category Breakdown',
                            style: GoogleFonts.outfit(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _fetchCategoryCosts(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );
                          }

                          final categoryList = snapshot.data!;

                          if (snapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 64.0,
                                      color: FlutterFlowTheme.of(context).error,
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text(
                                      'Error loading categories',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      snapshot.error.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.readexPro(
                                        fontSize: 14.0,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          if (categoryList.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.category_outlined,
                                      size: 64.0,
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryText,
                                    ),
                                    const SizedBox(height: 16.0),
                                    Text(
                                      'No categories yet',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      'Start tracking your costs',
                                      style: GoogleFonts.readexPro(
                                        fontSize: 14.0,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: categoryList.map((categoryItem) {
                              final categoryId =
                                  categoryItem['categoryid'] as int? ?? 0;
                              final categoryName =
                                  categoryItem['categoryname'] as String? ??
                                      'Category';
                              final cost =
                                  categoryItem['cost'] as double? ?? 0.0;

                              return _buildCategoryItem(
                                categoryId,
                                categoryName,
                                cost.toStringAsFixed(2),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
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
