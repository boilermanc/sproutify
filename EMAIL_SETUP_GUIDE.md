# Email Sending Setup Guide

This guide covers everything you need to set up email sending for Sproutify, including trial reminder emails and password reset emails.

## Overview

Sproutify uses **Resend** as the email service provider. You'll need to:
1. Create a Resend account and get an API key
2. Verify your sending domain
3. Configure the API key in your app
4. Set up n8n workflow for automated trial emails (optional)

## Step 1: Create Resend Account

1. Go to https://resend.com and sign up for a free account
2. The free tier includes:
   - 3,000 emails/month
   - 100 emails/day
   - API access
   - Domain verification

## Step 2: Get Your API Key

1. After signing up, go to **API Keys** in your Resend dashboard
2. Click **Create API Key**
3. Give it a name (e.g., "Sproutify Production")
4. Copy the API key (starts with `re_`)
   - ⚠️ **Important**: You can only see the full key once! Copy it immediately.

## Step 3: Verify Your Domain

To send emails from `noreply@sproutify.com` (or your domain), you need to verify domain ownership:

1. In Resend dashboard, go to **Domains**
2. Click **Add Domain**
3. Enter your domain (e.g., `sproutify.com` or `sproutify.app`)
4. Resend will provide DNS records to add:
   - **SPF record** - Authorizes Resend to send emails
   - **DKIM record** - Signs emails for authentication
   - **DMARC record** (optional) - Email security policy

5. Add these records to your domain's DNS settings:
   - If using a domain registrar (GoDaddy, Namecheap, etc.), add them in DNS management
   - If using a hosting provider, add them in their DNS panel
   - Wait for DNS propagation (usually 5-60 minutes)

6. Resend will verify automatically once DNS records are detected

### Using Resend's Test Domain (Development Only)

For testing, you can use Resend's test domain:
- From: `onboarding@resend.dev`
- This works immediately without domain verification
- ⚠️ **Note**: Emails sent from `resend.dev` may go to spam

## Step 4: Configure API Key in Your App

### Option A: Using Environment Variables (Recommended)

1. **Add to `env.template`:**
   ```env
   # Email Configuration (Resend)
   RESEND_API_KEY=re_your_api_key_here
   RESEND_FROM_EMAIL=noreply@sproutify.com
   ```

2. **Update `lib/config/env.dart`:**
   ```dart
   // Email Configuration
   static const String resendApiKey = String.fromEnvironment(
     'RESEND_API_KEY',
     defaultValue: '',
   );
   
   static const String resendFromEmail = String.fromEnvironment(
     'RESEND_FROM_EMAIL',
     defaultValue: 'onboarding@resend.dev', // Test domain for development
   );
   ```

3. **Update `lib/backend/api_requests/api_calls.dart`:**
   Replace the hardcoded API key with:
   ```dart
   'Authorization': 'Bearer ${Env.resendApiKey}',
   ```

4. **Update your `.env` file** (create from `env.template` if needed):
   ```env
   RESEND_API_KEY=re_your_actual_api_key_here
   RESEND_FROM_EMAIL=noreply@sproutify.com
   ```

5. **Update build scripts** (`build.sh` and `build.bat`) to include the new environment variable:
   ```bash
   # In build.sh, add:
   --dart-define=RESEND_API_KEY="${RESEND_API_KEY}"
   --dart-define=RESEND_FROM_EMAIL="${RESEND_FROM_EMAIL}"
   ```

### Option B: Using Dart Defines (For Production Builds)

When building your app, pass the API key as a dart-define flag:

```bash
flutter build apk --release \
  --dart-define=RESEND_API_KEY=re_your_api_key_here \
  --dart-define=RESEND_FROM_EMAIL=noreply@sproutify.com
```

## Step 5: Set Up n8n Workflow for Trial Emails

If you're using n8n for automated trial reminder emails (recommended):

1. **In n8n, add Resend credentials:**
   - Go to **Credentials** → **Add Credential**
   - Search for "Resend"
   - Enter your API key: `re_your_api_key_here`
   - Save as "Resend - Sproutify"

2. **Configure the email node in your workflow:**
   - Use the credential you just created
   - From: `Sproutify <noreply@sproutify.com>`
   - To: `{{ $json.email }}`
   - Subject and HTML as defined in `N8N_TRIAL_WORKFLOW.md`

3. **Test the workflow:**
   - Create a test user in Supabase
   - Manually trigger the workflow
   - Verify email is received

## Step 6: Alternative - Supabase Edge Function

If you prefer to use Supabase Edge Functions instead of n8n:

1. **Create the function:**
   ```bash
   supabase functions new send-trial-emails
   ```

2. **Add Resend API key to Supabase secrets:**
   ```bash
   supabase secrets set RESEND_API_KEY=re_your_api_key_here
   ```

3. **Implement the function** (see `TRIAL_SYSTEM_IMPLEMENTATION.md` for example code)

4. **Set up cron job** in Supabase to trigger daily

## Step 7: Test Email Sending

### Test from Flutter App

1. Use the password reset flow to test email sending
2. Check that emails are received
3. Verify sender address is correct

### Test from n8n

1. Create a test workflow with a single email node
2. Send a test email to yourself
3. Verify it arrives and doesn't go to spam

## Security Best Practices

1. **Never commit API keys to git**
   - ✅ Use `.env` files (already in `.gitignore`)
   - ✅ Use environment variables in CI/CD
   - ❌ Never hardcode in source files

2. **Rotate keys regularly**
   - Generate new keys every 3-6 months
   - Update in all environments (dev, staging, prod)

3. **Use different keys per environment**
   - Development: Test domain (`resend.dev`)
   - Production: Verified domain (`sproutify.com`)

4. **Monitor usage**
   - Check Resend dashboard for email volume
   - Set up alerts for unusual activity

## Troubleshooting

### Emails Not Sending

1. **Check API key:**
   - Verify key is correct in Resend dashboard
   - Ensure key hasn't been revoked

2. **Check domain verification:**
   - Go to Resend dashboard → Domains
   - Verify domain shows as "Verified"
   - Check DNS records are correct

3. **Check spam folder:**
   - Test emails may go to spam initially
   - Add `noreply@sproutify.com` to contacts

4. **Check API limits:**
   - Free tier: 100 emails/day
   - Upgrade if you need more

### Emails Going to Spam

1. **Verify domain properly:**
   - Ensure SPF, DKIM, and DMARC records are set
   - Wait for DNS propagation (up to 48 hours)

2. **Use proper from address:**
   - Use verified domain: `noreply@sproutify.com`
   - Avoid test domains in production

3. **Warm up your domain:**
   - Start with low volume
   - Gradually increase over time
   - Maintain good engagement rates

### API Errors

- **401 Unauthorized**: API key is invalid or expired
- **403 Forbidden**: Domain not verified or rate limit exceeded
- **422 Unprocessable**: Invalid email address or missing required fields

## Email Templates

Email templates for trial reminders are documented in:
- `N8N_TRIAL_WORKFLOW.md` - Complete templates for Day 0, 2, 4, 6

## Next Steps

1. ✅ Set up Resend account
2. ✅ Get API key
3. ✅ Verify domain (or use test domain for now)
4. ✅ Configure API key in app
5. ✅ Test email sending
6. ✅ Set up n8n workflow (if using)
7. ✅ Monitor email delivery rates

## Resources

- [Resend Documentation](https://resend.com/docs)
- [Resend API Reference](https://resend.com/docs/api-reference)
- [Domain Verification Guide](https://resend.com/docs/dashboard/domains/introduction)
- [n8n Resend Integration](https://docs.n8n.io/integrations/builtin/credentials/resend/)

---

**Last Updated:** 2025-01-27
**Status:** Ready for implementation


