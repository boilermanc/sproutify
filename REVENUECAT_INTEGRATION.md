# RevenueCat Integration - Complete Setup

## Current Status

✅ **RevenueCat is now fully integrated** with the subscription page!

## What's Implemented

### 1. Subscription Purchase Flow
- Users can select between Monthly, Annual, and Lifetime plans
- The "Continue" button now purchases the selected product via RevenueCat
- Product IDs used:
  - Monthly: `Sprout_Sub_Month`
  - Annual: `Sprout_Sub_Year`
  - Lifetime: `Sprout_Sub_Life`

### 2. Error Handling
- Purchase cancelled by user
- Already purchased products
- Product not found errors
- Network/connection errors
- User-friendly error messages

### 3. Success Flow
- After successful purchase, updates Supabase database
- Calls `convert_trial_to_subscription()` function
- Shows success message
- Navigates back to home page

### 4. Restore Purchases
- Fully functional "Restore Purchases" button
- Restores previous purchases from App Store/Play Store
- Updates database with restored subscription
- Handles cases where no purchases exist

### 5. Purchase Prevention
- Prevents double-tap during purchase
- Shows "Processing..." during purchase flow
- Button is disabled while processing

## How It Works

### Purchase Flow:
1. User selects a plan (Monthly/Annual/Lifetime)
2. User taps "Continue" button
3. App loads RevenueCat offerings
4. App finds the product matching the selected plan
5. App initiates purchase via `Purchases.purchaseStoreProduct()`
6. On success:
   - Updates `profiles` table via `convert_trial_to_subscription()`
   - Stores RevenueCat customer ID
   - Sets subscription duration (30/365/36500 days)
   - Shows success message
   - Returns to home page
7. On error:
   - Shows user-friendly error message
   - Allows user to try again

### Restore Flow:
1. User taps "Restore Purchases"
2. App calls `revenue_cat.restorePurchases()`
3. If active purchases found:
   - Determines subscription type from product identifier
   - Updates database with subscription info
   - Shows success message
   - Returns to home page
4. If no purchases found:
   - Shows "No purchases found" message

## Required Setup in RevenueCat Dashboard

Before this will work in production, you need to configure RevenueCat:

### 1. Create Products in RevenueCat
1. Go to RevenueCat Dashboard → Products
2. Create three products:
   - Product ID: `Sprout_Sub_Month`
   - Product ID: `Sprout_Sub_Year`
   - Product ID: `Sprout_Sub_Life`
3. Link each product to your App Store/Play Store product IDs

### 2. Create Entitlements
1. Go to RevenueCat Dashboard → Entitlements
2. Create an entitlement (e.g., `premium`)
3. Attach all three products to this entitlement

### 3. Create Offerings
1. Go to RevenueCat Dashboard → Offerings
2. Create a "Current" offering (or any identifier you prefer)
3. Add packages:
   - Add a package containing `Sprout_Sub_Month`
   - Add a package containing `Sprout_Sub_Year`
   - Add a package containing `Sprout_Sub_Life`

**Note:** The code looks for products by their identifier, so the package type doesn't matter - just make sure your product IDs are correct in RevenueCat.

## Testing

### Test in Sandbox Mode:

1. Set up sandbox tester accounts:
   - **iOS:** App Store Connect → Users and Access → Sandbox Testers
   - **Android:** Google Play Console → Setup → License Testing

2. Run the app in debug mode:
   ```bash
   flutter run
   ```

3. Navigate to the subscription page and test:
   - Try purchasing each plan type
   - Test cancelling a purchase
   - Test purchasing when already purchased
   - Test restore purchases

4. Verify in RevenueCat Dashboard:
   - Go to Customers tab
   - Find your test user
   - Verify purchase appears correctly

### Test Database Updates:

After a successful purchase, check your Supabase database:

```sql
SELECT
  email,
  trial_status,
  subscription_start_date,
  subscription_end_date,
  revenue_cat_customer_id,
  subscription_platform
FROM profiles
WHERE id = 'your-user-id';
```

Should show:
- `trial_status`: `'converted'`
- `subscription_start_date`: current timestamp
- `subscription_end_date`: start date + duration
- `revenue_cat_customer_id`: RevenueCat's app user ID
- `subscription_platform`: `'ios'` or `'android'`

## Files Modified

1. **[lib/pages/subscription_page/subscription_page_widget.dart](lib/pages/subscription_page/subscription_page_widget.dart)**
   - Added imports for RevenueCat and Supabase
   - Implemented purchase flow in "Continue" button
   - Implemented restore purchases functionality
   - Added error handling and user feedback

2. **[lib/pages/subscription_page/subscription_page_model.dart](lib/pages/subscription_page/subscription_page_model.dart)**
   - Added `isPurchasing` flag to prevent double-taps
   - Product ID mapping already existed

## Database Integration

The subscription page integrates with your existing trial system by calling the `convert_trial_to_subscription()` database function:

```dart
await SupaFlow.client.rpc(
  'convert_trial_to_subscription',
  params: {
    'user_uuid': currentUserUid,
    'duration_days': durationDays, // 30, 365, or 36500
    'platform': Platform.isIOS ? 'ios' : 'android',
    'rc_customer_id': purchaserInfo.originalAppUserId,
  },
);
```

This function (from migration 015) handles:
- Updating `trial_status` to `'converted'`
- Setting `subscription_start_date` and `subscription_end_date`
- Storing the RevenueCat customer ID
- Recording the platform (iOS/Android)

## Next Steps

1. **Configure RevenueCat Products** (see "Required Setup" above)
2. **Test in Sandbox** with test accounts
3. **Set up n8n Email Workflow** (see [N8N_TRIAL_WORKFLOW.md](N8N_TRIAL_WORKFLOW.md))
4. **Submit for Review** to App Store/Play Store with in-app purchases
5. **Monitor** purchases in RevenueCat dashboard

## Troubleshooting

### "No offerings available"
- Make sure you've created products in RevenueCat dashboard
- Verify offerings are configured
- Check that product IDs match exactly

### "Product not found"
- Verify product IDs in RevenueCat match code:
  - `Sprout_Sub_Month`
  - `Sprout_Sub_Year`
  - `Sprout_Sub_Life`
- Make sure products are attached to an offering

### Purchase fails silently
- Check debug logs for RevenueCat errors
- Verify sandbox tester accounts are set up
- Make sure app is signed with correct certificate
- Check that products are approved in App Store/Play Store

### Database not updating
- Verify `convert_trial_to_subscription()` function exists (migration 015)
- Check Supabase logs for RPC errors
- Verify user is authenticated (`currentUserUid` is valid)
- Check RLS policies on `profiles` table

## API Keys

RevenueCat is already initialized in [lib/main.dart](lib/main.dart) with your API keys from the environment.

Make sure your `.env` file has:
```env
REVENUE_CAT_IOS_API_KEY=appl_your_ios_key_here
REVENUE_CAT_ANDROID_API_KEY=goog_your_android_key_here
```

Or pass them as dart-define flags during build (see [REVENUECAT_SETUP_GUIDE.md](REVENUECAT_SETUP_GUIDE.md)).

---

**RevenueCat integration is complete!** 🎉

The subscription page is now ready to accept real payments once you configure your products in the RevenueCat dashboard and submit your app for review.
