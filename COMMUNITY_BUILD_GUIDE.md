# Community Feature - Flutter Build Guide

## Overview
This guide outlines the incremental build plan for the Instagram-style community feature in Sproutify.

---

## ✅ Phase 0: Foundation (COMPLETE)

- [x] Database migrations (001, 002, 003)
- [x] Supabase functions created
- [x] Storage bucket created
- [x] Navigation updated (Community tab added)

---

## ✅ Phase 1: MVP Community Feed (COMPLETE)

**Goal:** Users can post photos and see others' posts

### Step 1: Navigation ✅
- [x] Replace Supplies with Community in bottom nav
- [x] Move Supplies to drawer menu
- [x] Add Community tab with people icon
- [x] Create route

### Step 2: Data Models ✅
- [x] Create Dart models for:
  - `CommunityPost` (id, user_id, photo_url, caption, likes_count, etc.)
  - `UserCommunityProfile` (bio, posts_count, followers_count, etc.)
  - `PostLike` (user_id, post_id)
  - `Badge` (id, name, description, icon_url, etc.)

### Step 3: Supabase Integration ✅
- [x] Create Supabase service class:
  - `getRecentPosts()` - Fetch recent posts
  - `createPost()` - Create new post
  - `toggleLike()` - Like/unlike post
  - `uploadPhoto()` - Upload photo to storage

### Step 4: Community Feed Screen ✅
- [x] Update `CommunityFeedWidget` to:
  - Display list of posts (photo, caption, username, likes)
  - Show loading state
  - Show empty state
  - Pull to refresh
  - Embedded in home page (replaced button section)

### Step 5: Post Card Widget ✅
- [x] Create `PostCardWidget`:
  - Display post photo
  - Show username and timestamp
  - Show caption
  - Show like button and count
  - Tap to view details (later)
  - Profile photo/initials display
  - Like toggle functionality

### Step 6: Create Post Screen ✅
- [x] Create `CreatePostWidget`:
  - Photo picker (camera/gallery)
  - Caption input (500 char limit)
  - Post button
  - Upload to Supabase Storage
  - Create post record
  - Image preview and remove
  - Loading states
  - Character counter

### Step 7: Like Functionality ✅
- [x] Implement like button:
  - Toggle like on tap
  - Update like count
  - Show liked state (filled heart)
  - Call `toggle_post_like` function
  - Real-time like count updates
  - Loading state during like toggle

---

## ✅ Phase 2: Basic Engagement (COMPLETE)

- [x] Following system
- [x] "Following" feed tab
- [x] Basic notifications
- [x] Simple search

---

## ✅ Phase 3: Discovery & Tags (COMPLETE)

- [x] Hashtags (extracted from caption)
- [x] Plant tags (UI for selection)
- [x] Tower tags (UI for selection)
- [x] "Popular" feed

---

## ✅ Phase 4: Gamification (COMPLETE)

- [x] Badge system UI
- [x] Badge collection view
- [x] Badge earned notifications
- [x] XP/Level display

---

## 📋 Phase 5+: Advanced Features

- [x] "For You" algorithm
- [ ] AI moderation
- [ ] Comments
- [ ] Challenges
- [ ] Featured posts

---

## Current Status

**Phase:** Phase 5 - Advanced Features  
**Step:** Starting Phase 5 implementation  
**Status:** Phase 4 Complete! 🎉 Starting Phase 5

---

## Quick Reference

### Files to Create/Update

**Models:**
- `lib/models/community_post.dart` ✅
- `lib/models/user_community_profile.dart` ✅
- `lib/models/post_like.dart` ✅
- `lib/models/badge.dart` ✅

**Services:**
- `lib/services/community_service.dart` ✅

**Widgets:**
- `lib/components/community_feed_widget.dart` ✅ (updated with create post button)
- `lib/components/community_feed_embedded.dart` ✅
- `lib/components/post_card_widget.dart` ✅
- `lib/components/create_post_widget.dart` ✅

**Screens:**
- `lib/pages/community_feed_page.dart` (if separate from widget)

---

## Next Steps

**Phase 1 Complete!** ✅ All MVP features are implemented:
- ✅ Data models created
- ✅ Supabase service with all CRUD operations
- ✅ Community feed embedded in home page
- ✅ Post card widget with like functionality
- ✅ Create post screen
- ✅ Like/unlike functionality working

**Phase 2 Complete!** ✅ All Basic Engagement features are implemented:
- ✅ Following/unfollowing system
- ✅ Following feed tab
- ✅ Basic notification fetching
- ✅ User search functionality
- ✅ Follow button on post cards

**Phase 3 Complete!** ✅ All Discovery & Tags features are implemented:
- ✅ Hashtag parsing from captions
- ✅ Plant tag selection UI
- ✅ Tower tag selection UI
- ✅ Popular feed tab
- ✅ Tag selection in create post screen

**Phase 4 Complete!** ✅ All Gamification features are implemented:
- ✅ Badge system UI (BadgeCardWidget)
- ✅ Badge collection view (BadgeCollectionWidget)
- ✅ Badge earned notifications with special styling
- ✅ XP/Level display widget (XpLevelDisplayWidget)
- ✅ XP/Level display on post cards
- ✅ Badge and gamification API methods in CommunityService

**Ready for Phase 5:** Advanced Features

---

## Notes

- Build incrementally - one feature at a time
- Test each step before moving to next
- Keep it simple for MVP
- Add complexity later based on user feedback

---

**Last Updated:** Phase 4 Complete - All Gamification features implemented! 🎉

