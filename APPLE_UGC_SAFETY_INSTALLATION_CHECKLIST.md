# Apple UGC Safety Features - Installation Checklist

## Overview
This checklist ensures all required Apple App Store safety features for User Generated Content are properly installed and configured.

## ✅ Database Migrations (Run in Supabase SQL Editor)

### Migration 019: User Blocks
- [ ] Run `supabase/migrations/019_add_user_blocks.sql`
- [ ] Verify `user_blocks` table exists
- [ ] Verify RLS policies are created
- [ ] Verify `is_user_blocked()` function exists

**Verify with:**
```sql
SELECT * FROM user_blocks LIMIT 1; -- Should return empty or data
SELECT * FROM pg_policies WHERE tablename = 'user_blocks'; -- Should show 3 policies
```

### Migration 020: Auto-Hide on Reports
- [ ] Run `supabase/migrations/020_auto_hide_on_reports.sql`
- [ ] Verify `handle_post_report()` function exists
- [ ] Verify trigger `trigger_auto_hide_on_reports` exists

**Verify with:**
```sql
SELECT proname FROM pg_proc WHERE proname = 'handle_post_report'; -- Should return function
SELECT tgname FROM pg_trigger WHERE tgname = 'trigger_auto_hide_on_reports'; -- Should return trigger
```

### Migration 021: Profanity Filter
- [ ] Run `supabase/migrations/021_add_profanity_filter_table.sql`
- [ ] Verify `profanity_filter` table exists
- [ ] Verify words were inserted (should have ~80+ words)
- [ ] Verify RLS policy exists

**Verify with:**
```sql
SELECT COUNT(*) FROM profanity_filter; -- Should return 80+ words
SELECT * FROM profanity_filter WHERE enabled = true LIMIT 5; -- Should return enabled words
```

## ✅ Code Files (Already in place)

### User-Facing Features
- [x] `lib/components/post_card_widget.dart` - Report button & block user menu
- [x] `lib/components/report_post_dialog.dart` - Report dialog UI
- [x] `lib/services/community_service.dart` - All service methods
- [x] `lib/components/create_post_widget.dart` - Content filtering

### Service Methods (in CommunityService)
- [x] `reportPost()` - Report a post
- [x] `blockUser()` - Block a user
- [x] `unblockUser()` - Unblock a user
- [x] `isUserBlocked()` - Check if user is blocked
- [x] `getBlockedUserIds()` - Get list of blocked users
- [x] `containsProfanity()` - Check for profanity (async, loads from DB)
- [x] `_loadProfanityWords()` - Load words from database with caching
- [x] `clearProfanityCache()` - Clear cache (for admin use)

### Feed Filtering (All feeds filter blocked users)
- [x] `getRecentPosts()` - Filters blocked users
- [x] `getFeaturedPosts()` - Filters blocked users
- [x] `getPopularFeed()` - Filters blocked users
- [x] `getFollowingFeed()` - Filters blocked users
- [x] `getForYouFeed()` - Filters blocked users

## ✅ Testing Checklist

### Report Functionality
- [ ] Tap 3-dot menu on a post → "Report Post" appears
- [ ] Report dialog shows all 4 reason options
- [ ] Can submit report with reason
- [ ] Success message appears after reporting
- [ ] Cannot report same post twice (error message)
- [ ] After 3 reports, post auto-hides (check `is_hidden = true` in DB)

### Block User Functionality
- [ ] Tap 3-dot menu → "Block User" appears (only on others' posts)
- [ ] Can block a user
- [ ] Success message appears
- [ ] Blocked user's posts disappear from all feeds
- [ ] Can unblock user from menu
- [ ] Unblocked user's posts reappear in feeds

### Content Filtering
- [ ] Try creating post with profanity word → Blocked with error message
- [ ] Try creating post without profanity → Succeeds
- [ ] Profanity filter loads from database (check network tab/logs)
- [ ] Cache works (second check should be faster)

### Database Triggers
- [ ] Report a post → `reports_count` increments automatically
- [ ] Report 3 times → Post `is_hidden` becomes `true` automatically
- [ ] Check `post_reports` table has entries

## ✅ Admin Build Setup

### Files to Add to Admin Build
- [ ] `admin_moderation_widget.dart` - Moderation queue for reported posts
- [ ] `admin_profanity_filter_widget.dart` - Manage profanity words

### Admin Widget Features
- [ ] Moderation queue shows reported posts
- [ ] Can hide/restore posts
- [ ] Can resolve reports
- [ ] Can delete posts
- [ ] Profanity filter management works
- [ ] Can add/edit/delete profanity words
- [ ] Can enable/disable words

### Admin Permissions
- [ ] Admin authentication check added
- [ ] Only admins can access moderation pages
- [ ] Admin can manage profanity filter (insert/update/delete)

## ✅ RLS Policies Verification

### user_blocks table
```sql
-- Should allow users to view their own blocks
SELECT * FROM pg_policies WHERE tablename = 'user_blocks' AND policyname LIKE '%view%';
-- Should allow users to block others
SELECT * FROM pg_policies WHERE tablename = 'user_blocks' AND policyname LIKE '%block%';
-- Should allow users to unblock
SELECT * FROM pg_policies WHERE tablename = 'user_blocks' AND policyname LIKE '%unblock%';
```

### profanity_filter table
```sql
-- Should allow viewing enabled words
SELECT * FROM pg_policies WHERE tablename = 'profanity_filter';
-- Note: Admin operations require service role or admin RLS bypass
```

### post_reports table
```sql
-- Should allow users to report posts
SELECT * FROM pg_policies WHERE tablename = 'post_reports';
```

## ✅ Performance Considerations

- [ ] Profanity words are cached (1 hour cache)
- [ ] Blocked users list is fetched once per feed load
- [ ] Database indexes exist for performance:
  - `idx_user_blocks_blocker`
  - `idx_user_blocks_blocked`
  - `idx_profanity_filter_word`
  - `idx_profanity_filter_enabled`

## ✅ Error Handling

- [ ] Report fails gracefully if user already reported
- [ ] Block fails gracefully if already blocked
- [ ] Profanity filter fails gracefully if DB unavailable (allows post)
- [ ] Feed queries handle blocked user filtering errors

## ✅ Apple Requirements Met

- [x] **Method to filter objectionable content** - Profanity filter in place
- [x] **Mechanism for users to report offensive content** - Report button & dialog
- [x] **Ability to block abusive users** - Block user functionality
- [x] **Way for developer to act on reported content** - Admin moderation widget

## 🚀 Deployment Steps

1. **Run all migrations in order:**
   ```sql
   -- Run in Supabase SQL Editor:
   -- 1. 019_add_user_blocks.sql
   -- 2. 020_auto_hide_on_reports.sql
   -- 3. 021_add_profanity_filter_table.sql
   ```

2. **Verify migrations:**
   - Check all tables exist
   - Check all functions/triggers exist
   - Check RLS policies are in place

3. **Test user-facing features:**
   - Report a post
   - Block a user
   - Try posting with profanity

4. **Deploy admin widgets:**
   - Add moderation widget to admin build
   - Add profanity filter widget to admin build
   - Test admin functionality

5. **Monitor:**
   - Check reports are being created
   - Check auto-hide is working (after 3 reports)
   - Monitor profanity filter effectiveness

## 📝 Notes

- Profanity filter cache expires after 1 hour automatically
- Admin can clear cache by calling `CommunityService.clearProfanityCache()` (if available)
- Auto-hide trigger fires on every report insert
- All feeds filter blocked users client-side for performance
- Profanity filter allows posts if database is unavailable (fail-safe)

## 🔧 Troubleshooting

**Reports not incrementing?**
- Check trigger exists: `SELECT * FROM pg_trigger WHERE tgname = 'trigger_auto_hide_on_reports';`
- Check function exists: `SELECT * FROM pg_proc WHERE proname = 'handle_post_report';`

**Blocked users still showing?**
- Verify `getBlockedUserIds()` returns correct list
- Check feed methods are calling `getBlockedUserIds()`
- Verify RLS policies allow reading `user_blocks` table

**Profanity filter not working?**
- Check `profanity_filter` table has words: `SELECT COUNT(*) FROM profanity_filter WHERE enabled = true;`
- Check RLS policy allows reading: `SELECT * FROM pg_policies WHERE tablename = 'profanity_filter';`
- Check cache is loading: Look for "Error loading profanity words" in logs

**Admin widgets not working?**
- Verify admin has service role or RLS bypass
- Check table permissions for admin operations
- Verify imports match admin build structure


