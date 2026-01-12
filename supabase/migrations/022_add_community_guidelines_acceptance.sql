-- ========================================
-- COMMUNITY GUIDELINES ACCEPTANCE
-- Migration 022: Add community guidelines acceptance tracking
-- ========================================

-- Add column to profiles table to track when user accepted guidelines
ALTER TABLE profiles
  ADD COLUMN IF NOT EXISTS community_guidelines_accepted_at TIMESTAMP WITH TIME ZONE;

-- Add index for quick lookups
CREATE INDEX IF NOT EXISTS idx_profiles_guidelines_accepted 
  ON profiles(community_guidelines_accepted_at) 
  WHERE community_guidelines_accepted_at IS NOT NULL;

-- Comment
COMMENT ON COLUMN profiles.community_guidelines_accepted_at IS 
  'Timestamp when user accepted the community guidelines. NULL means not accepted yet.';



