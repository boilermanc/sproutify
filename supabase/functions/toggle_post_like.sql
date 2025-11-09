-- ========================================
-- SUPABASE FUNCTION: Toggle Post Like
-- Likes or unlikes a post and creates notification
-- ========================================

CREATE OR REPLACE FUNCTION toggle_post_like(
  p_post_id UUID,
  p_user_id UUID
)
RETURNS JSONB AS $$
DECLARE
  v_is_liked BOOLEAN;
  v_post_owner_id UUID;
  v_liker_username TEXT;
  v_likes_count INTEGER;
BEGIN
  -- Check if user already liked this post
  SELECT EXISTS (
    SELECT 1 FROM post_likes
    WHERE post_id = p_post_id AND user_id = p_user_id
  ) INTO v_is_liked;

  -- Get post owner
  SELECT user_id INTO v_post_owner_id
  FROM community_posts
  WHERE id = p_post_id;

  -- Get liker username
  SELECT COALESCE(display_name, email, 'Someone') INTO v_liker_username
  FROM profiles
  WHERE id = p_user_id;

  IF v_is_liked THEN
    -- Unlike the post
    DELETE FROM post_likes
    WHERE post_id = p_post_id AND user_id = p_user_id;

    -- Note: The trigger will automatically decrement likes_count

  ELSE
    -- Like the post
    INSERT INTO post_likes (post_id, user_id)
    VALUES (p_post_id, p_user_id)
    ON CONFLICT (user_id, post_id) DO NOTHING;

    -- Note: The trigger will automatically increment likes_count

    -- Create notification for post owner (if not liking own post)
    IF p_user_id != v_post_owner_id THEN
      INSERT INTO community_notifications (
        user_id,
        type,
        title,
        message,
        related_user_id,
        related_post_id
      )
      VALUES (
        v_post_owner_id,
        'post_liked',
        'New like on your post',
        v_liker_username || ' liked your post',
        p_user_id,
        p_post_id
      );
    END IF;

    -- Update user's total likes received
    UPDATE user_community_profiles
    SET total_likes_received = total_likes_received + 1
    WHERE user_id = v_post_owner_id;

    -- Check badge progress for likes given
    INSERT INTO badge_progress (user_id, badge_category, current_value)
    VALUES (p_user_id, 'likes_given', 1)
    ON CONFLICT (user_id, badge_category)
    DO UPDATE SET
      current_value = badge_progress.current_value + 1,
      updated_at = NOW();

    -- Check badge progress for likes received (post owner)
    INSERT INTO badge_progress (user_id, badge_category, current_value)
    VALUES (v_post_owner_id, 'total_likes_received', 1)
    ON CONFLICT (user_id, badge_category)
    DO UPDATE SET
      current_value = badge_progress.current_value + 1,
      updated_at = NOW();

  END IF;

  -- Get updated likes count
  SELECT likes_count INTO v_likes_count
  FROM community_posts
  WHERE id = p_post_id;

  -- Return result
  RETURN JSONB_BUILD_OBJECT(
    'success', true,
    'is_liked', NOT v_is_liked,
    'likes_count', v_likes_count
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
GRANT EXECUTE ON FUNCTION toggle_post_like TO authenticated;

-- Example usage:
-- SELECT toggle_post_like('post-uuid', auth.uid());
