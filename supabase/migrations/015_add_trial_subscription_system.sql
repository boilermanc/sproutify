-- Migration to add 7-day free trial and subscription tracking
-- This adds trial and subscription fields to profiles table
-- This migration is idempotent and safe to run multiple times
-- Based on Rejoice app trial system pattern

BEGIN;

-- Add trial and subscription columns to profiles table
ALTER TABLE profiles
    ADD COLUMN IF NOT EXISTS trial_started_at TIMESTAMPTZ DEFAULT NOW(),
    ADD COLUMN IF NOT EXISTS trial_ends_at TIMESTAMPTZ DEFAULT (NOW() + INTERVAL '7 days'),
    ADD COLUMN IF NOT EXISTS trial_status TEXT NOT NULL DEFAULT 'active',
    ADD COLUMN IF NOT EXISTS trial_converted_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS subscription_start_date TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS subscription_end_date TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS trial_banner_dismissed_at TIMESTAMPTZ,
    ADD COLUMN IF NOT EXISTS first_login_email_sent BOOLEAN DEFAULT false,
    ADD COLUMN IF NOT EXISTS day2_email_sent BOOLEAN DEFAULT false,
    ADD COLUMN IF NOT EXISTS day4_email_sent BOOLEAN DEFAULT false,
    ADD COLUMN IF NOT EXISTS day6_email_sent BOOLEAN DEFAULT false,
    ADD COLUMN IF NOT EXISTS offer_code TEXT,
    ADD COLUMN IF NOT EXISTS revenue_cat_customer_id TEXT,
    ADD COLUMN IF NOT EXISTS subscription_platform TEXT CHECK (subscription_platform IN ('ios', 'android', 'web'));

-- Add constraint for trial_status
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'profiles_trial_status_check'
    ) THEN
        ALTER TABLE profiles
        ADD CONSTRAINT profiles_trial_status_check
        CHECK (trial_status IN ('none', 'active', 'converted', 'expired'));
    END IF;
END $$;

-- Add indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_profiles_trial_status ON profiles(trial_status);
CREATE INDEX IF NOT EXISTS idx_profiles_trial_ends_at ON profiles(trial_ends_at);

-- Function to initialize trial for new users
CREATE OR REPLACE FUNCTION initialize_user_trial()
RETURNS TRIGGER AS $$
BEGIN
    -- Set trial dates if not already set (for new inserts)
    IF NEW.trial_started_at IS NULL THEN
        NEW.trial_started_at = NOW();
    END IF;

    IF NEW.trial_ends_at IS NULL THEN
        NEW.trial_ends_at = NOW() + INTERVAL '7 days';
    END IF;

    IF NEW.trial_status IS NULL THEN
        NEW.trial_status = 'active';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to initialize trial on profile creation
DROP TRIGGER IF EXISTS trigger_initialize_user_trial ON profiles;
CREATE TRIGGER trigger_initialize_user_trial
    BEFORE INSERT ON profiles
    FOR EACH ROW
    EXECUTE FUNCTION initialize_user_trial();

-- Function to check if trial has expired and update status
CREATE OR REPLACE FUNCTION check_and_update_trial_status(user_uuid UUID)
RETURNS TABLE(
    status TEXT,
    days_remaining INTEGER,
    trial_end_date TIMESTAMPTZ,
    is_banner_dismissed BOOLEAN
) AS $$
DECLARE
    profile_record RECORD;
    current_time TIMESTAMPTZ := NOW();
BEGIN
    SELECT
        trial_status,
        trial_ends_at,
        trial_banner_dismissed_at
    INTO profile_record
    FROM profiles
    WHERE id = user_uuid;

    -- If no profile found, return null
    IF NOT FOUND THEN
        RETURN;
    END IF;

    -- If already converted (subscribed), return converted status
    IF profile_record.trial_status = 'converted' THEN
        RETURN QUERY SELECT
            'converted'::TEXT,
            NULL::INTEGER,
            NULL::TIMESTAMPTZ,
            false::BOOLEAN;
        RETURN;
    END IF;

    -- Check if trial has expired (with 1 day grace period)
    -- Grace period: expires at end of day AFTER trial_ends_at
    IF profile_record.trial_status = 'active' AND
       profile_record.trial_ends_at IS NOT NULL AND
       current_time > (profile_record.trial_ends_at + INTERVAL '1 day') THEN

        -- Update status to expired
        UPDATE profiles
        SET trial_status = 'expired'
        WHERE id = user_uuid;

        RETURN QUERY SELECT
            'expired'::TEXT,
            0::INTEGER,
            profile_record.trial_ends_at,
            false::BOOLEAN;
        RETURN;
    END IF;

    -- Calculate days remaining (ceiling to show "1 day" on last day until it expires)
    -- Days remaining includes the grace day
    RETURN QUERY SELECT
        profile_record.trial_status,
        GREATEST(0, CEIL(EXTRACT(EPOCH FROM ((profile_record.trial_ends_at + INTERVAL '1 day') - current_time)) / 86400)::INTEGER),
        profile_record.trial_ends_at,
        CASE
            WHEN profile_record.trial_banner_dismissed_at IS NULL THEN false
            -- Banner is dismissed if dismissed today
            WHEN DATE(profile_record.trial_banner_dismissed_at) = DATE(current_time) THEN true
            ELSE false
        END;
END;
$$ LANGUAGE plpgsql;

-- Function to dismiss trial banner (only for current day)
CREATE OR REPLACE FUNCTION dismiss_trial_banner(user_uuid UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE profiles
    SET trial_banner_dismissed_at = NOW()
    WHERE id = user_uuid;
END;
$$ LANGUAGE plpgsql;

-- Function to convert trial to subscription (called by RevenueCat webhook or in-app)
CREATE OR REPLACE FUNCTION convert_trial_to_subscription(
    user_uuid UUID,
    duration_days INTEGER DEFAULT 365,
    platform TEXT DEFAULT NULL,
    rc_customer_id TEXT DEFAULT NULL
)
RETURNS VOID AS $$
BEGIN
    UPDATE profiles
    SET
        trial_status = 'converted',
        trial_converted_at = NOW(),
        subscription_start_date = NOW(),
        subscription_end_date = NOW() + (duration_days || ' days')::INTERVAL,
        subscription_platform = platform,
        revenue_cat_customer_id = COALESCE(rc_customer_id, revenue_cat_customer_id)
    WHERE id = user_uuid;
END;
$$ LANGUAGE plpgsql;

-- Function to apply offer code and extend trial
CREATE OR REPLACE FUNCTION apply_offer_code(
    user_uuid UUID,
    code TEXT,
    extra_days INTEGER DEFAULT 7
)
RETURNS TABLE(
    success BOOLEAN,
    message TEXT,
    new_trial_end_date TIMESTAMPTZ
) AS $$
DECLARE
    current_trial_end TIMESTAMPTZ;
    current_status TEXT;
BEGIN
    -- Get current trial info
    SELECT trial_ends_at, trial_status
    INTO current_trial_end, current_status
    FROM profiles
    WHERE id = user_uuid;

    -- Check if user is on active trial
    IF current_status != 'active' THEN
        RETURN QUERY SELECT
            false,
            'Offer codes can only be applied to active trials'::TEXT,
            NULL::TIMESTAMPTZ;
        RETURN;
    END IF;

    -- Apply the offer code and extend trial
    UPDATE profiles
    SET
        trial_ends_at = GREATEST(current_trial_end, NOW()) + (extra_days || ' days')::INTERVAL,
        offer_code = code
    WHERE id = user_uuid;

    -- Return success with new end date
    SELECT trial_ends_at INTO current_trial_end
    FROM profiles
    WHERE id = user_uuid;

    RETURN QUERY SELECT
        true,
        ('Trial extended by ' || extra_days || ' days')::TEXT,
        current_trial_end;
END;
$$ LANGUAGE plpgsql;

-- Function to get users who need trial reminder emails
-- This would be called by a scheduled job (e.g., n8n, Supabase Edge Function with cron)
CREATE OR REPLACE FUNCTION get_users_for_trial_emails(day_number INTEGER)
RETURNS TABLE(
    user_id UUID,
    email TEXT,
    days_remaining INTEGER,
    first_name TEXT,
    last_name TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.id,
        p.email,
        CEIL(EXTRACT(EPOCH FROM (p.trial_ends_at - NOW())) / 86400)::INTEGER as days_remaining,
        p.first_name,
        p.last_name
    FROM profiles p
    WHERE
        p.trial_status = 'active'
        AND p.trial_ends_at IS NOT NULL
        AND p.email IS NOT NULL
        AND CASE
            WHEN day_number = 0 THEN
                p.first_login_email_sent = false
                AND p.created_at >= NOW() - INTERVAL '1 day'
            WHEN day_number = 2 THEN
                p.day2_email_sent = false
                AND DATE(p.trial_started_at) = DATE(NOW() - INTERVAL '2 days')
            WHEN day_number = 4 THEN
                p.day4_email_sent = false
                AND DATE(p.trial_started_at) = DATE(NOW() - INTERVAL '4 days')
            WHEN day_number = 6 THEN
                p.day6_email_sent = false
                AND DATE(p.trial_started_at) = DATE(NOW() - INTERVAL '6 days')
            ELSE false
        END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to mark trial email as sent
CREATE OR REPLACE FUNCTION mark_trial_email_sent(user_uuid UUID, day_number INTEGER)
RETURNS VOID AS $$
BEGIN
    UPDATE profiles
    SET
        first_login_email_sent = CASE WHEN day_number = 0 THEN true ELSE first_login_email_sent END,
        day2_email_sent = CASE WHEN day_number = 2 THEN true ELSE day2_email_sent END,
        day4_email_sent = CASE WHEN day_number = 4 THEN true ELSE day4_email_sent END,
        day6_email_sent = CASE WHEN day_number = 6 THEN true ELSE day6_email_sent END
    WHERE id = user_uuid;
END;
$$ LANGUAGE plpgsql;

-- Grant execute permissions on functions
GRANT EXECUTE ON FUNCTION check_and_update_trial_status(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION dismiss_trial_banner(UUID) TO authenticated;
GRANT EXECUTE ON FUNCTION convert_trial_to_subscription(UUID, INTEGER, TEXT, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION apply_offer_code(UUID, TEXT, INTEGER) TO authenticated;

-- Add comments for documentation
COMMENT ON COLUMN profiles.trial_started_at IS 'When the user started their 7-day free trial';
COMMENT ON COLUMN profiles.trial_ends_at IS 'When the 7-day free trial expires';
COMMENT ON COLUMN profiles.trial_status IS 'Current trial status: none, active, converted, or expired';
COMMENT ON COLUMN profiles.trial_converted_at IS 'When the trial was converted to a paid subscription';
COMMENT ON COLUMN profiles.subscription_start_date IS 'When the paid subscription started';
COMMENT ON COLUMN profiles.subscription_end_date IS 'When the paid subscription ends';
COMMENT ON COLUMN profiles.trial_banner_dismissed_at IS 'Last time user dismissed the trial banner (resets daily)';
COMMENT ON COLUMN profiles.first_login_email_sent IS 'Whether welcome/first login email has been sent';
COMMENT ON COLUMN profiles.day2_email_sent IS 'Whether day 2 trial reminder email has been sent';
COMMENT ON COLUMN profiles.day4_email_sent IS 'Whether day 4 trial reminder email has been sent';
COMMENT ON COLUMN profiles.day6_email_sent IS 'Whether day 6 trial reminder email has been sent';
COMMENT ON COLUMN profiles.offer_code IS 'Promotional offer code used to extend trial period';
COMMENT ON COLUMN profiles.revenue_cat_customer_id IS 'RevenueCat customer ID for subscription management';
COMMENT ON COLUMN profiles.subscription_platform IS 'Platform where subscription was purchased: ios, android, or web';

COMMIT;
