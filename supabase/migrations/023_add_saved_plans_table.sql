-- Create saved_plans table for storing garden plans from Sage AI
CREATE TABLE IF NOT EXISTS saved_plans (
    id SERIAL PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    tower_id INT NOT NULL,
    plan_name VARCHAR(255) NOT NULL,
    plan_data JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX IF NOT EXISTS idx_saved_plans_user_id ON saved_plans(user_id);
CREATE INDEX IF NOT EXISTS idx_saved_plans_tower_id ON saved_plans(tower_id);
CREATE INDEX IF NOT EXISTS idx_saved_plans_user_tower ON saved_plans(user_id, tower_id);

-- Enable RLS
ALTER TABLE saved_plans ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- Users can only see their own plans
CREATE POLICY "Users can view own plans" ON saved_plans
    FOR SELECT
    USING (auth.uid() = user_id);

-- Users can insert their own plans
CREATE POLICY "Users can insert own plans" ON saved_plans
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Users can update their own plans
CREATE POLICY "Users can update own plans" ON saved_plans
    FOR UPDATE
    USING (auth.uid() = user_id);

-- Users can delete their own plans
CREATE POLICY "Users can delete own plans" ON saved_plans
    FOR DELETE
    USING (auth.uid() = user_id);
