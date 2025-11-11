# Flutter Deployment Guide with RevenueCat

This guide covers deploying your Flutter app to iOS and Android app stores with RevenueCat configured.

## Overview

Your project is a **Flutter** app, not an Expo/React Native app. Flutter has its own deployment process that's different from Expo.

## Deployment Options

### Option 1: Local Build & Manual Upload (Recommended for RevenueCat)

Build your app locally and upload to app stores manually.

### Option 2: CI/CD with GitHub Actions

Automate builds using GitHub Actions (similar to EAS Build for Expo).

### Option 3: Codemagic / AppCircle

Use Flutter-specific CI/CD services (similar to EAS Build).

---

## Option 1: Local Build & Manual Upload

### Prerequisites

- **iOS**: Mac with Xcode installed
- **Android**: Android Studio installed
- **Both**: RevenueCat API keys configured

### Step 1: Configure Environment Variables

Create a `.env` file or use dart-define flags:

```bash
# .env file
REVENUE_CAT_IOS_API_KEY=appl_your_ios_key
REVENUE_CAT_ANDROID_API_KEY=goog_your_android_key
```

### Step 2: Build for Android

#### Build APK (for testing):
```bash
flutter build apk --release \
  --dart-define=REVENUE_CAT_IOS_API_KEY=your_ios_key \
  --dart-define=REVENUE_CAT_ANDROID_API_KEY=your_android_key
```

#### Build App Bundle (for Play Store):
```bash
flutter build appbundle --release \
  --dart-define=REVENUE_CAT_IOS_API_KEY=your_ios_key \
  --dart-define=REVENUE_CAT_ANDROID_API_KEY=your_android_key
```

Output: `build/app/outputs/bundle/release/app-release.aab`

#### Upload to Play Store:
1. Go to Google Play Console
2. Create release → Upload `app-release.aab`
3. Complete release process

### Step 3: Build for iOS

#### Build iOS App:
```bash
flutter build ios --release \
  --dart-define=REVENUE_CAT_IOS_API_KEY=your_ios_key \
  --dart-define=REVENUE_CAT_ANDROID_API_KEY=your_android_key
```

#### Archive in Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Product** → **Archive**
3. Wait for archive to complete
4. Click **Distribute App**
5. Choose distribution method (App Store, Ad Hoc, etc.)
6. Follow Xcode's distribution wizard

---

## Option 2: CI/CD with GitHub Actions

Create automated builds similar to EAS Build.

### Step 1: Create GitHub Actions Workflow

Create `.github/workflows/build.yml`:

```yaml
name: Build and Deploy

on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build Android App Bundle
        run: |
          flutter build appbundle --release \
            --dart-define=REVENUE_CAT_IOS_API_KEY=${{ secrets.REVENUE_CAT_IOS_API_KEY }} \
            --dart-define=REVENUE_CAT_ANDROID_API_KEY=${{ secrets.REVENUE_CAT_ANDROID_API_KEY }}
      
      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: android-release
          path: build/app/outputs/bundle/release/app-release.aab

  build-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Install CocoaPods
        run: |
          cd ios
          pod install
      
      - name: Build iOS
        run: |
          flutter build ios --release --no-codesign \
            --dart-define=REVENUE_CAT_IOS_API_KEY=${{ secrets.REVENUE_CAT_IOS_API_KEY }} \
            --dart-define=REVENUE_CAT_ANDROID_API_KEY=${{ secrets.REVENUE_CAT_ANDROID_API_KEY }}
      
      - name: Upload artifact
        uses: actions/upload-artifact@v3
        with:
          name: ios-release
          path: build/ios/iphoneos/Runner.app
```

### Step 2: Add Secrets to GitHub

1. Go to your GitHub repo → **Settings** → **Secrets and variables** → **Actions**
2. Add secrets:
   - `REVENUE_CAT_IOS_API_KEY`
   - `REVENUE_CAT_ANDROID_API_KEY`

### Step 3: Trigger Build

Push to main branch or manually trigger from Actions tab.

---

## Option 3: Codemagic (Flutter CI/CD Service)

Codemagic is a Flutter-focused CI/CD service (similar to EAS Build for Expo).

### Step 1: Sign Up

1. Go to https://codemagic.io
2. Sign up with GitHub
3. Connect your repository

### Step 2: Configure Build

1. Click **Add application**
2. Select your repository
3. Choose **Flutter** as project type
4. Configure build settings:

**Android:**
```yaml
workflows:
  android-workflow:
    name: Android Workflow
    max_build_duration: 120
    instance_type: mac_mini_m1
    environment:
      groups:
        - revenuecat_secrets
      flutter: stable
    scripts:
      - name: Get Flutter dependencies
        script: flutter pub get
      - name: Build Android App Bundle
        script: |
          flutter build appbundle --release \
            --dart-define=REVENUE_CAT_IOS_API_KEY=$REVENUE_CAT_IOS_API_KEY \
            --dart-define=REVENUE_CAT_ANDROID_API_KEY=$REVENUE_CAT_ANDROID_API_KEY
    artifacts:
      - build/app/outputs/**/**.aab
```

**iOS:**
```yaml
workflows:
  ios-workflow:
    name: iOS Workflow
    max_build_duration: 120
    instance_type: mac_mini_m1
    environment:
      groups:
        - revenuecat_secrets
      flutter: stable
      xcode: latest
    scripts:
      - name: Get Flutter dependencies
        script: flutter pub get
      - name: Install CocoaPods dependencies
        script: |
          cd ios && pod install
      - name: Build iOS
        script: |
          flutter build ios --release \
            --dart-define=REVENUE_CAT_IOS_API_KEY=$REVENUE_CAT_IOS_API_KEY \
            --dart-define=REVENUE_CAT_ANDROID_API_KEY=$REVENUE_CAT_ANDROID_API_KEY
    artifacts:
      - build/ios/ipa/*.ipa
```

### Step 3: Add Environment Variables

1. Go to **Settings** → **Environment variables**
2. Add:
   - `REVENUE_CAT_IOS_API_KEY`
   - `REVENUE_CAT_ANDROID_API_KEY`

---

## Important Notes for RevenueCat

### 1. API Keys Must Match Platform

- **iOS builds** must use iOS API key (starts with `appl_`)
- **Android builds** must use Android API key (starts with `goog_`)
- Both keys are passed to all builds, but only the platform-specific one is used

### 2. Testing Before Production

Always test with sandbox/test accounts before deploying to production:

1. Use RevenueCat sandbox testers
2. Test purchases in development builds
3. Verify entitlements work correctly
4. Test restore purchases functionality

### 3. Production Checklist

Before deploying to production:

- [ ] Replace sandbox API keys with production keys
- [ ] Test purchases on both platforms
- [ ] Verify products are approved in App Store/Play Store
- [ ] Test subscription renewal
- [ ] Test subscription cancellation
- [ ] Verify webhooks (if using)
- [ ] Test restore purchases

---

## Comparison: Flutter vs Expo

| Feature | Flutter (Your Project) | Expo |
|---------|----------------------|------|
| Framework | Flutter/Dart | React Native/JavaScript |
| Build System | `flutter build` | `eas build` or `expo build` |
| Native Code | Full access | Limited (unless using bare workflow) |
| RevenueCat | `purchases_flutter` | `react-native-purchases` |
| Deployment | Manual or CI/CD | EAS Build (recommended) |
| Configuration | `pubspec.yaml` | `app.json` / `app.config.js` |

---

## Quick Start: Deploy Now

### Android (Quickest):
```bash
# 1. Build
flutter build appbundle --release \
  --dart-define=REVENUE_CAT_IOS_API_KEY=your_ios_key \
  --dart-define=REVENUE_CAT_ANDROID_API_KEY=your_android_key

# 2. Upload to Play Console
# Go to: https://play.google.com/console
# Upload: build/app/outputs/bundle/release/app-release.aab
```

### iOS (Requires Mac):
```bash
# 1. Build
flutter build ios --release \
  --dart-define=REVENUE_CAT_IOS_API_KEY=your_ios_key \
  --dart-define=REVENUE_CAT_ANDROID_API_KEY=your_android_key

# 2. Open in Xcode and Archive
open ios/Runner.xcworkspace
# Then: Product → Archive → Distribute App
```

---

## Need Help?

- **Flutter Deployment**: https://docs.flutter.dev/deployment
- **RevenueCat Flutter**: https://docs.revenuecat.com/docs/flutter
- **Google Play Console**: https://play.google.com/console
- **App Store Connect**: https://appstoreconnect.apple.com

---

**Note**: If you specifically need Expo functionality, you would need to:
1. Create a new React Native/Expo project
2. Migrate your app logic to React Native
3. Use `react-native-purchases` instead of `purchases_flutter`

However, Flutter provides excellent deployment options and is fully capable of everything Expo offers for React Native.

