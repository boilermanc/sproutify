-- Test the trial status function for your user
-- Run this in Supabase SQL Editor to debug

-- Check your current profile data
SELECT
    id,
    email,
    trial_status,
    trial_started_at,
    trial_ends_at,
    trial_banner_dismissed_at,
    trial_ends_at - NOW() as time_remaining
FROM profiles
WHERE email = 'carson05@yopmail.com';

-- Test the check_and_update_trial_status function
SELECT * FROM check_and_update_trial_status('bd23506b-0b68-42da-95e1-96f2efa5a985'::uuid);

-- This should return:
-- status: 'active'
-- days_remaining: number between 1-8 (7 days + 1 grace day)
-- trial_end_date: your trial_ends_at timestamp
-- is_banner_dismissed: false
