-- ========================================
-- SPROUTIFY COMMUNITY FEATURE - BADGE SEED DATA
-- Migration 003: Insert Initial Badges
-- ========================================

-- ========================================
-- GETTING STARTED BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Seed Starter', 'Welcome to the Sproutify community!', 'getting_started', 'single', 'common', 100, 'account_created', 1, 1),
  ('Tower Builder', 'You added your first tower to the app!', 'getting_started', 'single', 'common', 100, 'tower_added', 1, 2),
  ('First Plant', 'Your growing journey begins!', 'getting_started', 'single', 'common', 100, 'plant_added', 1, 3),
  ('First Post', 'Thanks for sharing with the community!', 'getting_started', 'single', 'common', 100, 'post_created', 1, 4),
  ('Profile Complete', 'You completed your community profile!', 'getting_started', 'single', 'common', 100, 'profile_completed', 1, 5);

-- ========================================
-- HARVEST BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('First Harvest', 'You harvested your first plant!', 'harvest', 'single', 'common', 250, 'harvest_logged', 1, 10),
  ('Harvest Novice', 'Keep harvesting!', 'harvest', 'bronze', 'common', 100, 'harvest_count', 5, 11),
  ('Harvest Enthusiast', 'Growing strong!', 'harvest', 'silver', 'uncommon', 250, 'harvest_count', 25, 12),
  ('Harvest Expert', 'Master grower!', 'harvest', 'gold', 'rare', 500, 'harvest_count', 50, 13),
  ('Harvest Master', 'Incredible dedication!', 'harvest', 'platinum', 'epic', 1000, 'harvest_count', 100, 14),
  ('Harvest Legend', 'Legendary grower!', 'harvest', 'diamond', 'legendary', 2500, 'harvest_count', 250, 15),
  ('Seasonal Harvester', 'You harvested in all 4 seasons!', 'harvest', 'single', 'rare', 500, 'seasonal_harvest', 4, 16);

-- ========================================
-- PLANT VARIETY BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Variety Explorer', 'Grow different plant varieties!', 'variety', 'bronze', 'common', 100, 'plant_variety_count', 10, 20),
  ('Variety Enthusiast', 'Experimental grower!', 'variety', 'silver', 'uncommon', 250, 'plant_variety_count', 25, 21),
  ('Variety Master', 'So many varieties!', 'variety', 'gold', 'rare', 500, 'plant_variety_count', 50, 22),
  ('Variety Legend', 'Ultimate variety!', 'variety', 'platinum', 'epic', 1000, 'plant_variety_count', 100, 23);

-- ========================================
-- EXPERTISE BADGES (Plant-Specific)
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Herb Master', 'Successfully grew 10 different herbs!', 'expertise', 'single', 'rare', 500, 'herb_variety', 10, 30),
  ('Salad Bar', 'Growing 5 different lettuce varieties!', 'expertise', 'single', 'rare', 500, 'lettuce_variety', 5, 31),
  ('Tomato Royalty', 'Grew 3 different tomato varieties!', 'expertise', 'single', 'rare', 500, 'tomato_variety', 3, 32),
  ('Spice Master', 'Grew and harvested 5 different peppers!', 'expertise', 'single', 'rare', 500, 'pepper_variety', 5, 33),
  ('Fruit Fanatic', 'Grew 5 different fruit-bearing plants!', 'expertise', 'single', 'rare', 500, 'fruit_variety', 5, 34);

-- ========================================
-- COMMUNITY ENGAGEMENT BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Community Supporter', 'Spreading the love!', 'community', 'bronze', 'common', 100, 'likes_given', 25, 40),
  ('Super Supporter', 'Keep supporting others!', 'community', 'silver', 'uncommon', 250, 'likes_given', 100, 41),
  ('Mega Supporter', 'Amazing support!', 'community', 'gold', 'rare', 500, 'likes_given', 500, 42),
  ('Ultimate Supporter', 'Community champion!', 'community', 'platinum', 'epic', 1000, 'likes_given', 1000, 43);

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Content Creator', 'Sharing your journey!', 'community', 'bronze', 'common', 100, 'post_count', 5, 50),
  ('Active Creator', 'Keep posting!', 'community', 'silver', 'uncommon', 250, 'post_count', 25, 51),
  ('Prolific Creator', 'So much content!', 'community', 'gold', 'rare', 500, 'post_count', 50, 52),
  ('Legendary Creator', 'Content master!', 'community', 'platinum', 'epic', 1000, 'post_count', 100, 53);

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Rising Star', 'Your post got 50 likes!', 'community', 'single', 'uncommon', 250, 'post_likes_received', 50, 60),
  ('Viral Post', 'Your post got 100 likes!', 'community', 'single', 'rare', 500, 'post_likes_received', 100, 61),
  ('Influencer', 'Community favorite!', 'community', 'bronze', 'uncommon', 100, 'total_likes_received', 100, 62),
  ('Top Influencer', 'Everyone loves your posts!', 'community', 'silver', 'rare', 250, 'total_likes_received', 500, 63),
  ('Mega Influencer', 'Inspiring thousands!', 'community', 'gold', 'epic', 500, 'total_likes_received', 1000, 64),
  ('Legend Influencer', 'Community legend!', 'community', 'platinum', 'legendary', 1000, 'total_likes_received', 5000, 65);

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Social Butterfly', 'Building your network!', 'community', 'bronze', 'common', 100, 'followers_count', 10, 70),
  ('Popular Grower', 'People love following you!', 'community', 'silver', 'uncommon', 250, 'followers_count', 50, 71),
  ('Community Leader', 'Leading the community!', 'community', 'gold', 'rare', 500, 'followers_count', 100, 72),
  ('Community Icon', 'Everyone knows you!', 'community', 'platinum', 'epic', 1000, 'followers_count', 500, 73);

-- ========================================
-- CONSISTENCY & DEDICATION BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Weekly Warrior', 'Logged activity for 7 days straight!', 'consistency', 'single', 'uncommon', 250, 'streak_days', 7, 80),
  ('Monthly Maintainer', '30 day streak!', 'consistency', 'single', 'rare', 500, 'streak_days', 30, 81),
  ('Quarterly Grower', '90 day streak!', 'consistency', 'single', 'epic', 1000, 'streak_days', 90, 82),
  ('Year-Round Grower', 'Full year streak!', 'consistency', 'single', 'legendary', 2500, 'streak_days', 365, 83),
  ('Dedication Master', 'Maintained plants for 365 days!', 'consistency', 'single', 'legendary', 2500, 'active_plants_days', 365, 84);

-- ========================================
-- TOWER MANAGEMENT BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Tower Owner', 'Growing empire begins!', 'tower', 'bronze', 'common', 100, 'tower_count', 2, 90),
  ('Tower Manager', 'Multiple towers!', 'tower', 'silver', 'uncommon', 250, 'tower_count', 3, 91),
  ('Tower Tycoon', 'Tower empire!', 'tower', 'gold', 'rare', 500, 'tower_count', 5, 92),
  ('Tower Mogul', 'Tower master!', 'tower', 'platinum', 'epic', 1000, 'tower_count', 10, 93),
  ('Indoor Grower', 'Maintained indoor tower for 90 days!', 'tower', 'single', 'uncommon', 250, 'indoor_tower_days', 90, 94),
  ('Outdoor Grower', 'Maintained outdoor tower for 90 days!', 'tower', 'single', 'uncommon', 250, 'outdoor_tower_days', 90, 95),
  ('Hybrid Grower', 'Growing both indoor and outdoor!', 'tower', 'single', 'rare', 500, 'hybrid_towers', 1, 96);

-- ========================================
-- PLANT COLLECTION BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Plant Collector', 'Your tower is filling up!', 'collection', 'bronze', 'common', 100, 'active_plants', 10, 100),
  ('Plant Enthusiast', 'So many plants!', 'collection', 'silver', 'uncommon', 250, 'active_plants', 25, 101),
  ('Plant Expert', 'Tower is packed!', 'collection', 'gold', 'rare', 500, 'active_plants', 50, 102),
  ('Plant Master', 'Maximum capacity!', 'collection', 'platinum', 'epic', 1000, 'active_plants', 100, 103);

-- ========================================
-- WATER QUALITY BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('pH Perfect', '30 pH readings in optimal range!', 'water_quality', 'single', 'uncommon', 250, 'ph_perfect_count', 30, 110),
  ('EC Expert', '30 EC readings at optimal levels!', 'water_quality', 'single', 'uncommon', 250, 'ec_optimal_count', 30, 111),
  ('Data Driven', 'Logged pH and EC for 30 days straight!', 'water_quality', 'single', 'rare', 500, 'water_log_streak', 30, 112);

-- ========================================
-- COST TRACKING BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Budget Tracker', 'Financial planning pro!', 'cost', 'single', 'uncommon', 250, 'cost_entries', 20, 120),
  ('Supply Manager', 'Well-stocked grower!', 'cost', 'bronze', 'common', 100, 'supply_items', 10, 121),
  ('Organized Grower', 'Great organization!', 'cost', 'silver', 'uncommon', 250, 'supply_items', 25, 122),
  ('Master Organizer', 'Everything tracked!', 'cost', 'gold', 'rare', 500, 'supply_items', 50, 123);

-- ========================================
-- RATING & REVIEW BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Plant Critic', 'Helpful reviewer!', 'rating', 'bronze', 'common', 100, 'ratings_count', 5, 130),
  ('Expert Reviewer', 'So many reviews!', 'rating', 'silver', 'uncommon', 250, 'ratings_count', 25, 131),
  ('Master Reviewer', 'Review master!', 'rating', 'gold', 'rare', 500, 'ratings_count', 50, 132),
  ('Detailed Reviewer', 'Thorough and helpful!', 'rating', 'single', 'uncommon', 250, 'photo_reviews', 10, 133);

-- ========================================
-- CHALLENGE BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Challenge Champion', 'You won a monthly challenge!', 'challenge', 'single', 'epic', 1000, 'challenge_won', 1, 140),
  ('Challenge Participant', 'Active community member!', 'challenge', 'bronze', 'uncommon', 100, 'challenges_entered', 3, 141),
  ('Challenge Regular', 'Love the challenges!', 'challenge', 'silver', 'rare', 250, 'challenges_entered', 10, 142),
  ('Challenge Master', 'Challenge expert!', 'challenge', 'gold', 'epic', 500, 'challenges_entered', 25, 143);

-- ========================================
-- SEASONAL BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Spring Sprouts', 'Posted during Spring season!', 'seasonal', 'single', 'common', 100, 'spring_post', 1, 150),
  ('Summer Bounty', 'Posted during Summer season!', 'seasonal', 'single', 'common', 100, 'summer_post', 1, 151),
  ('Fall Harvest', 'Posted during Fall season!', 'seasonal', 'single', 'common', 100, 'fall_post', 1, 152),
  ('Winter Greens', 'Posted during Winter season!', 'seasonal', 'single', 'common', 100, 'winter_post', 1, 153);

-- ========================================
-- MILESTONE BADGES
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('One Year Anniversary', 'One year of growing!', 'milestone', 'single', 'rare', 500, 'account_age_days', 365, 160),
  ('Two Year Veteran', 'Two years of growing!', 'milestone', 'single', 'epic', 1000, 'account_age_days', 730, 161),
  ('Three Year Master', 'Three years strong!', 'milestone', 'single', 'legendary', 2500, 'account_age_days', 1095, 162),
  ('Early Adopter', 'You were here from the beginning!', 'milestone', 'single', 'legendary', 2500, 'early_adopter', 1, 163);

-- ========================================
-- META BADGES (Badge Collecting)
-- ========================================

INSERT INTO badge_definitions (name, description, category, tier, rarity, xp_value, trigger_type, trigger_threshold, sort_order)
VALUES
  ('Badge Hunter', 'Achievement hunter!', 'meta', 'bronze', 'uncommon', 100, 'badges_earned', 10, 170),
  ('Badge Collector', 'So many badges!', 'meta', 'silver', 'rare', 250, 'badges_earned', 25, 171),
  ('Badge Master', 'Badge master!', 'meta', 'gold', 'epic', 500, 'badges_earned', 50, 172),
  ('Badge Legend', 'Ultimate collector!', 'meta', 'platinum', 'legendary', 1000, 'badges_earned', 75, 173);

-- Note: icon_url will need to be populated with actual badge icon URLs
-- You can update these later with:
-- UPDATE badge_definitions SET icon_url = 'https://your-storage-url.com/badges/badge_name.png' WHERE name = 'Badge Name';
