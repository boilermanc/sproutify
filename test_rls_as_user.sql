-- Test if RLS is working correctly
-- First, check if RLS is enabled
SELECT tablename, rowsecurity
FROM pg_tables
WHERE tablename = 'ph_echistory';

-- Check what policies exist
SELECT policyname, cmd, roles
FROM pg_policies
WHERE tablename = 'ph_echistory';

-- Check if user_id in my_towers is UUID or text
SELECT
  column_name,
  data_type
FROM information_schema.columns
WHERE table_name = 'my_towers'
  AND column_name IN ('user_id', 'tower_id');

-- Test the policy condition - see if tower_ids would match
-- This simulates what the RLS policy checks
SELECT
  mt.tower_id,
  mt.user_id,
  COUNT(ph.history_id) as ph_ec_count
FROM my_towers mt
LEFT JOIN ph_echistory ph ON mt.tower_id = ph.tower_id
GROUP BY mt.tower_id, mt.user_id
HAVING COUNT(ph.history_id) > 0
ORDER BY ph_ec_count DESC
LIMIT 10;
