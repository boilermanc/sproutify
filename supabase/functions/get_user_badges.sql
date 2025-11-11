-- ========================================
-- SUPABASE FUNCTION: Get User Badges
-- Returns user's badge collection with progress info
-- ========================================

CREATE OR REPLACE FUNCTION get_user_badges(
  p_user_id UUID,
  p_filter TEXT DEFAULT 'all' -- 'all', 'earned', 'locked'
)
RETURNS JSONB AS $$
DECLARE
  v_result JSONB;
BEGIN

  WITH user_badge_data AS (
    SELECT
      bd.id as badge_id,
      bd.name,
      bd.description,
      bd.category,
      bd.icon_url,
      bd.tier,
      bd.rarity,
      bd.xp_value,
      bd.trigger_type,
      bd.trigger_threshold,
      bd.sort_order,
      ub.earned_at,
      ub.showcased,
      CASE
        WHEN ub.id IS NOT NULL THEN 'earned'
        ELSE 'locked'
      END as status,
      COALESCE(bp.current_value, 0) as current_progress,
      CASE
        WHEN bd.trigger_threshold > 0 THEN
          ROUND((COALESCE(bp.current_value, 0)::NUMERIC / bd.trigger_threshold::NUMERIC) * 100, 2)
        ELSE 0
      END as progress_percentage
    FROM badge_definitions bd
    LEFT JOIN user_badges ub ON bd.id = ub.badge_id AND ub.user_id = p_user_id
    LEFT JOIN badge_progress bp ON bd.trigger_type = bp.badge_category AND bp.user_id = p_user_id
    WHERE bd.is_active = true
  ),

  category_summary AS (
    SELECT
      category,
      COUNT(*) as total_badges,
      COUNT(CASE WHEN status = 'earned' THEN 1 END) as earned_badges
    FROM user_badge_data
    GROUP BY category
  ),

  user_stats AS (
    SELECT
      COALESCE(ug.total_xp, 0) as total_xp,
      COALESCE(ug.current_level, 1) as current_level,
      (
        SELECT COUNT(*)::INTEGER
        FROM user_badges
        WHERE user_id = p_user_id
      ) as total_badges_earned
    FROM (SELECT 1) dummy
    LEFT JOIN user_gamification ug ON ug.user_id = p_user_id
  )

  SELECT JSONB_BUILD_OBJECT(
    'user_stats', (SELECT ROW_TO_JSON(user_stats.*) FROM user_stats),
    'categories', (
      SELECT JSONB_AGG(
        JSONB_BUILD_OBJECT(
          'category', category,
          'total', total_badges,
          'earned', earned_badges,
          'completion_percentage', ROUND((earned_badges::NUMERIC / total_badges::NUMERIC) * 100, 2)
        )
        ORDER BY category
      )
      FROM category_summary
    ),
    'badges', (
      SELECT JSONB_AGG(
        JSONB_BUILD_OBJECT(
          'badge_id', badge_id,
          'name', name,
          'description', description,
          'category', category,
          'icon_url', icon_url,
          'tier', tier,
          'rarity', rarity,
          'xp_value', xp_value,
          'status', status,
          'earned_at', earned_at,
          'showcased', COALESCE(showcased, false),
          'current_progress', current_progress,
          'required_progress', trigger_threshold,
          'progress_percentage', progress_percentage
        )
        ORDER BY sort_order
      )
      FROM user_badge_data
      WHERE
        p_filter = 'all' OR
        (p_filter = 'earned' AND status = 'earned') OR
        (p_filter = 'locked' AND status = 'locked')
    )
  ) INTO v_result;

  RETURN v_result;

EXCEPTION
  WHEN OTHERS THEN
    RETURN JSONB_BUILD_OBJECT(
      'success', false,
      'error', SQLERRM
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_user_badges TO authenticated;

-- Example usage:
-- SELECT get_user_badges(auth.uid(), 'all');
-- SELECT get_user_badges(auth.uid(), 'earned');
-- SELECT get_user_badges(auth.uid(), 'locked');
