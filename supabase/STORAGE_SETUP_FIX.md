# Storage RLS Policy Fix

## Issue
Getting error: "StorageException(message: new row violates row-level security policy, statusCode: 403, error: Unauthorized)"

This means the storage bucket RLS policies are not set up correctly.

## Solution

### Step 1: Verify Bucket Exists
1. Go to Supabase Dashboard → Storage
2. Check if `community-posts` bucket exists
3. If not, create it:
   - Click "New Bucket"
   - Name: `community-posts`
   - Public bucket: `true` (checked)
   - Click "Create"

### Step 2: Run Storage Policies Migration
1. Go to Supabase Dashboard → SQL Editor
2. Run the migration file: `supabase/migrations/004_storage_policies.sql`
   - Or copy/paste the SQL below

### Step 3: Verify Policies
Run this query to check policies exist:
```sql
SELECT policyname, cmd, qual, with_check
FROM pg_policies
WHERE schemaname = 'storage'
  AND tablename = 'objects'
  AND policyname LIKE '%post%';
```

You should see 4-5 policies for the community-posts bucket.

## Quick Fix SQL

Run this in Supabase SQL Editor:

```sql
-- Drop existing policies if they exist (to allow re-running)
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

-- Allow users to update their own photos
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
```

## How It Works

The upload path format is: `{user_id}/post_{timestamp}.{ext}`

For example: `a1b2c3d4-5678-90ab-cdef-1234567890ab/post_1234567890.jpg`

The RLS policy checks that the first folder (`storage.foldername(name))[1]`) matches the authenticated user's UUID (`auth.uid()::text`).

## After Running

1. Try creating a post again
2. The upload should work now
3. Photos will be stored in: `community-posts/{user_id}/post_{timestamp}.{ext}`

