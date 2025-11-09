-- ========================================
-- SUPABASE FUNCTION: Create Community Post
-- Creates a post with tags and checks for badges
-- ========================================

CREATE OR REPLACE FUNCTION create_community_post(
  p_user_id UUID,
  p_photo_url TEXT,
  p_photo_aspect_ratio DECIMAL DEFAULT 1.00,
  p_caption TEXT DEFAULT NULL,
  p_tower_id INTEGER DEFAULT NULL,
  p_location_city TEXT DEFAULT NULL,
  p_location_state TEXT DEFAULT NULL,
  p_plant_ids INTEGER[] DEFAULT ARRAY[]::INTEGER[],
  p_hashtag_tags TEXT[] DEFAULT ARRAY[]::TEXT[]
)
RETURNS JSONB AS $$
DECLARE
  v_post_id UUID;
  v_hashtag_id UUID;
  v_hashtag_tag TEXT;
  v_plant_id INTEGER;
  v_badge_result JSONB;
BEGIN

  -- Create the post
  INSERT INTO community_posts (
    user_id,
    photo_url,
    photo_aspect_ratio,
    caption,
    tower_id,
    location_city,
    location_state,
    is_approved,
    created_at
  )
  VALUES (
    p_user_id,
    p_photo_url,
    p_photo_aspect_ratio,
    p_caption,
    p_tower_id,
    p_location_city,
    p_location_state,
    true, -- Auto-approve for now; set to false for moderation queue
    NOW()
  )
  RETURNING id INTO v_post_id;

  -- Add plant tags
  IF array_length(p_plant_ids, 1) > 0 THEN
    FOREACH v_plant_id IN ARRAY p_plant_ids
    LOOP
      INSERT INTO post_plant_tags (post_id, plant_id)
      VALUES (v_post_id, v_plant_id)
      ON CONFLICT (post_id, plant_id) DO NOTHING;
    END LOOP;
  END IF;

  -- Add hashtags
  IF array_length(p_hashtag_tags, 1) > 0 THEN
    FOREACH v_hashtag_tag IN ARRAY p_hashtag_tags
    LOOP
      -- Normalize hashtag (lowercase, no #)
      v_hashtag_tag := LOWER(TRIM(REPLACE(v_hashtag_tag, '#', '')));

      -- Insert or get hashtag
      INSERT INTO hashtags (tag, display_tag)
      VALUES (v_hashtag_tag, v_hashtag_tag)
      ON CONFLICT (tag) DO UPDATE SET tag = hashtags.tag
      RETURNING id INTO v_hashtag_id;

      -- If no id returned (conflict), get existing id
      IF v_hashtag_id IS NULL THEN
        SELECT id INTO v_hashtag_id
        FROM hashtags
        WHERE tag = v_hashtag_tag;
      END IF;

      -- Link hashtag to post
      INSERT INTO post_hashtags (post_id, hashtag_id)
      VALUES (v_post_id, v_hashtag_id)
      ON CONFLICT (post_id, hashtag_id) DO NOTHING;

    END LOOP;
  END IF;

  -- Update badge progress for post count
  INSERT INTO badge_progress (user_id, badge_category, current_value)
  VALUES (p_user_id, 'post_count', 1)
  ON CONFLICT (user_id, badge_category)
  DO UPDATE SET
    current_value = badge_progress.current_value + 1,
    updated_at = NOW();

  -- Check if user earned any badges
  SELECT check_and_award_badges(p_user_id, 'post_count') INTO v_badge_result;

  -- Check for first post badge
  SELECT check_and_award_badges(p_user_id, 'post_created') INTO v_badge_result;

  -- Check for seasonal badges based on current month
  CASE EXTRACT(MONTH FROM NOW())
    WHEN 3, 4, 5 THEN
      -- Spring (March, April, May)
      INSERT INTO badge_progress (user_id, badge_category, current_value)
      VALUES (p_user_id, 'spring_post', 1)
      ON CONFLICT (user_id, badge_category) DO NOTHING;
      PERFORM check_and_award_badges(p_user_id, 'spring_post');

    WHEN 6, 7, 8 THEN
      -- Summer (June, July, August)
      INSERT INTO badge_progress (user_id, badge_category, current_value)
      VALUES (p_user_id, 'summer_post', 1)
      ON CONFLICT (user_id, badge_category) DO NOTHING;
      PERFORM check_and_award_badges(p_user_id, 'summer_post');

    WHEN 9, 10, 11 THEN
      -- Fall (September, October, November)
      INSERT INTO badge_progress (user_id, badge_category, current_value)
      VALUES (p_user_id, 'fall_post', 1)
      ON CONFLICT (user_id, badge_category) DO NOTHING;
      PERFORM check_and_award_badges(p_user_id, 'fall_post');

    WHEN 12, 1, 2 THEN
      -- Winter (December, January, February)
      INSERT INTO badge_progress (user_id, badge_category, current_value)
      VALUES (p_user_id, 'winter_post', 1)
      ON CONFLICT (user_id, badge_category) DO NOTHING;
      PERFORM check_and_award_badges(p_user_id, 'winter_post');

    ELSE
      NULL;
  END CASE;

  -- Return success with post ID
  RETURN JSONB_BUILD_OBJECT(
    'success', true,
    'post_id', v_post_id,
    'badges', v_badge_result
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
GRANT EXECUTE ON FUNCTION create_community_post TO authenticated;

-- Example usage:
/*
SELECT create_community_post(
  p_user_id := auth.uid(),
  p_photo_url := 'https://storage.supabase.com/...',
  p_photo_aspect_ratio := 1.00,
  p_caption := 'First harvest of the season!',
  p_tower_id := 'tower-uuid',
  p_location_city := 'Seattle',
  p_location_state := 'WA',
  p_plant_ids := ARRAY['plant-uuid-1', 'plant-uuid-2']::UUID[],
  p_hashtag_tags := ARRAY['FirstHarvest', 'IndoorGarden']
);
*/
