# 7-Day Free Trial System Implementation Guide

## Overview
This document outlines the complete implementation of the 7-day free trial system for Sproutify, including database schema, UI components, and email automation requirements.

## Database Changes

### Migration: 015_add_trial_subscription_system.sql
Location: `supabase/migrations/015_add_trial_subscription_system.sql`

**New columns added to `profiles` table:**
- `trial_started_at` (TIMESTAMPTZ) - When the trial began (default: NOW())
- `trial_ends_at` (TIMESTAMPTZ) - When the trial expires (default: NOW() + 7 days)
- `trial_status` (TEXT) - Status: 'none', 'active', 'converted', or 'expired' (default: 'active')
- `trial_converted_at` (TIMESTAMPTZ) - When trial was converted to paid subscription
- `subscription_start_date` (TIMESTAMPTZ) - When paid subscription started
- `subscription_end_date` (TIMESTAMPTZ) - When paid subscription ends
- `trial_banner_dismissed_at` (TIMESTAMPTZ) - Last time banner was dismissed (resets daily)
- `first_login_email_sent` (BOOLEAN) - Whether welcome email sent (default: false)
- `day2_email_sent` (BOOLEAN) - Whether day 2 reminder email sent (default: false)
- `day4_email_sent` (BOOLEAN) - Whether day 4 reminder email sent (default: false)
- `day6_email_sent` (BOOLEAN) - Whether day 6 reminder email sent (default: false)
- `offer_code` (TEXT) - Promotional offer code used to extend trial
- `revenue_cat_customer_id` (TEXT) - RevenueCat customer ID for subscription management
- `subscription_platform` (TEXT) - Platform: 'ios', 'android', or 'web'

**Database Functions:**

1. **initialize_user_trial()** - Trigger function
   - Automatically sets trial dates when new user profile is created
   - Sets trial_started_at to NOW()
   - Sets trial_ends_at to NOW() + 7 days
   - Sets trial_status to 'active'

2. **check_and_update_trial_status(user_uuid UUID)** - Returns trial status
   - Returns: status, days_remaining, trial_end_date, is_banner_dismissed
   - Automatically updates status to 'expired' if trial period has ended
   - Banner dismissed status resets daily
   - Call this from your app on home page load

3. **dismiss_trial_banner(user_uuid UUID)** - Dismisses banner for current day
   - Updates trial_banner_dismissed_at to NOW()
   - Banner will show again tomorrow

4. **convert_trial_to_subscription(user_uuid UUID, duration_days INTEGER)** - Converts trial to paid subscription
   - Sets trial_status to 'converted'
   - Sets trial_converted_at, subscription_start_date and subscription_end_date
   - Call this after successful payment

5. **get_users_for_trial_emails(day_number INTEGER)** - Get users needing emails
   - Returns users who need reminder emails for specific day (0, 2, 4, or 6)
   - Includes user_id, email, days_remaining, first_name, last_name
   - Used by email automation system (n8n or Edge Function)
   - Security definer function (can be called by service role)

6. **mark_trial_email_sent(user_uuid UUID, day_number INTEGER)** - Mark email as sent
   - Updates the appropriate email sent flag
   - Prevents duplicate emails

7. **apply_offer_code(user_uuid UUID, code TEXT, extra_days INTEGER)** - Apply promotional offer code
   - Extends trial period by specified number of days
   - Only works for users with 'active' trial status
   - Returns success status and new trial end date
   - Stores offer code in user profile

### Important Notes

**Grace Period:** The trial includes a 1-day grace period. Users can still access the app for 1 full day after `trial_ends_at`. This means:
- Trial starts: Day 0
- Trial ends at: Day 7
- Grace period ends: Day 8 (at end of day)
- Banner shows "1 day left" during the grace period

**RevenueCat Integration:** The `convert_trial_to_subscription()` function accepts optional `platform` and `rc_customer_id` parameters for RevenueCat integration. Call this from your RevenueCat webhook handler when a purchase is confirmed.

## UI Components

### Trial Banner Widget
Location: `lib/components/trial_banner_widget.dart`

**Features:**
- Color-coded based on days remaining:
  - Blue: 7-5 days remaining
  - Orange: 4-3 days remaining
  - Red: 2-0 days remaining
- Shows countdown message
- "Subscribe" button to navigate to paywall
- Dismiss button (shows again next day)
- Responsive design

**Usage:**

```dart
import '/components/trial_banner_widget.dart';

// In your widget build method:
TrialBannerWidget(
  daysRemaining: 5,
  onDismiss: () async {
    // Call dismiss_trial_banner function
    await SupaFlow.client.rpc('dismiss_trial_banner',
      params: {'user_uuid': currentUserUid}
    );
    setState(() {});
  },
  onSubscribe: () {
    // Navigate to paywall/subscription page
    context.pushNamed('SubscriptionPage');
  },
)
```

## Implementation Steps

### Step 1: Run Database Migration

```bash
supabase db push
```

This will apply the migration and create all necessary columns and functions.

### Step 2: Integrate Trial Banner in Home Page

Add to [home_page_widget.dart](lib/pages/home_page/home_page_widget.dart):

**1. Add import at top:**

```dart
import '/components/trial_banner_widget.dart';
```

**2. Add trial status variables to model** ([home_page_model.dart](lib/pages/home_page/home_page_model.dart)):

```dart
class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  // ... existing fields ...

  // Trial status fields
  String? trialStatus;
  int? trialDaysRemaining;
  bool? isTrialBannerDismissed;

  // ... rest of model ...
}
```

**3. Load trial status in initState** (in home_page_widget.dart):

```dart
// In the SchedulerBinding.instance.addPostFrameCallback
Future(() async {
  final trialData = await SupaFlow.client.rpc(
    'check_and_update_trial_status',
    params: {'user_uuid': currentUserUid},
  );

  if (trialData != null && trialData.isNotEmpty) {
    final data = trialData.first;
    _model.trialStatus = data['status'];
    _model.trialDaysRemaining = data['days_remaining'];
    _model.isTrialBannerDismissed = data['is_banner_dismissed'];
    safeSetState(() {});
  }
}),
```

**4. Add banner to Scaffold body** (just after body: SingleChildScrollView):

```dart
body: Column(
  children: [
    // Trial banner - only show if on trial and not dismissed
    if (_model.trialStatus == 'active' &&
        _model.isTrialBannerDismissed == false &&
        _model.trialDaysRemaining != null)
      TrialBannerWidget(
        daysRemaining: _model.trialDaysRemaining!,
        onDismiss: () async {
          await SupaFlow.client.rpc(
            'dismiss_trial_banner',
            params: {'user_uuid': currentUserUid},
          );
          _model.isTrialBannerDismissed = true;
          safeSetState(() {});
        },
        onSubscribe: () {
          context.pushNamed('SubscriptionPage'); // Create this page
        },
      ),

    // Existing SingleChildScrollView content
    Expanded(
      child: SingleChildScrollView(
        // ... existing content ...
      ),
    ),
  ],
),
```

### Step 3: Create Subscription/Paywall Page

Create a new page for subscription handling:
- Display subscription plans
- Integrate with payment provider (Stripe, RevenueCat, etc.)
- On successful payment, call: `activate_subscription(user_uuid, 365)`

### Step 4: Handle Trial Expiration

Add a check to block expired users from key features:

```dart
// Before allowing access to premium features:
if (_model.trialStatus == 'expired') {
  context.pushNamed('SubscriptionPage');
  return;
}
```

**Note:** After successful payment in your subscription page, call:

```dart
await SupaFlow.client.rpc(
  'convert_trial_to_subscription',
  params: {
    'user_uuid': currentUserUid,
    'duration_days': 365, // or 30 for monthly
    'platform': 'ios', // or 'android' or 'web'
    'rc_customer_id': revenueCatCustomerId, // from RevenueCat
  }
);
```

### Step 5: Offer Code Redemption (Optional)

To allow users to redeem promotional offer codes:

```dart
// In your offer code redemption UI
final result = await SupaFlow.client.rpc(
  'apply_offer_code',
  params: {
    'user_uuid': currentUserUid,
    'code': offerCodeController.text.toUpperCase(),
    'extra_days': 7, // Extend trial by 7 days
  }
);

if (result != null && result.isNotEmpty) {
  final success = result.first['success'];
  final message = result.first['message'];

  if (success) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    // Refresh trial status
    setState(() {});
  } else {
    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
```

### Step 6: RevenueCat Webhook Integration

When RevenueCat sends a purchase webhook, handle it in your backend:

**Example webhook handler (Supabase Edge Function):**

```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const event = await req.json()

  if (event.type === 'INITIAL_PURCHASE' || event.type === 'RENEWAL') {
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    const { data: profile } = await supabase
      .from('profiles')
      .select('id')
      .eq('revenue_cat_customer_id', event.app_user_id)
      .single()

    if (profile) {
      await supabase.rpc('convert_trial_to_subscription', {
        user_uuid: profile.id,
        duration_days: event.product_duration === 'P1M' ? 30 : 365,
        platform: event.store === 'app_store' ? 'ios' : 'android',
        rc_customer_id: event.app_user_id
      })
    }
  }

  return new Response('OK', { status: 200 })
})
```

## Email Automation System

### Overview
Trial reminder emails are automated using n8n workflows (similar to your Rejoice app setup). The n8n workflow runs on a cron schedule and queries the Supabase database to send emails.

**See [N8N_TRIAL_WORKFLOW.md](N8N_TRIAL_WORKFLOW.md) for complete n8n setup instructions, email templates, and workflow configuration.**

### Email Schedule
1. **Day 0 (Sign up)** - Welcome email
   - Subject: "Welcome to Sproutify! Your 7-day trial has started"
   - Content: Introduction, key features, support info

2. **Day 2** - First reminder
   - Subject: "5 days left in your Sproutify trial"
   - Content: Highlight features they may have missed

3. **Day 4** - Second reminder
   - Subject: "3 days left - Make the most of your Sproutify trial"
   - Content: Tips for getting more value

4. **Day 6** - Final reminder
   - Subject: "Your trial expires tomorrow!"
   - Content: Call to action to subscribe, pricing info

### Implementation Options

#### Option 1: Supabase Edge Function with Cron (Recommended)

Create a Supabase Edge Function that runs daily:

**supabase/functions/send-trial-emails/index.ts:**
```typescript
import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

serve(async (req) => {
  const supabaseAdmin = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  // Check each email day
  for (const day of [0, 2, 4, 6]) {
    const { data: users } = await supabaseAdmin.rpc('get_users_for_trial_emails', {
      day_number: day
    })

    for (const user of users || []) {
      // Send email using your email service (Resend, SendGrid, etc.)
      await sendTrialEmail(user.email, day, user.days_remaining)

      // Mark email as sent
      await supabaseAdmin.rpc('mark_trial_email_sent', {
        user_uuid: user.user_id,
        day_number: day
      })
    }
  }

  return new Response('Emails sent', { status: 200 })
})
```

**Schedule with Supabase Cron:**
```sql
-- In Supabase SQL Editor, create a cron job to run daily at 9 AM
SELECT cron.schedule(
  'send-trial-emails',
  '0 9 * * *', -- Every day at 9 AM
  $$
  SELECT net.http_post(
    url := 'https://your-project.supabase.co/functions/v1/send-trial-emails',
    headers := '{"Authorization": "Bearer YOUR_ANON_KEY"}'::jsonb
  );
  $$
);
```

#### Option 2: External Cron Service (Alternative)

Use a service like:
- **Render Cron Jobs**
- **Vercel Cron**
- **GitHub Actions** with schedule

Create an API endpoint that:
1. Calls `get_users_for_trial_emails(day_number)` for each day
2. Sends emails via your email service
3. Calls `mark_trial_email_sent(user_uuid, day_number)` after each email

### Email Service Integration

Recommended email services:
- **Resend** (developer-friendly, good pricing)
- **SendGrid** (established, good deliverability)
- **Postmark** (transactional emails)
- **Amazon SES** (cheapest for high volume)

**Example with Resend:**
```typescript
import { Resend } from 'resend';

const resend = new Resend(Deno.env.get('RESEND_API_KEY'));

async function sendTrialEmail(email: string, day: number, daysRemaining: number) {
  const templates = {
    0: {
      subject: 'Welcome to Sproutify! Your 7-day trial has started',
      html: welcomeEmailTemplate()
    },
    2: {
      subject: `${daysRemaining} days left in your Sproutify trial`,
      html: reminderEmailTemplate(daysRemaining)
    },
    4: {
      subject: `${daysRemaining} days left - Make the most of your trial`,
      html: reminderEmailTemplate(daysRemaining)
    },
    6: {
      subject: 'Your trial expires tomorrow!',
      html: finalReminderEmailTemplate()
    }
  };

  await resend.emails.send({
    from: 'Sproutify <noreply@sproutify.com>',
    to: email,
    subject: templates[day].subject,
    html: templates[day].html
  });
}
```

## Testing the Trial System

### Manual Testing Steps

1. **Test new user signup:**
   ```sql
   -- Check that trial was initialized
   SELECT user_id, trial_start_date, trial_end_date, subscription_status
   FROM user_community_profiles
   WHERE user_id = 'YOUR_USER_ID';
   ```

2. **Test trial status check:**
   ```sql
   SELECT * FROM check_and_update_trial_status('YOUR_USER_ID');
   ```

3. **Test banner dismiss:**
   ```sql
   SELECT dismiss_trial_banner('YOUR_USER_ID');
   -- Check banner shows again tomorrow
   ```

4. **Test email query:**
   ```sql
   -- Get users who need day 2 emails
   SELECT * FROM get_users_for_trial_emails(2);
   ```

5. **Test subscription activation:**
   ```sql
   SELECT activate_subscription('YOUR_USER_ID', 365);
   -- Verify subscription_status changed to 'active'
   ```

### Simulate Trial Expiration

To test expired trial behavior:
```sql
-- Manually expire a trial
UPDATE user_community_profiles
SET trial_end_date = NOW() - INTERVAL '1 day'
WHERE user_id = 'YOUR_USER_ID';

-- Check that status gets updated to 'expired'
SELECT * FROM check_and_update_trial_status('YOUR_USER_ID');
```

## Missing Considerations Checklist

- [x] Database schema for trial tracking
- [x] Automatic trial initialization on signup
- [x] Trial status checking function
- [x] Trial expiration handling
- [x] Banner dismissal (with daily reset)
- [x] Email tracking flags
- [x] Email automation functions
- [ ] **Subscription/Paywall page UI** - Needs to be created
- [ ] **Payment provider integration** (Stripe/RevenueCat)
- [ ] **Email service setup** (Resend/SendGrid)
- [ ] **Email templates** - Need to be designed
- [ ] **Edge function deployment** - For automated emails
- [ ] **Cron job setup** - For scheduled email sends
- [ ] **Analytics tracking** - Track conversion rates
- [ ] **Grace period handling** - Optional: Allow 1-2 day grace period
- [ ] **Refund policy** - Terms for cancellations
- [ ] **Receipt/invoice system** - For paid subscriptions
- [ ] **Subscription management page** - For users to cancel/renew
- [ ] **Admin dashboard** - To monitor trial conversions

## Next Steps

1. **Run the database migration:**
   ```bash
   supabase db push
   ```

2. **Integrate trial banner in home page** (follow Step 2 above)

3. **Create subscription/paywall page** with payment integration

4. **Set up email service** (Resend recommended)

5. **Deploy edge function** for automated trial emails

6. **Set up cron job** to trigger email function daily

7. **Create email templates** for each day

8. **Test thoroughly** before going live

## Additional Recommendations

### Analytics to Track
- Trial signup rate
- Trial-to-paid conversion rate
- Email open rates
- Email click-through rates
- Average days before conversion
- Churn rate after trial

### Future Enhancements
- **Multiple subscription tiers** (Basic, Pro, Premium)
- **Annual vs Monthly pricing** options
- **Team/Family plans**
- **Promo codes** for extended trials
- **Referral program** (give extra trial days)
- **Win-back campaigns** for expired trials who didn't convert

## Questions to Answer

1. **What happens after trial expires?**
   - Block all features? Or allow limited free tier?
   - Current implementation: Set status to 'expired'

2. **Subscription pricing?**
   - Monthly price?
   - Annual discount?
   - Multiple tiers?

3. **Payment provider?**
   - Stripe? (Most common, easy integration)
   - RevenueCat? (Good for mobile apps)
   - Apple/Google In-App Purchase? (Required for app store)

4. **Email sender domain?**
   - What email address to send from?
   - Domain verification needed

5. **Free tier after trial?**
   - Limited features available?
   - Or completely blocked?

## Support Resources

- [Supabase Edge Functions Docs](https://supabase.com/docs/guides/functions)
- [Supabase Cron Jobs](https://supabase.com/docs/guides/database/extensions/pg_cron)
- [Stripe Integration Guide](https://stripe.com/docs)
- [RevenueCat Flutter SDK](https://www.revenuecat.com/docs/getting-started/installation/flutter)
- [Resend Email API](https://resend.com/docs)

---

**Last Updated:** 2025-11-24
**Status:** Database migration complete, UI component ready, email automation pending
