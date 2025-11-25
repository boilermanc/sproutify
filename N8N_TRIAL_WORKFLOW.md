# n8n Workflow for Trial Email Automation

## Overview
This document describes the n8n workflow setup for sending automated trial reminder emails to Sproutify users. The workflow runs daily via cron schedule and queries the Supabase database to identify users who need emails.

## Workflow Configuration

### Trigger: Schedule (Cron)
- **Name:** Daily Trial Email Check
- **Schedule:** Every day at 9:00 AM (user's local timezone)
- **Cron Expression:** `0 9 * * *`
- **Note:** You may want to run this multiple times per day (e.g., 9 AM, 12 PM, 3 PM) to catch users in different timezones

### Step 1: Check Each Email Day

Create 4 parallel branches (one for each email day: 0, 2, 4, 6)

#### Branch 1: Welcome Email (Day 0)
**Supabase Node:**
- Operation: Execute SQL
- SQL Query:
```sql
SELECT * FROM get_users_for_trial_emails(0);
```

#### Branch 2: Day 2 Reminder
**Supabase Node:**
- Operation: Execute SQL
- SQL Query:
```sql
SELECT * FROM get_users_for_trial_emails(2);
```

#### Branch 3: Day 4 Reminder
**Supabase Node:**
- Operation: Execute SQL
- SQL Query:
```sql
SELECT * FROM get_users_for_trial_emails(4);
```

#### Branch 4: Day 6 Final Reminder
**Supabase Node:**
- Operation: Execute SQL
- SQL Query:
```sql
SELECT * FROM get_users_for_trial_emails(6);
```

### Step 2: Loop Through Users

For each branch, add a **Loop Over Items** node to process each user individually.

### Step 3: Send Email

**Email Service Node** (choose your provider):

#### Option A: SendGrid
- API Key: `{{ $credentials.sendgrid.apiKey }}`
- From Email: `noreply@sproutify.com`
- From Name: `Sproutify`
- To Email: `{{ $json.email }}`
- Subject: Use expressions based on day_number (see templates below)
- HTML Content: Use expressions based on day_number (see templates below)

#### Option B: Resend (Recommended)
- API Key: `{{ $credentials.resend.apiKey }}`
- From: `Sproutify <noreply@sproutify.com>`
- To: `{{ $json.email }}`
- Subject: Use expressions based on day_number
- HTML: Use expressions based on day_number

#### Option C: Mailgun, Postmark, Amazon SES
Similar configuration to above

### Step 4: Mark Email as Sent

**Supabase Node:**
- Operation: Execute SQL
- SQL Query:
```sql
SELECT mark_trial_email_sent('{{ $json.user_id }}'::uuid, {{ $node["Schedule Trigger"].json.day_number }});
```

**Note:** You'll need to set a static value for `day_number` in each branch (0, 2, 4, or 6).

### Step 5: Error Handling

Add an **Error Trigger** node to catch failed emails:
- Log error to monitoring system
- Optionally retry once
- Send alert to admin if email continues to fail

## Email Templates

### Day 0: Welcome Email

**Subject:**
```
Welcome to Sproutify, {{ $json.first_name }}! Your 7-day trial has started 🌱
```

**HTML Body:**
```html
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px 20px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #ffffff; padding: 30px; border: 1px solid #e0e0e0; }
        .button { display: inline-block; background: #667eea; color: white; padding: 12px 30px; text-decoration: none; border-radius: 6px; margin: 20px 0; }
        .footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🌱 Welcome to Sproutify!</h1>
        </div>
        <div class="content">
            <p>Hi {{ $json.first_name }},</p>

            <p>Welcome to Sproutify! Your 7-day free trial has just started. We're excited to help you grow the best hydroponic garden possible.</p>

            <p><strong>Here's what you can do with Sproutify:</strong></p>
            <ul>
                <li>📊 Track pH and EC levels for optimal plant growth</li>
                <li>🌿 Browse our plant catalog and add your favorites</li>
                <li>🗼 Manage multiple towers and track each one separately</li>
                <li>💰 Monitor costs and track your harvests</li>
                <li>🎯 Set growing goals and earn badges</li>
            </ul>

            <p>You have <strong>{{ $json.days_remaining }} days</strong> to explore all features. Make the most of your trial!</p>

            <a href="https://sproutify.app" class="button">Open Sproutify</a>

            <p>Need help getting started? Reply to this email anytime - we're here to help!</p>

            <p>Happy growing! 🌱</p>
            <p>The Sproutify Team</p>
        </div>
        <div class="footer">
            <p>Sproutify · Sweetwater Technologies</p>
            <p>You're receiving this because you started a free trial with Sproutify.</p>
        </div>
    </div>
</body>
</html>
```

### Day 2: First Reminder (5 Days Left)

**Subject:**
```
{{ $json.first_name }}, you have 5 days left in your Sproutify trial 🌱
```

**HTML Body:**
```html
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px 20px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #ffffff; padding: 30px; border: 1px solid #e0e0e0; }
        .button { display: inline-block; background: #667eea; color: white; padding: 12px 30px; text-decoration: none; border-radius: 6px; margin: 20px 0; }
        .tip-box { background: #f0f7ff; border-left: 4px solid #667eea; padding: 15px; margin: 20px 0; }
        .footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⏰ 5 Days Left in Your Trial</h1>
        </div>
        <div class="content">
            <p>Hi {{ $json.first_name }},</p>

            <p>You have <strong>{{ $json.days_remaining }} days remaining</strong> in your Sproutify trial!</p>

            <p><strong>Pro tips to get the most out of Sproutify:</strong></p>

            <div class="tip-box">
                <strong>💡 Tip #1: Set up pH/EC tracking</strong><br>
                Regular monitoring is key to healthy plants. Log your readings daily to see trends over time.
            </div>

            <div class="tip-box">
                <strong>💡 Tip #2: Add your plants</strong><br>
                Browse our plant catalog and add what you're growing. Track growth stages and harvest dates.
            </div>

            <div class="tip-box">
                <strong>💡 Tip #3: Track costs</strong><br>
                See if your garden is saving you money! Add seed costs, nutrients, and electricity to get the full picture.
            </div>

            <a href="https://sproutify.app" class="button">Continue Exploring</a>

            <p>Questions? Just reply to this email!</p>

            <p>Happy growing! 🌱</p>
            <p>The Sproutify Team</p>
        </div>
        <div class="footer">
            <p>Sproutify · Sweetwater Technologies</p>
        </div>
    </div>
</body>
</html>
```

### Day 4: Second Reminder (3 Days Left)

**Subject:**
```
Only 3 days left, {{ $json.first_name }}! Don't miss out on Sproutify Premium 🌿
```

**HTML Body:**
```html
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; padding: 30px 20px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #ffffff; padding: 30px; border: 1px solid #e0e0e0; }
        .button { display: inline-block; background: #f5576c; color: white; padding: 12px 30px; text-decoration: none; border-radius: 6px; margin: 20px 0; }
        .pricing { background: #f9f9f9; padding: 20px; border-radius: 8px; margin: 20px 0; text-align: center; }
        .footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⏰ 3 Days Remaining</h1>
        </div>
        <div class="content">
            <p>Hi {{ $json.first_name }},</p>

            <p>Your trial is winding down - only <strong>{{ $json.days_remaining }} days left</strong> to explore Sproutify!</p>

            <p>We hope you've enjoyed tracking your hydroponic garden. Here's what you'll keep with a subscription:</p>

            <ul>
                <li>✅ Unlimited pH/EC tracking</li>
                <li>✅ Unlimited plants and towers</li>
                <li>✅ Harvest tracking and analytics</li>
                <li>✅ Cost analysis and ROI reports</li>
                <li>✅ Growing goals and badge achievements</li>
                <li>✅ Priority support</li>
            </ul>

            <div class="pricing">
                <h3>Subscribe Today</h3>
                <p style="font-size: 32px; margin: 10px 0;"><strong>$X.XX/month</strong></p>
                <p style="color: #666;">or save 20% with annual billing</p>
            </div>

            <a href="https://sproutify.app/subscribe" class="button">Subscribe Now</a>

            <p>Have questions? Reply to this email anytime!</p>

            <p>Happy growing! 🌱</p>
            <p>The Sproutify Team</p>
        </div>
        <div class="footer">
            <p>Sproutify · Sweetwater Technologies</p>
        </div>
    </div>
</body>
</html>
```

### Day 6: Final Reminder (1 Day Left)

**Subject:**
```
⚠️ Last chance, {{ $json.first_name }}! Your trial expires tomorrow
```

**HTML Body:**
```html
<!DOCTYPE html>
<html>
<head>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; line-height: 1.6; color: #333; }
        .container { max-width: 600px; margin: 0 auto; padding: 20px; }
        .header { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); color: white; padding: 30px 20px; text-align: center; border-radius: 10px 10px 0 0; }
        .content { background: #ffffff; padding: 30px; border: 1px solid #e0e0e0; }
        .button { display: inline-block; background: #fa709a; color: white; padding: 15px 40px; text-decoration: none; border-radius: 6px; margin: 20px 0; font-size: 18px; font-weight: bold; }
        .urgent-box { background: #fff3cd; border: 2px solid #ffc107; padding: 20px; border-radius: 8px; margin: 20px 0; text-align: center; }
        .footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>⚠️ Your Trial Expires Tomorrow!</h1>
        </div>
        <div class="content">
            <p>Hi {{ $json.first_name }},</p>

            <div class="urgent-box">
                <h2 style="margin-top: 0;">⏰ Final Reminder</h2>
                <p style="font-size: 18px;">Your Sproutify trial ends <strong>tomorrow</strong>!</p>
            </div>

            <p>Don't lose access to all your tracking data, plant records, and growing insights.</p>

            <p><strong>Subscribe today to keep:</strong></p>
            <ul>
                <li>📊 All your pH/EC history and trends</li>
                <li>🌿 Your complete plant catalog and records</li>
                <li>🗼 Tower management and tracking</li>
                <li>💰 Cost analysis and harvest reports</li>
                <li>🎯 Growing goals and achievements</li>
            </ul>

            <p style="text-align: center;">
                <a href="https://sproutify.app/subscribe" class="button">Subscribe Now & Save Your Data</a>
            </p>

            <p><strong>Still have questions?</strong> Reply to this email and we'll help you decide if Sproutify is right for you.</p>

            <p>We'd love to have you continue growing with us! 🌱</p>

            <p>Best regards,<br>The Sproutify Team</p>
        </div>
        <div class="footer">
            <p>Sproutify · Sweetwater Technologies</p>
            <p>Your trial expires on {{ $json.trial_end_date }}. Subscribe to continue using Sproutify.</p>
        </div>
    </div>
</body>
</html>
```

## n8n Workflow JSON Structure

Here's a simplified structure of how the workflow should be organized:

```
Cron Trigger (Daily 9 AM)
    |
    ├── Branch 1: Day 0 Emails
    │   ├── Get users (day 0)
    │   ├── Loop through users
    │   ├── Send welcome email
    │   └── Mark email sent (day 0)
    |
    ├── Branch 2: Day 2 Emails
    │   ├── Get users (day 2)
    │   ├── Loop through users
    │   ├── Send reminder email
    │   └── Mark email sent (day 2)
    |
    ├── Branch 3: Day 4 Emails
    │   ├── Get users (day 4)
    │   ├── Loop through users
    │   ├── Send reminder email
    │   └── Mark email sent (day 4)
    |
    └── Branch 4: Day 6 Emails
        ├── Get users (day 6)
        ├── Loop through users
        ├── Send final reminder
        └── Mark email sent (day 6)
```

## Supabase Connection Setup

In n8n, create a Supabase credential:
- **Host:** `https://your-project.supabase.co`
- **Service Role Key:** Your Supabase service role key (not anon key!)
- **Note:** Service role key is required to call `SECURITY DEFINER` functions

## Testing the Workflow

### Test Queries

To test each email query independently in Supabase SQL Editor:

```sql
-- Test Day 0 (new signups today)
SELECT * FROM get_users_for_trial_emails(0);

-- Test Day 2 (signups from 2 days ago)
SELECT * FROM get_users_for_trial_emails(2);

-- Test Day 4 (signups from 4 days ago)
SELECT * FROM get_users_for_trial_emails(4);

-- Test Day 6 (signups from 6 days ago)
SELECT * FROM get_users_for_trial_emails(6);
```

### Create Test User

To create a test user at various trial stages:

```sql
-- Create a test user at Day 2
UPDATE profiles
SET
    trial_started_at = NOW() - INTERVAL '2 days',
    trial_ends_at = NOW() + INTERVAL '5 days',
    trial_status = 'active',
    day2_email_sent = false
WHERE email = 'test@example.com';

-- Run the workflow and verify email is sent
```

## Monitoring and Analytics

### Track Email Performance

Add these metrics to your n8n workflow:
1. **Email sent count** - Log successful sends
2. **Email failed count** - Track failures
3. **Conversion tracking** - Monitor who subscribes after which email

### Recommended Logging

After each email send, log to a `trial_email_log` table (optional):
```sql
CREATE TABLE trial_email_log (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES profiles(id),
    email_type TEXT, -- 'welcome', 'day2', 'day4', 'day6'
    sent_at TIMESTAMPTZ DEFAULT NOW(),
    email_provider TEXT,
    status TEXT, -- 'sent', 'failed', 'bounced'
    error_message TEXT
);
```

## Troubleshooting

### Common Issues

**Emails not sending:**
- Check Supabase service role key is correct
- Verify email provider credentials
- Check that users exist in query results

**Duplicate emails:**
- Verify `mark_trial_email_sent()` is being called
- Check email sent flags are being updated
- Review date comparison logic in `get_users_for_trial_emails()`

**Wrong users getting emails:**
- Check trial_started_at dates are correct
- Verify time zone settings in n8n and Supabase
- Test queries independently in Supabase SQL Editor

## Next Steps

1. Set up email provider account (Resend, SendGrid, etc.)
2. Create n8n account and import workflow
3. Configure Supabase connection with service role key
4. Customize email templates with your branding
5. Test with a few test users
6. Enable workflow and monitor for first week
7. Adjust timing/content based on open rates and conversions

---

**Last Updated:** 2025-11-24
**Status:** Ready for implementation
