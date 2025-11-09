# Running Community Migrations on Remote Supabase

## ✅ Pre-Flight Checklist

Before running migrations, verify:

1. **You have access to Supabase Dashboard**
   - Go to: https://supabase.com/dashboard
   - Select your project

2. **You know your project URL**
   - Found in: Settings → API
   - Format: `https://xxxxx.supabase.co`

3. **You have SQL Editor access**
   - Navigate to: SQL Editor in left sidebar

4. **Backup your database** (recommended)
   - Go to: Database → Backups
   - Create a manual backup before running migrations

---

## 🚀 Running Migrations (Remote Supabase)

Since you're using **remote Supabase** (not local), you'll run migrations through the **Supabase Dashboard SQL Editor**.

### Step 1: Open SQL Editor

1. Go to your Supabase project dashboard
2. Click **SQL Editor** in the left sidebar
3. Click **New Query**

### Step 2: Run Migration 001 (Core Tables)

1. Open the file: `supabase/migrations/001_community_core_tables.sql`
2. Copy **ALL** contents (Ctrl+A, Ctrl+C)
3. Paste into SQL Editor
4. Click **Run** (or press Ctrl+Enter)
5. Wait for success message: ✅ "Success. No rows returned"

**What this creates:**
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

**Expected time:** 5-10 seconds

---

### Step 3: Run Migration 002 (Badge System)

1. Open the file: `supabase/migrations/002_badge_system.sql`
2. Copy **ALL** contents
3. Paste into SQL Editor (new query)
4. Click **Run**

**What this creates:**
- `badge_definitions` - All available badges
- `user_badges` - Badges users have earned
- `user_gamification` - XP, levels, streaks
- `badge_progress` - Track progress toward badges
- `monthly_challenges` - Challenge system
- `challenge_submissions` & `challenge_votes` - Challenge entries
- `post_views` - Track post views
- `community_stats` - Aggregate statistics

**Expected time:** 5-10 seconds

---

### Step 4: Run Migration 003 (Badge Seed Data)

1. Open the file: `supabase/migrations/003_badge_seed_data.sql`
2. Copy **ALL** contents
3. Paste into SQL Editor (new query)
4. Click **Run**

**What this creates:**
- Inserts 80+ badge definitions
- Categories: Getting Started, Harvest, Community, Expertise, etc.

**Expected time:** 2-5 seconds

---

## ✅ Verification Queries

After running all migrations, verify everything worked:

### Check Tables Exist

```sql
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name LIKE '%community%' OR table_name LIKE '%badge%'
ORDER BY table_name;
```

**Expected:** ~20+ tables including:
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

### Check Functions Exist

```sql
SELECT routine_name
FROM information_schema.routines
WHERE routine_schema = 'public'
  AND (routine_name LIKE '%badge%' OR routine_name LIKE '%post%' OR routine_name LIKE '%feed%')
ORDER BY routine_name;
```

**Expected:** Functions like:
- `check_and_award_badges`
- `create_community_post`
- `get_personalized_feed`
- `toggle_post_like`
- `get_user_badges`

### Check RLS Policies

```sql
SELECT tablename, policyname
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename LIKE '%community%' OR tablename LIKE '%badge%'
ORDER BY tablename, policyname;
```

**Expected:** Multiple policies per table (SELECT, INSERT, UPDATE, DELETE)

---

## 🐛 Troubleshooting

### Error: "relation already exists"

**Cause:** Tables already exist from previous run

**Solution:**
- Option 1: Skip that migration (if tables already exist)
- Option 2: Drop tables first (see Rollback section below)
- Option 3: Use `DROP TABLE IF EXISTS` before CREATE (not recommended)

### Error: "column does not exist"

**Cause:** Previous migration didn't complete

**Solution:**
1. Check which tables exist
2. Run missing migrations in order
3. If stuck, drop all community tables and re-run

### Error: "foreign key constraint"

**Cause:** Referenced table doesn't exist or wrong column name

**Solution:**
- Verify `my_towers` table exists with `tower_id` column
- Verify `plants` table exists with `plant_id` column
- Check that `auth.users` exists (should be automatic)

### Error: "permission denied"

**Cause:** RLS policies blocking access

**Solution:**
- Run migrations as database owner (should be automatic in SQL Editor)
- Check that you're logged in as project owner

---

## 🔄 Rollback (If Needed)

If you need to remove everything and start over:

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
DROP FUNCTION IF EXISTS update_post_likes_count CASCADE;
DROP FUNCTION IF EXISTS update_post_comments_count CASCADE;
DROP FUNCTION IF EXISTS update_user_posts_count CASCADE;
DROP FUNCTION IF EXISTS update_follow_counts CASCADE;
DROP FUNCTION IF EXISTS update_hashtag_use_count CASCADE;
DROP FUNCTION IF EXISTS update_updated_at_column CASCADE;
DROP FUNCTION IF EXISTS update_user_badges_count CASCADE;
DROP FUNCTION IF EXISTS update_challenge_votes_count CASCADE;
```

---

## 📋 MVP Approach (Recommended)

For MVP, you can run migrations incrementally:

### Phase 1: Core Tables Only
Run **Migration 001** only
- This gives you posts, likes, bookmarks
- Skip badges for now (can add later)

### Phase 2: Add Badges
Run **Migration 002** and **003**
- Adds badge system
- Adds gamification

---

## ✅ Next Steps After Migrations

1. **Create Storage Bucket** (see COMMUNITY_SETUP_GUIDE.md)
2. **Run Function Files** (see COMMUNITY_SETUP_GUIDE.md)
3. **Test with Sample Data** (see COMMUNITY_SETUP_GUIDE.md)
4. **Set Up n8n Workflows** (see N8N_COMMUNITY_AUTOMATIONS.md)

---

## 📞 Need Help?

If you encounter issues:
1. Check Supabase logs: Dashboard → Logs → Postgres Logs
2. Review error messages carefully
3. Verify table structures match your existing schema
4. Check the COMMUNITY_SETUP_GUIDE.md for more details

---

**Ready to run?** Start with Migration 001! 🚀

