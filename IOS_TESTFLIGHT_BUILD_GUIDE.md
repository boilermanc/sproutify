# iOS TestFlight Build Guide

## Prerequisites

**Important:** iOS builds require a Mac. Since you're on Windows, you'll need:
- A physical Mac, OR
- A cloud Mac service (MacStadium, MacinCloud, AWS EC2 Mac instances), OR
- A CI/CD service with Mac runners (GitHub Actions, Codemagic, etc.)

## Current App Configuration

- **Bundle ID:** `com.sproutify.sproutifymobile`
- **Version:** `2.6.8` (from pubspec.yaml)
- **Build Number:** `4` (from pubspec.yaml)
- **iOS Deployment Target:** `14.0.0`

## Building for TestFlight

### Option 1: Using Flutter CLI + Xcode (Recommended)

1. **On your Mac, navigate to the project:**
   ```bash
   cd /path/to/sproutify
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Install iOS pods:**
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **Build the iOS app (Release mode):**
   ```bash
   flutter build ipa --release
   ```
   
   This will create an `.ipa` file at: `build/ios/ipa/sproutify_home.ipa`

5. **Upload to App Store Connect:**
   - Open Xcode
   - Go to **Window → Organizer** (or press `Cmd+Shift+O`)
   - Click **Distribute App**
   - Select **App Store Connect**
   - Follow the wizard to upload

### Option 2: Using Xcode Directly

1. **Open the workspace in Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configure code signing:**
   - Select the **Runner** project in the navigator
   - Go to **Signing & Capabilities** tab
   - Select your **Team** (your Apple Developer account)
   - Ensure **Automatically manage signing** is checked
   - Verify the Bundle Identifier matches: `com.sproutify.sproutifymobile`

3. **Select the scheme:**
   - At the top, select **Runner** scheme
   - Select **Any iOS Device (arm64)** as the destination

4. **Create Archive:**
   - Go to **Product → Archive**
   - Wait for the build to complete

5. **Distribute:**
   - In the Organizer window, select your archive
   - Click **Distribute App**
   - Choose **App Store Connect**
   - Follow the wizard

### Option 3: Using Codemagic (Recommended for Windows Users) ⭐

Codemagic is a CI/CD service specifically designed for Flutter apps. It's perfect if you're on Windows and need to build iOS apps.

#### Setup Steps:

1. **Sign up/Login to Codemagic:**
   - Go to https://codemagic.io
   - Sign up with your GitHub/GitLab/Bitbucket account
   - Connect your repository

2. **Configure App Store Connect API Key:**
   - Go to [App Store Connect](https://appstoreconnect.apple.com) → Users and Access → Keys
   - Create a new API key with **App Manager** or **Admin** role
   - Download the `.p8` key file (you can only download it once!)
   - Note the **Key ID** and **Issuer ID**

3. **Add Environment Variables in Codemagic:**
   - In Codemagic dashboard, go to your app → **Environment variables**
   - Create a group called `app_secrets` with:
     - `SUPABASE_URL` = `https://xzckfyipgrgpwnydddev.supabase.co` (required)
     - `SUPABASE_ANON_KEY` = `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (your full key, required)
     - `REVENUE_CAT_IOS_API_KEY` = `appl_szgNwIyKqHcKLtwDsoMEvuwPtOi` (optional - leave empty if you don't have it yet)
     - `N8N_WEBHOOK_URL` = `https://n8n.sproutify.app/webhook/...` (required)
   
   **Note:** RevenueCat is optional. If you don't have the API key yet, you can leave `REVENUE_CAT_IOS_API_KEY` empty or omit it. The app will build and run fine, but RevenueCat features (in-app purchases) won't work until you add the key later.

4. **Configure App Store Connect Integration:**
   
   This is where you use the `.p8` key file you downloaded from App Store Connect.
   
   **Step-by-step:**
   
   a. In Codemagic dashboard, go to your app settings
   
   b. Look for **"App Store Connect"** or **"Code signing"** section in the left sidebar
   
   c. Click **"Add credentials"** or **"Upload certificate"**
   
   d. You'll see a form asking for:
      - **API Key (.p8 file)**: Upload the `.p8` file you downloaded from App Store Connect
      - **Key ID**: This is the 10-character string (like `ABC123DEFG`) shown when you created the key
      - **Issuer ID**: This is a UUID (like `12345678-1234-1234-1234-123456789012`) found in App Store Connect → Users and Access → Keys
   
   e. After uploading, Codemagic will automatically create the `app_store_credentials` group
   
   **Where to find these values:**
   - **Key ID**: App Store Connect → Users and Access → Keys → Your key name → Shows the Key ID
   - **Issuer ID**: Same page, shown at the top (usually starts with a number)
   - **.p8 file**: You downloaded this when creating the key (if you lost it, you'll need to create a new key)

5. **Update Email in codemagic.yaml:**
   - Edit `codemagic.yaml` in your project
   - Change `user@example.com` to your email address

6. **Start a Build:**
   - In Codemagic dashboard, click **Start new build**
   - Select the `ios-testflight` workflow
   - Click **Start new build**
   - Codemagic will build and automatically upload to TestFlight!

#### The `codemagic.yaml` file is already configured in your project root.

**Benefits:**
- ✅ No Mac required - builds in the cloud
- ✅ Automatic TestFlight upload
- ✅ Email notifications on build completion
- ✅ Handles code signing automatically
- ✅ Free tier available (500 build minutes/month)

### Option 4: Using GitHub Actions

If you prefer GitHub Actions, here's a basic workflow:

```yaml
name: Build iOS for TestFlight

on:
  workflow_dispatch:

jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: cd ios && pod install && cd ..
      - run: flutter build ipa --release
      - uses: apple-actions/upload-testflight-build@v1
        with:
          app-path: 'build/ios/ipa/sproutify_home.ipa'
          issuer-id: ${{ secrets.APPSTORE_ISSUER_ID }}
          api-key-id: ${{ secrets.APPSTORE_API_KEY_ID }}
          api-private-key: ${{ secrets.APPSTORE_API_PRIVATE_KEY }}
```

## Important Notes

### Code Signing
- You need an **Apple Developer account** ($99/year)
- The app must be registered in **App Store Connect** with bundle ID `com.sproutify.sproutifymobile`
- You'll need distribution certificates and provisioning profiles (Xcode can manage these automatically)

### App Store Connect Setup
Before uploading, ensure:
1. Your app exists in App Store Connect
2. The bundle ID matches: `com.sproutify.sproutifymobile`
3. You have the necessary permissions (Admin or App Manager role)

### Version & Build Number
- **Version** (CFBundleShortVersionString): Currently `2.6.8` from pubspec.yaml
- **Build Number** (CFBundleVersion): Currently `4` from pubspec.yaml
- Each TestFlight upload needs a unique build number (increment it for each upload)

To update the version/build number, edit `pubspec.yaml`:
```yaml
version: 2.6.8+5  # Version 2.6.8, Build 5
```

## Uploading to TestFlight

After building, you can upload via:
1. **Xcode Organizer** (as described above)
2. **Transporter app** (download from Mac App Store)
3. **Command line** using `xcrun altool` or `xcrun notarytool`
4. **CI/CD** (automated upload)

## Troubleshooting

### "No signing certificate found"
- Ensure you're logged into Xcode with your Apple ID
- Go to Xcode → Settings → Accounts → Add your Apple ID
- Select your team in the Signing & Capabilities tab

### "Bundle identifier is already in use"
- The bundle ID must be unique across all App Store apps
- If it's already registered, you need to use that App Store Connect app record

### Build fails
- Ensure all dependencies are installed: `flutter pub get` and `pod install`
- Check that your Mac has the latest Xcode and command line tools
- Verify Flutter is properly installed: `flutter doctor`

## Next Steps After Upload

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Navigate to your app → TestFlight
3. Wait for processing (usually 10-30 minutes)
4. Add testers and configure TestFlight groups
5. Submit for review if needed

