-- Fix the refresh function to handle both concurrent and non-concurrent refresh
CREATE OR REPLACE FUNCTION refresh_usertowerdetails()
RETURNS void AS $$
BEGIN
  -- Try concurrent refresh first (faster, doesn't lock the view)
  BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY usertowerdetails;
  EXCEPTION
    WHEN OTHERS THEN
      -- If concurrent refresh fails, fall back to regular refresh
      -- This can happen if the view hasn't been populated yet
      REFRESH MATERIALIZED VIEW usertowerdetails;
  END;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION refresh_usertowerdetails() TO authenticated;

COMMENT ON FUNCTION refresh_usertowerdetails() IS
  'Refreshes the usertowerdetails materialized view. Attempts concurrent refresh first, falls back to regular refresh if needed.';
