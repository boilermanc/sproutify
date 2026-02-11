import '/flutter_flow/flutter_flow_util.dart';
import 'subscription_page_widget.dart' show SubscriptionPageWidget;
import 'package:flutter/material.dart';

class SubscriptionPageModel extends FlutterFlowModel<SubscriptionPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Selected subscription option
  String selectedPlan = 'annual'; // 'monthly', 'annual', 'lifetime'

  // Purchase in progress flag
  bool isPurchasing = false;

  // Offerings loading state
  bool isLoadingOfferings = true;
  String? offeringsError;

  // Lifetime cap tracking
  int? lifetimeCount; // null = not yet loaded
  bool get lifetimeSoldOut => (lifetimeCount ?? 0) >= 100;
  int get lifetimeRemaining => (100 - (lifetimeCount ?? 0)).clamp(0, 100);

  // RevenueCat product identifiers
  String get selectedProductId {
    switch (selectedPlan) {
      case 'monthly':
        return 'Sprout_Sub_M';
      case 'annual':
        return 'Sprout_Sub_A';
      case 'lifetime':
        return 'Sprout_Sub_Life';
      default:
        return 'Sprout_Sub_A'; // Default to annual
    }
  }

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
