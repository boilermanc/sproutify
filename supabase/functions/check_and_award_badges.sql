-- ========================================
-- SUPABASE FUNCTION: Check and Award Badges
-- Checks user's progress and awards badges if thresholds met
-- ========================================

CREATE OR REPLACE FUNCTION check_and_award_badges(
  p_user_id UUID,
  p_trigger_type TEXT
)
RETURNS JSONB AS $$
DECLARE
  v_badge RECORD;
  v_current_progress INTEGER;
  v_newly_earned_badges JSONB := '[]'::JSONB;
  v_badge_info JSONB;
  v_total_xp INTEGER := 0;
  v_new_level INTEGER;
BEGIN

  -- Loop through all active badges with matching trigger type
  FOR v_badge IN
    SELECT *
    FROM badge_definitions
    WHERE trigger_type = p_trigger_type
      AND is_active = true
      AND NOT EXISTS (
        -- Don't check badges user already has
        SELECT 1 FROM user_badges
        WHERE user_id = p_user_id AND badge_id = badge_definitions.id
      )
  LOOP

    -- Get current progress for this badge category
    SELECT COALESCE(current_value, 0) INTO v_current_progress
    FROM badge_progress
    WHERE user_id = p_user_id
      AND badge_category = v_badge.trigger_type;

    -- Check if threshold is met
    IF v_current_progress >= v_badge.trigger_threshold THEN

      -- Award the badge
      INSERT INTO user_badges (user_id, badge_id, earned_at)
      VALUES (p_user_id, v_badge.id, NOW())
      ON CONFLICT (user_id, badge_id) DO NOTHING;

      -- Check if insert actually happened (might conflict)
      IF FOUND THEN

        -- Add XP to user
        INSERT INTO user_gamification (user_id, total_xp, badges_earned, last_badge_earned_at)
        VALUES (p_user_id, v_badge.xp_value, 1, NOW())
        ON CONFLICT (user_id)
        DO UPDATE SET
          total_xp = user_gamification.total_xp + v_badge.xp_value,
          badges_earned = user_gamification.badges_earned + 1,
          last_badge_earned_at = NOW();

        -- Create notification
        INSERT INTO community_notifications (
          user_id,
          type,
          title,
          message,
          related_badge_id
        )
        VALUES (
          p_user_id,
          'badge_earned',
          'New Badge Earned!',
          'You earned the ' || v_badge.name || ' badge!',
          v_badge.id
        );

        -- Add to newly earned badges array
        v_badge_info := JSONB_BUILD_OBJECT(
          'id', v_badge.id,
          'name', v_badge.name,
          'description', v_badge.description,
          'tier', v_badge.tier,
          'rarity', v_badge.rarity,
          'xp_value', v_badge.xp_value,
          'icon_url', v_badge.icon_url
        );

        v_newly_earned_badges := v_newly_earned_badges || v_badge_info;
        v_total_xp := v_total_xp + v_badge.xp_value;

      END IF;

    END IF;

  END LOOP;

  -- Calculate new level based on total XP
  SELECT total_xp INTO v_total_xp
  FROM user_gamification
  WHERE user_id = p_user_id;

  -- Level formula: Level = FLOOR(SQRT(total_xp / 100)) + 1
  -- This means:
  -- Level 1: 0-99 XP
  -- Level 2: 100-399 XP
  -- Level 3: 400-899 XP
  -- Level 4: 900-1599 XP
  -- Level 5: 1600-2499 XP
  -- etc.
  v_new_level := FLOOR(SQRT(v_total_xp / 100.0)) + 1;

  -- Update user level
  UPDATE user_gamification
  SET current_level = v_new_level
  WHERE user_id = p_user_id;

  -- Check for meta-badges (badges about earning badges)
  IF JSONB_ARRAY_LENGTH(v_newly_earned_badges) > 0 THEN
    -- Recursively check meta badges
    PERFORM check_and_award_badges(p_user_id, 'badges_earned');
  END IF;

  -- Return results
  RETURN JSONB_BUILD_OBJECT(
    'success', true,
    'newly_earned_badges', v_newly_earned_badges,
    'total_new_xp', v_total_xp,
    'current_level', v_new_level
  );

EXCEPTION
  WHEN OTHERS THEN
    RETURN JSONB_BUILD_OBJECT(
      'success', false,
      'error', SQLERRM
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION check_and_award_badges TO authenticated;

-- Example usage:
-- SELECT check_and_award_badges(auth.uid(), 'post_count');
-- SELECT check_and_award_badges(auth.uid(), 'harvest_count');
-- SELECT check_and_award_badges(auth.uid(), 'likes_given');
