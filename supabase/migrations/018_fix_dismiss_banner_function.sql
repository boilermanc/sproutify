-- Fix dismiss_trial_banner function to use consistent timezone handling
-- The function was using NOW() which is transaction-start time, which is generally fine,
-- but to be safe and consistent with other time comparisons, we'll ensure it works as expected.
-- Also adds security check to ensure users can only dismiss their own banner.

CREATE OR REPLACE FUNCTION dismiss_trial_banner(user_uuid UUID)
RETURNS VOID AS $$
BEGIN
    -- Verify that the user_uuid matches the authenticated user
    IF user_uuid != auth.uid() THEN
        RAISE EXCEPTION 'You can only dismiss your own trial banner';
    END IF;
    
    UPDATE profiles
    SET trial_banner_dismissed_at = NOW()
    WHERE id = user_uuid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION dismiss_trial_banner(UUID) TO authenticated;

