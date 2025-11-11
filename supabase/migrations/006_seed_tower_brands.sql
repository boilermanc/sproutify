-- ========================================
-- SPROUTIFY TOWER BRANDS SEED DATA
-- Migration 006: Populate tower_brands with common aeroponic systems
-- ========================================

BEGIN;

-- Clear existing sample data (except Tower Garden which was migrated)
-- Keep Tower Garden and update it, remove the sample brands we added
DELETE FROM tower_brands WHERE brand_name IN ('AeroSpring', 'Lettuce Grow', 'Other');

-- Update Tower Garden entry with proper display order
UPDATE tower_brands
SET display_order = 1,
    allow_custom_name = false
WHERE brand_name = 'Tower Garden';

-- Insert all the major tower brands
-- Display order roughly based on popularity and price point

INSERT INTO tower_brands (brand_name, brand_logo_url, is_active, display_order, allow_custom_name)
VALUES
  -- Top tier popular systems
  ('Aerospring', NULL, true, 2, false),
  ('Lettuce Grow Farmstand', NULL, true, 3, false),
  ('Gardyn', NULL, true, 4, false),
  ('Rise Gardens', NULL, true, 5, false),

  -- Mid-range popular systems
  ('AeroGarden', NULL, true, 6, false),
  ('EXO Tower', NULL, true, 7, false),
  ('ALTO Garden GX', NULL, true, 8, false),
  ('iHarvest', NULL, true, 9, false),

  -- Budget-friendly options
  ('Nutraponics', NULL, true, 10, false),
  ('AVUX Hydroponic Tower', NULL, true, 11, false),
  ('4P6 Hydro Tower', NULL, true, 12, false),

  -- High capacity systems
  ('ZMXT 80-Pot Tower', NULL, true, 13, false),

  -- Specialty systems
  ('Garden Tower Project', NULL, true, 14, false),
  ('Mother (Forest & MicroPod)', NULL, true, 15, false),
  ('Auk Hydroponic System', NULL, true, 16, false),

  -- Custom/Other option (always last)
  ('Other', NULL, true, 999, true)

ON CONFLICT (id) DO NOTHING;

-- Add helpful comments
COMMENT ON TABLE tower_brands IS 'Catalog of aeroponic and hydroponic tower brands. Users select a brand and specify their port count when adding a tower.';

COMMIT;
