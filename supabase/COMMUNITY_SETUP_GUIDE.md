## Sproutify Community Feature - Setup Guide

This guide will walk you through setting up the complete community feature including Instagram-style posts, badges, and gamification.

---

## Prerequisites

- Supabase project created
- Supabase CLI installed (optional, but recommended)
- Access to Supabase SQL Editor
- Basic understanding of SQL

---

## Step 1: Run Database Migrations

Run the migrations in order. You can do this through the Supabase Dashboard SQL Editor or using the Supabase CLI.

### Option A: Using Supabase Dashboard

1. Go to your Supabase project
2. Navigate to **SQL Editor** in the sidebar
3. Create a new query
4. Copy and paste the contents of each migration file in order:

#### Migration 1: Core Community Tables
File: `migrations/001_community_core_tables.sql`

This creates:
- `community_posts` - Main posts table
- `post_plant_tags` - Link posts to plants
- `hashtags` & `post_hashtags` - Hashtag system
- `post_likes` - Like functionality
- `post_bookmarks` - Save posts
- `post_comments` - Comments (Phase 2)
- `post_reports` - Content moderation
- `user_follows` - Follow system
- `user_community_profiles` - Extended user profiles
- `community_notifications` - In-app notifications
- Automatic triggers for counter updates

**Run this first!**

#### Migration 2: Badge System
File: `migrations/002_badge_system.sql`

This creates:
- `badge_definitions` - All available badges
- `user_badges` - Badges users have earned
- `user_gamification` - XP, levels, streaks
- `badge_progress` - Track progress toward badges
- `monthly_challenges` - Challenge system
- `challenge_submissions` & `challenge_votes` - Challenge entries
- `post_views` - Track post views
- `community_stats` - Aggregate statistics

**Run this second!**

#### Migration 3: Badge Seed Data
File: `migrations/003_badge_seed_data.sql`

This inserts 80+ initial badges across categories:
- Getting Started (5 badges)
- Harvest (7 badges)
- Plant Variety (4 badges)
- Expertise (5 badges)
- Community Engagement (17 badges)
- Consistency & Dedication (5 badges)
- Tower Management (7 badges)
- Plant Collection (4 badges)
- Water Quality (3 badges)
- Cost Tracking (4 badges)
- Rating & Review (4 badges)
- Challenges (4 badges)
- Seasonal (4 badges)
- Milestones (4 badges)
- Meta Badges (4 badges)

**Run this third!**

### Option B: Using Supabase CLI

```bash
# Navigate to project directory
cd c:\Users\clint\Github\sproutify

# Run migrations in order
supabase db push

# Or manually execute each file
supabase db execute -f supabase/migrations/001_community_core_tables.sql
supabase db execute -f supabase/migrations/002_badge_system.sql
supabase db execute -f supabase/migrations/003_badge_seed_data.sql
```

---

## Step 2: Create Supabase Functions

These are PostgreSQL functions that handle complex operations efficiently.

Run each function file through the SQL Editor:

1. **get_personalized_feed.sql** - Returns posts for user's feed with relevance scoring
   - Supports: 'for_you', 'following', 'recent', 'popular' feeds

2. **toggle_post_like.sql** - Like/unlike posts with notifications
   - Handles counters, notifications, and badge progress

3. **check_and_award_badges.sql** - Checks progress and awards badges
   - Called by other functions automatically
   - Can be triggered manually

4. **create_community_post.sql** - Create post with tags and hashtags
   - Handles plant tags, hashtags, and badge checks

5. **get_user_badges.sql** - Get user's badge collection
   - Returns earned and locked badges with progress

### Execute these in the SQL Editor:

```sql
-- Copy and paste contents of each file into SQL Editor and run
```

---

## Step 3: Set Up Storage Bucket

Create a storage bucket for community post photos:

1. Go to **Storage** in Supabase Dashboard
2. Click **New Bucket**
3. Name: `community-posts`
4. Public bucket: `true` (so photos are viewable)
5. Create the bucket

### Set Up Storage Policies

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

### Recommended Folder Structure

```
community-posts/
├── {user_id}/
│   ├── post_{post_id}_original.jpg
│   ├── post_{post_id}_1080.jpg (feed size)
│   ├── post_{post_id}_480.jpg (thumbnail)
│   └── post_{post_id}_240.jpg (tiny)
```

---

## Step 4: Verify Installation

Run these queries to verify everything is set up correctly:

```sql
-- Check tables exist
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name LIKE '%community%'
ORDER BY table_name;

-- Check badges were seeded
SELECT category, COUNT(*) as badge_count
FROM badge_definitions
GROUP BY category
ORDER BY category;

-- Check functions exist
SELECT routine_name
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND routine_name LIKE '%badge%' OR routine_name LIKE '%post%'
ORDER BY routine_name;

-- Check RLS policies
SELECT tablename, policyname
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename LIKE '%community%'
ORDER BY tablename, policyname;
```

Expected results:
- ~20+ community tables
- ~80 badges across 14 categories
- 5 functions
- Multiple RLS policies per table

---

## Step 5: Test the System

### Create a Test Post

```sql
-- Replace 'your-user-id' with actual user UUID
SELECT create_community_post(
  p_user_id := 'your-user-id'::UUID,
  p_photo_url := 'https://picsum.photos/800',
  p_photo_aspect_ratio := 1.00,
  p_caption := 'Test post from Supabase!',
  p_plant_ids := ARRAY[]::UUID[], -- Add actual plant UUIDs if you want
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
SELECT * FROM get_personalized_feed('your-user-id'::UUID, 'for_you', 20, 0);
```

### Test Like

```sql
-- Like a post
SELECT toggle_post_like('post-id'::UUID, 'your-user-id'::UUID);

-- Check notification was created
SELECT * FROM community_notifications
WHERE user_id = 'post-owner-id'::UUID
ORDER BY created_at DESC
LIMIT 5;
```

---

## Step 6: Configure Badge Icons (Optional)

Update badge definitions with icon URLs:

```sql
-- Upload badge icons to Supabase Storage first, then:
UPDATE badge_definitions
SET icon_url = 'https://your-project.supabase.co/storage/v1/object/public/badges/first_post.png'
WHERE name = 'First Post';

-- Or bulk update with a pattern
UPDATE badge_definitions
SET icon_url = 'https://your-project.supabase.co/storage/v1/object/public/badges/' ||
               LOWER(REPLACE(name, ' ', '_')) || '.png';
```

---

## Step 7: Set Up Initial User Profiles

When users first access the community feature, create their profile:

```sql
-- This can be done automatically via a trigger or Flutter code
INSERT INTO user_community_profiles (user_id, is_public, show_location, show_stats)
VALUES ('user-id'::UUID, true, true, true)
ON CONFLICT (user_id) DO NOTHING;

INSERT INTO user_gamification (user_id, total_xp, current_level)
VALUES ('user-id'::UUID, 0, 1)
ON CONFLICT (user_id) DO NOTHING;
```

Or create a function to auto-initialize:

```sql
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

-- Call this when user first opens community tab
SELECT initialize_community_user(auth.uid());
```

---

## Integration with Existing Tables

The community feature integrates with your existing Sproutify tables:

### Plants Integration
```sql
-- community_posts.tower_id → my_towers.id
-- post_plant_tags.plant_id → plants.id
```

### User Integration
```sql
-- All user_id fields reference auth.users(id)
-- Profiles pulled from existing profiles table
```

### Example Query: Posts with User's Plants
```sql
SELECT cp.*, p.common_name
FROM community_posts cp
JOIN post_plant_tags ppt ON cp.id = ppt.post_id
JOIN plants p ON ppt.plant_id = p.id
JOIN userplants up ON p.id = up.plant_id
WHERE up.user_id = auth.uid()
ORDER BY cp.created_at DESC;
```

---

## Performance Considerations

### Indexes Created
All critical indexes are created in the migration files:
- Post lookups by user, date, likes, featured status
- Like/bookmark/follow lookups
- Badge lookups by user and category
- Notification lookups by user and read status

### Recommended: Add Composite Indexes Later

If performance becomes an issue with large datasets:

```sql
-- Composite index for feed queries
CREATE INDEX idx_posts_approved_hidden_created
ON community_posts(is_approved, is_hidden, created_at DESC)
WHERE is_approved = true AND is_hidden = false;

-- Index for user's post history
CREATE INDEX idx_posts_user_created
ON community_posts(user_id, created_at DESC);
```

---

## Security Notes

### Row Level Security (RLS)
All tables have RLS enabled with appropriate policies:
- Users can only edit/delete their own content
- All approved content is publicly viewable
- Users can only see their own bookmarks/notifications

### Function Security
All functions use `SECURITY DEFINER` to run with elevated privileges:
- Ensures proper permission checks
- Prevents users from bypassing RLS
- Grants are limited to `authenticated` role

---

## Next Steps

1. **Flutter Integration** - Create Dart models and API calls
2. **n8n Workflows** - Set up automation (see N8N_COMMUNITY_AUTOMATIONS.md)
3. **Badge Icons** - Design and upload badge icons
4. **Test Data** - Create sample posts and users for testing
5. **Moderation Dashboard** - Build admin tools for content moderation

---

## Troubleshooting

### Migration Errors

**Error: "relation already exists"**
- Tables might already be created
- Use `DROP TABLE IF EXISTS` or skip to next migration

**Error: "column does not exist"**
- Check that migrations ran in order
- Verify previous migration completed successfully

**Error: "foreign key constraint"**
- Ensure referenced tables exist (auth.users, plants, my_towers)
- Check that user IDs are valid UUIDs

### Function Errors

**Error: "function does not exist"**
- Ensure function was created successfully
- Check for syntax errors in function definition

**Error: "permission denied"**
- Run: `GRANT EXECUTE ON FUNCTION function_name TO authenticated;`

### RLS Policy Issues

**Can't see data even though it exists**
- Check RLS is enabled: `ALTER TABLE table_name ENABLE ROW LEVEL SECURITY;`
- Verify policies exist: `SELECT * FROM pg_policies WHERE tablename = 'table_name';`
- Test with: `SET ROLE authenticated;` then query

---

## Rollback

If you need to remove the community feature:

```sql
-- Drop tables in reverse order (respects foreign keys)
DROP TABLE IF EXISTS community_stats CASCADE;
DROP TABLE IF EXISTS post_views CASCADE;
DROP TABLE IF EXISTS challenge_votes CASCADE;
DROP TABLE IF EXISTS challenge_submissions CASCADE;
DROP TABLE IF EXISTS monthly_challenges CASCADE;
DROP TABLE IF EXISTS badge_progress CASCADE;
DROP TABLE IF EXISTS user_gamification CASCADE;
DROP TABLE IF EXISTS user_badges CASCADE;
DROP TABLE IF EXISTS badge_definitions CASCADE;
DROP TABLE IF EXISTS community_notifications CASCADE;
DROP TABLE IF EXISTS user_community_profiles CASCADE;
DROP TABLE IF EXISTS user_follows CASCADE;
DROP TABLE IF EXISTS post_reports CASCADE;
DROP TABLE IF EXISTS post_comments CASCADE;
DROP TABLE IF EXISTS post_bookmarks CASCADE;
DROP TABLE IF EXISTS post_likes CASCADE;
DROP TABLE IF EXISTS post_hashtags CASCADE;
DROP TABLE IF EXISTS hashtags CASCADE;
DROP TABLE IF EXISTS post_plant_tags CASCADE;
DROP TABLE IF EXISTS community_posts CASCADE;

-- Drop functions
DROP FUNCTION IF EXISTS get_user_badges CASCADE;
DROP FUNCTION IF EXISTS create_community_post CASCADE;
DROP FUNCTION IF EXISTS check_and_award_badges CASCADE;
DROP FUNCTION IF EXISTS toggle_post_like CASCADE;
DROP FUNCTION IF EXISTS get_personalized_feed CASCADE;
DROP FUNCTION IF EXISTS initialize_community_user CASCADE;
```

---

## Support

For issues or questions:
1. Check the detailed specification docs:
   - `INSTAGRAM_STYLE_SHOWCASE_DETAILED.md`
   - `N8N_COMMUNITY_AUTOMATIONS.md`
2. Review Supabase logs in Dashboard
3. Test queries in SQL Editor
4. Check the GitHub issues

---

## Database Schema Diagram

```
auth.users (Supabase Auth)
    ↓
user_community_profiles (bio, stats, settings)
user_gamification (XP, level, streaks)
    ↓
community_posts ← post_plant_tags → plants
    ↓            ↓
post_likes   post_hashtags → hashtags
post_comments
post_bookmarks
post_reports
post_views
    ↓
user_follows (follower/following)
    ↓
community_notifications
    ↓
badge_definitions
    ↓
user_badges ← user_gamification
badge_progress
    ↓
monthly_challenges
    ↓
challenge_submissions ← challenge_votes
```

---

## Quick Reference: Function Usage

```sql
-- Create a post
SELECT create_community_post(
  auth.uid(),
  'https://photo-url.jpg',
  1.00,
  'My caption',
  'tower-uuid'::UUID,
  'Seattle',
  'WA',
  ARRAY['plant-uuid']::UUID[],
  ARRAY['firstharvest']
);

-- Get feed
SELECT * FROM get_personalized_feed(auth.uid(), 'for_you', 20, 0);

-- Like a post
SELECT toggle_post_like('post-uuid'::UUID, auth.uid());

-- Get badges
SELECT get_user_badges(auth.uid(), 'all');

-- Check for badge awards
SELECT check_and_award_badges(auth.uid(), 'post_count');

-- Initialize new user
SELECT initialize_community_user(auth.uid());
```

---

Ready to build! 🚀
