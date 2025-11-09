# Next Steps After Running Migrations

## ✅ Step 1: Verify Migrations Worked

Run these queries in Supabase SQL Editor to verify everything is set up:

### Check Tables Exist
```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND (table_name LIKE '%community%' OR table_name LIKE '%badge%')
ORDER BY table_name;
```

**Expected:** Should see ~20+ tables including:
- `community_posts`
- `post_likes`
- `user_badges`
- `badge_definitions`
- etc.

### Check Badges Were Seeded
```sql
SELECT category, COUNT(*) as badge_count
FROM badge_definitions
GROUP BY category
ORDER BY category;
```

**Expected:** ~14 categories with 80+ total badges

### Check RLS Policies
```sql
SELECT tablename, policyname
FROM pg_policies
WHERE schemaname = 'public'
  AND (tablename LIKE '%community%' OR tablename LIKE '%badge%')
ORDER BY tablename, policyname;
```

**Expected:** Multiple policies per table

---

## 📦 Step 2: Create Storage Bucket

1. Go to **Storage** in Supabase Dashboard
2. Click **New Bucket**
3. Name: `community-posts`
4. **Public bucket:** `true` (so photos are viewable)
5. Click **Create**

### Set Up Storage Policies

Run this in SQL Editor:

```sql
-- Allow authenticated users to upload
CREATE POLICY "Users can upload their own post photos"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'community-posts' AND
  (storage.foldername(name))[1] = auth.uid()::text
);

-- Allow public to view
CREATE POLICY "Public can view post photos"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'community-posts');

-- Allow users to delete their own photos
CREATE POLICY "Users can delete their own post photos"
ON storage.objects FOR DELETE
TO authenticated
USING (
  bucket_id = 'community-posts' AND
  (storage.foldername(name))[1] = auth.uid()::text
);
```

---

## 🔧 Step 3: Run Database Functions

Run each function file in SQL Editor (in order):

### 1. get_personalized_feed.sql
- Returns posts for user's feed with relevance scoring
- Supports: 'for_you', 'following', 'recent', 'popular' feeds

### 2. toggle_post_like.sql
- Like/unlike posts with notifications
- Handles counters, notifications, and badge progress

### 3. check_and_award_badges.sql
- Checks progress and awards badges
- Called by other functions automatically

### 4. create_community_post.sql
- Create post with tags and hashtags
- Handles plant tags, hashtags, and badge checks

### 5. get_user_badges.sql
- Get user's badge collection
- Returns earned and locked badges with progress

**How to run:**
1. Open each `.sql` file in `supabase/functions/`
2. Copy all contents
3. Paste into SQL Editor
4. Click Run

---

## 🧪 Step 4: Test with Sample Data

### Create a Test Post

Replace `'your-user-id'` with an actual user UUID from your `auth.users` table:

```sql
-- Get your user ID first
SELECT id, email FROM auth.users LIMIT 1;

-- Then create a test post (replace 'your-user-id' with actual UUID)
SELECT create_community_post(
  p_user_id := 'your-user-id'::UUID,
  p_photo_url := 'https://picsum.photos/800',
  p_photo_aspect_ratio := 1.00,
  p_caption := 'Test post from Supabase! 🌱',
  p_plant_ids := ARRAY[]::INTEGER[], -- Add actual plant IDs if you want
  p_hashtag_tags := ARRAY['test', 'firstpost']
);
```

### Check Badge Award

```sql
-- This should award the "First Post" badge
SELECT * FROM user_badges
WHERE user_id = 'your-user-id'::UUID;

SELECT * FROM user_gamification
WHERE user_id = 'your-user-id'::UUID;
```

### Test Feed

```sql
-- Get personalized feed
SELECT * FROM get_personalized_feed('your-user-id'::UUID, 'recent', 20, 0);
```

### Test Like

```sql
-- Get a post ID first
SELECT id FROM community_posts LIMIT 1;

-- Then like it (replace 'post-id' with actual post UUID)
SELECT toggle_post_like('post-id'::UUID, 'your-user-id'::UUID);

-- Check notification was created
SELECT * FROM community_notifications
WHERE user_id = 'post-owner-id'::UUID
ORDER BY created_at DESC
LIMIT 5;
```

---

## 🎯 Step 5: Initialize User Profiles

When users first access the community feature, create their profile:

```sql
-- Create a function to auto-initialize
CREATE OR REPLACE FUNCTION initialize_community_user(p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  -- Create community profile
  INSERT INTO user_community_profiles (user_id)
  VALUES (p_user_id)
  ON CONFLICT (user_id) DO NOTHING;

  -- Create gamification record
  INSERT INTO user_gamification (user_id)
  VALUES (p_user_id)
  ON CONFLICT (user_id) DO NOTHING;

  -- Award "Seed Starter" badge
  INSERT INTO badge_progress (user_id, badge_category, current_value)
  VALUES (p_user_id, 'account_created', 1)
  ON CONFLICT (user_id, badge_category) DO NOTHING;

  PERFORM check_and_award_badges(p_user_id, 'account_created');

  RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION initialize_community_user(UUID) TO authenticated;
```

---

## ✅ Verification Checklist

- [ ] Tables created (20+ tables)
- [ ] Badges seeded (80+ badges)
- [ ] RLS policies active
- [ ] Storage bucket created
- [ ] Storage policies set up
- [ ] Functions created (5 functions)
- [ ] Test post created successfully
- [ ] Badge awarded correctly
- [ ] Feed query works
- [ ] Like functionality works

---

## 🚀 You're Ready!

Once all steps are complete, you can:
1. Start building Flutter UI components
2. Set up n8n workflows (see N8N_COMMUNITY_AUTOMATIONS.md)
3. Design badge icons
4. Test with real users

---

## 📞 Need Help?

If something doesn't work:
1. Check Supabase logs: Dashboard → Logs → Postgres Logs
2. Review error messages carefully
3. Check the COMMUNITY_SETUP_GUIDE.md for more details

