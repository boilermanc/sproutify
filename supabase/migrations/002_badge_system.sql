-- ========================================
-- SPROUTIFY COMMUNITY FEATURE - BADGE SYSTEM
-- Migration 002: Badge & Gamification Tables
-- ========================================

-- ========================================
-- BADGE DEFINITIONS
-- ========================================

CREATE TABLE IF NOT EXISTS badge_definitions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL, -- 'getting_started', 'harvest', 'community', 'expertise', 'consistency', etc.
  icon_url TEXT, -- URL to badge icon image
  tier TEXT, -- 'single', 'bronze', 'silver', 'gold', 'platinum', 'diamond'
  rarity TEXT, -- 'common', 'uncommon', 'rare', 'epic', 'legendary'
  xp_value INTEGER DEFAULT 100,
  trigger_type TEXT NOT NULL, -- 'manual', 'harvest_count', 'post_count', 'plant_count', etc.
  trigger_threshold INTEGER, -- e.g., 5 for "5 harvests"
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_badge_definitions_category ON badge_definitions(category);
CREATE INDEX idx_badge_definitions_trigger ON badge_definitions(trigger_type);
CREATE INDEX idx_badge_definitions_active ON badge_definitions(is_active);

ALTER TABLE badge_definitions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Badge definitions are viewable by everyone" ON badge_definitions
  FOR SELECT USING (is_active = true);

-- ========================================
-- USER BADGES
-- ========================================

CREATE TABLE IF NOT EXISTS user_badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  badge_id UUID NOT NULL REFERENCES badge_definitions(id) ON DELETE CASCADE,
  earned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  showcased BOOLEAN DEFAULT false, -- If user wants to display on profile
  UNIQUE(user_id, badge_id)
);

CREATE INDEX idx_user_badges_user ON user_badges(user_id);
CREATE INDEX idx_user_badges_badge ON user_badges(badge_id);
CREATE INDEX idx_user_badges_showcased ON user_badges(user_id, showcased);
CREATE INDEX idx_user_badges_earned ON user_badges(earned_at DESC);

ALTER TABLE user_badges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "User badges are viewable by everyone" ON user_badges
  FOR SELECT USING (true);

-- Users can update showcase status on their own badges
CREATE POLICY "Users can update their own badges" ON user_badges
  FOR UPDATE USING (auth.uid() = user_id);

-- ========================================
-- USER GAMIFICATION
-- ========================================

CREATE TABLE IF NOT EXISTS user_gamification (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  total_xp INTEGER DEFAULT 0,
  current_level INTEGER DEFAULT 1,
  badges_earned INTEGER DEFAULT 0,
  last_badge_earned_at TIMESTAMP WITH TIME ZONE,
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_activity_date DATE,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_user_gamification_level ON user_gamification(current_level DESC);
CREATE INDEX idx_user_gamification_xp ON user_gamification(total_xp DESC);

ALTER TABLE user_gamification ENABLE ROW LEVEL SECURITY;

CREATE POLICY "User gamification is viewable by everyone" ON user_gamification
  FOR SELECT USING (true);

CREATE POLICY "Users can view their own gamification" ON user_gamification
  FOR SELECT USING (auth.uid() = user_id);

-- ========================================
-- BADGE PROGRESS TRACKING
-- ========================================

CREATE TABLE IF NOT EXISTS badge_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  badge_category TEXT NOT NULL, -- 'harvest_count', 'post_count', 'plant_count', etc.
  current_value INTEGER DEFAULT 0,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, badge_category)
);

CREATE INDEX idx_badge_progress_user ON badge_progress(user_id);
CREATE INDEX idx_badge_progress_category ON badge_progress(badge_category);

ALTER TABLE badge_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own badge progress" ON badge_progress
  FOR SELECT USING (auth.uid() = user_id);

-- ========================================
-- MONTHLY CHALLENGES
-- ========================================

CREATE TABLE IF NOT EXISTS monthly_challenges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  theme TEXT NOT NULL,
  description TEXT,
  hashtag TEXT, -- e.g., 'SpringHarvest2024'
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  is_active BOOLEAN DEFAULT true,
  prize_description TEXT,
  banner_image_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_monthly_challenges_active ON monthly_challenges(is_active, start_date);
CREATE INDEX idx_monthly_challenges_dates ON monthly_challenges(start_date, end_date);

ALTER TABLE monthly_challenges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Active challenges are viewable by everyone" ON monthly_challenges
  FOR SELECT USING (is_active = true);

-- ========================================
-- CHALLENGE SUBMISSIONS
-- ========================================

CREATE TABLE IF NOT EXISTS challenge_submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  challenge_id UUID NOT NULL REFERENCES monthly_challenges(id) ON DELETE CASCADE,
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  votes_count INTEGER DEFAULT 0,
  is_winner BOOLEAN DEFAULT false,
  winner_rank INTEGER, -- 1st, 2nd, 3rd place
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, challenge_id)
);

CREATE INDEX idx_challenge_submissions_challenge ON challenge_submissions(challenge_id);
CREATE INDEX idx_challenge_submissions_user ON challenge_submissions(user_id);
CREATE INDEX idx_challenge_submissions_votes ON challenge_submissions(votes_count DESC);

ALTER TABLE challenge_submissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Challenge submissions are viewable by everyone" ON challenge_submissions
  FOR SELECT USING (true);

CREATE POLICY "Users can create their own submissions" ON challenge_submissions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ========================================
-- CHALLENGE VOTES
-- ========================================

CREATE TABLE IF NOT EXISTS challenge_votes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  submission_id UUID NOT NULL REFERENCES challenge_submissions(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, submission_id)
);

CREATE INDEX idx_challenge_votes_submission ON challenge_votes(submission_id);
CREATE INDEX idx_challenge_votes_user ON challenge_votes(user_id);

ALTER TABLE challenge_votes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Challenge votes are viewable by everyone" ON challenge_votes
  FOR SELECT USING (true);

CREATE POLICY "Users can vote on submissions" ON challenge_votes
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can remove their votes" ON challenge_votes
  FOR DELETE USING (auth.uid() = user_id);

-- ========================================
-- ANALYTICS & TRACKING
-- ========================================

CREATE TABLE IF NOT EXISTS post_views (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID NOT NULL REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES auth.users(id) ON DELETE SET NULL, -- NULL for anonymous views
  viewed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_post_views_post ON post_views(post_id);
CREATE INDEX idx_post_views_date ON post_views(viewed_at);
CREATE INDEX idx_post_views_user ON post_views(user_id);

ALTER TABLE post_views ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Post views are trackable by everyone" ON post_views
  FOR INSERT WITH CHECK (true);

-- ========================================
-- COMMUNITY STATS (Aggregate)
-- ========================================

CREATE TABLE IF NOT EXISTS community_stats (
  stat_date DATE PRIMARY KEY,
  total_posts INTEGER DEFAULT 0,
  total_users INTEGER DEFAULT 0,
  active_users_today INTEGER DEFAULT 0,
  total_likes INTEGER DEFAULT 0,
  total_comments INTEGER DEFAULT 0,
  total_badges_earned INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_community_stats_date ON community_stats(stat_date DESC);

-- ========================================
-- TRIGGERS FOR BADGE SYSTEM
-- ========================================

-- Function to update user badges count
CREATE OR REPLACE FUNCTION update_user_badges_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO user_gamification (user_id, badges_earned, last_badge_earned_at)
    VALUES (NEW.user_id, 1, NOW())
    ON CONFLICT (user_id)
    DO UPDATE SET
      badges_earned = user_gamification.badges_earned + 1,
      last_badge_earned_at = NOW();
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE user_gamification
    SET badges_earned = GREATEST(badges_earned - 1, 0)
    WHERE user_id = OLD.user_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_user_badges_count
  AFTER INSERT OR DELETE ON user_badges
  FOR EACH ROW EXECUTE FUNCTION update_user_badges_count();

-- Function to update challenge votes count
CREATE OR REPLACE FUNCTION update_challenge_votes_count()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE challenge_submissions
    SET votes_count = votes_count + 1
    WHERE id = NEW.submission_id;
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE challenge_submissions
    SET votes_count = GREATEST(votes_count - 1, 0)
    WHERE id = OLD.submission_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_challenge_votes_count
  AFTER INSERT OR DELETE ON challenge_votes
  FOR EACH ROW EXECUTE FUNCTION update_challenge_votes_count();

-- Add foreign key to community_notifications now that badge_definitions exists
-- Use IF NOT EXISTS pattern to make it idempotent
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint 
    WHERE conname = 'fk_community_notifications_badge'
  ) THEN
    ALTER TABLE community_notifications
      ADD CONSTRAINT fk_community_notifications_badge
      FOREIGN KEY (related_badge_id) REFERENCES badge_definitions(id) ON DELETE CASCADE;
  END IF;
END $$;
