-- Fix specific variable name collision with reserved keyword "current_time"
-- The variable "current_time" was shadowing the system function current_time (which returns time with time zone)
-- causing type mismatch errors when comparing with timestamps.

-- Also updated to cap displayed days remaining at 7, even if grace period makes it 8 technically.

CREATE OR REPLACE FUNCTION check_and_update_trial_status(user_uuid UUID)
RETURNS TABLE(
    status TEXT,
    days_remaining INTEGER,
    trial_end_date TIMESTAMPTZ,
    is_banner_dismissed BOOLEAN
) AS $$
DECLARE
    profile_record RECORD;
    current_ts TIMESTAMPTZ := NOW(); -- Renamed from current_time to avoid keyword collision
    grace_end_time TIMESTAMPTZ;
    raw_days_remaining INTEGER;
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

    -- Calculate grace end time (trial_ends_at + 1 day) with explicit type cast
    IF profile_record.trial_ends_at IS NOT NULL THEN
        grace_end_time := profile_record.trial_ends_at::TIMESTAMPTZ + INTERVAL '1 day';
    END IF;

    -- Check if trial has expired (with 1 day grace period)
    -- Grace period: expires at end of day AFTER trial_ends_at
    IF profile_record.trial_status = 'active' AND
       profile_record.trial_ends_at IS NOT NULL AND
       current_ts > grace_end_time THEN

        -- Update status to expired
        UPDATE profiles
        SET trial_status = 'expired'
        WHERE id = user_uuid;

        RETURN QUERY SELECT
            'expired'::TEXT,
            0::INTEGER,
            profile_record.trial_ends_at::TIMESTAMPTZ,
            false::BOOLEAN;
        RETURN;
    END IF;

    -- Calculate days remaining (ceiling to show "1 day" on last day until it expires)
    -- Days remaining includes the grace day for access, but we cap display at 7
    raw_days_remaining := GREATEST(0, CEIL(EXTRACT(EPOCH FROM (grace_end_time - current_ts)) / 86400)::INTEGER);

    RETURN QUERY SELECT
        profile_record.trial_status,
        LEAST(7, raw_days_remaining), -- Cap at 7 days for display purposes
        profile_record.trial_ends_at::TIMESTAMPTZ,
        CASE
            WHEN profile_record.trial_banner_dismissed_at IS NULL THEN false
            -- Banner is dismissed if dismissed today
            WHEN DATE(profile_record.trial_banner_dismissed_at) = DATE(current_ts) THEN true
            ELSE false
        END;
END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION check_and_update_trial_status(UUID) TO authenticated;
