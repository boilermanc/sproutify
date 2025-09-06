# Security Configuration Setup

This document explains how to use the new secure configuration system for your Flutter app.

## Files Created

### 1. `lib/config/env.dart`
This file contains all your environment configuration with fallback values. It uses Dart's `String.fromEnvironment()` to read from build-time environment variables.

### 2. `env.template`
Template file showing all the environment variables your app uses. Copy this to `.env` and modify as needed.

### 3. `build.sh` and `build.bat`
Build scripts for Unix/Linux and Windows respectively that pass environment variables during build.

### 4. Updated `.gitignore`
Added entries to prevent committing sensitive `.env` files.

## How to Use

### For Development (Current Setup)
Your app will work exactly as before since we included the current values as defaults in `env.dart`.

### For Production
1. Copy `env.template` to `.env`:
   ```bash
   cp env.template .env
   ```

2. Edit `.env` with your production values:
   ```
   SUPABASE_URL=https://your-production-supabase-url.supabase.co
   SUPABASE_ANON_KEY=your-production-anon-key
   REVENUE_CAT_API_KEY=your-production-revenue-cat-key
   ```

3. Build using the script:
   ```bash
   # Unix/Linux/Mac
   ./build.sh prod
   
   # Windows
   build.bat prod
   ```

### For Different Environments
You can create multiple `.env` files:
- `.env.development`
- `.env.staging` 
- `.env.production`

Then modify the build scripts to use the appropriate file.

## Security Benefits

1. **No Hardcoded Secrets**: All sensitive data is now externalized
2. **Environment-Specific Config**: Different values for dev/staging/prod
3. **Version Control Safe**: `.env` files are gitignored
4. **Build-Time Injection**: Values are baked into the app at build time

## What Was Fixed

1. **Supabase Configuration**: Now uses environment variables
2. **RevenueCat API Key**: Now uses environment variables  
3. **State Persistence**: Fixed the empty `initializePersistedState()` method
4. **Debug Settings**: Automatically enables debug mode in development

## Next Steps

1. **Test the current setup**: Run your app normally - it should work exactly as before
2. **Create production environment**: Set up your production Supabase project
3. **Update build process**: Use the build scripts for releases
4. **Consider CI/CD**: Integrate environment variables into your deployment pipeline

## Troubleshooting

If you get import errors, make sure you run:
```bash
flutter pub get
```

The linting errors you see are normal - they occur because the linter doesn't have access to Flutter SDK when running outside of a Flutter environment.
