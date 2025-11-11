@echo off
REM Build script for Flutter app with environment variables
REM Usage: build.bat [dev|prod]

set ENVIRONMENT=%1
if "%ENVIRONMENT%"=="" set ENVIRONMENT=dev

if "%ENVIRONMENT%"=="prod" (
    echo Building for PRODUCTION...
    echo NOTE: Update REVENUE_CAT_IOS_API_KEY and REVENUE_CAT_ANDROID_API_KEY with your actual keys
    flutter build apk --release ^
        --dart-define=SUPABASE_URL=https://xzckfyipgrgpwnydddev.supabase.co ^
        --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo ^
        --dart-define=REVENUE_CAT_IOS_API_KEY=appl_szgNwIyKqHcKLtwDsoMEvuwPtOi ^
        --dart-define=REVENUE_CAT_ANDROID_API_KEY=your_android_key_here ^
        --dart-define=N8N_WEBHOOK_URL=https://n8n.sproutify.app/webhook/a9aae518-ec85-4b0d-b2cb-5e6f64c5783d
) else (
    echo Building for DEVELOPMENT...
    echo NOTE: Update REVENUE_CAT_IOS_API_KEY and REVENUE_CAT_ANDROID_API_KEY with your actual keys
    flutter run ^
        --dart-define=SUPABASE_URL=https://xzckfyipgrgpwnydddev.supabase.co ^
        --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh6Y2tmeWlwZ3JncHdueWRkZGV2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTgwODc2NTMsImV4cCI6MjAxMzY2MzY1M30._EnLLfn0DqX5uC94ZegKtfvz4uZW2bzWQidjqaYUsOo ^
        --dart-define=REVENUE_CAT_IOS_API_KEY=appl_szgNwIyKqHcKLtwDsoMEvuwPtOi ^
        --dart-define=REVENUE_CAT_ANDROID_API_KEY=your_android_key_here ^
        --dart-define=N8N_WEBHOOK_URL=https://n8n.sproutify.app/webhook/a9aae518-ec85-4b0d-b2cb-5e6f64c5783d
)
