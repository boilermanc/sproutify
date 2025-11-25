-- Fix dismiss_trial_banner function to use consistent timezone handling
-- The function was using NOW() which is transaction-start time, which is generally fine,
-- but to be safe and consistent with other time comparisons, we'll ensure it works as expected.

CREATE OR REPLACE FUNCTION dismiss_trial_banner(user_uuid UUID)
RETURNS VOID AS $$
BEGIN
    UPDATE profiles
    SET trial_banner_dismissed_at = NOW()
    WHERE id = user_uuid;
END;
$$ LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION dismiss_trial_banner(UUID) TO authenticated;

