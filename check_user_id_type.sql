-- Check data types in my_towers
SELECT
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'my_towers'
  AND column_name IN ('user_id', 'tower_id')
ORDER BY column_name;
