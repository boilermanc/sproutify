-- ========================================
-- SPROUTIFY COMMUNITY FEATURE - CORE TABLES
-- Migration 001: Core Community Tables
-- ========================================

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================
-- COMMUNITY POSTS
-- ========================================

CREATE TABLE IF NOT EXISTS community_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  photo_url TEXT NOT NULL,
  photo_aspect_ratio DECIMAL(3,2) DEFAULT 1.00, -- 1.00 for square, 1.78 for 16:9, etc.
  caption TEXT,
  tower_id INTEGER REFERENCES my_towers(tower_id) ON DELETE SET NULL,
  location_city TEXT,
  location_state TEXT,
  is_featured BOOLEAN DEFAULT false,
  featured_type TEXT, -- 'tower_of_week', 'admin_pick', 'challenge_winner'
  is_approved BOOLEAN DEFAULT true, -- Set to false if you want manual approval
  is_hidden BOOLEAN DEFAULT false, -- Hidden due to reports or moderation
  view_count INTEGER DEFAULT 0,
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  shares_count INTEGER DEFAULT 0,
  reports_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for performance
CREATE INDEX idx_community_posts_user ON community_posts(user_id);
CREATE INDEX idx_community_posts_created ON community_posts(created_at DESC);
CREATE INDEX idx_community_posts_featured ON community_posts(is_featured, created_at DESC);
CREATE INDEX idx_community_posts_likes ON community_posts(likes_count DESC, created_at DESC);
CREATE INDEX idx_community_posts_approved ON community_posts(is_approved, is_hidden);

-- Row Level Security
ALTER TABLE community_posts ENABLE ROW LEVEL SECURITY;

-- Users can view approved, non-hidden posts
CREATE POLICY "Community posts are viewable by everyone" ON community_posts
  FOR SELECT USING (is_approved = true AND is_hidden = false);

-- Users can insert their own posts
CREATE POLICY "Users can create their own posts" ON community_posts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Users can update their own posts
CREATE POLICY "Users can update their own posts" ON community_posts
  FOR UPDATE USING (auth.uid() = user_id);

-- Users can delete their own posts
CREATE POLICY "Users can delete their own posts" ON community_posts
  FOR DELETE USING (auth.uid() = user_id);

-- ========================================
-- POST PLANT TAGS (Many-to-Many)
-- ========================================

CREATE TABLE IF NOT EXISTS post_plant_tags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  plant_id INTEGER NOT NULL REFERENCES plants(plant_id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(post_id, plant_id)
);

CREATE INDEX idx_post_plant_tags_post ON post_plant_tags(post_id);
CREATE INDEX idx_post_plant_tags_plant ON post_plant_tags(plant_id);

ALTER TABLE post_plant_tags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Plant tags are viewable by everyone" ON post_plant_tags
  FOR SELECT USING (true);

CREATE POLICY "Users can tag plants on their posts" ON post_plant_tags
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM community_posts
      WHERE id = post_id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Users can remove tags from their posts" ON post_plant_tags
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM community_posts
      WHERE id = post_id AND user_id = auth.uid()
    )
  );

-- ========================================
-- HASHTAGS
-- ========================================

CREATE TABLE IF NOT EXISTS hashtags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tag TEXT UNIQUE NOT NULL, -- lowercase, no # (e.g., 'firstharvest')
  display_tag TEXT NOT NULL, -- display format (e.g., 'FirstHarvest')
  use_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_hashtags_tag ON hashtags(tag);
CREATE INDEX idx_hashtags_count ON hashtags(use_count DESC);

ALTER TABLE hashtags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Hashtags are viewable by everyone" ON hashtags
  FOR SELECT USING (true);

-- ========================================
-- POST HASHTAGS (Many-to-Many)
-- ========================================

CREATE TABLE IF NOT EXISTS post_hashtags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  hashtag_id UUID NOT NULL REFERENCES hashtags(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(post_id, hashtag_id)
);

CREATE INDEX idx_post_hashtags_post ON post_hashtags(post_id);
CREATE INDEX idx_post_hashtags_tag ON post_hashtags(hashtag_id);

ALTER TABLE post_hashtags ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Post hashtags are viewable by everyone" ON post_hashtags
  FOR SELECT USING (true);

CREATE POLICY "Users can add hashtags to their posts" ON post_hashtags
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM community_posts
      WHERE id = post_id AND user_id = auth.uid()
    )
  );

CREATE POLICY "Users can remove hashtags from their posts" ON post_hashtags
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM community_posts
      WHERE id = post_id AND user_id = auth.uid()
    )
  );

-- ========================================
-- POST LIKES
-- ========================================

CREATE TABLE IF NOT EXISTS post_likes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

CREATE INDEX idx_post_likes_user ON post_likes(user_id);
CREATE INDEX idx_post_likes_post ON post_likes(post_id);
CREATE INDEX idx_post_likes_created ON post_likes(created_at DESC);

ALTER TABLE post_likes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Post likes are viewable by everyone" ON post_likes
  FOR SELECT USING (true);

CREATE POLICY "Users can like posts" ON post_likes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can unlike posts" ON post_likes
  FOR DELETE USING (auth.uid() = user_id);

-- ========================================
-- POST BOOKMARKS/SAVES
-- ========================================

CREATE TABLE IF NOT EXISTS post_bookmarks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  collection_name TEXT, -- Optional: organize into collections like "Ideas", "Inspiration"
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

CREATE INDEX idx_post_bookmarks_user ON post_bookmarks(user_id);
CREATE INDEX idx_post_bookmarks_post ON post_bookmarks(post_id);

ALTER TABLE post_bookmarks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own bookmarks" ON post_bookmarks
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can bookmark posts" ON post_bookmarks
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove their bookmarks" ON post_bookmarks
  FOR DELETE USING (auth.uid() = user_id);

-- ========================================
-- POST COMMENTS (Phase 2 - Optional)
-- ========================================

CREATE TABLE IF NOT EXISTS post_comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  comment_text TEXT NOT NULL,
  is_hidden BOOLEAN DEFAULT false,
  likes_count INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_post_comments_post ON post_comments(post_id, created_at);
CREATE INDEX idx_post_comments_user ON post_comments(user_id);

ALTER TABLE post_comments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Comments are viewable by everyone" ON post_comments
  FOR SELECT USING (is_hidden = false);

CREATE POLICY "Users can create comments" ON post_comments
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own comments" ON post_comments
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own comments" ON post_comments
  FOR DELETE USING (auth.uid() = user_id);

-- ========================================
-- POST REPORTS
-- ========================================

CREATE TABLE IF NOT EXISTS post_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  reason TEXT NOT NULL, -- 'spam', 'inappropriate', 'unrelated', 'other'
  additional_info TEXT,
  is_resolved BOOLEAN DEFAULT false,
  resolved_at TIMESTAMP WITH TIME ZONE,
  resolved_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

CREATE INDEX idx_post_reports_unresolved ON post_reports(is_resolved, created_at);
CREATE INDEX idx_post_reports_post ON post_reports(post_id);

ALTER TABLE post_reports ENABLE ROW LEVEL SECURITY;

-- Users can view their own reports
CREATE POLICY "Users can view their own reports" ON post_reports
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can report posts" ON post_reports
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ========================================
-- USER FOLLOWS
-- ========================================

CREATE TABLE IF NOT EXISTS user_follows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  follower_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  following_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(follower_id, following_id),
  CHECK (follower_id != following_id) -- Can't follow yourself
);

CREATE INDEX idx_follows_follower ON user_follows(follower_id);
CREATE INDEX idx_follows_following ON user_follows(following_id);

ALTER TABLE user_follows ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Follows are viewable by everyone" ON user_follows
  FOR SELECT USING (true);

CREATE POLICY "Users can follow others" ON user_follows
  FOR INSERT WITH CHECK (auth.uid() = follower_id);

CREATE POLICY "Users can unfollow" ON user_follows
  FOR DELETE USING (auth.uid() = follower_id);

-- ========================================
-- USER COMMUNITY PROFILES
-- ========================================

CREATE TABLE IF NOT EXISTS user_community_profiles (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  bio TEXT,
  profile_photo_url TEXT,
  is_public BOOLEAN DEFAULT true,
  show_location BOOLEAN DEFAULT true,
  show_stats BOOLEAN DEFAULT true,
  posts_count INTEGER DEFAULT 0,
  followers_count INTEGER DEFAULT 0,
  following_count INTEGER DEFAULT 0,
  total_likes_received INTEGER DEFAULT 0,
  joined_community_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE user_community_profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public profiles are viewable by everyone" ON user_community_profiles
  FOR SELECT USING (is_public = true);

CREATE POLICY "Users can view their own profile" ON user_community_profiles
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own profile" ON user_community_profiles
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own profile" ON user_community_profiles
  FOR UPDATE USING (auth.uid() = user_id);

-- ========================================
-- COMMUNITY NOTIFICATIONS
-- ========================================

CREATE TABLE IF NOT EXISTS community_notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL, -- 'post_liked', 'new_follower', 'badge_earned', 'post_commented', etc.
  title TEXT NOT NULL,
  message TEXT,
  related_user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  related_post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  related_badge_id UUID, -- Will reference badge_definitions
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_community_notif_user ON community_notifications(user_id, is_read, created_at DESC);
CREATE INDEX idx_community_notif_type ON community_notifications(type);

ALTER TABLE community_notifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own notifications" ON community_notifications
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications" ON community_notifications
  FOR UPDATE USING (auth.uid() = user_id);

-- ========================================
-- TRIGGERS FOR AUTOMATIC COUNTER UPDATES
-- ========================================

-- Function to update post likes count
CREATE OR REPLACE FUNCTION update_post_likes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE community_posts
    SET likes_count = likes_count + 1
    WHERE id = NEW.post_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE community_posts
    SET likes_count = GREATEST(likes_count - 1, 0)
    WHERE id = OLD.post_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_post_likes_count
  AFTER INSERT OR DELETE ON post_likes
  FOR EACH ROW EXECUTE FUNCTION update_post_likes_count();

-- Function to update post comments count
CREATE OR REPLACE FUNCTION update_post_comments_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE community_posts
    SET comments_count = comments_count + 1
    WHERE id = NEW.post_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE community_posts
    SET comments_count = GREATEST(comments_count - 1, 0)
    WHERE id = OLD.post_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_post_comments_count
  AFTER INSERT OR DELETE ON post_comments
  FOR EACH ROW EXECUTE FUNCTION update_post_comments_count();

-- Function to update user posts count
CREATE OR REPLACE FUNCTION update_user_posts_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO user_community_profiles (user_id, posts_count)
    VALUES (NEW.user_id, 1)
    ON CONFLICT (user_id)
    DO UPDATE SET posts_count = user_community_profiles.posts_count + 1;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE user_community_profiles
    SET posts_count = GREATEST(posts_count - 1, 0)
    WHERE user_id = OLD.user_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_user_posts_count
  AFTER INSERT OR DELETE ON community_posts
  FOR EACH ROW EXECUTE FUNCTION update_user_posts_count();

-- Function to update follower/following counts
CREATE OR REPLACE FUNCTION update_follow_counts()
RETURNS TRIGGER AS $$
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
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_follow_counts
  AFTER INSERT OR DELETE ON user_follows
  FOR EACH ROW EXECUTE FUNCTION update_follow_counts();

-- Function to update hashtag use count
CREATE OR REPLACE FUNCTION update_hashtag_use_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE hashtags
    SET use_count = use_count + 1
    WHERE id = NEW.hashtag_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE hashtags
    SET use_count = GREATEST(use_count - 1, 0)
    WHERE id = OLD.hashtag_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_hashtag_use_count
  AFTER INSERT OR DELETE ON post_hashtags
  FOR EACH ROW EXECUTE FUNCTION update_hashtag_use_count();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_community_posts_updated_at
  BEFORE UPDATE ON community_posts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER trigger_update_user_community_profiles_updated_at
  BEFORE UPDATE ON user_community_profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
