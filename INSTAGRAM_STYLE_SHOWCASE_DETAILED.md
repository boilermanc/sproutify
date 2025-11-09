# Instagram-Style Tower Showcase - Detailed Specification

## Overview
A visual-first community feature where users share tower photos, celebrate harvests, and showcase their growing success. Combined with a comprehensive badge/achievement system to gamify the growing experience.

---

## Part 1: Tower Showcase Feed

### Core Features

#### 1. Photo Posts
**What Users Can Share:**
- Tower setup photos (full tower, close-ups, creative placements)
- Harvest photos (baskets of produce, individual plants)
- Growth progress (weekly updates, before/after)
- Creative installations (indoor setups, balcony gardens, multiple towers)

**Post Composition:**
```
┌─────────────────────────────────┐
│  @username · 2h ago            │
├─────────────────────────────────┤
│                                 │
│      [PHOTO - Full Width]       │
│                                 │
├─────────────────────────────────┤
│  ❤️ 47   💬 12   🔖 8          │
├─────────────────────────────────┤
│  🌿 Basil, Lettuce, Tomatoes   │ (Plant tags)
│  🏢 Indoor Tower #2             │ (Tower tag)
│                                 │
│  "First harvest of the season!  │
│   These tomatoes are amazing!"  │
│                                 │
│  #FirstHarvest #IndoorGarden    │
├─────────────────────────────────┤
│  View all 12 comments           │
└─────────────────────────────────┘
```

**Post Fields:**
- **Photo** (required): Single photo upload (Future: multi-photo carousel)
- **Caption** (optional): Max 500 characters
- **Plant Tags** (optional but encouraged): Select from plants in your garden or catalog
- **Tower Tag** (optional): Select from your towers
- **Hashtags** (optional): Auto-suggest or custom
- **Location** (optional): City-level only, privacy-conscious

**Photo Requirements:**
- Minimum resolution: 800x800px
- Maximum file size: 10MB
- Formats: JPG, PNG, HEIC
- Auto-crop to square or allow original aspect ratio (16:9, 4:3, 1:1)
- Optional filters (light editing: brightness, contrast, saturation)

---

#### 2. Feed Types & Filtering

**Main Feed Views:**

**A. For You (Personalized Algorithm)**
- Posts featuring plants user has favorited
- Posts from same climate zone
- Posts with plants user is currently growing
- Recently active users
- Featured/curated content
- Balances popular posts with fresh content

**B. Following**
- Posts only from growers user follows
- Chronological order (newest first)
- Shows when you're caught up

**C. Recent**
- All community posts, newest first
- Default view for new users (before they follow anyone)

**D. Popular**
- Most liked posts from past 7 days
- Then 30 days
- Then all time

**E. Featured**
- Admin-curated "best of" posts
- Weekly highlights
- Challenge winners
- Quality showcase

**Filter Options (All Feeds):**
```
Filter by:
├─ Plant Type
│  ├─ Herbs
│  ├─ Vegetables
│  ├─ Fruits
│  ├─ Greens
│  └─ Flowers
├─ Growing Location
│  ├─ Indoor
│  ├─ Outdoor
│  └─ Both
├─ Post Type (via hashtags)
│  ├─ #FirstHarvest
│  ├─ #TowerSetup
│  ├─ #GrowthProgress
│  ├─ #BiggestHarvest
│  └─ #CreativeSetup
└─ Time Period
   ├─ Today
   ├─ This Week
   ├─ This Month
   └─ All Time
```

---

#### 3. Post Interactions

**Engagement Actions:**

**❤️ Like**
- Single tap on photo or heart icon
- Counter visible to all
- Tap again to unlike
- Notification to poster when liked

**💬 Comments** (Phase 2 - Optional)
- Initially: DISABLED to prevent complaints
- When enabled: Positive-only prompts
  - "What tips do you have?"
  - "How long did this take to grow?"
  - "What's your secret?"
- Report inappropriate comments
- Auto-hide comments with negative words (configurable list)

**🔖 Bookmark/Save**
- Save posts to private collection
- Organize into collections: "Ideas for next season," "Setup inspiration," etc.
- Only user can see their bookmarks

**📤 Share** (Future)
- Share to other apps
- Copy link
- Share within app to followers

**🚩 Report**
- Report inappropriate content
- Reasons: Spam, Inappropriate, Unrelated, Other
- Goes to moderation queue
- Auto-hide if 3+ reports until reviewed

**Other Interactions:**
- Tap username → View user profile
- Tap plant tag → View plant details from catalog
- Tap tower tag → View tower details (if public)
- Tap hashtag → View all posts with that hashtag
- Tap photo → Full screen view with swipe to next/previous

---

#### 4. Creating a Post

**User Flow:**
```
1. Tap "+" button (bottom center of Community tab or top right)
   ↓
2. Select photo source:
   - Take photo now (opens camera)
   - Choose from gallery
   - Choose from recent tower/harvest photos already in app
   ↓
3. Edit photo screen:
   - Crop/rotate
   - Apply filter (optional): Natural, Vibrant, Fresh, Earthy
   - Adjust brightness/contrast
   ↓
4. Add details screen:
   ┌─────────────────────────────────────┐
   │ [Photo preview - top 1/3 of screen] │
   ├─────────────────────────────────────┤
   │ Caption (optional)                  │
   │ [Text input - 500 char limit]       │
   ├─────────────────────────────────────┤
   │ Tag Plants 🌿                       │
   │ [Searchable list from user plants + │
   │  catalog - multi-select]            │
   ├─────────────────────────────────────┤
   │ Tag Your Tower 🏢                   │
   │ [Dropdown: My towers]               │
   ├─────────────────────────────────────┤
   │ Add Hashtags #                      │
   │ [Suggested: #FirstHarvest,          │
   │  #IndoorGarden, etc.]               │
   │ [Or type custom]                    │
   ├─────────────────────────────────────┤
   │ Add Location 📍 (optional)          │
   │ [City, State]                       │
   ├─────────────────────────────────────┤
   │ Post to Challenge? 🏆               │
   │ [Current active challenge if any]   │
   ├─────────────────────────────────────┤
   │         [Cancel]    [Post]          │
   └─────────────────────────────────────┘
   ↓
5. Post published!
   - Appears in feed immediately (or after moderation)
   - User gets notification when post gets first like
   - Optional: Share to social media prompt
```

**Post Validation:**
- Photo is required
- At least one plant tag OR tower tag recommended (not required)
- Caption scanned for profanity (blocked if found)
- Photo scanned for inappropriate content (AI moderation)

---

#### 5. User Profiles (Community View)

When user taps on another user's name, they see:

```
┌─────────────────────────────────────┐
│  [Profile Photo]  @username         │
│                                     │
│  🌱 Growing since: Jan 2024         │
│  📍 Seattle, WA                     │
│  🏢 3 Towers · 🌿 47 Plants         │
│                                     │
│  ⭐ Level 12 Grower                 │
│  🏆 15 Badges Earned                │
│                                     │
│  Bio: "Indoor tower enthusiast,    │
│  love growing herbs and greens!"   │
│                                     │
│      [Follow] [Message]             │
│                                     │
├─────────────────────────────────────┤
│  Posts (24) | Badges | Stats        │ (Tabs)
├─────────────────────────────────────┤
│  [Grid of user's posts]             │
│  📷 📷 📷                            │
│  📷 📷 📷                            │
└─────────────────────────────────────┘
```

**Profile Stats:**
- Total posts
- Total likes received
- Plants grown (total count)
- Towers managed
- Member since date
- Current growing streak (days with active plants)
- Badges earned (see badge section below)

**Privacy Options:**
- Make profile public or private
- If private: Only approved followers see posts
- Hide location
- Hide stats

---

#### 6. Notifications

**Community-Related Notifications:**
- **Someone liked your post** - "John liked your harvest photo"
- **Someone commented** (if enabled) - "Sarah commented on your post"
- **New follower** - "Mike started following you"
- **You earned a badge!** - "🏆 You earned the First Harvest badge!"
- **Featured post** - "Your post was featured in Tower of the Week!"
- **Challenge reminder** - "2 days left to enter the Spring Greens Challenge!"
- **Milestone reached** - "You just hit 100 total likes! 🎉"

**Notification Settings:**
- Toggle each notification type on/off
- Digest mode: Daily summary instead of real-time
- Quiet hours

---

#### 7. Search & Discovery

**Search Functionality:**

**A. Search Posts**
- Search by caption text
- Search by plant name
- Search by username
- Search by hashtag
- Search by location

**B. Trending**
- Trending plants (most posted this week)
- Trending hashtags
- Popular growers (most followed/engaged)

**C. Explore Page**
```
┌─────────────────────────────────────┐
│  Trending This Week 🔥              │
│  ├─ #SpringHarvest (127 posts)      │
│  ├─ #BasilGang (89 posts)           │
│  └─ #IndoorGarden (156 posts)       │
├─────────────────────────────────────┤
│  Featured Growers 🌟                │
│  [Carousel of top growers]          │
├─────────────────────────────────────┤
│  Popular Plants This Month 🌿       │
│  ├─ Basil (234 posts)               │
│  ├─ Cherry Tomatoes (198 posts)     │
│  └─ Butterhead Lettuce (167 posts)  │
├─────────────────────────────────────┤
│  New Growers to Follow 👋           │
│  [Suggested users based on          │
│   similar plants/location]          │
└─────────────────────────────────────┘
```

---

## Part 2: Badge & Achievement System

### Badge Philosophy
Celebrate milestones, encourage engagement, and reward consistent growing. Badges should be:
- **Achievable** - Not too hard to earn first few
- **Progressive** - Tiered levels for ongoing achievement
- **Meaningful** - Tied to actual growing success, not just app usage
- **Visual** - Beautiful icons users want to collect

---

### Badge Categories & Examples

#### 1. **Getting Started Badges** (Onboarding)

**🌱 Seed Starter**
- Trigger: Create account and complete onboarding
- Description: "Welcome to the Sproutify community!"
- Tier: Single

**🏢 Tower Builder**
- Trigger: Add your first tower
- Description: "You've added your first tower to the app!"
- Tier: Single

**🌿 First Plant**
- Trigger: Add your first plant to a tower
- Description: "Your growing journey begins!"
- Tier: Single

**📸 First Post**
- Trigger: Share your first community post
- Description: "Thanks for sharing with the community!"
- Tier: Single

---

#### 2. **Harvest Badges** (Core Growing Achievement)

**🥬 First Harvest**
- Trigger: Mark first plant as harvested OR post with #FirstHarvest
- Description: "You harvested your first plant!"
- Tier: Single

**🌾 Harvest Milestones**
- Bronze: 5 harvests
- Silver: 25 harvests
- Gold: 50 harvests
- Platinum: 100 harvests
- Diamond: 250 harvests
- Description: "Keep harvesting!"

**📅 Seasonal Harvester**
- Trigger: Harvest at least one plant in all 4 seasons (within a year)
- Description: "Year-round grower!"
- Tier: Single (repeatable yearly)

**🍅 Variety Master**
- Bronze: Grow 10 different plant varieties
- Silver: 25 varieties
- Gold: 50 varieties
- Platinum: 100 varieties
- Description: "Experimental grower!"

---

#### 3. **Community Engagement Badges**

**❤️ Community Supporter**
- Bronze: Give 25 likes
- Silver: 100 likes
- Gold: 500 likes
- Platinum: 1,000 likes
- Description: "Spreading the love!"

**📸 Content Creator**
- Bronze: 5 posts
- Silver: 25 posts
- Gold: 50 posts
- Platinum: 100 posts
- Description: "Sharing your journey!"

**⭐ Rising Star**
- Trigger: Get 50 likes on a single post
- Description: "Your post went viral!"
- Tier: Single

**🏆 Influencer**
- Bronze: 100 total likes received
- Silver: 500 total likes
- Gold: 1,000 total likes
- Platinum: 5,000 total likes
- Description: "Community favorite!"

**👥 Social Butterfly**
- Bronze: 10 followers
- Silver: 50 followers
- Gold: 100 followers
- Platinum: 500 followers
- Description: "Building your network!"

**💬 Conversationalist** (If comments enabled)
- Bronze: Leave 25 helpful comments
- Silver: 100 comments
- Gold: 500 comments
- Description: "Sharing your knowledge!"

---

#### 4. **Growing Expertise Badges**

**🌿 Herb Master**
- Trigger: Successfully grow and harvest 10 different herbs
- Description: "Herb garden expert!"
- Tier: Single

**🥗 Salad Bar**
- Trigger: Grow 5 different lettuce/greens varieties simultaneously
- Description: "Fresh salads every day!"
- Tier: Single

**🍅 Tomato King/Queen**
- Trigger: Grow 3 different tomato varieties and harvest all
- Description: "Tomato enthusiast!"
- Tier: Single

**🌶️ Spice It Up**
- Trigger: Grow and harvest 5 different peppers
- Description: "Hot stuff!"
- Tier: Single

**🍓 Fruit Fanatic**
- Trigger: Grow 5 different fruit-bearing plants
- Description: "Sweet success!"
- Tier: Single

**📚 Plant Collector**
- Bronze: Have 10 active plants
- Silver: 25 active plants
- Gold: 50 active plants
- Platinum: 100 active plants
- Description: "Your tower is full!"

---

#### 5. **Consistency & Dedication Badges**

**📆 Weekly Warrior**
- Trigger: Log activity (add plant, update, or post) 7 days in a row
- Description: "Consistent grower!"
- Tiers: 1 week, 4 weeks, 12 weeks, 52 weeks (Year-Round Grower)

**⏰ Early Bird**
- Trigger: Log into app before 7am on 10 different days
- Description: "Morning garden check champion!"
- Tier: Single

**🌙 Night Owl**
- Trigger: Log activity after 10pm on 10 different days
- Description: "Late night growing check!"
- Tier: Single

**💪 Dedication**
- Trigger: Maintain at least one active plant for 365 consecutive days
- Description: "Year-round grower!"
- Tier: Single (repeatable yearly)

---

#### 6. **Tower Management Badges**

**🏗️ Tower Tycoon**
- Bronze: 2 towers
- Silver: 3 towers
- Gold: 5 towers
- Platinum: 10 towers
- Description: "Growing empire!"

**🏠 Indoor Grower**
- Trigger: Maintain an indoor tower for 90 days
- Description: "Indoor growing master!"
- Tier: Single

**☀️ Outdoor Grower**
- Trigger: Maintain an outdoor tower for 90 days
- Description: "Outdoor growing expert!"
- Tier: Single

**🌍 Hybrid Grower**
- Trigger: Maintain both indoor and outdoor towers simultaneously
- Description: "Best of both worlds!"
- Tier: Single

---

#### 7. **Water Quality Badges**

**💧 pH Perfect**
- Trigger: Log 30 pH readings within optimal range (5.5-6.5)
- Description: "Water quality expert!"
- Tier: Single

**⚡ EC Expert**
- Trigger: Log 30 EC readings and maintain optimal levels
- Description: "Nutrient balance master!"
- Tier: Single

**📊 Data Driven**
- Trigger: Log pH and EC for 30 consecutive days
- Description: "Consistent monitoring!"
- Tier: Single

---

#### 8. **Cost & Planning Badges**

**💰 Budget Tracker**
- Trigger: Log 20 cost entries
- Description: "Financial planning pro!"
- Tier: Single

**🛒 Supply Manager**
- Bronze: 10 supply items tracked
- Silver: 25 items
- Gold: 50 items
- Description: "Well-stocked grower!"

**📈 ROI Master**
- Trigger: Log total harvest value exceeding total costs
- Description: "Profitable growing!"
- Tier: Single (requires cost tracking + harvest value estimation)

---

#### 9. **Rating & Review Badges**

**⭐ Plant Critic**
- Bronze: Rate 5 plants
- Silver: 25 plants
- Gold: 50 plants
- Description: "Helpful reviewer!"

**📝 Detailed Reviewer**
- Trigger: Leave 10 reviews with photos
- Description: "Thorough and helpful!"
- Tier: Single

---

#### 10. **Special Event Badges**

**🎉 Challenge Champion**
- Trigger: Win a monthly challenge (top 3)
- Description: "Competition winner!"
- Tier: Repeatable (shows count)

**🏅 Challenge Participant**
- Bronze: Participate in 3 challenges
- Silver: 10 challenges
- Gold: 25 challenges
- Description: "Active community member!"

**🎊 Anniversary**
- Trigger: One year since joining Sproutify
- Description: "One year of growing!"
- Tiers: 1 year, 2 years, 3 years, 5 years

**🎃 Seasonal Grower**
- Trigger: Post during specific seasons/holidays
- Examples:
  - 🎃 Fall Harvest (post in Oct)
  - 🎄 Winter Greens (post in Dec)
  - 🌸 Spring Sprouts (post in Mar)
  - ☀️ Summer Bounty (post in Jun)

**🚀 Early Adopter**
- Trigger: Join within first 1,000 users (or first month of community launch)
- Description: "OG Sproutify grower!"
- Tier: Single

---

#### 11. **Achievement Meta-Badges**

**🏆 Badge Collector**
- Bronze: Earn 10 badges
- Silver: 25 badges
- Gold: 50 badges
- Platinum: 75 badges
- Description: "Achievement hunter!"

**💎 Completionist**
- Trigger: Earn all badges in a specific category
- Examples:
  - "Herb Master Completionist" (all herb badges)
  - "Community Completionist" (all community badges)

---

### Badge Display & Mechanics

#### Badge UI Elements

**1. Badge Icons**
- Unique icon for each badge type
- Tier indicated by color:
  - Bronze: #CD7F32
  - Silver: #C0C0C0
  - Gold: #FFD700
  - Platinum: #E5E4E2
  - Diamond: #B9F2FF

**2. Badge Card (When Earned)**
```
┌─────────────────────────────────────┐
│                                     │
│         🏆 NEW BADGE! 🏆           │
│                                     │
│      [Large Badge Icon]             │
│                                     │
│        First Harvest                │
│                                     │
│   "You harvested your first plant!" │
│                                     │
│    [Share] [View All Badges]        │
│                                     │
└─────────────────────────────────────┘
```
- Full-screen modal or prominent toast
- Confetti animation
- Sound effect (optional, can be disabled)
- Haptic feedback

**3. Badge Collection View**
```
┌─────────────────────────────────────┐
│  My Badges (24/100)                 │
│  Level 12 · 2,400 XP                │
├─────────────────────────────────────┤
│  [Tab: All | Earned | Locked]       │
├─────────────────────────────────────┤
│  Getting Started (5/5) ✓            │
│  🌱 🏢 🌿 📸 ⭐                     │
│                                     │
│  Harvest (3/6) ⚡                   │
│  🥬 🌾 📅 🔒 🔒 🔒                 │
│                                     │
│  Community (8/10) ⚡                │
│  ❤️ 📸 ⭐ 👥 💬 🏆 🔒 🔒          │
│                                     │
│  [Show more categories...]          │
└─────────────────────────────────────┘
```
- Grouped by category
- Progress bars for category completion
- Locked badges show silhouette + how to unlock
- Tap badge for details

**4. Badge Detail View**
```
┌─────────────────────────────────────┐
│         [Back]     [Share]          │
├─────────────────────────────────────┤
│                                     │
│      [Large Badge Icon]             │
│                                     │
│       🌾 Harvest Master             │
│         (Gold Tier)                 │
│                                     │
│  "You've harvested 50 plants!"      │
│                                     │
│  Earned: March 15, 2024             │
│  Rarity: Earned by 12% of growers   │
│                                     │
│  Next Tier: Platinum (100 harvests) │
│  Progress: 50/100 ▓▓▓▓▓░░░░░ 50%   │
│                                     │
└─────────────────────────────────────┘
```

**5. Profile Badge Display**
- Show top 3-5 most impressive badges on profile
- "Showcase" feature - user selects which badges to highlight
- Badge count visible on profile

---

#### Gamification Elements

**Experience Points (XP) System**
- Each badge earns XP
- XP determines user level
- XP values:
  - Common badge: 100 XP
  - Uncommon: 250 XP
  - Rare: 500 XP
  - Epic: 1,000 XP
  - Legendary: 2,500 XP

**User Levels**
- Level 1: 0 XP (New Grower)
- Level 5: 1,000 XP (Seedling)
- Level 10: 3,000 XP (Sprout)
- Level 15: 6,000 XP (Young Plant)
- Level 20: 10,000 XP (Established Grower)
- Level 25: 15,000 XP (Expert Grower)
- Level 30: 25,000 XP (Master Grower)
- Level 50: 50,000 XP (Legend)

**Level Benefits** (Optional)
- Cosmetic rewards (profile badges, themes)
- Early access to new features
- Priority support
- Featured in "Top Growers" section

---

### Badge Implementation Strategy

#### Phase 1: Core Badges (MVP)
- Getting Started (5 badges)
- First Harvest
- Community basics (First Post, Community Supporter)
- Plant Collector (Bronze only)
- Total: ~15 badges

#### Phase 2: Engagement Badges
- Full Community badges
- Harvest Milestones
- Tower Management
- Total: +20 badges

#### Phase 3: Advanced Badges
- Expertise badges (Herb Master, etc.)
- Water Quality
- Cost tracking
- Consistency
- Total: +30 badges

#### Phase 4: Special Events
- Challenge badges
- Seasonal badges
- Anniversary badges
- Total: +20 badges

---

### Badge Database Schema

```sql
-- Badge definitions (admin-managed)
CREATE TABLE badge_definitions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL, -- 'getting_started', 'harvest', 'community', etc.
  icon_url TEXT,
  tier TEXT, -- 'single', 'bronze', 'silver', 'gold', 'platinum', 'diamond'
  rarity TEXT, -- 'common', 'uncommon', 'rare', 'epic', 'legendary'
  xp_value INTEGER DEFAULT 100,
  trigger_type TEXT NOT NULL, -- 'manual', 'harvest_count', 'post_count', etc.
  trigger_threshold INTEGER, -- e.g., 5 for "5 harvests"
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);

-- User badges earned
CREATE TABLE user_badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  badge_id UUID REFERENCES badge_definitions(id),
  earned_at TIMESTAMP DEFAULT NOW(),
  showcased BOOLEAN DEFAULT false, -- If user wants to display on profile
  UNIQUE(user_id, badge_id)
);

-- User XP and level
CREATE TABLE user_gamification (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  total_xp INTEGER DEFAULT 0,
  current_level INTEGER DEFAULT 1,
  badges_earned INTEGER DEFAULT 0,
  last_badge_earned_at TIMESTAMP,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Badge progress tracking (for tiered badges)
CREATE TABLE badge_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  badge_category TEXT NOT NULL, -- 'harvest_count', 'post_count', etc.
  current_value INTEGER DEFAULT 0,
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, badge_category)
);
```

---

### Badge Notification & Sharing

**When User Earns Badge:**
1. In-app modal/toast with celebration
2. Push notification (if enabled)
3. Badge appears in collection
4. XP added to profile
5. Optional: Prompt to share

**Sharing Options:**
- Share to community feed as a post
- Share to external social media (Twitter, Instagram, Facebook)
- Share badge image with custom background

**Badge Share Image:**
```
┌─────────────────────────────────┐
│                                 │
│   🌿 SPROUTIFY ACHIEVEMENT 🌿   │
│                                 │
│      [Large Badge Icon]         │
│                                 │
│     First Harvest Master        │
│                                 │
│      @username                  │
│                                 │
│   #SproutifyGrower #Aeroponic   │
│                                 │
└─────────────────────────────────┘
```

---

## Part 3: Technical Implementation

### Database Schema (Complete)

```sql
-- ========================================
-- COMMUNITY POSTS
-- ========================================

CREATE TABLE community_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  photo_url TEXT NOT NULL,
  photo_aspect_ratio DECIMAL(3,2), -- e.g., 1.00 for square, 1.78 for 16:9
  caption TEXT,
  tower_id UUID REFERENCES my_towers(id),
  location_city TEXT,
  location_state TEXT,
  is_featured BOOLEAN DEFAULT false,
  is_approved BOOLEAN DEFAULT false, -- For moderation queue
  is_hidden BOOLEAN DEFAULT false, -- If reported/removed
  view_count INTEGER DEFAULT 0,
  likes_count INTEGER DEFAULT 0,
  comments_count INTEGER DEFAULT 0,
  shares_count INTEGER DEFAULT 0,
  reports_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_posts_user ON community_posts(user_id);
CREATE INDEX idx_posts_created ON community_posts(created_at DESC);
CREATE INDEX idx_posts_featured ON community_posts(is_featured, created_at DESC);
CREATE INDEX idx_posts_likes ON community_posts(likes_count DESC, created_at DESC);

-- ========================================
-- POST PLANT TAGS (Many-to-Many)
-- ========================================

CREATE TABLE post_plant_tags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  plant_id UUID REFERENCES plants(id),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(post_id, plant_id)
);

CREATE INDEX idx_post_plant_tags_post ON post_plant_tags(post_id);
CREATE INDEX idx_post_plant_tags_plant ON post_plant_tags(plant_id);

-- ========================================
-- POST HASHTAGS
-- ========================================

CREATE TABLE hashtags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tag TEXT UNIQUE NOT NULL, -- e.g., 'firstharvest' (lowercase, no #)
  display_tag TEXT NOT NULL, -- e.g., 'FirstHarvest' (display format)
  use_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE post_hashtags (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  hashtag_id UUID REFERENCES hashtags(id),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(post_id, hashtag_id)
);

CREATE INDEX idx_post_hashtags_post ON post_hashtags(post_id);
CREATE INDEX idx_post_hashtags_tag ON post_hashtags(hashtag_id);
CREATE INDEX idx_hashtags_count ON hashtags(use_count DESC);

-- ========================================
-- POST INTERACTIONS
-- ========================================

-- Likes
CREATE TABLE post_likes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

CREATE INDEX idx_post_likes_user ON post_likes(user_id);
CREATE INDEX idx_post_likes_post ON post_likes(post_id);

-- Comments (Phase 2)
CREATE TABLE post_comments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  comment_text TEXT NOT NULL,
  is_hidden BOOLEAN DEFAULT false,
  likes_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_post_comments_post ON post_comments(post_id, created_at);

-- Bookmarks/Saves
CREATE TABLE post_bookmarks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  collection_name TEXT, -- Optional: organize into collections
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

CREATE INDEX idx_post_bookmarks_user ON post_bookmarks(user_id);

-- Reports
CREATE TABLE post_reports (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  reason TEXT NOT NULL, -- 'spam', 'inappropriate', 'unrelated', 'other'
  additional_info TEXT,
  is_resolved BOOLEAN DEFAULT false,
  resolved_at TIMESTAMP,
  resolved_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, post_id)
);

CREATE INDEX idx_post_reports_unresolved ON post_reports(is_resolved, created_at);

-- ========================================
-- USER FOLLOWING
-- ========================================

CREATE TABLE user_follows (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  follower_id UUID REFERENCES users(id) ON DELETE CASCADE,
  following_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(follower_id, following_id),
  CHECK (follower_id != following_id) -- Can't follow yourself
);

CREATE INDEX idx_follows_follower ON user_follows(follower_id);
CREATE INDEX idx_follows_following ON user_follows(following_id);

-- ========================================
-- USER COMMUNITY PROFILE
-- ========================================

CREATE TABLE user_community_profiles (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  bio TEXT,
  profile_photo_url TEXT,
  is_public BOOLEAN DEFAULT true,
  show_location BOOLEAN DEFAULT true,
  show_stats BOOLEAN DEFAULT true,
  posts_count INTEGER DEFAULT 0,
  followers_count INTEGER DEFAULT 0,
  following_count INTEGER DEFAULT 0,
  total_likes_received INTEGER DEFAULT 0,
  joined_community_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- ========================================
-- NOTIFICATIONS
-- ========================================

CREATE TABLE community_notifications (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  type TEXT NOT NULL, -- 'post_liked', 'new_follower', 'badge_earned', 'post_commented', etc.
  title TEXT NOT NULL,
  message TEXT,
  related_user_id UUID REFERENCES users(id), -- Who triggered the notification
  related_post_id UUID REFERENCES community_posts(id),
  related_badge_id UUID REFERENCES badge_definitions(id),
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_community_notif_user ON community_notifications(user_id, is_read, created_at DESC);

-- ========================================
-- BADGES (from previous section)
-- ========================================

CREATE TABLE badge_definitions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL,
  icon_url TEXT,
  tier TEXT,
  rarity TEXT,
  xp_value INTEGER DEFAULT 100,
  trigger_type TEXT NOT NULL,
  trigger_threshold INTEGER,
  is_active BOOLEAN DEFAULT true,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE user_badges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  badge_id UUID REFERENCES badge_definitions(id),
  earned_at TIMESTAMP DEFAULT NOW(),
  showcased BOOLEAN DEFAULT false,
  UNIQUE(user_id, badge_id)
);

CREATE INDEX idx_user_badges_user ON user_badges(user_id);
CREATE INDEX idx_user_badges_showcased ON user_badges(user_id, showcased);

CREATE TABLE user_gamification (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  total_xp INTEGER DEFAULT 0,
  current_level INTEGER DEFAULT 1,
  badges_earned INTEGER DEFAULT 0,
  last_badge_earned_at TIMESTAMP,
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE badge_progress (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  badge_category TEXT NOT NULL,
  current_value INTEGER DEFAULT 0,
  updated_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, badge_category)
);

-- ========================================
-- MONTHLY CHALLENGES
-- ========================================

CREATE TABLE monthly_challenges (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  theme TEXT NOT NULL,
  description TEXT,
  hashtag TEXT, -- e.g., 'SpringHarvest2024'
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  is_active BOOLEAN DEFAULT true,
  prize_description TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE challenge_submissions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  challenge_id UUID REFERENCES monthly_challenges(id) ON DELETE CASCADE,
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  votes_count INTEGER DEFAULT 0,
  is_winner BOOLEAN DEFAULT false,
  winner_rank INTEGER, -- 1st, 2nd, 3rd place
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, challenge_id)
);

CREATE TABLE challenge_votes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  submission_id UUID REFERENCES challenge_submissions(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(user_id, submission_id)
);

-- ========================================
-- ANALYTICS & TRACKING
-- ========================================

CREATE TABLE post_views (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  post_id UUID REFERENCES community_posts(id) ON DELETE CASCADE,
  user_id UUID REFERENCES users(id), -- NULL for anonymous views
  viewed_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_post_views_post ON post_views(post_id);
CREATE INDEX idx_post_views_date ON post_views(viewed_at);

-- Aggregate stats (updated daily via cron)
CREATE TABLE community_stats (
  stat_date DATE PRIMARY KEY,
  total_posts INTEGER DEFAULT 0,
  total_users INTEGER DEFAULT 0,
  active_users_today INTEGER DEFAULT 0,
  total_likes INTEGER DEFAULT 0,
  total_comments INTEGER DEFAULT 0,
  total_badges_earned INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

### Supabase Functions Needed

**1. Get Personalized Feed**
```sql
CREATE OR REPLACE FUNCTION get_personalized_feed(
  p_user_id UUID,
  p_limit INTEGER DEFAULT 20,
  p_offset INTEGER DEFAULT 0
)
RETURNS TABLE (
  post_id UUID,
  user_id UUID,
  username TEXT,
  user_photo TEXT,
  photo_url TEXT,
  caption TEXT,
  likes_count INTEGER,
  comments_count INTEGER,
  created_at TIMESTAMP,
  is_liked_by_user BOOLEAN,
  is_bookmarked_by_user BOOLEAN,
  plant_tags JSON,
  tower_name TEXT,
  hashtags JSON
) AS $$
BEGIN
  -- Complex query combining:
  -- - Following feed
  -- - Popular posts
  -- - Relevant posts (same plants user is growing)
  -- - Featured posts
  -- Ordered by relevance score
END;
$$ LANGUAGE plpgsql;
```

**2. Check and Award Badges**
```sql
CREATE OR REPLACE FUNCTION check_and_award_badges(
  p_user_id UUID,
  p_trigger_type TEXT
)
RETURNS TABLE (
  badge_id UUID,
  badge_name TEXT,
  newly_earned BOOLEAN
) AS $$
BEGIN
  -- Check badge progress for user
  -- Award badges if thresholds met
  -- Update user XP and level
  -- Return list of newly earned badges
END;
$$ LANGUAGE plpgsql;
```

**3. Increment Post Stats**
```sql
CREATE OR REPLACE FUNCTION increment_post_likes(
  p_post_id UUID,
  p_user_id UUID
)
RETURNS BOOLEAN AS $$
BEGIN
  -- Insert like
  -- Increment counter
  -- Create notification
  -- Return success
END;
$$ LANGUAGE plpgsql;
```

---

### Flutter Components Needed

**New Screens:**
1. `community_feed_page.dart` - Main feed screen
2. `post_detail_page.dart` - Single post view
3. `create_post_page.dart` - New post creation
4. `user_profile_page.dart` - Community profile
5. `badges_page.dart` - Badge collection
6. `explore_page.dart` - Discovery/search
7. `challenge_detail_page.dart` - Monthly challenge view
8. `hashtag_feed_page.dart` - Posts by hashtag

**New Components:**
1. `post_card_widget.dart` - Post display in feed
2. `badge_card_widget.dart` - Badge display
3. `badge_earned_modal.dart` - Badge unlock animation
4. `user_avatar_widget.dart` - Profile photo with level ring
5. `hashtag_chip.dart` - Tappable hashtag
6. `plant_tag_chip.dart` - Tappable plant tag
7. `level_progress_bar.dart` - XP/Level display
8. `challenge_banner.dart` - Active challenge promotion

**Updated Components:**
1. Update bottom nav to include "Community" tab
2. Update user profile to include community stats
3. Update plant details to show community posts featuring that plant

---

### Photo Upload & Storage

**Supabase Storage Setup:**
```
Bucket: community-posts
├─ /users/{user_id}/
│  ├─ post_{post_id}_original.jpg
│  ├─ post_{post_id}_1080.jpg (feed size)
│  ├─ post_{post_id}_480.jpg (thumbnail)
│  └─ post_{post_id}_240.jpg (tiny thumbnail)
```

**Upload Flow:**
1. User selects photo
2. Client-side compression (if > 10MB)
3. Upload original to Supabase Storage
4. Trigger serverless function to create thumbnails
5. Save post record with photo URLs
6. Return success to client

**Image Processing:**
- Use `image` package in Flutter for client-side resize
- Or use Supabase Edge Function with sharp/imaginary for server-side

---

### Push Notification Setup

**Types:**
```dart
enum CommunityNotificationType {
  postLiked,
  postCommented,
  newFollower,
  badgeEarned,
  postFeatured,
  challengeReminder,
  milestoneReached,
}
```

**Notification Payload:**
```json
{
  "type": "post_liked",
  "title": "John liked your post",
  "message": "Your harvest photo has 10 likes!",
  "data": {
    "post_id": "uuid",
    "user_id": "uuid",
    "timestamp": "2024-03-15T10:30:00Z"
  }
}
```

---

## Part 4: Moderation & Safety

### Content Moderation Strategy

**Automated Moderation:**
1. **Profanity Filter**
   - Block posts with profanity in caption
   - Customizable word list

2. **Image Analysis** (Optional - requires third-party service)
   - Google Cloud Vision API or AWS Rekognition
   - Detect inappropriate content
   - Flag for manual review if confidence low

3. **Spam Detection**
   - Rate limiting: Max 10 posts per day
   - Detect duplicate posts (same image hash)
   - Auto-flag posts with excessive hashtags (>10)

**Manual Moderation:**
1. **Report Queue**
   - Admin dashboard to review reported posts
   - Quick actions: Approve, Hide, Delete, Ban User

2. **New User Approval** (Optional)
   - First 3 posts require approval
   - After approval, auto-publish

3. **Featured Content Curation**
   - Admin can feature/unfeature posts
   - Curate "Best of Week" collections

**User Actions:**
- Report post (with reason)
- Block user (won't see their posts)
- Mute user (see posts but no notifications)

---

### Community Guidelines (To Display in App)

```markdown
# Sproutify Community Guidelines

Welcome to our community of tower growers! This is a space to celebrate your success, share your growing journey, and inspire others.

## ✅ Please Do:
- Share photos of your towers, plants, and harvests
- Celebrate your growing milestones
- Tag plants and towers in your posts
- Engage positively with other growers
- Share tips and encouragement in comments
- Report content that violates guidelines

## ❌ Please Don't:
- Post unrelated content (non-gardening)
- Use inappropriate language or imagery
- Spam or self-promote products/services
- Share others' content without permission
- Complain or post negative rants
- Harass or bully other users

## 🚨 For Help & Support:
If you're experiencing issues with your tower or plants, please use our AI Assistant (Tower Buddy) or contact support directly. The community feed is for celebrating success, not troubleshooting.

Thank you for helping keep Sproutify a positive, inspiring community!
```

---

## Part 5: Launch Strategy

### Phased Rollout

**Beta Phase (2-4 weeks)**
- Invite 50-100 active users
- Basic feed + likes only
- 15 core badges
- Gather feedback
- Fix bugs

**Soft Launch (1-2 months)**
- Open to all users
- Add hashtags, filters
- Add more badges (50 total)
- First monthly challenge
- Monitor engagement

**Full Launch**
- Comments (if safe)
- Following system
- Advanced features
- Marketing push

### Success Metrics

**Engagement:**
- % of users who post at least once (target: 30%)
- Average posts per active user (target: 5/month)
- Average likes per post (target: 10+)
- Daily active users in community tab (target: 40% of DAU)

**Content Quality:**
- % of posts that are featured (target: 5%)
- Report rate (target: <1%)
- Approval rate (target: >95%)

**Retention:**
- 7-day retention of users who post (target: 60%)
- 30-day retention (target: 40%)

**Badges:**
- % users with at least 1 badge (target: 80%)
- Average badges per user (target: 8)
- % users checking badge page weekly (target: 25%)

---

## Summary

This Instagram-style showcase combined with comprehensive badge system will:

1. **Drive Engagement**: Visual content is inherently more engaging than text
2. **Build Community**: Users feel connected to other growers
3. **Increase Retention**: Badges and challenges give reasons to return
4. **Showcase Success**: Positive-only environment celebrates wins
5. **Provide Value**: Inspiration, ideas, and social proof for new growers
6. **Encourage Consistency**: Streaks and milestones reward ongoing use
7. **Enable Discovery**: Hashtags and tags help users find relevant content
8. **Create FOMO**: Featured posts and challenges motivate participation
9. **Generate UGC**: Free marketing content from happy users
10. **Differentiate Product**: No other aeroponic app has this level of community

The key to success is maintaining the positive, celebration-focused culture while preventing it from becoming a complaint forum. Strict moderation, smart UX design (no general comments initially), and clear guidelines will be essential.
