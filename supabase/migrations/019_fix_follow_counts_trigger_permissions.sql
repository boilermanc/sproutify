-- ========================================
-- Migration 019: Fix follow trigger permissions
-- Ensures follow counters can be updated even when
-- auth users don't own the destination profile rows.
-- ========================================

BEGIN;

CREATE OR REPLACE FUNCTION update_follow_counts()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    -- Increment following count for follower
    INSERT INTO user_community_profiles (user_id, following_count)
    VALUES (NEW.follower_id, 1)
    ON CONFLICT (user_id)
    DO UPDATE SET following_count = user_community_profiles.following_count + 1;

    -- Increment followers count for following
    INSERT INTO user_community_profiles (user_id, followers_count)
    VALUES (NEW.following_id, 1)
    ON CONFLICT (user_id)
    DO UPDATE SET followers_count = user_community_profiles.followers_count + 1;

    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    -- Decrement following count for follower
    UPDATE user_community_profiles
    SET following_count = GREATEST(following_count - 1, 0)
    WHERE user_id = OLD.follower_id;

    -- Decrement followers count for following
    UPDATE user_community_profiles
    SET followers_count = GREATEST(followers_count - 1, 0)
    WHERE user_id = OLD.following_id;

    RETURN OLD;
  END IF;

  RETURN NULL;
END;
$$;

COMMENT ON FUNCTION update_follow_counts()
IS 'Maintains follower/following counters with SECURITY DEFINER to bypass RLS when updating other profiles.';

COMMIT;








