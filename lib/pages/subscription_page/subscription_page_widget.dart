import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import 'package:url_launcher/url_launcher.dart';
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

/// Sentinel substring returned by `convert_trial_to_subscription_with_cap`
/// when the 100-lifetime-subscriber cap is reached. The Supabase RPC must
/// include this phrase (case-insensitive) in its error message so the client
/// can detect a sold-out condition and refresh the UI.
///
/// If the server-side wording changes, update this constant to match.
const _kLifetimeSoldOutError = 'sold out';

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
    _loadOfferings();
    _loadLifetimeCount();
  }

  Future<void> _loadOfferings({bool retry = false}) async {
    if (mounted) {
      setState(() {
        _model.isLoadingOfferings = true;
        _model.offeringsError = null;
      });
    }

    try {
      // Try loading offerings with retry logic
      int attempts = 0;
      const maxAttempts = 3;

      while (attempts < maxAttempts) {
        try {
          await revenue_cat.loadOfferings();
        } catch (e) {
          // If loadOfferings throws, log it but continue to check offerings
          debugPrint('Error calling loadOfferings: $e');
        }

        final offerings = revenue_cat.offerings;

        if (offerings != null && offerings.current != null) {
          // Success - offerings loaded
          if (mounted) {
            setState(() {
              _model.isLoadingOfferings = false;
              _model.offeringsError = null;
            });
          }
          return;
        }

        attempts++;
        if (attempts < maxAttempts) {
          // Wait before retrying (exponential backoff)
          await Future.delayed(Duration(seconds: attempts));
        }
      }

      // If we get here, offerings failed to load after retries
      if (mounted) {
        final offerings = revenue_cat.offerings;
        String errorMessage = 'Unable to load subscription options.';

        if (offerings == null) {
          errorMessage += ' Please check your internet connection and RevenueCat configuration.';
        } else if (offerings.current == null) {
          errorMessage += ' No default offering is configured in RevenueCat. Please contact support.';
        } else {
          errorMessage += ' Please try again.';
        }

        setState(() {
          _model.isLoadingOfferings = false;
          _model.offeringsError = errorMessage;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _model.isLoadingOfferings = false;
          _model.offeringsError =
              'Error loading subscription options: ${e.toString().replaceAll('Exception: ', '')}';
        });
      }
    }
  }

  /// Load the current count of lifetime subscribers (fail open).
  Future<void> _loadLifetimeCount() async {
    try {
      final result = await SupaFlow.client.rpc('get_lifetime_count');
      final count = (result as num?)?.toInt() ?? 0;
      if (mounted) {
        setState(() {
          _model.lifetimeCount = count;
          // If lifetime was selected but now sold out, switch to annual
          if (_model.lifetimeSoldOut && _model.selectedPlan == 'lifetime') {
            _model.selectedPlan = 'annual';
          }
        });
      }
    } catch (e) {
      // Fail open — leave lifetimeCount as null so the card stays enabled
      debugPrint('Error loading lifetime count: $e');
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  /// Find a StoreProduct from RevenueCat offerings by product ID.
  StoreProduct? _getStoreProduct(String productId) {
    final offerings = revenue_cat.offerings;
    if (offerings?.current == null) return null;
    for (final package in offerings!.current!.availablePackages) {
      if (package.storeProduct.identifier == productId) {
        return package.storeProduct;
      }
    }
    return null;
  }

  /// Whether the current date falls in the Early Adopter launch window
  /// (launch through March 31, 2026). Price is locked at the intro rate
  /// for early adopters.
  // TODO(post-launch): Remove this getter after April 2026 and clean up
  // all `_isEarlyAdopterPeriod` references once the promo window closes.
  bool get _isEarlyAdopterPeriod {
    final now = DateTime.now();
    final end = DateTime(2026, 4, 1); // Up to but not including April 1
    return now.isBefore(end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        automaticallyImplyLeading: true,
        title: Flexible(
          child: Text(
            'Subscribe to Sproutify',
            overflow: TextOverflow.ellipsis,
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.readexPro(),
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 0.0,
                ),
          ),
        ),
        centerTitle: true,
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
                        'Grow Smarter\nwith Sproutify',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.readexPro(
                          color: Colors.white,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Your complete aeroponic tower companion',
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
                      'Everything You Need',
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

              // Error banner if offerings failed to load
              if (_model.offeringsError != null)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 12.0),
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).error,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _model.offeringsError!,
                            style: GoogleFonts.readexPro(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        InkWell(
                          onTap: () => _loadOfferings(retry: true),
                          child: Container(
                            padding: const EdgeInsetsDirectional.fromSTEB(8.0, 4.0, 8.0, 4.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Text(
                              'Retry',
                              style: GoogleFonts.readexPro(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Subscription options
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 32.0),
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

                    // Monthly plan
                    _buildPricingCard(
                      plan: 'monthly',
                      title: 'Monthly',
                      price: _getStoreProduct('Sprout_Sub_M')?.priceString ?? '\$4.99',
                      period: '/month',
                      features: const [
                        'Full app access',
                        'Cancel anytime',
                      ],
                    ),

                    const SizedBox(height: 12.0),

                    // Annual plan (recommended)
                    Builder(builder: (_) {
                      final product = _getStoreProduct('Sprout_Sub_A');
                      final hasIntroOffer = _isEarlyAdopterPeriod &&
                          product?.introductoryPrice != null;
                      final displayPrice = hasIntroOffer
                          ? product!.introductoryPrice!.priceString
                          : (product?.priceString ?? '\$49.99');
                      final perMonthAmount = hasIntroOffer
                          ? product!.introductoryPrice!.price / 12
                          : (product?.price ?? 49.99) / 12;

                      return _buildPricingCard(
                        plan: 'annual',
                        title: 'Annual',
                        price: displayPrice,
                        period: '/year',
                        savings: hasIntroOffer ? 'Save ~\$20' : 'Save ~\$10',
                        isRecommended: true,
                        perMonth:
                            '\$${perMonthAmount.toStringAsFixed(2)}/mo',
                        features: hasIntroOffer
                            ? const [
                                'Full app access',
                                'Price locked for 2 years',
                                '\$25 seedling credit (1st year)*',
                              ]
                            : const [
                                'Full app access',
                                'Save ~\$10 vs monthly',
                              ],
                        badge: _isEarlyAdopterPeriod ? 'EARLY ADOPTER' : null,
                        badgeColor: const Color(0xFFD08008),
                        originalPrice:
                            hasIntroOffer ? product!.priceString : null,
                        disclaimer: hasIntroOffer
                            ? '*Seedling credit redeemable through ATL Urban Farms. Shipping not included. Credit expires after 12 months. Cannot combine with other promos.'
                            : null,
                        disclaimerLinkText: hasIntroOffer ? 'Visit ATL Urban Farms' : null,
                        disclaimerLinkUrl: hasIntroOffer ? 'https://atlurbanfarms.com' : null,
                      );
                    }),

                    const SizedBox(height: 12.0),

                    // Lifetime plan
                    _buildPricingCard(
                      plan: 'lifetime',
                      title: 'Lifetime',
                      price: _getStoreProduct('Sprout_Sub_Life')?.priceString ?? '\$199.99',
                      period: 'one-time',
                      badge: _model.lifetimeSoldOut ? 'SOLD OUT' : 'FOUNDING GROWER',
                      badgeColor: _model.lifetimeSoldOut
                          ? const Color(0xFF9E9E9E)
                          : const Color(0xFFD08008),
                      features: _model.lifetimeSoldOut
                          ? const [
                              'All 100 Founding Grower spots have been claimed',
                            ]
                          : const [
                              '"Founding Grower" badge',
                              'Limited to first 100 customers',
                              '\$25 annual seedling credit*',
                              '10% off all seedlings forever',
                            ],
                      subtitle: (!_model.lifetimeSoldOut && _model.lifetimeCount != null)
                          ? '${_model.lifetimeRemaining} of 100 remaining'
                          : null,
                      disclaimer: _model.lifetimeSoldOut
                          ? null
                          : '*Seedling credit redeemable through ATL Urban Farms. Shipping not included. Credit expires after 12 months. Cannot combine with other promos.',
                      disclaimerLinkText: _model.lifetimeSoldOut ? null : 'Visit ATL Urban Farms',
                      disclaimerLinkUrl: _model.lifetimeSoldOut ? null : 'https://atlurbanfarms.com',
                      isDisabled: _model.lifetimeSoldOut,
                    ),
                  ],
                ),
              ),

              // Subscribe button
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 16.0),
                child: FFButtonWidget(
                  onPressed: (_model.isPurchasing || _model.isLoadingOfferings || _model.offeringsError != null)
                      ? null
                      : () async {
                    if (_model.isPurchasing) {
                      return; // Prevent double-tap
                    }

                    // Prevent purchasing sold-out lifetime plan
                    if (_model.selectedPlan == 'lifetime' && _model.lifetimeSoldOut) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'All 100 Founding Grower spots have been claimed.',
                            style: GoogleFonts.readexPro(),
                          ),
                          backgroundColor: FlutterFlowTheme.of(context).error,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _model.isPurchasing = true;
                    });

                    try {
                      // Get the product identifier
                      final productId = _model.selectedProductId;

                      // Ensure offerings are loaded
                      if (_model.isLoadingOfferings) {
                        await _loadOfferings();
                      }

                      // Get offerings to find the right product
                      var offerings = revenue_cat.offerings;

                      if (offerings == null || offerings.current == null) {
                        // Try loading one more time
                        await revenue_cat.loadOfferings();
                        offerings = revenue_cat.offerings;

                        if (offerings == null || offerings.current == null) {
                          throw Exception(
                              'No subscription options available. Please check your internet connection and try again.');
                        }
                      }

                      // Find the product by identifier
                      StoreProduct? targetProduct;
                      for (final package
                          in offerings.current!.availablePackages) {
                        if (package.storeProduct.identifier == productId) {
                          targetProduct = package.storeProduct;
                          break;
                        }
                      }

                      if (targetProduct == null) {
                        throw Exception(
                            'Product not found. Please contact support.');
                      }

                      // Make the purchase
                      final purchaserInfo =
                          await Purchases.purchaseStoreProduct(targetProduct);

                      // Check if purchase was successful
                      if (purchaserInfo.entitlements.active.isNotEmpty) {
                        // Purchase successful - update database
                        final durationDays = _model.selectedPlan == 'lifetime'
                            ? 36500 // ~100 years for lifetime
                            : (_model.selectedPlan == 'annual' ? 365 : 30);

                        await SupaFlow.client.rpc(
                          'convert_trial_to_subscription_with_cap',
                          params: {
                            'user_uuid': currentUserUid,
                            'duration_days': durationDays,
                            'platform': Platform.isIOS ? 'ios' : 'android',
                            'rc_customer_id': purchaserInfo.originalAppUserId,
                            'tier': _model.selectedPlan,
                          },
                        );

                        try {
                          await SupaFlow.client.rpc(
                            'issue_seedling_credit',
                            params: {
                              'p_user_id': currentUserUid,
                              'p_subscription_tier': _model.selectedPlan,
                              'p_is_early_adopter': _isEarlyAdopterPeriod,
                            },
                          );
                        } catch (e) {
                          debugPrint('Failed to issue seedling credit: $e');
                          // Don't block — subscription is already active
                        }

                        // Show success message
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Welcome to Sproutify Premium! 🌱',
                                style: GoogleFonts.readexPro(),
                              ),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).success,
                              duration: const Duration(seconds: 3),
                            ),
                          );

                          // Navigate back to home
                          context.pop();
                        }
                      } else {
                        throw Exception(
                            'Purchase did not complete. Please try again.');
                      }
                    } catch (e) {
                      // Handle sold-out lifetime cap (see _kLifetimeSoldOutError)
                      final errorStr = e.toString().toLowerCase();
                      if (errorStr.contains(_kLifetimeSoldOutError)) {
                        _loadLifetimeCount(); // Refresh count
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Sorry, all 100 Founding Grower spots have been claimed!',
                                style: GoogleFonts.readexPro(),
                              ),
                              backgroundColor: FlutterFlowTheme.of(context).error,
                              duration: const Duration(seconds: 4),
                            ),
                          );
                        }
                        return;
                      }

                      // Handle other errors
                      String errorMessage =
                          'Purchase failed. Please try again.';

                      if (e is PlatformException) {
                        if (e.code == 'PURCHASE_CANCELLED') {
                          errorMessage = 'Purchase cancelled.';
                        } else if (e.code == 'PRODUCT_ALREADY_PURCHASED') {
                          errorMessage = 'You already own this subscription.';
                        } else {
                          errorMessage = e.message ?? errorMessage;
                        }
                      } else if (e is Exception) {
                        errorMessage =
                            e.toString().replaceAll('Exception: ', '');
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
                  text: _model.isPurchasing
                      ? 'Processing...'
                      : (_model.isLoadingOfferings
                          ? 'Loading...'
                          : 'Continue'),
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
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 16.0),
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
                        final entitlement =
                            customerInfo.entitlements.active.values.first;

                        // Determine duration and tier based on product identifier
                        int durationDays = 30; // default to monthly
                        String tier = 'monthly';
                        if (entitlement.productIdentifier.contains('Life')) {
                          durationDays = 36500;
                          tier = 'lifetime';
                        } else if (entitlement.productIdentifier.contains('Sub_A') ||
                            entitlement.productIdentifier.contains('Year')) {
                          durationDays = 365;
                          tier = 'annual';
                        }

                        await SupaFlow.client.rpc(
                          'convert_trial_to_subscription_with_cap',
                          params: {
                            'user_uuid': currentUserUid,
                            'duration_days': durationDays,
                            'platform': Platform.isIOS ? 'ios' : 'android',
                            'rc_customer_id': customerInfo.originalAppUserId,
                            'tier': tier,
                          },
                        );

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Purchases restored successfully!',
                                style: GoogleFonts.readexPro(),
                              ),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).success,
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
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 16.0),
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
              // Terms and Privacy Links
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Semantics(
                      link: true,
                      label: 'Terms of Use',
                      child: GestureDetector(
                        onTap: () => launchUrl(
                          Uri.parse('https://www.apple.com/legal/internet-services/itunes/dev/stdeula/'),
                          mode: LaunchMode.externalApplication,
                        ),
                        child: Text(
                          'Terms of Use',
                          style: GoogleFonts.readexPro(
                            color: FlutterFlowTheme.of(context).primary,
                            fontSize: 12.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '|',
                      style: GoogleFonts.readexPro(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Semantics(
                      link: true,
                      label: 'Privacy Policy',
                      child: GestureDetector(
                        onTap: () => launchUrl(
                          Uri.parse('https://www.sproutify.app/index.php/privacy-policy-2/'),
                          mode: LaunchMode.externalApplication,
                        ),
                        child: Text(
                          'Privacy Policy',
                          style: GoogleFonts.readexPro(
                            color: FlutterFlowTheme.of(context).primary,
                            fontSize: 12.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
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
    bool isRecommended = false,
    String? perMonth,
    List<String>? features,
    String? badge,
    Color? badgeColor,
    String? originalPrice,
    String? disclaimer,
    String? disclaimerLinkText,
    String? disclaimerLinkUrl,
    String? subtitle,
    bool isDisabled = false,
  }) {
    final bool isSelected = !isDisabled && _model.selectedPlan == plan;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1.0,
      child: InkWell(
      onTap: isDisabled
          ? null
          : () {
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
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title row with badges
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.readexPro(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.0,
                              ),
                            ),
                            if (savings != null)
                              Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 4.0, 8.0, 4.0),
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).success,
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
                            if (badge != null)
                              Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    8.0, 4.0, 8.0, 4.0),
                                decoration: BoxDecoration(
                                  color: badgeColor ??
                                      FlutterFlowTheme.of(context).tertiary,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  badge,
                                  style: GoogleFonts.readexPro(
                                    color: Colors.white,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4.0),
                          Text(
                            subtitle,
                            style: GoogleFonts.readexPro(
                              color: FlutterFlowTheme.of(context).primary,
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                        const SizedBox(height: 4.0),
                        // Price row
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
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                ),
                              ),
                            ),
                            // Strikethrough original price (e.g. during Early Adopter promo)
                            if (originalPrice != null) ...[
                              const SizedBox(width: 8.0),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 4.0),
                                child: Text(
                                  originalPrice,
                                  style: GoogleFonts.readexPro(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryText,
                                    fontSize: 14.0,
                                    decoration: TextDecoration.lineThrough,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (perMonth != null) ...[
                          const SizedBox(height: 4.0),
                          Text(
                            perMonth,
                            style: GoogleFonts.readexPro(
                              color:
                                  FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                        // Feature bullets
                        if (features != null && features.isNotEmpty) ...[
                          const SizedBox(height: 8.0),
                          ...features.map(
                            (feature) => Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0.0, 2.0, 0.0, 2.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline_rounded,
                                    color:
                                        FlutterFlowTheme.of(context).success,
                                    size: 16.0,
                                  ),
                                  const SizedBox(width: 6.0),
                                  Expanded(
                                    child: Text(
                                      feature,
                                      style: GoogleFonts.readexPro(
                                        fontSize: 13.0,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        letterSpacing: 0.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        // Disclaimer text
                        if (disclaimer != null) ...[
                          const SizedBox(height: 6.0),
                          Text(
                            disclaimer,
                            style: GoogleFonts.readexPro(
                              color:
                                  FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 10.0,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 0.0,
                            ),
                          ),
                          if (disclaimerLinkText != null &&
                              disclaimerLinkUrl != null) ...[
                            const SizedBox(height: 4.0),
                            Semantics(
                              link: true,
                              label: disclaimerLinkText,
                              child: GestureDetector(
                                onTap: () => launchUrl(
                                  Uri.parse(disclaimerLinkUrl),
                                  mode: LaunchMode.externalApplication,
                                ),
                                child: Text(
                                  disclaimerLinkText,
                                  style: GoogleFonts.readexPro(
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                  // Selection indicator
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        8.0, 0.0, 0.0, 0.0),
                    child: Container(
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
    ),
    );
  }
}
