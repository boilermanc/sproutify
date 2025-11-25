-- Check if RLS is enabled
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE tablename = 'ph_echistory';

-- Check existing policies on ph_echistory
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE tablename = 'ph_echistory'
ORDER BY policyname;

-- Test query as authenticated user would see it
-- This simulates what the Flutter app sees
SELECT COUNT(*) as total_visible_records
FROM ph_echistory;
