# 7-Day Free Trial System - Quick Start

## What's Been Built

✅ Complete database migration with trial tracking
✅ Trial banner UI component
✅ Grace period (1 extra day after trial ends)
✅ Offer code system
✅ RevenueCat integration support
✅ n8n email workflow documentation
✅ Full implementation guide

## Files Created

1. **[supabase/migrations/015_add_trial_subscription_system.sql](supabase/migrations/015_add_trial_subscription_system.sql)**
   - Database schema for trial tracking
   - 7 database functions for trial management
   - Automatic trial initialization on signup

2. **[lib/components/trial_banner_widget.dart](lib/components/trial_banner_widget.dart)**
   - Color-coded countdown banner
   - Dismissible (resets daily)
   - Subscribe button

3. **[TRIAL_SYSTEM_IMPLEMENTATION.md](TRIAL_SYSTEM_IMPLEMENTATION.md)**
   - Complete step-by-step implementation guide
   - Code examples for Flutter integration
   - RevenueCat webhook setup
   - Testing procedures

4. **[N8N_TRIAL_WORKFLOW.md](N8N_TRIAL_WORKFLOW.md)**
   - n8n workflow setup (like Rejoice)
   - All 4 email templates (Day 0, 2, 4, 6)
   - Database queries for each email day
   - Monitoring and troubleshooting

## Quick Start

### 1. Run Migration
```bash
supabase db push
```

### 2. Test Database Functions
```sql
-- Create a test user at day 2 of trial
UPDATE profiles
SET
    trial_started_at = NOW() - INTERVAL '2 days',
    trial_ends_at = NOW() + INTERVAL '5 days',
    trial_status = 'active'
WHERE email = 'your-test-email@example.com';

-- Check trial status
SELECT * FROM check_and_update_trial_status('your-user-id');
```

### 3. Integrate Banner in Home Page
Follow Step 2 in [TRIAL_SYSTEM_IMPLEMENTATION.md](TRIAL_SYSTEM_IMPLEMENTATION.md)

### 4. Set Up n8n Workflow
Follow [N8N_TRIAL_WORKFLOW.md](N8N_TRIAL_WORKFLOW.md)

### 5. Configure RevenueCat
- Set up webhook handler
- Map RevenueCat customer IDs to Supabase user IDs
- Call `convert_trial_to_subscription()` on purchase

## Key Features

### Trial Flow
1. **Day 0:** User signs up → Trial auto-initialized (7 days + 1 grace day)
2. **Day 0:** Welcome email sent via n8n
3. **Day 2:** First reminder (5 days left)
4. **Day 4:** Second reminder (3 days left)
5. **Day 6:** Final warning (1 day left + grace day)
6. **Day 7:** Trial ends, grace period begins
7. **Day 8:** Grace period ends → Status changes to 'expired'

### Grace Period
- Trial ends on Day 7 but users get Day 8 as grace period
- Banner shows countdown including grace day
- Database function automatically expires after grace period
- Gives users extra time to subscribe

### Offer Codes
```dart
// Apply offer code to extend trial
final result = await SupaFlow.client.rpc(
  'apply_offer_code',
  params: {
    'user_uuid': currentUserUid,
    'code': 'SPROUT2024',
    'extra_days': 14, // Extend by 2 weeks
  }
);
```

### RevenueCat Integration
```dart
// Convert trial after successful purchase
await SupaFlow.client.rpc(
  'convert_trial_to_subscription',
  params: {
    'user_uuid': currentUserUid,
    'duration_days': 365,
    'platform': 'ios', // or 'android'
    'rc_customer_id': customerInfo.originalAppUserId,
  }
);
```

## Database Functions Reference

| Function | Purpose | Called By |
|----------|---------|-----------|
| `initialize_user_trial()` | Auto-set trial dates on signup | Trigger (automatic) |
| `check_and_update_trial_status(uuid)` | Get trial status, auto-expire | App (home page load) |
| `dismiss_trial_banner(uuid)` | Dismiss banner for today | App (dismiss button) |
| `convert_trial_to_subscription(...)` | Convert trial to paid | App/Webhook (after payment) |
| `apply_offer_code(uuid, code, days)` | Redeem promotional code | App (offer code UI) |
| `get_users_for_trial_emails(day)` | Get users needing emails | n8n (daily cron) |
| `mark_trial_email_sent(uuid, day)` | Mark email sent | n8n (after send) |

## Trial Status Values

| Status | Meaning |
|--------|---------|
| `none` | No trial (should never happen with new signups) |
| `active` | Currently in trial period |
| `converted` | Subscribed (paid user) |
| `expired` | Trial ended, no subscription |

## Next Steps

- [ ] Run database migration
- [ ] Add trial banner to home page
- [ ] Create subscription/paywall page
- [ ] Set up RevenueCat
- [ ] Configure n8n workflow
- [ ] Set up email service (Resend/SendGrid)
- [ ] Customize email templates
- [ ] Test with test users
- [ ] Clean database before launch
- [ ] Monitor conversion metrics

## Questions to Decide

1. **Subscription pricing?** (Monthly/Annual amounts)
2. **What features are blocked after trial expires?** (All or partial)
3. **Email sender domain?** (e.g., noreply@sproutify.com)
4. **Offer code campaigns?** (Launch codes, influencer codes, etc.)
5. **Analytics tracking?** (Which events to log)

## Support

- Issues? Check [TRIAL_SYSTEM_IMPLEMENTATION.md](TRIAL_SYSTEM_IMPLEMENTATION.md) troubleshooting section
- n8n problems? See [N8N_TRIAL_WORKFLOW.md](N8N_TRIAL_WORKFLOW.md) debugging guide
- Database questions? Review the migration comments and function documentation

---

**System is ready to launch!** Just run the migration, integrate the UI, and set up n8n.
