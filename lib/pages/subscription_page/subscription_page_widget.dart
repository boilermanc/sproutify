import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/revenue_cat_util.dart' as revenue_cat;
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'subscription_page_model.dart';
export 'subscription_page_model.dart';

class SubscriptionPageWidget extends StatefulWidget {
  const SubscriptionPageWidget({super.key});

  static String routeName = 'SubscriptionPage';
  static String routePath = '/subscription';

  @override
  State<SubscriptionPageWidget> createState() => _SubscriptionPageWidgetState();
}

class _SubscriptionPageWidgetState extends State<SubscriptionPageWidget> {
  late SubscriptionPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionPageModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: true,
        title: Text(
          'Subscribe to Sproutify',
          style: FlutterFlowTheme.of(context).headlineMedium.override(
                font: GoogleFonts.readexPro(),
                color: Colors.white,
                fontSize: 22.0,
                letterSpacing: 0.0,
              ),
        ),
        centerTitle: false,
        elevation: 2.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Hero section
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      FlutterFlowTheme.of(context).primary,
                      FlutterFlowTheme.of(context).secondary,
                    ],
                    stops: const [0.0, 1.0],
                    begin: const AlignmentDirectional(0.0, -1.0),
                    end: const AlignmentDirectional(0, 1.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      24.0, 32.0, 24.0, 32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.eco_rounded,
                        color: Colors.white,
                        size: 64.0,
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Unlock Full Access',
                        style: GoogleFonts.readexPro(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Get unlimited access to all premium features',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.readexPro(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16.0,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Features list
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    24.0, 32.0, 24.0, 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Features',
                      style: GoogleFonts.readexPro(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildFeatureItem(
                      icon: Icons.show_chart_rounded,
                      title: 'Unlimited pH & EC Tracking',
                      description: 'Monitor and log readings with no limits',
                    ),
                    _buildFeatureItem(
                      icon: Icons.yard_rounded,
                      title: 'Unlimited Plants & Towers',
                      description: 'Manage as many gardens as you want',
                    ),
                    _buildFeatureItem(
                      icon: Icons.analytics_rounded,
                      title: 'Advanced Analytics',
                      description: 'Detailed harvest reports and ROI tracking',
                    ),
                    _buildFeatureItem(
                      icon: Icons.emoji_events_rounded,
                      title: 'Achievement System',
                      description: 'Unlock badges and track your progress',
                    ),
                    _buildFeatureItem(
                      icon: Icons.cloud_sync_rounded,
                      title: 'Cloud Sync',
                      description: 'Access your data on any device',
                    ),
                    _buildFeatureItem(
                      icon: Icons.support_agent_rounded,
                      title: 'Priority Support',
                      description: 'Get help when you need it',
                    ),
                  ],
                ),
              ),

              // Subscription options
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 0.0, 16.0, 32.0),
                child: Column(
                  children: [
                    Text(
                      'Choose Your Plan',
                      style: GoogleFonts.readexPro(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // Annual plan (recommended)
                    _buildPricingCard(
                      plan: 'annual',
                      title: 'Annual',
                      price: '\$39.99',
                      period: '/year',
                      savings: 'Save 33%',
                      isRecommended: true,
                      perMonth: '\$3.33/mo',
                    ),

                    const SizedBox(height: 12.0),

                    // Monthly plan
                    _buildPricingCard(
                      plan: 'monthly',
                      title: 'Monthly',
                      price: '\$4.99',
                      period: '/month',
                      savings: null,
                      isRecommended: false,
                      perMonth: null,
                    ),

                    const SizedBox(height: 12.0),

                    // Lifetime plan (best value)
                    _buildPricingCard(
                      plan: 'lifetime',
                      title: 'Lifetime',
                      price: '\$99.99',
                      period: 'one-time',
                      savings: 'Best Value',
                      isRecommended: false,
                      perMonth: 'Pay once, own forever',
                    ),
                  ],
                ),
              ),

              // Subscribe button
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    24.0, 0.0, 24.0, 16.0),
                child: FFButtonWidget(
                  onPressed: () async {
                    if (_model.isPurchasing) {
                      return; // Prevent double-tap
                    }

                    setState(() {
                      _model.isPurchasing = true;
                    });

                    try {
                      // Get the product identifier
                      final productId = _model.selectedProductId;

                      // Get offerings to find the right product
                      await revenue_cat.loadOfferings();
                      final offerings = revenue_cat.offerings;

                      if (offerings == null || offerings.current == null) {
                        throw Exception('No offerings available. Please try again.');
                      }

                      // Find the product by identifier
                      StoreProduct? targetProduct;
                      for (final package in offerings.current!.availablePackages) {
                        if (package.storeProduct.identifier == productId) {
                          targetProduct = package.storeProduct;
                          break;
                        }
                      }

                      if (targetProduct == null) {
                        throw Exception('Product not found. Please contact support.');
                      }

                      // Make the purchase
                      final purchaserInfo = await Purchases.purchaseStoreProduct(targetProduct);

                      // Check if purchase was successful
                      if (purchaserInfo.entitlements.active.isNotEmpty) {
                        // Purchase successful - update database
                        final durationDays = _model.selectedPlan == 'lifetime'
                            ? 36500  // ~100 years for lifetime
                            : (_model.selectedPlan == 'annual' ? 365 : 30);

                        await SupaFlow.client.rpc(
                          'convert_trial_to_subscription',
                          params: {
                            'user_uuid': currentUserUid,
                            'duration_days': durationDays,
                            'platform': Platform.isIOS ? 'ios' : 'android',
                            'rc_customer_id': purchaserInfo.originalAppUserId,
                          },
                        );

                        // Show success message
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Welcome to Sproutify Premium! 🌱',
                                style: GoogleFonts.readexPro(),
                              ),
                              backgroundColor: FlutterFlowTheme.of(context).success,
                              duration: const Duration(seconds: 3),
                            ),
                          );

                          // Navigate back to home
                          context.pop();
                        }
                      } else {
                        throw Exception('Purchase did not complete. Please try again.');
                      }
                    } catch (e) {
                      // Handle errors
                      String errorMessage = 'Purchase failed. Please try again.';

                      if (e is PlatformException) {
                        if (e.code == 'PURCHASE_CANCELLED') {
                          errorMessage = 'Purchase cancelled.';
                        } else if (e.code == 'PRODUCT_ALREADY_PURCHASED') {
                          errorMessage = 'You already own this subscription.';
                        } else {
                          errorMessage = e.message ?? errorMessage;
                        }
                      } else if (e is Exception) {
                        errorMessage = e.toString().replaceAll('Exception: ', '');
                      }

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _model.isPurchasing = false;
                        });
                      }
                    }
                  },
                  text: _model.isPurchasing ? 'Processing...' : 'Continue',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 56.0,
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        24.0, 0.0, 24.0, 0.0),
                    iconPadding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 0.0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          font: GoogleFonts.readexPro(),
                          color: Colors.white,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                        ),
                    elevation: 3.0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),

              // Restore purchases
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    24.0, 0.0, 24.0, 16.0),
                child: InkWell(
                  onTap: () async {
                    try {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Restoring purchases...',
                            style: GoogleFonts.readexPro(),
                          ),
                        ),
                      );

                      await revenue_cat.restorePurchases();
                      final customerInfo = revenue_cat.customerInfo;

                      if (customerInfo != null &&
                          customerInfo.entitlements.active.isNotEmpty) {
                        // Has active subscription - update database
                        final entitlement = customerInfo.entitlements.active.values.first;

                        // Determine duration based on product identifier
                        int durationDays = 30; // default to monthly
                        if (entitlement.productIdentifier.contains('Year')) {
                          durationDays = 365;
                        } else if (entitlement.productIdentifier.contains('Life')) {
                          durationDays = 36500;
                        }

                        await SupaFlow.client.rpc(
                          'convert_trial_to_subscription',
                          params: {
                            'user_uuid': currentUserUid,
                            'duration_days': durationDays,
                            'platform': Platform.isIOS ? 'ios' : 'android',
                            'rc_customer_id': customerInfo.originalAppUserId,
                          },
                        );

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Purchases restored successfully!',
                                style: GoogleFonts.readexPro(),
                              ),
                              backgroundColor: FlutterFlowTheme.of(context).success,
                            ),
                          );
                          context.pop();
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'No purchases found to restore.',
                                style: GoogleFonts.readexPro(),
                              ),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to restore purchases. Please try again.',
                              style: GoogleFonts.readexPro(),
                            ),
                            backgroundColor: FlutterFlowTheme.of(context).error,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    'Restore Purchases',
                    style: GoogleFonts.readexPro(
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ),

              // Terms and privacy
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    24.0, 0.0, 24.0, 32.0),
                child: Text(
                  'Subscription automatically renews unless auto-renew is turned off at least 24 hours before the end of the current period. Payment will be charged to your App Store account.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.readexPro(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 12.0,
                    letterSpacing: 0.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).accent1,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
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
                  title,
                  style: GoogleFonts.readexPro(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  description,
                  style: GoogleFonts.readexPro(
                    color: FlutterFlowTheme.of(context).secondaryText,
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard({
    required String plan,
    required String title,
    required String price,
    required String period,
    String? savings,
    required bool isRecommended,
    String? perMonth,
  }) {
    final bool isSelected = _model.selectedPlan == plan;

    return InkWell(
      onTap: () {
        setState(() {
          _model.selectedPlan = plan;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).alternate,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  16.0, 16.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.readexPro(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.0,
                              ),
                            ),
                            if (savings != null) ...[
                              const SizedBox(width: 8.0),
                              Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 4.0, 8.0, 4.0),
                                decoration: BoxDecoration(
                                  color: isRecommended
                                      ? FlutterFlowTheme.of(context).success
                                      : FlutterFlowTheme.of(context).warning,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  savings,
                                  style: GoogleFonts.readexPro(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              price,
                              style: GoogleFonts.readexPro(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.0,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 4.0),
                              child: Text(
                                period,
                                style: GoogleFonts.readexPro(
                                  color:
                                      FlutterFlowTheme.of(context).secondaryText,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (perMonth != null) ...[
                          const SizedBox(height: 4.0),
                          Text(
                            perMonth,
                            style: GoogleFonts.readexPro(
                              color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Selection indicator
                  Container(
                    width: 24.0,
                    height: 24.0,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? FlutterFlowTheme.of(context).primary
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).alternate,
                        width: 2.0,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16.0,
                          )
                        : null,
                  ),
                ],
              ),
            ),
            // Recommended badge
            if (isRecommended)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      12.0, 4.0, 12.0, 4.0),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).success,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'RECOMMENDED',
                    style: GoogleFonts.readexPro(
                      color: Colors.white,
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
