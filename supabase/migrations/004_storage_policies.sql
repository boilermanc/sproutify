-- ========================================
-- SPROUTIFY COMMUNITY FEATURE - STORAGE POLICIES
-- Migration 004: Storage Bucket RLS Policies
-- ========================================

-- Note: This assumes the 'community-posts' bucket has already been created
-- in the Supabase Dashboard with public access enabled.

-- ========================================
-- STORAGE POLICIES FOR COMMUNITY POSTS BUCKET
-- ========================================

-- Drop existing policies if they exist (to allow re-running this migration)
DROP POLICY IF EXISTS "Users can upload their own post photos" ON storage.objects;
DROP POLICY IF EXISTS "Public can view post photos" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can view post photos" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own post photos" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own post photos" ON storage.objects;

-- Allow authenticated users to upload photos to their own folder
CREATE POLICY "Users can upload their own post photos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'community-posts' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow public to view all post photos
CREATE POLICY "Public can view post photos"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'community-posts');

-- Allow authenticated users to view all post photos
CREATE POLICY "Authenticated users can view post photos"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'community-posts');

-- Allow users to delete their own photos
CREATE POLICY "Users can delete their own post photos"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'community-posts' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow users to update their own photos (for replacing images)
CREATE POLICY "Users can update their own post photos"
ON storage.objects FOR UPDATE
TO authenticated
USING (
  bucket_id = 'community-posts' AND
  (storage.foldername(name))[1] = auth.uid()::text
)
WITH CHECK (
  bucket_id = 'community-posts' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

