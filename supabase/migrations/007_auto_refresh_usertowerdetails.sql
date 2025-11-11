-- ========================================
-- AUTO-REFRESH MATERIALIZED VIEW TRIGGER
-- Migration 007: Auto-refresh usertowerdetails when my_towers changes
-- ========================================

-- This migration creates a trigger that automatically refreshes the
-- usertowerdetails materialized view whenever my_towers is updated

BEGIN;

-- Create a function that refreshes the materialized view
-- This function runs with SECURITY DEFINER so it has permission to refresh the view
CREATE OR REPLACE FUNCTION refresh_usertowerdetails_trigger()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  -- Refresh the materialized view when my_towers changes
  REFRESH MATERIALIZED VIEW CONCURRENTLY usertowerdetails;
  RETURN NULL;
END;
$$;

-- Create a trigger that fires after INSERT, UPDATE, or DELETE on my_towers
DROP TRIGGER IF EXISTS auto_refresh_usertowerdetails ON my_towers;

CREATE TRIGGER auto_refresh_usertowerdetails
  AFTER INSERT OR UPDATE OR DELETE ON my_towers
  FOR EACH ROW
  EXECUTE FUNCTION refresh_usertowerdetails_trigger();

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION refresh_usertowerdetails_trigger() TO authenticated;

COMMENT ON FUNCTION refresh_usertowerdetails_trigger() IS 
  'Automatically refreshes usertowerdetails materialized view when my_towers changes';

COMMIT;

