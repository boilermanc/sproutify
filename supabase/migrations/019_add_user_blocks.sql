-- ========================================
-- USER BLOCKS TABLE
-- Migration 019: Add User Blocking Functionality
-- ========================================

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ========================================
-- USER BLOCKS
-- ========================================

CREATE TABLE IF NOT EXISTS user_blocks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  blocker_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  blocked_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(blocker_id, blocked_id),
  CHECK (blocker_id != blocked_id) -- Can't block yourself
);

-- Indexes for performance
CREATE INDEX idx_user_blocks_blocker ON user_blocks(blocker_id);
CREATE INDEX idx_user_blocks_blocked ON user_blocks(blocked_id);

-- Row Level Security
ALTER TABLE user_blocks ENABLE ROW LEVEL SECURITY;

-- Users can view their own blocks (who they've blocked)
CREATE POLICY "Users can view their own blocks" ON user_blocks
  FOR SELECT USING (auth.uid() = blocker_id);

-- Users can create blocks (block other users)
CREATE POLICY "Users can block others" ON user_blocks
  FOR INSERT WITH CHECK (auth.uid() = blocker_id);

-- Users can unblock (delete their blocks)
CREATE POLICY "Users can unblock" ON user_blocks
  FOR DELETE USING (auth.uid() = blocker_id);

-- ========================================
-- FUNCTION: Check if user is blocked
-- ========================================

CREATE OR REPLACE FUNCTION is_user_blocked(
  p_blocker_id UUID,
  p_blocked_id UUID
)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM user_blocks
    WHERE blocker_id = p_blocker_id
      AND blocked_id = p_blocked_id
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION is_user_blocked TO authenticated;


