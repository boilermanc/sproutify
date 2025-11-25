-- Migration to ensure ph_echistory table has proper permissions
-- This migration is idempotent and safe to run multiple times

BEGIN;

-- Create the table if it doesn't exist
CREATE TABLE IF NOT EXISTS ph_echistory (
    id BIGSERIAL PRIMARY KEY,
    tower_id UUID NOT NULL REFERENCES my_towers(tower_id) ON DELETE CASCADE,
    timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    ph_value DOUBLE PRECISION,
    ec_value DOUBLE PRECISION,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Ensure at least one value is provided
    CONSTRAINT at_least_one_value CHECK (ph_value IS NOT NULL OR ec_value IS NOT NULL)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_ph_echistory_tower_id ON ph_echistory(tower_id);
CREATE INDEX IF NOT EXISTS idx_ph_echistory_timestamp ON ph_echistory(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_ph_echistory_tower_timestamp ON ph_echistory(tower_id, timestamp DESC);

-- Enable Row Level Security
ALTER TABLE ph_echistory ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can view pH/EC history for their own towers" ON ph_echistory;
DROP POLICY IF EXISTS "Users can insert pH/EC history for their own towers" ON ph_echistory;
DROP POLICY IF EXISTS "Users can update pH/EC history for their own towers" ON ph_echistory;
DROP POLICY IF EXISTS "Users can delete pH/EC history for their own towers" ON ph_echistory;

-- Create RLS policies for ph_echistory
-- SELECT: Users can view history for their own towers
CREATE POLICY "Users can view pH/EC history for their own towers"
    ON ph_echistory
    FOR SELECT
    TO authenticated
    USING (
        tower_id IN (
            SELECT tower_id FROM my_towers WHERE user_id::text = auth.uid()::text
        )
    );

-- INSERT: Users can insert history for their own towers
CREATE POLICY "Users can insert pH/EC history for their own towers"
    ON ph_echistory
    FOR INSERT
    TO authenticated
    WITH CHECK (
        tower_id IN (
            SELECT tower_id FROM my_towers WHERE user_id::text = auth.uid()::text
        )
    );

-- UPDATE: Users can update history for their own towers
CREATE POLICY "Users can update pH/EC history for their own towers"
    ON ph_echistory
    FOR UPDATE
    TO authenticated
    USING (
        tower_id IN (
            SELECT tower_id FROM my_towers WHERE user_id::text = auth.uid()::text
        )
    )
    WITH CHECK (
        tower_id IN (
            SELECT tower_id FROM my_towers WHERE user_id::text = auth.uid()::text
        )
    );

-- DELETE: Users can delete history for their own towers
CREATE POLICY "Users can delete pH/EC history for their own towers"
    ON ph_echistory
    FOR DELETE
    TO authenticated
    USING (
        tower_id IN (
            SELECT tower_id FROM my_towers WHERE user_id::text = auth.uid()::text
        )
    );

-- Grant necessary permissions to authenticated users
GRANT SELECT, INSERT, UPDATE, DELETE ON ph_echistory TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE ph_echistory_id_seq TO authenticated;

-- Create or replace trigger for updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_ph_echistory_updated_at ON ph_echistory;

CREATE TRIGGER update_ph_echistory_updated_at
    BEFORE UPDATE ON ph_echistory
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comment to table
COMMENT ON TABLE ph_echistory IS 'Stores pH and EC measurements for towers over time. Each record can contain either pH, EC, or both values.';

COMMIT;
