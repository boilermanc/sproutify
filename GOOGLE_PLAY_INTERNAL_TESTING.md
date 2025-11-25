# Google Play Store Internal Testing Build Guide

## Quick Answer

**You build locally and then upload manually.** This is a Flutter project (not Expo), so you'll use Flutter's build commands to create an App Bundle (.aab file) and then upload it to Google Play Console.

---

## Step-by-Step Instructions

### 1. Update Your RevenueCat Android API Key

Before building, make sure you have your actual RevenueCat Android API key. Update it in the build script:

**Windows (`build.bat`):**
```batch
--dart-define=REVENUE_CAT_ANDROID_API_KEY=goog_YOUR_ACTUAL_KEY_HERE
```

**Mac/Linux (`build.sh`):**
```bash
--dart-define=REVENUE_CAT_ANDROID_API_KEY=goog_YOUR_ACTUAL_KEY_HERE
```

### 2. Build the App Bundle

**On Windows:**
```batch
build.bat playstore
```

**On Mac/Linux:**
```bash
./build.sh playstore
```

**Or manually:**
```bash
flutter build appbundle --release \
  --dart-define=SUPABASE_URL=https://xzckfyipgrgpwnydddev.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo \
  --dart-define=REVENUE_CAT_IOS_API_KEY=appl_szgNwIyKqHcKLtwDsoMEvuwPtOi \
  --dart-define=REVENUE_CAT_ANDROID_API_KEY=YOUR_ANDROID_KEY \
  --dart-define=N8N_WEBHOOK_URL=https://n8n.sproutify.app/webhook/a9aae518-ec85-4b0d-b2cb-5e6f64c5783d
```

### 3. Find Your App Bundle

After building, your `.aab` file will be located at:

```
build/app/outputs/bundle/release/app-release.aab
```

### 4. Upload to Google Play Console

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Navigate to **Testing** → **Internal testing** (or **Closed testing** / **Open testing**)
4. Click **Create new release**
5. Upload the `app-release.aab` file
6. Fill in release notes
7. Click **Save** → **Review release** → **Start rollout to Internal testing**

---

## Important Notes

### App Bundle vs APK

- **App Bundle (.aab)** - Required for Google Play Store uploads
- **APK (.apk)** - Used for direct installation/testing, NOT for Play Store

The build script now supports both:
- `build.bat playstore` - Builds App Bundle for Play Store
- `build.bat prod` - Builds APK for direct installation

### Signing

Your app is currently using debug signing. For production releases, you'll need to set up proper release signing:

1. Create a keystore file
2. Create `android/key.properties` with your keystore details
3. Update `android/app/build.gradle` to use release signing (currently commented out)

For **internal testing**, debug signing will work, but Google recommends using release signing even for testing.

### Version Number

Your current version is `2.6.8+15` (defined in `pubspec.yaml`). Each time you upload a new build to Play Store, you need to increment:
- **Version name** (2.6.8) - User-facing version
- **Version code** (+15) - Internal build number (must always increase)

---

## Troubleshooting

### Build Fails

- Make sure Flutter is installed: `flutter doctor`
- Ensure Android SDK is properly configured
- Check that all dependencies are installed: `flutter pub get`

### Upload Fails

- Ensure the `.aab` file is not corrupted
- Check that version code is higher than previous uploads
- Verify app signing is correct

### Testing the Build Locally

You can't directly install an `.aab` file on a device. To test locally:
1. Build an APK instead: `build.bat prod`
2. Install the APK: `flutter install` or manually install `build/app/outputs/flutter-apk/app-release.apk`

---

## Next Steps

After internal testing:
1. Fix any issues found during testing
2. Increment version number in `pubspec.yaml`
3. Build new App Bundle
4. Upload to **Closed testing** or **Production**

---

## Resources

- [Flutter App Bundle Guide](https://docs.flutter.dev/deployment/android#building-an-app-bundle)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer/)
- [Flutter Deployment Guide](./FLUTTER_DEPLOYMENT_GUIDE.md)





