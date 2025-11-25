# Android App Signing Setup for Google Play Store

## Problem

Google Play Console expects your App Bundle to be signed with a specific certificate:
- **Expected SHA1**: `FB:60:2B:60:DF:9F:6F:51:F9:EC:19:F0:70:DE:A4:95:B8:98:4D:44`
- **Current SHA1**: `14:92:DD:FF:B9:0C:A0:B8:15:47:78:ED:DF:A5:F2:0F:83:65:F1:D2` (debug key)

## Solution

You need to use the **same keystore file** that was used for your previous Google Play uploads.

---

## Step 1: Find Your Keystore File

The keystore file should have the SHA1 fingerprint: `FB:60:2B:60:DF:9F:6F:51:F9:EC:19:F0:70:DE:A4:95:B8:98:4D:44`

**Common locations:**
- `android/upload-keystore.jks` or `android/upload-keystore.keystore`
- `android/app/upload-keystore.jks`
- Your home directory or a secure location
- A password manager or secure backup

**If you can't find it:**
- Check with team members who may have created previous builds
- Check your backups or secure storage
- Check if it was stored in a CI/CD system (like Codemagic, GitHub Actions, etc.)

---

## Step 2: Verify Keystore Fingerprint

Once you find the keystore file, verify it matches the expected fingerprint:

```bash
# On Windows (PowerShell)
keytool -list -v -keystore android\upload-keystore.jks

# On Mac/Linux
keytool -list -v -keystore android/upload-keystore.jks
```

Look for the SHA1 fingerprint in the output. It should match: `FB:60:2B:60:DF:9F:6F:51:F9:EC:19:F0:70:DE:A4:95:B8:98:4D:44`

---

## Step 3: Create key.properties File

1. Copy the template:
   ```bash
   # Windows
   copy android\key.properties.template android\key.properties
   
   # Mac/Linux
   cp android/key.properties.template android/key.properties
   ```

2. Edit `android/key.properties` and fill in your keystore details:
   ```properties
   storeFile=../upload-keystore.jks
   storePassword=YOUR_ACTUAL_STORE_PASSWORD
   keyAlias=upload
   keyPassword=YOUR_ACTUAL_KEY_PASSWORD
   ```

   **Important:**
   - Update the `storeFile` path to match where your keystore file is located
   - Replace `YOUR_ACTUAL_STORE_PASSWORD` and `YOUR_ACTUAL_KEY_PASSWORD` with your actual passwords
   - The `keyAlias` might be different - check with `keytool -list -v -keystore <your-keystore>`

---

## Step 4: Place Keystore File

Place your keystore file in the `android/` directory (or update the path in `key.properties` accordingly).

**Recommended:** `android/upload-keystore.jks`

---

## Step 5: Rebuild Your App Bundle

Now rebuild with the correct signing:

```bash
# Windows
.\build.bat playstore

# Mac/Linux
./build.sh playstore
```

The build will now use the release signing key automatically.

---

## Step 6: Verify the Signature

After building, verify the new App Bundle is signed correctly:

```bash
# Check the signature of your new .aab file
jarsigner -verify -verbose -certs build\app\outputs\bundle\release\app-release.aab
```

Or use:
```bash
keytool -printcert -jarfile build\app\outputs\bundle\release\app-release.aab
```

The SHA1 fingerprint should now match: `FB:60:2B:60:DF:9F:6F:51:F9:EC:19:F0:70:DE:A4:95:B8:98:4D:44`

---

## If You Don't Have the Keystore

**⚠️ CRITICAL:** If you've lost the keystore file, you have two options:

### Option 1: Contact Google Play Support (Recommended)
- Google Play Support can help you recover or reset your app signing
- They may be able to help you upload a new signing key
- This is the safest option to avoid breaking your app

### Option 2: Create a New App Listing
- Create a new app in Google Play Console with a new package name
- This means starting fresh (losing reviews, ratings, etc.)
- Only do this if you absolutely cannot recover the keystore

---

## Security Best Practices

1. **Never commit `key.properties` or keystore files to Git**
   - They're already in `.gitignore`, but double-check
   
2. **Backup your keystore file securely**
   - Store in a password manager
   - Keep encrypted backups
   - Share securely with team members who need it

3. **Use strong passwords**
   - Store passwords securely
   - Consider using a password manager

---

## Troubleshooting

### "Keystore file not found"
- Check the path in `key.properties` is correct
- Use absolute path if relative path doesn't work
- On Windows, use forward slashes or escaped backslashes: `storeFile=C:\\path\\to\\keystore.jks`

### "Wrong password"
- Double-check your passwords in `key.properties`
- Verify the keystore password and key password are correct

### "Key alias not found"
- List aliases in your keystore: `keytool -list -keystore <keystore-file>`
- Update `keyAlias` in `key.properties` to match

### Still getting wrong signature error
- Make sure `build.gradle` is using `signingConfig signingConfigs.release`
- Clean and rebuild: `flutter clean && flutter build appbundle --release`
- Verify the keystore fingerprint matches what Google Play expects

---

## Next Steps

Once you have the keystore set up:
1. Build the App Bundle: `.\build.bat playstore`
2. Upload to Google Play Console
3. The signature should now match and upload should succeed!





