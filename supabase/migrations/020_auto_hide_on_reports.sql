-- ========================================
-- AUTO-HIDE ON MULTIPLE REPORTS
-- Migration 020: Add trigger to auto-hide posts after 3 reports
-- ========================================

-- Function to increment reports_count and auto-hide after 3 reports
CREATE OR REPLACE FUNCTION handle_post_report()
RETURNS TRIGGER AS $$
DECLARE
  current_reports_count INTEGER;
BEGIN
  -- Get current reports count
  SELECT reports_count INTO current_reports_count
  FROM community_posts
  WHERE id = NEW.post_id;

  -- Increment reports_count
  UPDATE community_posts
  SET reports_count = COALESCE(reports_count, 0) + 1
  WHERE id = NEW.post_id;

  -- Auto-hide if reports_count >= 3 (after this increment)
  IF current_reports_count >= 2 THEN -- 2 means this will be the 3rd report
    UPDATE community_posts
    SET is_hidden = true
    WHERE id = NEW.post_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger
DROP TRIGGER IF EXISTS trigger_auto_hide_on_reports ON post_reports;
CREATE TRIGGER trigger_auto_hide_on_reports
  AFTER INSERT ON post_reports
  FOR EACH ROW
  EXECUTE FUNCTION handle_post_report();

-- Grant necessary permissions
GRANT EXECUTE ON FUNCTION handle_post_report() TO authenticated;


