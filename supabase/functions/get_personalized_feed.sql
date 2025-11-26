-- ========================================
-- SUPABASE FUNCTION: Get Personalized Feed
-- Returns posts for a user's feed with relevance scoring
-- ========================================

CREATE OR REPLACE FUNCTION get_personalized_feed(
  p_user_id UUID,
  p_feed_type TEXT DEFAULT 'for_you', -- 'for_you', 'following', 'recent', 'popular'
  p_limit INTEGER DEFAULT 20,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  post_id UUID,
  post_user_id UUID,
  username TEXT,
  user_photo TEXT,
  photo_url TEXT,
  photo_aspect_ratio DECIMAL,
  caption TEXT,
  location_city TEXT,
  location_state TEXT,
  is_featured BOOLEAN,
  featured_type TEXT,
  likes_count INTEGER,
  comments_count INTEGER,
  view_count INTEGER,
  created_at TIMESTAMP WITH TIME ZONE,
  is_liked_by_user BOOLEAN,
  is_bookmarked_by_user BOOLEAN,
  plant_tags JSONB,
  tower_name TEXT,
  hashtags JSONB,
  relevance_score NUMERIC
) AS $$
BEGIN
  RETURN QUERY

  WITH user_plants AS (
    -- Get plants the current user is growing
    SELECT DISTINCT plant_id
    FROM userplants
    WHERE user_id = p_user_id
  ),

  user_following AS (
    -- Get users the current user follows
    SELECT following_id
    FROM user_follows
    WHERE follower_id = p_user_id
  ),

  post_data AS (
    SELECT
      cp.id,
      cp.user_id,
      COALESCE(
        p.username,
        NULLIF(TRIM(COALESCE(p.first_name, '') || ' ' || COALESCE(p.last_name, '')), ''),
        p.email,
        'Anonymous'
      ) as username,
      ucp.profile_photo_url,
      cp.photo_url,
      cp.photo_aspect_ratio,
      cp.caption,
      cp.location_city,
      cp.location_state,
      cp.is_featured,
      cp.featured_type,
      cp.likes_count,
      cp.comments_count,
      cp.view_count,
      cp.created_at,

      -- Check if current user liked this post
      EXISTS (
        SELECT 1 FROM post_likes pl_like
        WHERE pl_like.post_id = cp.id AND pl_like.user_id = p_user_id
      ) as is_liked,

      -- Check if current user bookmarked this post
      EXISTS (
        SELECT 1 FROM post_bookmarks pb
        WHERE pb.post_id = cp.id AND pb.user_id = p_user_id
      ) as is_bookmarked,

      -- Get plant tags as JSON
      (
        SELECT JSONB_AGG(
          JSONB_BUILD_OBJECT(
            'id', ppt.plant_id
          )
        )
        FROM post_plant_tags ppt
        WHERE ppt.post_id = cp.id
      ) as plant_tags_json,

      -- Get tower name
      mt.tower_name as tower_name,

      -- Get hashtags as JSON
      (
        SELECT JSONB_AGG(
          JSONB_BUILD_OBJECT(
            'id', h.id,
            'tag', h.display_tag
          )
        )
        FROM post_hashtags ph
        JOIN hashtags h ON ph.hashtag_id = h.id
        WHERE ph.post_id = cp.id
      ) as hashtags_json,

      -- Calculate relevance score based on feed type
      CASE
        WHEN p_feed_type = 'for_you' THEN
          -- Personalized scoring
          (
            -- Base recency score (0-10 points)
            (10 * EXP(-EXTRACT(EPOCH FROM (NOW() - cp.created_at)) / 86400)) +

            -- Engagement score (0-20 points)
            (LEAST(cp.likes_count::NUMERIC / 10, 10)) +
            (LEAST(cp.comments_count::NUMERIC / 2, 5)) +
            (LEAST(cp.view_count::NUMERIC / 50, 5)) +

            -- Following boost (20 points if following)
            (CASE WHEN EXISTS (SELECT 1 FROM user_following WHERE following_id = cp.user_id) THEN 20 ELSE 0 END) +

            -- Same plant boost (15 points if growing same plants)
            (CASE WHEN EXISTS (
              SELECT 1 FROM post_plant_tags ppt_same
              JOIN user_plants up ON ppt_same.plant_id = up.plant_id
              WHERE ppt_same.post_id = cp.id
            ) THEN 15 ELSE 0 END) +

            -- Featured boost (10 points)
            (CASE WHEN cp.is_featured THEN 10 ELSE 0 END)
          )

        WHEN p_feed_type = 'following' THEN
          -- Just recency for following feed
          EXTRACT(EPOCH FROM cp.created_at)

        WHEN p_feed_type = 'popular' THEN
          -- Engagement-based scoring
          (cp.likes_count * 3) + (cp.comments_count * 5) + (cp.view_count * 0.1)

        ELSE -- 'recent'
          -- Pure recency
          EXTRACT(EPOCH FROM cp.created_at)
      END as relevance_score

    FROM community_posts cp
    LEFT JOIN profiles p ON cp.user_id = p.id
    LEFT JOIN user_community_profiles ucp ON cp.user_id = ucp.user_id
    LEFT JOIN my_towers mt ON cp.tower_id = mt.tower_id

    WHERE
      cp.is_approved = true
      AND cp.is_hidden = false
      AND (
        -- For 'following' feed, only show posts from followed users
        p_feed_type != 'following' OR
        EXISTS (SELECT 1 FROM user_following WHERE following_id = cp.user_id)
      )
      AND cp.user_id != p_user_id -- Don't show user's own posts in feed (optional)
  )

  SELECT
    pd.id,
    pd.user_id,
    pd.username::TEXT,
    pd.profile_photo_url::TEXT,
    pd.photo_url::TEXT,
    pd.photo_aspect_ratio,
    pd.caption::TEXT,
    pd.location_city::TEXT,
    pd.location_state::TEXT,
    pd.is_featured,
    pd.featured_type::TEXT,
    pd.likes_count,
    pd.comments_count,
    pd.view_count,
    pd.created_at,
    pd.is_liked,
    pd.is_bookmarked,
    pd.plant_tags_json,
    pd.tower_name::TEXT,
    pd.hashtags_json,
    pd.relevance_score
  FROM post_data pd
  ORDER BY pd.relevance_score DESC, pd.created_at DESC
  LIMIT p_limit
  OFFSET p_offset;

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION get_personalized_feed TO authenticated;

-- Example usage:
-- SELECT * FROM get_personalized_feed(auth.uid(), 'for_you', 20, 0);
-- SELECT * FROM get_personalized_feed(auth.uid(), 'following', 20, 0);
-- SELECT * FROM get_personalized_feed(auth.uid(), 'recent', 20, 0);
-- SELECT * FROM get_personalized_feed(auth.uid(), 'popular', 20, 0);
