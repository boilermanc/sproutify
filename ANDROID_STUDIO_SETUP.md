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

### Issue: Emulator stuck with "SensorsMultiHal" errors / "system_server not running"
**Symptoms**: Emulator shows repeated errors like:
```
SensorsMultiHal E  Dropping 1 events after blockingWrite failed (is system_server running?)
```

**Solutions** (try in order):

1. **Cold Boot the Emulator** (Most Common Fix):
   - Close the emulator completely
   - Open **Tools → Device Manager** (or **AVD Manager**)
   - Find your emulator in the list
   - Click the **▼ dropdown arrow** next to the emulator
   - Select **Cold Boot Now**
   - Wait for the emulator to fully boot (may take 1-2 minutes)

2. **Wipe Emulator Data**:
   - Close the emulator
   - In **Device Manager**, click the **▼ dropdown** next to your emulator
   - Select **Wipe Data**
   - Confirm the action
   - Start the emulator again

3. **Restart Emulator**:
   - Close the emulator window completely
   - Wait 10-15 seconds
   - Start it again from Device Manager

4. **Check for Multiple Emulator Instances**:
   - Open Task Manager (Windows) and look for multiple `qemu-system-x86_64.exe` or `emulator.exe` processes
   - End all emulator-related processes
   - Start a fresh emulator instance

5. **Update Emulator and System Images**:
   - Open **Tools → SDK Manager**
   - Go to **SDK Tools** tab
   - Check **Android Emulator** and update if available
   - Go to **SDK Platforms** tab
   - Update your system image (e.g., Android 14/API 35)
   - Restart Android Studio

6. **Create a New Emulator** (if above doesn't work):
   - In **Device Manager**, click **Create Device**
   - Select a device (e.g., Pixel 5)
   - Select a system image (API 35 recommended)
   - Click **Finish**
   - Try the new emulator

7. **Check System Resources**:
   - Ensure you have enough RAM (emulator needs at least 2GB free)
   - Close other resource-intensive applications
   - In Device Manager, edit your emulator and reduce RAM allocation if needed

8. **Command Line Alternative**:
   ```powershell
   # List running emulators
   adb devices
   
   # Kill all emulator processes
   taskkill /F /IM qemu-system-x86_64.exe
   taskkill /F /IM emulator.exe
   
   # Start emulator with cold boot
   emulator -avd YOUR_AVD_NAME -no-snapshot-load
   ```
   (Replace `YOUR_AVD_NAME` with your actual AVD name - find it in Device Manager)

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

