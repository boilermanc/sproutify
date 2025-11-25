-- Check tower_id type in my_towers
SELECT
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_name = 'my_towers'
  AND column_name = 'tower_id';

-- Check if tower_id values exist in both tables
SELECT
  mt.tower_id as my_towers_id,
  COUNT(ph.history_id) as ph_ec_records
FROM my_towers mt
LEFT JOIN ph_echistory ph ON mt.tower_id = ph.tower_id
GROUP BY mt.tower_id
ORDER BY mt.tower_id;

-- Show recent ph_echistory records with their tower_id
SELECT
  history_id,
  tower_id,
  ph_value,
  ec_value,
  timestamp
FROM ph_echistory
ORDER BY timestamp DESC
LIMIT 5;
