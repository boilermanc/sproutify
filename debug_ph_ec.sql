-- Check if ph_echistory table has data
SELECT
  COUNT(*) as total_records,
  COUNT(ph_value) as records_with_ph,
  COUNT(ec_value) as records_with_ec,
  MIN(timestamp) as earliest,
  MAX(timestamp) as latest
FROM ph_echistory;

-- Show recent records
SELECT
  history_id,
  tower_id,
  ph_value,
  ec_value,
  timestamp,
  created_at
FROM ph_echistory
ORDER BY timestamp DESC
LIMIT 10;

-- Check tower_id type
SELECT
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_name = 'ph_echistory'
ORDER BY ordinal_position;
