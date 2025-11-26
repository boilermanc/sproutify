# Email Setup - Quick Summary

## What Was Done

✅ **Created comprehensive setup guide** (`EMAIL_SETUP_GUIDE.md`)
✅ **Removed hardcoded API key** from `api_calls.dart`
✅ **Added Resend configuration** to `lib/config/env.dart`
✅ **Updated `env.template`** with email configuration variables

## What You Need to Do

### 1. Get Resend API Key (5 minutes)

1. Sign up at https://resend.com
2. Go to **API Keys** → **Create API Key**
3. Copy the key (starts with `re_`)

### 2. Configure Your App

**Option A: For Development (Quick Start)**
- Use Resend's test domain (works immediately):
  - No domain verification needed
  - From: `onboarding@resend.dev`
  - Just add your API key to `.env` file

**Option B: For Production (Recommended)**
- Verify your domain in Resend dashboard
- Add DNS records (SPF, DKIM)
- Use: `noreply@sproutify.com` or your verified domain

### 3. Update Environment Variables

Create or update your `.env` file:

```env
RESEND_API_KEY=re_your_actual_api_key_here
RESEND_FROM_EMAIL=noreply@sproutify.com
```

### 4. Build Your App

The app will now use the API key from environment variables instead of the hardcoded one.

**For development:**
```bash
flutter run --dart-define=RESEND_API_KEY=re_your_key_here
```

**For production builds:**
Update `build.sh` and `build.bat` to include:
```bash
--dart-define=RESEND_API_KEY="${RESEND_API_KEY}"
--dart-define=RESEND_FROM_EMAIL="${RESEND_FROM_EMAIL}"
```

### 5. Set Up n8n for Trial Emails (Optional)

If using n8n for automated trial reminder emails:

1. In n8n, add Resend credentials
2. Use API key: `re_your_key_here`
3. Configure email nodes as described in `N8N_TRIAL_WORKFLOW.md`

## Files Changed

- ✅ `lib/config/env.dart` - Added `resendApiKey` and `resendFromEmail`
- ✅ `lib/backend/api_requests/api_calls.dart` - Now uses `Env.resendApiKey` instead of hardcoded key
- ✅ `env.template` - Added email configuration section
- ✅ `EMAIL_SETUP_GUIDE.md` - Complete setup guide created

## Security Note

⚠️ **The old hardcoded API key has been removed.** You must now provide your own API key via environment variables.

## Next Steps

1. Get Resend API key
2. Add to `.env` file
3. Test email sending (try password reset flow)
4. Set up domain verification (for production)
5. Configure n8n workflow (if using automated emails)

## Need Help?

See `EMAIL_SETUP_GUIDE.md` for detailed instructions, troubleshooting, and best practices.

