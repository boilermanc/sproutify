# RevenueCat Setup Guide

This guide will walk you through setting up RevenueCat in your Flutter app step by step.

## Prerequisites

- A RevenueCat account (sign up at https://app.revenuecat.com)
- Your app configured in both App Store Connect (iOS) and Google Play Console (Android)
- Flutter project already set up (✅ You have this!)

## Step 1: Create a RevenueCat Account and Project

1. Go to https://app.revenuecat.com and sign up/login
2. Create a new project or select an existing one
3. Name your project (e.g., "Sproutify")

## Step 2: Add Your Apps to RevenueCat

### For iOS:
1. In RevenueCat dashboard, go to **Projects** → Select your project → **Apps**
2. Click **Add App** → Select **iOS**
3. Enter your **Bundle ID** (found in Xcode or `ios/Runner.xcodeproj`)
   - Your bundle ID appears to be: `com.sproutify.sproutifymobile` (check in Xcode to confirm)
4. RevenueCat will generate an **iOS API Key** (starts with `appl_`)
5. Copy this key - you'll need it later

### For Android:
1. In the same project, click **Add App** → Select **Android**
2. Enter your **Package Name** (found in `android/app/build.gradle`)
   - Your package name is: `com.sproutify.sproutifymobile`
3. RevenueCat will generate an **Android API Key** (starts with `goog_`)
4. Copy this key - you'll need it later

## Step 3: Configure Your API Keys

### Option A: Using Environment Variables (Recommended for Development)

1. Copy `env.template` to `.env` (if you don't have one already):
   ```bash
   cp env.template .env
   ```

2. Open `.env` and add your API keys:
   ```env
   REVENUE_CAT_IOS_API_KEY=appl_your_ios_key_here
   REVENUE_CAT_ANDROID_API_KEY=goog_your_android_key_here
   ```

3. **Important**: Add `.env` to your `.gitignore` to keep keys secure!

### Option B: Using Dart Defines (For Production Builds)

When building your app, pass the keys as dart-define flags:

**For Android:**
```bash
flutter build apk --release \
  --dart-define=REVENUE_CAT_IOS_API_KEY=appl_your_ios_key \
  --dart-define=REVENUE_CAT_ANDROID_API_KEY=goog_your_android_key
```

**For iOS:**
```bash
flutter build ios --release \
  --dart-define=REVENUE_CAT_IOS_API_KEY=appl_your_ios_key \
  --dart-define=REVENUE_CAT_ANDROID_API_KEY=goog_your_android_key
```

## Step 4: Configure Products in App Stores

### iOS - App Store Connect:
1. Go to App Store Connect → Your App → **Features** → **In-App Purchases**
2. Create your subscription/product:
   - Click **+** to create a new subscription
   - Set up your subscription group
   - Configure pricing and duration
   - **Important**: Note the **Product ID** (e.g., `premium_monthly`)

### Android - Google Play Console:
1. Go to Google Play Console → Your App → **Monetize** → **Products** → **Subscriptions**
2. Create your subscription:
   - Click **Create subscription**
   - Set up pricing and billing period
   - **Important**: Use the **same Product ID** as iOS (e.g., `premium_monthly`)

## Step 5: Configure Products in RevenueCat

1. In RevenueCat dashboard, go to **Products**
2. Click **Add Product**
3. Enter the **Product ID** (must match App Store/Play Store)
4. Configure:
   - **Identifier**: Your product ID (e.g., `premium_monthly`)
   - **Type**: Subscription or One-time purchase
   - **Store Product IDs**: 
     - iOS: Your App Store product ID
     - Android: Your Play Store product ID

## Step 6: Create Entitlements

1. In RevenueCat dashboard, go to **Entitlements**
2. Click **Add Entitlement**
3. Set **Identifier** (e.g., `premium`)
4. Add your products to this entitlement
5. This entitlement ID is what you'll check in your code

## Step 7: Test Your Setup

### Run the App:
```bash
flutter run --dart-define=REVENUE_CAT_IOS_API_KEY=your_ios_key --dart-define=REVENUE_CAT_ANDROID_API_KEY=your_android_key
```

### Test Purchases:
1. Use RevenueCat's **Sandbox Tester** accounts:
   - iOS: Create sandbox testers in App Store Connect
   - Android: Add test accounts in Play Console
2. Test the purchase flow in your app
3. Check RevenueCat dashboard → **Customers** to see test purchases

## Step 8: Using RevenueCat in Your Code

The project already has helper functions in `lib/flutter_flow/revenue_cat_util.dart`. Here's how to use them:

### Check if User Has Premium:
```dart
import 'flutter_flow/revenue_cat_util.dart' as revenue_cat;

// Check if user has premium entitlement
bool? hasPremium = await revenue_cat.isEntitled('premium');
if (hasPremium == true) {
  // User has premium access
}
```

### Purchase a Product:
```dart
// Purchase a package (e.g., 'monthly', 'annual')
bool success = await revenue_cat.purchasePackage('monthly');
if (success) {
  // Purchase successful
}
```

### Restore Purchases:
```dart
await revenue_cat.restorePurchases();
```

### Link User Account:
```dart
// When user logs in
await revenue_cat.login(userId);

// When user logs out
await revenue_cat.login(null);
```

### Get Offerings:
```dart
// Get available packages
final offerings = revenue_cat.offerings;
final currentOffering = offerings?.current;
final packages = currentOffering?.availablePackages;
```

## Step 9: Platform-Specific Configuration

### Android Configuration
✅ Already configured! The `purchases_flutter` package handles Android setup automatically.

**Optional - ProGuard Rules** (if using ProGuard):
Add to `android/app/proguard-rules.pro`:
```
-keep class com.revenuecat.** { *; }
-dontwarn com.revenuecat.**
```

### iOS Configuration
✅ Already configured! The `purchases_flutter` package handles iOS setup automatically.

**Note**: Make sure your iOS app has the correct bundle ID and is properly signed.

## Step 10: Production Checklist

Before going live:

- [ ] Replace sandbox API keys with production keys
- [ ] Test purchases on both iOS and Android
- [ ] Verify entitlements work correctly
- [ ] Set up webhooks (optional) for server-side validation
- [ ] Configure receipt validation
- [ ] Test restore purchases functionality
- [ ] Test subscription renewal
- [ ] Test subscription cancellation
- [ ] Set up analytics (optional)

## Troubleshooting

### "RevenueCat initialization failed"
- Check that your API keys are correct
- Ensure keys match the platform (iOS key for iOS, Android key for Android)
- Verify internet connection

### "No offerings available"
- Make sure you've created products in RevenueCat dashboard
- Verify products are linked to entitlements
- Check that products exist in App Store/Play Store

### "Purchase failed"
- Verify you're using sandbox test accounts
- Check that products are approved in App Store/Play Store
- Ensure billing is set up correctly

### Debug Logging
Debug logging is automatically enabled in development mode. To manually enable:
```dart
await revenue_cat.initialize(
  iosKey,
  androidKey,
  debugLogEnabled: true, // Enable debug logs
);
```

## Additional Resources

- [RevenueCat Flutter Documentation](https://docs.revenuecat.com/docs/flutter)
- [RevenueCat Dashboard](https://app.revenuecat.com)
- [RevenueCat Community](https://community.revenuecat.com)

## Support

If you encounter issues:
1. Check RevenueCat dashboard for error messages
2. Review RevenueCat logs in your app console
3. Check RevenueCat documentation
4. Contact RevenueCat support

---

**Your project is now configured for RevenueCat!** 🎉

Next steps:
1. Get your API keys from RevenueCat dashboard
2. Add them to your `.env` file or build scripts
3. Create your products in App Store/Play Store
4. Configure products in RevenueCat
5. Start implementing purchase flows in your app

