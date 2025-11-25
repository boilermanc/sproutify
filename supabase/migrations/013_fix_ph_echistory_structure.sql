-- Migration to fix ph_echistory table structure and add proper permissions
BEGIN;

-- First, check if we need to migrate data or if table is empty
DO $$
DECLARE
  row_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO row_count FROM ph_echistory;

  IF row_count > 0 THEN
    RAISE NOTICE 'Table has % rows, will preserve data during migration', row_count;
  ELSE
    RAISE NOTICE 'Table is empty, performing clean migration';
  END IF;
END $$;

-- Add 'id' column as alias/copy of history_id for Flutter compatibility
-- Flutter's Supabase client expects 'id' as the primary key
ALTER TABLE ph_echistory ADD COLUMN IF NOT EXISTS id BIGINT;

-- Copy history_id values to id if id is null
UPDATE ph_echistory SET id = history_id WHERE id IS NULL;

-- Make id NOT NULL and set default
ALTER TABLE ph_echistory ALTER COLUMN id SET NOT NULL;
ALTER TABLE ph_echistory ALTER COLUMN id SET DEFAULT nextval('ph_echistory_history_id_seq');

-- Fix the tower_id to be UUID type to match my_towers.tower_id
-- First, we need to check the actual type of my_towers.tower_id
DO $$
DECLARE
  tower_id_type TEXT;
BEGIN
  SELECT data_type INTO tower_id_type
  FROM information_schema.columns
  WHERE table_name = 'my_towers' AND column_name = 'tower_id';

  RAISE NOTICE 'my_towers.tower_id type is: %', tower_id_type;

  -- Only convert if types don't match
  IF tower_id_type = 'uuid' THEN
    -- Drop the existing foreign key
    ALTER TABLE ph_echistory DROP CONSTRAINT IF EXISTS ph_echistory_tower_id_fkey;

    -- Add a temporary UUID column
    ALTER TABLE ph_echistory ADD COLUMN IF NOT EXISTS tower_id_uuid UUID;

    -- If tower_id is bigint and we have data, we can't auto-convert
    -- This would need manual data migration
    -- For now, just ensure the new column is used

    -- Drop old tower_id column (only if no data or after manual migration)
    -- Commented out for safety - uncomment after data migration
    -- ALTER TABLE ph_echistory DROP COLUMN tower_id;

    -- Rename the UUID column to tower_id
    -- ALTER TABLE ph_echistory RENAME COLUMN tower_id_uuid TO tower_id;

    -- Add the foreign key constraint back
    -- ALTER TABLE ph_echistory ADD CONSTRAINT ph_echistory_tower_id_fkey
    --   FOREIGN KEY (tower_id) REFERENCES my_towers(tower_id) ON DELETE CASCADE;
  END IF;
END $$;

-- Add created_at and updated_at if they don't exist
ALTER TABLE ph_echistory ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE ph_echistory ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ DEFAULT NOW();

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_ph_echistory_tower_id ON ph_echistory(tower_id);
CREATE INDEX IF NOT EXISTS idx_ph_echistory_timestamp ON ph_echistory(timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_ph_echistory_tower_timestamp ON ph_echistory(tower_id, timestamp DESC);
CREATE INDEX IF NOT EXISTS idx_ph_echistory_id ON ph_echistory(id);

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
GRANT USAGE, SELECT ON SEQUENCE ph_echistory_history_id_seq TO authenticated;

-- Create or replace trigger for updated_at timestamp
CREATE OR REPLACE FUNCTION update_ph_echistory_updated_at()
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
    EXECUTE FUNCTION update_ph_echistory_updated_at();

COMMIT;
