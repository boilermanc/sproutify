-- ========================================
-- SPROUTIFY GENERIC AEROPONIC TOWER SUPPORT
-- Migration 005: Convert from Tower Garden specific to multi-brand support
-- ========================================

-- This migration transforms the tower system from Tower Garden specific
-- to support any aeroponic tower brand with user-defined port counts

BEGIN;

-- ========================================
-- STEP 1: Drop dependent objects first
-- ========================================

-- Drop the view so we can modify the underlying tables
-- Handle both regular VIEW and MATERIALIZED VIEW cases
DROP VIEW IF EXISTS usertowerdetails CASCADE;
DROP MATERIALIZED VIEW IF EXISTS usertowerdetails CASCADE;

-- ========================================
-- STEP 2: Rename and restructure tower_gardens table to tower_brands
-- ========================================

-- Rename the table to better reflect its new purpose
ALTER TABLE tower_gardens RENAME TO tower_brands;

-- Rename the 'tower_garden' column to 'brand_name' for clarity
ALTER TABLE tower_brands RENAME COLUMN tower_garden TO brand_name;

-- Rename the corporate image column to be brand-agnostic
ALTER TABLE tower_brands RENAME COLUMN tg_corp_image TO brand_logo_url;

-- Remove the ports column (users will specify their own port count)
ALTER TABLE tower_brands DROP COLUMN ports;

-- Add new columns for better brand management
ALTER TABLE tower_brands ADD COLUMN IF NOT EXISTS display_order INTEGER DEFAULT 0;
ALTER TABLE tower_brands ADD COLUMN IF NOT EXISTS allow_custom_name BOOLEAN DEFAULT false;

-- Update the existing Tower Garden record
UPDATE tower_brands
SET display_order = 1,
    allow_custom_name = false
WHERE brand_name = 'Tower Garden';

-- Add example brand entries (you can add real brands later with logos)
INSERT INTO tower_brands (brand_name, brand_logo_url, is_active, display_order, allow_custom_name)
VALUES
  ('AeroSpring', NULL, true, 2, false),
  ('Lettuce Grow', NULL, true, 3, false),
  ('Other', NULL, true, 999, true)
ON CONFLICT DO NOTHING;

-- ========================================
-- STEP 3: Add port_count to my_towers table
-- ========================================

-- Add port_count column to store user-specified port counts
ALTER TABLE my_towers ADD COLUMN IF NOT EXISTS port_count INTEGER;

-- Migrate existing towers to have 20 ports (the default Tower Garden count)
UPDATE my_towers
SET port_count = 20
WHERE port_count IS NULL;

-- Make port_count required for new towers
ALTER TABLE my_towers ALTER COLUMN port_count SET NOT NULL;

-- Add constraint to ensure port_count is reasonable (between 1 and 100)
ALTER TABLE my_towers ADD CONSTRAINT port_count_range
  CHECK (port_count > 0 AND port_count <= 100);

-- Rename tower_garden_id to tower_brand_id for clarity
ALTER TABLE my_towers RENAME COLUMN tower_garden_id TO tower_brand_id;

-- ========================================
-- STEP 4: Recreate the usertowerdetails materialized view
-- ========================================

-- Recreate the view with the new structure (was dropped in STEP 1)
CREATE MATERIALIZED VIEW usertowerdetails AS
SELECT
  u.id AS user_id,
  u.email AS user_email,
  mt.tower_id,
  mt.tower_name,
  tb.brand_name AS tower_type,
  mt.port_count AS ports,  -- Now comes from my_towers, not tower_brands
  mt.indoor_outdoor,
  mt.archive,
  tb.brand_logo_url AS tg_corp_image,

  -- pH and EC monitoring data from ph_echistory table (latest values)
  ph_ec_latest.ph_value AS latest_ph_value,
  NULL::text AS ph_image_url,
  NULL::text AS ph_review,
  NULL::text AS review_image_url,

  ph_ec_latest.ec_value AS latest_ec_value,
  NULL::text AS ec_image_url,
  NULL::text AS ec_review,
  NULL::text AS ec_review_image_url

FROM auth.users u
INNER JOIN my_towers mt ON u.id::text = mt.user_id::text
LEFT JOIN tower_brands tb ON mt.tower_brand_id = tb.id
LEFT JOIN LATERAL (
  SELECT ph_value, ec_value
  FROM ph_echistory
  WHERE tower_id = mt.tower_id
  ORDER BY timestamp DESC
  LIMIT 1
) ph_ec_latest ON true;

-- Create index for performance
CREATE UNIQUE INDEX idx_usertowerdetails_user_tower ON usertowerdetails(user_id, tower_id);
CREATE INDEX idx_usertowerdetails_user ON usertowerdetails(user_id);

-- Enable periodic refresh (optional - adjust as needed)
-- This can be triggered by your application or a cron job
COMMENT ON MATERIALIZED VIEW usertowerdetails IS 'Denormalized view of user towers with latest pH/EC data. Refresh periodically.';

-- ========================================
-- STEP 5: Update any foreign key references
-- ========================================

-- Update foreign key constraint name in my_towers if it exists
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'my_towers_tower_garden_id_fkey'
  ) THEN
    ALTER TABLE my_towers DROP CONSTRAINT my_towers_tower_garden_id_fkey;
  END IF;
END $$;

-- Add the new foreign key with updated name
ALTER TABLE my_towers
  ADD CONSTRAINT my_towers_tower_brand_id_fkey
  FOREIGN KEY (tower_brand_id)
  REFERENCES tower_brands(id)
  ON DELETE SET NULL;

-- ========================================
-- STEP 6: Create helper function to refresh the materialized view
-- ========================================

CREATE OR REPLACE FUNCTION refresh_usertowerdetails()
RETURNS void AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY usertowerdetails;
END;
$$ LANGUAGE plpgsql;

-- ========================================
-- SUMMARY OF CHANGES
-- ========================================

-- Tables renamed:
--   tower_gardens → tower_brands

-- Columns renamed in tower_brands:
--   tower_garden → brand_name
--   tg_corp_image → brand_logo_url

-- Columns removed from tower_brands:
--   ports (moved to my_towers)

-- Columns added to tower_brands:
--   display_order (for sorting brands in UI)
--   allow_custom_name (for "Other" brand that allows custom names)

-- Columns renamed in my_towers:
--   tower_garden_id → tower_brand_id

-- Columns added to my_towers:
--   port_count (user-specified number of ports, migrated existing to 20)

-- Views recreated:
--   usertowerdetails (now pulls ports from my_towers instead of tower_brands)

COMMIT;
