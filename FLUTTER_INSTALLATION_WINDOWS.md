# Flutter Installation Guide for Windows

This guide will help you install Flutter on your Windows laptop so you can set up the Sproutify project in Android Studio.

## Prerequisites

Before installing Flutter, make sure you have:

1. **Windows 10 or later** (64-bit)
2. **Git for Windows** - Download from: https://git-scm.com/download/win
3. **At least 2GB of free disk space**

## Step 1: Download Flutter SDK

1. Go to: https://docs.flutter.dev/get-started/install/windows
2. Click the **"Download Flutter SDK"** button
3. Download the latest stable release (ZIP file, ~1GB)
4. Extract the ZIP file to a location where you want Flutter installed
   - **Recommended location**: `C:\Users\clint\flutter`
   - **OR**: `C:\src\flutter`
   - **Important**: Do NOT install Flutter in a path with spaces or special characters
   - **Important**: Do NOT install in `C:\Program Files\` (requires admin permissions)

## Step 2: Add Flutter to PATH

You need to add Flutter to your system PATH so you can run `flutter` commands from anywhere.

### Option A: Using System Environment Variables (Recommended)

1. **Open System Properties**:
   - Press `Win + R`
   - Type: `sysdm.cpl` and press Enter
   - OR: Right-click "This PC" → Properties → Advanced system settings

2. **Edit Environment Variables**:
   - Click **"Environment Variables"** button
   - Under **"User variables"**, find and select **"Path"**
   - Click **"Edit"**
   - Click **"New"**
   - Add the path to Flutter's `bin` folder:
     - If you installed to `C:\Users\clint\flutter`, add: `C:\Users\clint\flutter\bin`
     - If you installed to `C:\src\flutter`, add: `C:\src\flutter\bin`
   - Click **"OK"** on all dialogs

3. **Restart PowerShell/Terminal**:
   - Close all PowerShell/Command Prompt windows
   - Open a new PowerShell window
   - Test with: `flutter --version`

### Option B: Using PowerShell (Temporary for Current Session)

If you want to test Flutter without restarting:

```powershell
$env:Path += ";C:\Users\clint\flutter\bin"
```

(Replace with your actual Flutter installation path)

## Step 3: Verify Installation

1. Open a **new** PowerShell window (important - must be new after PATH change)
2. Run: `flutter --version`
   - You should see Flutter version information
3. Run: `flutter doctor`
   - This will check your Flutter installation and show what else needs to be configured

## Step 4: Install Android Studio (If Not Already Installed)

Flutter requires Android Studio for Android development:

1. Download Android Studio from: https://developer.android.com/studio
2. Run the installer
3. During installation, make sure to install:
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device (AVD)

## Step 5: Install Flutter and Dart Plugins in Android Studio

1. Open Android Studio
2. Go to **File → Settings** (or **Android Studio → Preferences** on Mac)
3. Navigate to **Plugins**
4. Search for **"Flutter"** and click **Install**
   - This will also install the **Dart** plugin automatically
5. Click **OK** and restart Android Studio when prompted

## Step 6: Run Flutter Doctor

After installing Android Studio and Flutter plugins:

1. Open PowerShell
2. Run: `flutter doctor`
3. Review the output - it will show:
   - ✅ What's properly configured
   - ❌ What needs to be fixed

### Common Issues and Fixes:

**Issue: "Android toolchain - develop for Android devices" shows errors**
- **Solution**: Open Android Studio → SDK Manager → Install Android SDK Platform 35
- Run: `flutter doctor --android-licenses` and accept all licenses

**Issue: "Android Studio (not installed)"**
- **Solution**: Make sure Android Studio is installed and Flutter plugin is installed
- Restart Android Studio

**Issue: "VS Code" or "IntelliJ IDEA" warnings**
- **Solution**: These are optional - you can ignore them if using Android Studio

## Step 7: Accept Android Licenses

1. Run: `flutter doctor --android-licenses`
2. Type `y` and press Enter for each license agreement

## Step 8: Verify Everything Works

Run `flutter doctor` again - you should see mostly green checkmarks:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.x.x, on Microsoft Windows)
[✓] Windows Version (Installed version of Windows is version 10 or higher)
[✓] Android toolchain - develop for Android devices
[✓] Chrome - develop for the web
[✓] Android Studio (version 2023.x)
[✓] VS Code (optional)
[✓] Connected device
[✓] Network resources
```

## Next Steps

Once Flutter is installed and `flutter doctor` shows mostly green checkmarks:

1. **Create `android/local.properties`**:
   - Copy `android/local.properties.template` to `android/local.properties`
   - Add your Flutter SDK path:
     ```
     flutter.sdk=C:\\Users\\clint\\flutter
     ```
   - (Replace with your actual Flutter installation path)

2. **Follow the Android Studio Setup Guide**:
   - See `ANDROID_STUDIO_SETUP.md` for next steps

## Quick Test

After installation, test Flutter:

```powershell
# Check Flutter version
flutter --version

# Check Flutter installation
flutter doctor

# Create a test app (optional)
flutter create test_app
cd test_app
flutter run
```

## Troubleshooting

### "flutter: command not found" after adding to PATH
- **Solution**: Make sure you:
  1. Added the correct path (should end with `\bin`)
  2. Closed and reopened PowerShell/Command Prompt
  3. Checked the path is correct: `echo $env:Path` (PowerShell) or `echo %Path%` (CMD)

### Flutter doctor shows Android issues
- **Solution**: 
  - Make sure Android Studio is fully installed
  - Open Android Studio → SDK Manager → Install required SDK components
  - Run `flutter doctor --android-licenses`

### Permission errors
- **Solution**: Make sure Flutter is NOT installed in `C:\Program Files\`
  - Install to `C:\Users\clint\flutter` or `C:\src\flutter` instead

## Need Help?

- Flutter Documentation: https://docs.flutter.dev/get-started/install/windows
- Flutter Community: https://flutter.dev/community
- Run `flutter doctor -v` for detailed diagnostic information


