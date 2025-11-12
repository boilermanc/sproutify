# n8n Automation Workflows for Sproutify Community

## Overview
Leverage n8n to handle backend automation, content moderation, notifications, badge awards, and community management tasks. This keeps the Flutter app lightweight while enabling powerful server-side workflows.

---

## Architecture

```
Flutter App → Supabase (Database/Storage) → n8n Webhooks → External Services
                    ↓
              Database Triggers
                    ↓
              n8n Workflows
                    ↓
         Push Notifications, AI Moderation, Badge Awards, Analytics
```

---

## Workflow 1: Post Upload & Moderation

### Trigger: New Post Created
**Supabase Trigger:** `community_posts` INSERT

**n8n Workflow:**
```
1. Webhook receives new post data
   ├─ post_id
   ├─ user_id
   ├─ photo_url
   ├─ caption
   └─ created_at

2. Image Moderation (Parallel)
   ├─ Download image from Supabase Storage
   ├─ Send to Google Cloud Vision API
   │  └─ Check for: Adult content, violence, offensive imagery
   ├─ Get safety scores
   └─ Decision:
      ├─ If safe (score > 0.8): Auto-approve
      ├─ If questionable (0.5-0.8): Flag for manual review
      └─ If unsafe (< 0.5): Auto-reject & notify user

3. Text Moderation (Parallel)
   ├─ Check caption against profanity list
   ├─ Send to OpenAI Moderation API (optional)
   └─ Decision:
      ├─ If clean: Approve
      └─ If profane: Reject & notify user

4. Spam Detection
   ├─ Check user's post count today (query Supabase)
   ├─ If > 10 posts: Flag as spam
   ├─ Check for duplicate image hash
   └─ If duplicate: Reject

5. If Approved:
   ├─ Update post: is_approved = true
   ├─ Check if eligible for auto-feature
   │  └─ User has high reputation score
   │  └─ Photo quality score > 0.9
   │  └─ Auto-feature: is_featured = true
   ├─ Increment user stats
   ├─ Trigger badge check workflow
   └─ Send notification to followers (if user has followers)

6. If Rejected:
   ├─ Update post: is_approved = false, is_hidden = true
   ├─ Send in-app notification to user explaining why
   └─ Log moderation event
```

**n8n Nodes:**
- Webhook (trigger)
- Supabase Query nodes
- HTTP Request (Cloud Vision, OpenAI)
- IF conditions
- Function nodes for logic
- Set nodes for data transformation

---

## Workflow 2: Badge Award System

### Trigger: Multiple Events
**Events that can award badges:**
- New post created
- Post liked
- Harvest logged
- Plant added
- Tower added
- pH/EC logged
- Cost logged
- Rating submitted

**n8n Workflow:**
```
1. Webhook receives event
   ├─ event_type: 'post_created', 'harvest_logged', etc.
   ├─ user_id
   └─ event_data: {...}

2. Query badge_progress table
   ├─ Get current progress for user
   └─ Increment relevant counters based on event_type

3. Check Badge Thresholds
   ├─ Query badge_definitions for triggers matching event
   ├─ For each badge:
   │  ├─ Check if user already has it
   │  ├─ Check if threshold met
   │  └─ If earned: Continue to award
   └─ Collect all newly earned badges

4. Award Badges (for each newly earned)
   ├─ Insert into user_badges table
   ├─ Calculate XP for badge
   ├─ Update user_gamification:
   │  ├─ Add XP
   │  ├─ Increment badges_earned count
   │  └─ Recalculate level
   └─ Create notification record

5. Check for Meta-Badges
   ├─ "Badge Collector" - earned X badges
   ├─ "Completionist" - earned all badges in category
   └─ Award if thresholds met (recursive)

6. Send Notifications
   ├─ In-app notification (Supabase insert)
   ├─ Push notification (Firebase/OneSignal)
   │  └─ "🏆 You earned the First Harvest badge!"
   └─ Optional: Email digest

7. Check for Level Up
   ├─ If user leveled up during this process
   └─ Send level up notification

8. Analytics Tracking
   ├─ Log badge award event
   ├─ Update daily stats
   └─ Track badge rarity metrics
```

**Badge Progress Tracking Examples:**

| Event Type | Progress Categories to Update |
|------------|------------------------------|
| post_created | post_count, community_engagement |
| post_liked | likes_given |
| harvest_logged | harvest_count, plant_variety_count |
| plant_added | active_plants_count |
| tower_added | tower_count |
| ph_logged | ph_log_streak, water_quality_logs |
| rating_submitted | ratings_count |

---

## Workflow 3: Daily Streak & Consistency Tracking

### Trigger: Cron (Daily at 1:00 AM)

**n8n Workflow:**
```
1. Cron Trigger (daily)

2. Get all active users
   ├─ Query users table
   └─ Where: has_active_plants = true OR has_active_tower = true

3. For each user:
   ├─ Check activity in past 24 hours
   │  ├─ Did they: add plant, log pH/EC, create post, or update tower?
   │  └─ If yes: activity_detected = true
   ├─ Query user streak data
   ├─ If activity_detected:
   │  ├─ Increment streak
   │  └─ Update last_activity_date
   ├─ If no activity:
   │  ├─ Check grace period (1 day)
   │  └─ If expired: Reset streak to 0
   └─ Update user_streaks table

4. Check Streak Badges
   ├─ Weekly Warrior (7 days)
   ├─ Monthly Maintainer (30 days)
   ├─ Quarterly Grower (90 days)
   └─ Year-Round Grower (365 days)
   └─ Award if thresholds met

5. Send Streak Notifications
   ├─ Milestone reached: "🔥 7 day streak!"
   ├─ At-risk users (haven't logged in 12+ hours):
   │  └─ "Don't break your streak! Check your tower"
   └─ Streak broken notification (encouraging, not negative)

6. Analytics
   ├─ Track average streak length
   ├─ Streak retention rate
   └─ Update community stats
```

**Additional Table Needed:**
```sql
CREATE TABLE user_streaks (
  user_id UUID PRIMARY KEY REFERENCES users(id),
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_activity_date DATE,
  streak_start_date DATE,
  updated_at TIMESTAMP DEFAULT NOW()
);
```

---

## Workflow 4: Smart Notifications & Digest

### Trigger: Various events + Daily digest cron

**n8n Workflow for Immediate Notifications:**
```
1. Event triggers (post liked, new follower, etc.)

2. Check user notification preferences
   ├─ Query user settings
   ├─ Is this notification type enabled?
   ├─ Is user in quiet hours?
   └─ Digest mode vs real-time?

3. If Digest Mode:
   ├─ Add to pending_notifications queue
   └─ Will be sent in daily digest

4. If Real-Time:
   ├─ Check notification throttling
   │  └─ Don't send more than X per hour
   ├─ Create notification record
   ├─ Send push notification
   │  ├─ OneSignal HTTP API
   │  └─ Firebase Cloud Messaging
   └─ Mark as sent

5. Smart Grouping
   ├─ "John and 5 others liked your post"
   └─ Instead of 6 separate notifications
```

**n8n Workflow for Daily Digest (Cron 8:00 AM):**
```
1. Cron trigger (daily at user's preferred time)

2. Get users with digest mode enabled

3. For each user:
   ├─ Query pending notifications (past 24 hours)
   ├─ Group by type:
   │  ├─ Likes: "Your posts got 23 new likes"
   │  ├─ Followers: "3 new growers followed you"
   │  ├─ Comments: "5 new comments on your posts"
   │  └─ Badges: "You earned 2 new badges!"
   ├─ Generate digest content
   └─ Send single notification or email

4. Mark notifications as sent

5. Analytics: Track digest open rates
```

---

## Workflow 5: Monthly Challenge Management

### Trigger: Multiple (Cron + Manual)

**n8n Workflow: Challenge Start (1st of month):**
```
1. Cron trigger (1st of month, 9:00 AM)

2. Get active challenge for this month
   ├─ Query monthly_challenges table
   └─ Where: start_date = today AND is_active = true

3. Send Challenge Announcement
   ├─ To all users (or opted-in users)
   ├─ Push notification: "🏆 New Monthly Challenge: [Theme]"
   ├─ In-app banner
   └─ Email (optional)

4. Create challenge hashtag
   ├─ Generate from theme
   └─ Insert into hashtags table

5. Analytics
   ├─ Track challenge views
   └─ Monitor participation rate
```

**n8n Workflow: Challenge Reminder (Mid-month):**
```
1. Cron trigger (15th of month)

2. Get active challenge

3. Get users who haven't participated
   ├─ Query all users
   ├─ Exclude users with submissions
   └─ Filter: has_active_plants = true

4. Send reminder notification
   ├─ "2 weeks left! Enter the [Theme] Challenge"
   └─ Include CTA to submit

5. Get users who have participated
   └─ Send encouragement: "Looking good! Want to submit another entry?"
```

**n8n Workflow: Challenge End (Last day of month):**
```
1. Cron trigger (Last day of month, 11:59 PM)

2. Get active challenge

3. Calculate winners
   ├─ Get all submissions
   ├─ Order by votes_count DESC
   ├─ Top 3 = winners
   └─ Update challenge_submissions:
      ├─ is_winner = true
      └─ winner_rank = 1, 2, or 3

4. Award challenge badges
   ├─ Winners get "Challenge Champion" badge
   ├─ All participants get participation badge progress
   └─ Trigger badge award workflow

5. Feature winning posts
   ├─ Update community_posts: is_featured = true
   └─ Add to "Challenge Winners" collection

6. Send winner notifications
   ├─ To winners: "🎉 You won the [Theme] Challenge!"
   ├─ To all participants: "Thanks for participating! Winners announced"
   └─ To all users: Showcase winners

7. Close challenge
   ├─ Update monthly_challenges: is_active = false
   └─ Archive challenge data

8. Analytics
   ├─ Total participants
   ├─ Total votes
   ├─ Engagement rate
   └─ Popular submission types
```

---

## Workflow 6: Content Curation & Featured Posts

### Trigger: Cron (Daily) + Manual webhook

**n8n Workflow: Auto-Feature Candidates:**
```
1. Cron trigger (Daily at 10:00 AM)

2. Find high-quality posts from past 24 hours
   ├─ Query community_posts
   ├─ Where:
   │  ├─ created_at >= yesterday
   │  ├─ is_approved = true
   │  ├─ is_featured = false
   │  ├─ likes_count > 10 (or percentile-based)
   │  └─ reports_count = 0
   └─ Order by engagement score

3. Calculate engagement score for each post
   ├─ Score = (likes * 3) + (comments * 5) + (bookmarks * 4) + (views * 0.1)
   ├─ Boost score if:
   │  ├─ User has high reputation
   │  ├─ Post has multiple plant tags
   │  ├─ Post has good image quality (from Vision API)
   │  └─ Post during peak hours
   └─ Sort by score

4. Get top 3-5 candidates

5. Send to admin for review
   ├─ Slack webhook with post preview
   ├─ Email with approval links
   └─ In-app admin dashboard notification

6. Admin Actions:
   ├─ Approve → Feature the post
   ├─ Reject → Mark as reviewed, don't feature
   └─ Timeout (12 hours) → Auto-approve top scorer
```

**n8n Workflow: "Tower of the Week" Curation:**
```
1. Cron trigger (Every Monday 9:00 AM)

2. Get top posts from past week
   ├─ Similar to daily curation
   ├─ But for 7-day period
   └─ Higher engagement thresholds

3. Create "Tower of the Week" collection
   ├─ Feature 1 main post
   ├─ Include 4-5 runner-ups
   └─ Update posts: is_featured = true, featured_type = 'tower_of_week'

4. Send announcement
   ├─ To winner: "🌟 Your tower was featured as Tower of the Week!"
   ├─ Award special badge
   └─ To all users: Push notification showcasing the tower

5. Create shareable graphic
   ├─ Use Bannerbear or Placid API
   ├─ Include post photo + badge overlay
   ├─ Post to social media (auto-post to Instagram/Twitter)
   └─ Save to assets for in-app display

6. Analytics
   ├─ Track feature engagement
   └─ Winner demographics
```

---

## Workflow 7: AI-Powered Community Insights

### Trigger: Cron (Weekly)

**n8n Workflow: Weekly Community Insights:**
```
1. Cron trigger (Every Sunday 8:00 PM)

2. Aggregate weekly data
   ├─ Total posts this week
   ├─ Total new users
   ├─ Top 5 most posted plants
   ├─ Top 5 hashtags
   ├─ Most engaged posts
   └─ Badge leaderboard

3. Analyze with ChatGPT (using existing Sage setup)
   ├─ Send aggregated data to OpenAI
   ├─ Prompt: "Generate a friendly weekly community summary highlighting:
   │  - Most popular plants this week
   │  - Growing trends
   │  - Shout-outs to top contributors
   │  - Encouraging message for next week"
   └─ Get AI-generated summary

4. Create insights post
   ├─ Generate graphics with stats
   ├─ Include AI summary
   └─ Post to community feed from @SproutifyBot account

5. Send to users
   ├─ In-app notification
   ├─ Optional: Email newsletter
   └─ Push notification: "Check out this week's community highlights!"

6. Store insights
   ├─ Save to community_insights table
   └─ Available in Explore tab
```

---

## Workflow 8: Toxic Content & Spam Prevention

### Trigger: Post reported, suspicious activity detected

**n8n Workflow: Report Handling:**
```
1. Webhook receives report
   ├─ report_id
   ├─ post_id
   ├─ reported_by (user_id)
   ├─ reason
   └─ additional_info

2. Increment report counter on post

3. Auto-action based on report count
   ├─ If reports >= 3:
   │  ├─ Auto-hide post (is_hidden = true)
   │  ├─ Add to moderation queue
   │  └─ Send to admin immediately (Slack alert)
   ├─ If reports >= 5:
   │  ├─ Auto-delete post
   │  └─ Warn user (strike system)
   └─ If user has 3+ posts reported:
      └─ Flag account for review (possible spam)

4. Analyze report with AI
   ├─ Send post content + image to OpenAI Moderation API
   ├─ Get toxicity scores
   └─ If high toxicity:
      ├─ Auto-confirm violation
      └─ Take action

5. Send to moderation queue
   ├─ Notify admin in Slack/Email
   ├─ Include:
   │  ├─ Post preview
   │  ├─ Report reasons
   │  ├─ AI moderation scores
   │  ├─ User history
   │  └─ Quick action buttons (Restore, Delete, Ban)
   └─ Set priority based on severity

6. Admin decision
   ├─ Restore: Unhide post, mark reports as invalid
   ├─ Delete: Permanently remove, warn user
   └─ Ban: Suspend user account, remove all posts
```

**n8n Workflow: Spam Pattern Detection (Cron hourly):**
```
1. Cron trigger (every hour)

2. Detect suspicious patterns
   ├─ Users posting same caption repeatedly
   ├─ Users with very high post frequency (> 5/hour)
   ├─ Duplicate image hashes
   ├─ Posts with 10+ hashtags
   └─ New users posting immediately after signup

3. For each suspicious user
   ├─ Calculate spam probability score
   ├─ If score > 0.7:
   │  ├─ Auto-flag account
   │  ├─ Require manual approval for posts
   │  └─ Notify admin
   └─ Track in spam_detection_log

4. Machine learning (optional)
   ├─ Send patterns to custom ML model
   ├─ Improve detection over time
   └─ Update spam rules
```

---

## Workflow 9: Follower Recommendations

### Trigger: Cron (Daily) or User action (view Explore page)

**n8n Workflow: Personalized Follower Suggestions:**
```
1. Trigger: User views Explore page or daily cron for all users

2. Get user's profile data
   ├─ Plants they're growing
   ├─ Location (city/state)
   ├─ Gardening goals
   ├─ Experience level
   └─ Current followers

3. Find similar users
   ├─ Query users with:
   │  ├─ Growing same/similar plants (70% match)
   │  ├─ Same location/climate zone
   │  ├─ Similar experience level
   │  └─ Who user is NOT already following
   ├─ Calculate similarity score
   └─ Order by score DESC

4. Boost scores for
   ├─ Active users (posted in past week)
   ├─ Highly engaged (avg likes per post > 10)
   ├─ Quality contributors (low report rate)
   └─ Badge holders (shows commitment)

5. Get top 10 suggestions

6. Return recommendations
   ├─ Store in user_recommendations table
   ├─ Cache for 24 hours
   └─ Display in Explore page

7. Track recommendation performance
   ├─ Did user follow suggested users?
   ├─ Engagement after following?
   └─ Improve algorithm based on success rate
```

---

## Workflow 10: Analytics & Reporting

### Trigger: Cron (Daily at 2:00 AM)

**n8n Workflow: Daily Analytics Aggregation:**
```
1. Cron trigger (daily)

2. Calculate daily metrics
   ├─ Total posts created today
   ├─ Total users who posted
   ├─ Total likes given
   ├─ Total comments (if enabled)
   ├─ Total new followers
   ├─ Total badges earned
   ├─ Top 10 posts by engagement
   ├─ Top 10 users by activity
   └─ Top 5 plants featured in posts

3. Store in community_stats table

4. Calculate trends (7-day, 30-day)
   ├─ Growth rate
   ├─ Engagement rate trend
   ├─ Churn detection
   └─ Feature adoption

5. Identify anomalies
   ├─ Sudden spike in reports → Spam attack?
   ├─ Drop in posts → Feature issue?
   ├─ Surge in specific plant posts → Trending opportunity
   └─ Alert admin if significant changes

6. Generate admin dashboard data
   ├─ Send to analytics platform (Mixpanel, Amplitude)
   ├─ Or custom Retool/Appsmith dashboard
   └─ Update Google Sheets (for simple tracking)

7. Weekly/Monthly rollup
   ├─ Every Monday: Generate weekly report
   ├─ 1st of month: Generate monthly report
   └─ Send email to stakeholders
```

---

## Workflow 11: Photo Enhancement & Optimization

### Trigger: Photo upload to Supabase Storage

**n8n Workflow: Image Processing Pipeline:**
```
1. Supabase Storage webhook (on file upload)
   ├─ file_path
   ├─ file_url
   └─ user_id

2. Download original image

3. Image Analysis (Parallel)
   ├─ Google Cloud Vision API:
   │  ├─ Label detection (what's in the image)
   │  ├─ Dominant colors
   │  ├─ Image quality score
   │  └─ Suggested crop
   └─ Store metadata

4. Auto-Tagging (Smart!)
   ├─ If labels include plant names:
   │  ├─ Match against plant catalog
   │  └─ Auto-suggest plant tags to user
   ├─ If labels include "indoor", "outdoor":
   │  └─ Auto-suggest location tag
   └─ Increase user engagement by reducing manual tagging

5. Generate Thumbnails (Parallel)
   ├─ 1080x1080 (feed size)
   ├─ 480x480 (thumbnail)
   └─ 240x240 (tiny thumbnail for lists)

6. Optional Enhancements
   ├─ Auto-adjust brightness/contrast
   ├─ Auto-crop to best composition
   ├─ Watermark (optional)
   └─ Apply subtle filter

7. Upload optimized versions
   ├─ Save to Supabase Storage
   └─ Update post record with all URLs

8. Update post with AI metadata
   ├─ auto_tags: ["basil", "indoor", "harvest"]
   ├─ image_quality_score: 0.89
   └─ dominant_colors: ["#2E7D32", "#FFFFFF"]

9. Send completion webhook to app
   └─ App can show "Processing..." then update when done
```

---

## Workflow 12: Community Health Monitoring

### Trigger: Cron (Daily)

**n8n Workflow: Community Health Check:**
```
1. Cron trigger (daily)

2. Calculate health metrics
   ├─ % of users who posted (activity rate)
   ├─ Average posts per user
   ├─ Average engagement per post
   ├─ Report rate (reports / total posts)
   ├─ New user retention (did they post again?)
   └─ Content diversity (variety of plants posted)

3. Check for issues
   ├─ If activity rate < 10%: Engagement issue
   ├─ If report rate > 5%: Moderation issue
   ├─ If new user retention < 20%: Onboarding issue
   └─ If content diversity low: Need new challenges

4. Generate recommendations
   ├─ Send to ChatGPT with health data
   ├─ Prompt: "Based on these community health metrics, suggest:
   │  - Actions to improve engagement
   │  - Challenge ideas
   │  - Feature improvements"
   └─ Get AI recommendations

5. Alert admin
   ├─ Send health report via Slack
   ├─ Include metrics + AI recommendations
   └─ Highlight urgent issues

6. Auto-actions (if enabled)
   ├─ Low engagement → Send motivational notification
   ├─ High quality posts → Auto-feature more
   └─ Trending plant → Create related challenge
```

---

## Integration Examples

### n8n + ChatGPT (Sage Integration)
```
Workflow: Enhanced AI Responses
├─ User asks Sage a question
├─ Before responding, check community posts
├─ Query: Posts with same plant/issue
├─ Include community examples in context
└─ ChatGPT response now includes: "Other growers have shared..."
```

### n8n + Supabase Realtime
```
Workflow: Live Notifications
├─ Supabase Realtime trigger (on new like)
├─ n8n receives event instantly
├─ Check notification preferences
└─ Send push notification immediately
```

### n8n + Social Media Auto-Post
```
Workflow: Cross-Platform Sharing
├─ When post is featured
├─ Generate share graphic (Bannerbear)
├─ Auto-post to:
│  ├─ Instagram (via Meta API)
│  ├─ Twitter (via Twitter API)
│  └─ Facebook (via Meta API)
└─ Drive traffic back to app
```

---

## n8n Node Requirements

**Core Nodes Needed:**
- Webhook (trigger from Supabase/App)
- Cron (scheduled tasks)
- Supabase (official node or HTTP requests)
- HTTP Request (APIs)
- IF/Switch (conditional logic)
- Function (JavaScript processing)
- Set (data transformation)
- Merge (combine data streams)
- Split in Batches (process large datasets)
- Wait (delays/throttling)
- Error Trigger (error handling)

**Third-Party Service Nodes:**
- OpenAI (ChatGPT, Moderation API)
- Google Cloud Vision
- Firebase/OneSignal (push notifications)
- Slack (admin alerts)
- SendGrid/Mailgun (emails)
- Bannerbear/Placid (image generation)
- Twitter/Instagram APIs
- Mixpanel/Amplitude (analytics)

---

## Monitoring & Error Handling

**n8n Workflow: Error Handling Template:**
```
Every workflow should include:
1. Try-Catch blocks for critical operations
2. Error Trigger node
3. On error:
   ├─ Log error to Supabase (error_logs table)
   ├─ Alert admin via Slack
   ├─ Send user-friendly message (if user-facing)
   └─ Retry logic (for transient failures)
```

**Monitoring Dashboard (Retool/Appsmith):**
```
Display:
├─ Workflow execution count (daily)
├─ Error rate by workflow
├─ Average execution time
├─ API call costs (OpenAI, Cloud Vision)
└─ Queue sizes (pending notifications, moderation)
```

---

## Cost Optimization

**Smart API Usage:**
```
1. Image Moderation:
   ├─ Only run Cloud Vision on first-time users (first 5 posts)
   ├─ After trusted: Skip AI check
   └─ Estimated cost: $0.001-0.003 per image

2. ChatGPT for Insights:
   ├─ Run weekly, not daily
   ├─ Use GPT-3.5 for simple tasks
   ├─ Use GPT-4 only for complex analysis
   └─ Estimated cost: $1-5/week

3. Push Notifications:
   ├─ Batch notifications (use digest mode)
   ├─ OneSignal free tier: 10,000 subscribers
   └─ Cost: Free up to scale

4. Caching:
   ├─ Cache API responses (follower suggestions, trending)
   ├─ Cache for 24 hours
   └─ Reduce redundant API calls
```

---

## Recommended n8n Hosting

**Options:**
1. **n8n Cloud** (Easiest)
   - Managed hosting
   - Auto-scaling
   - Built-in monitoring
   - Cost: $20-50/month

2. **Self-Hosted** (Most control)
   - DigitalOcean/AWS/Railway
   - Docker deployment
   - Cost: $10-20/month for VPS

3. **Railway** (Developer-friendly)
   - Easy deployment
   - Postgres included
   - Cost: ~$5-15/month

---

## Database Additions for n8n Workflows

```sql
-- Workflow execution logs
CREATE TABLE n8n_execution_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  workflow_name TEXT NOT NULL,
  execution_id TEXT,
  status TEXT, -- 'success', 'error'
  error_message TEXT,
  execution_time_ms INTEGER,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Pending actions queue
CREATE TABLE pending_actions_queue (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  action_type TEXT NOT NULL, -- 'send_notification', 'award_badge', etc.
  user_id UUID REFERENCES users(id),
  payload JSONB,
  status TEXT DEFAULT 'pending', -- 'pending', 'processing', 'completed', 'failed'
  scheduled_for TIMESTAMP DEFAULT NOW(),
  processed_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_pending_actions_status ON pending_actions_queue(status, scheduled_for);

-- Notification delivery tracking
CREATE TABLE notification_delivery_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  notification_id UUID REFERENCES community_notifications(id),
  user_id UUID REFERENCES users(id),
  delivery_method TEXT, -- 'push', 'email', 'in_app'
  status TEXT, -- 'sent', 'delivered', 'failed', 'opened'
  error_message TEXT,
  sent_at TIMESTAMP DEFAULT NOW(),
  delivered_at TIMESTAMP,
  opened_at TIMESTAMP
);
```

---

## Workflow Priority & Phases

**Phase 1 (MVP - Launch):**
1. ✅ Post Upload & Moderation
2. ✅ Badge Award System
3. ✅ Smart Notifications
4. ✅ Daily Analytics

**Phase 2 (Growth):**
5. ✅ Monthly Challenge Management
6. ✅ Content Curation (Featured Posts)
7. ✅ Follower Recommendations
8. ✅ Photo Enhancement

**Phase 3 (Scale):**
9. ✅ AI Community Insights
10. ✅ Toxic Content Prevention
11. ✅ Community Health Monitoring
12. ✅ Social Media Auto-Post

---

## Summary

By leveraging n8n, you can:
1. **Offload heavy processing** from the Flutter app
2. **Automate moderation** to reduce manual work
3. **Scale intelligently** without code changes
4. **Integrate multiple services** visually
5. **Adapt quickly** to changing requirements
6. **Reduce costs** through smart batching and caching
7. **Monitor everything** with centralized logging
8. **Maintain quality** with automated curation

The visual workflow builder makes it easy to iterate, debug, and add new automation as the community grows. Plus, you can reuse patterns across workflows and easily hand off to other team members.

n8n becomes your community automation engine, handling everything from badge awards to AI-powered insights while keeping your Flutter app clean and focused on the user experience.
