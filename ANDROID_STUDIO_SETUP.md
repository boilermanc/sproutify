# Android Studio Setup Guide for Sproutify

This guide will help you set up the Sproutify Flutter project in Android Studio for testing on Android devices/emulators.

## Prerequisites

1. **Flutter SDK** - Must be installed and configured
   - **If Flutter is NOT installed**: See `FLUTTER_INSTALLATION_WINDOWS.md` for installation instructions
   - **If Flutter is installed**: Verify installation by running `flutter doctor` in terminal
   - Download from: https://flutter.dev/docs/get-started/install

2. **Android Studio** - Latest version recommended
   - Download from: https://developer.android.com/studio
   - Install the following plugins:
     - Flutter plugin
     - Dart plugin

3. **Android SDK** - Installed via Android Studio
   - Open Android Studio → SDK Manager
   - Install Android SDK Platform 35 (or the version specified in build.gradle)
   - Install Android SDK Build-Tools

## Setup Steps

### Step 1: Configure Flutter SDK Path

1. Find your Flutter SDK path:
   - Run `flutter --version` in terminal to see Flutter location
   - Or run `where flutter` (Windows) / `which flutter` (Mac/Linux)

2. Create `android/local.properties` file:
   - Copy `android/local.properties.template` to `android/local.properties`
   - Replace `YOUR_FLUTTER_SDK_PATH` with your actual Flutter SDK path
   
   **Windows Example:**
   ```
   flutter.sdk=C:\\Users\\YourUsername\\flutter
   ```
   
   **Mac/Linux Example:**
   ```
   flutter.sdk=/Users/YourUsername/flutter
   ```

### Step 2: Open Project in Android Studio

1. Open Android Studio
2. Select **File → Open**
3. Navigate to the `sproutify` project root directory
4. Select the project folder and click **OK**
5. Android Studio will detect it's a Flutter project and prompt you to configure it

### Step 3: Configure Flutter SDK in Android Studio

1. If prompted, click **Configure Flutter SDK**
2. Enter your Flutter SDK path (same as in local.properties)
3. Click **OK**

### Step 4: Sync Gradle Files

1. Android Studio should automatically prompt to sync Gradle
2. If not, click **File → Sync Project with Gradle Files**
3. Wait for the sync to complete (this may take a few minutes on first run)

### Step 5: Install Dependencies

1. Open terminal in Android Studio (View → Tool Windows → Terminal)
2. Run: `flutter pub get`
3. Wait for dependencies to install

### Step 6: Set Up Android Emulator or Connect Device

**Option A: Android Emulator**
1. Open **Tools → Device Manager** (or **AVD Manager**)
2. Click **Create Device**
3. Select a device (e.g., Pixel 5)
4. Select a system image (API 35 recommended)
5. Click **Finish**
6. Start the emulator

**Option B: Physical Device**
1. Enable **Developer Options** on your Android device
2. Enable **USB Debugging**
3. Connect device via USB
4. Accept the debugging prompt on your device

### Step 7: Run the App

1. Select your device/emulator from the device dropdown (top toolbar)
2. Click the **Run** button (green play icon) or press `Shift+F10`
3. The app should build and launch on your device/emulator

## Troubleshooting

### Issue: "flutter.sdk not set in local.properties"
- **Solution**: Make sure `android/local.properties` exists and contains the correct Flutter SDK path

### Issue: Gradle sync fails
- **Solution**: 
  - Check internet connection (Gradle needs to download dependencies)
  - Try **File → Invalidate Caches / Restart**
  - Check that Android SDK is properly installed

### Issue: "SDK location not found"
- **Solution**: 
  - Verify Flutter SDK path in `local.properties`
  - Make sure path uses forward slashes (/) or escaped backslashes (\\) on Windows

### Issue: Build fails with version errors
- **Solution**: 
  - Run `flutter doctor` to check for issues
  - Run `flutter clean` then `flutter pub get`
  - In Android Studio: **Build → Clean Project**, then **Build → Rebuild Project**

### Issue: No devices found
- **Solution**:
  - For emulator: Make sure it's started and running
  - For physical device: Check USB debugging is enabled, try different USB cable/port
  - Run `flutter devices` in terminal to see available devices

## Additional Notes

- The project uses **compileSdkVersion 35** and **targetSdkVersion 35**
- Minimum SDK version is **23** (Android 6.0)
- The app package name is: `com.sproutify.sproutifymobile`
- MainActivity is located at: `android/app/src/main/kotlin/com/sproutify/sproutifymobile/MainActivity.kt`

## Quick Commands Reference

```bash
# Check Flutter installation
flutter doctor

# Get Flutter dependencies
flutter pub get

# List available devices
flutter devices

# Run the app
flutter run

# Build APK
flutter build apk
```

## Next Steps

Once the app is running:
- You can set breakpoints and debug in Android Studio
- Use the Flutter DevTools for performance monitoring
- Hot reload is available (press `r` in terminal or click the hot reload button)

