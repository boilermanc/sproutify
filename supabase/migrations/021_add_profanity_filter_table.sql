-- ========================================
-- PROFANITY FILTER TABLE
-- Migration 021: Add database-backed profanity filter
-- ========================================

-- Table to store profanity words that should be filtered
CREATE TABLE IF NOT EXISTS profanity_filter (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  word TEXT NOT NULL UNIQUE,
  severity TEXT DEFAULT 'medium', -- 'low', 'medium', 'high'
  enabled BOOLEAN DEFAULT true,
  context TEXT, -- Optional: 'general', 'hate_speech', 'violence', etc.
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for fast lookups
CREATE INDEX idx_profanity_filter_word ON profanity_filter(word);
CREATE INDEX idx_profanity_filter_enabled ON profanity_filter(enabled) WHERE enabled = true;

-- Row Level Security
ALTER TABLE profanity_filter ENABLE ROW LEVEL SECURITY;

-- Only authenticated users can view enabled words (for filtering)
-- Admins can view all words
CREATE POLICY "Anyone can view enabled profanity words" ON profanity_filter
  FOR SELECT USING (enabled = true);

-- Only service role (admin) can insert/update/delete
-- This will be managed through your admin build

-- Function to update updated_at timestamp
CREATE TRIGGER trigger_update_profanity_filter_updated_at
  BEFORE UPDATE ON profanity_filter
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Insert initial profanity words
INSERT INTO profanity_filter (word, severity, context) VALUES
  -- Common profanity
  ('fuck', 'high', 'general'),
  ('fucking', 'high', 'general'),
  ('fucked', 'high', 'general'),
  ('fucker', 'high', 'general'),
  ('fuckers', 'high', 'general'),
  ('shit', 'medium', 'general'),
  ('shitting', 'medium', 'general'),
  ('shitted', 'medium', 'general'),
  ('shitter', 'medium', 'general'),
  ('damn', 'low', 'general'),
  ('damned', 'low', 'general'),
  ('dammit', 'low', 'general'),
  ('hell', 'low', 'general'),
  ('hells', 'low', 'general'),
  ('ass', 'medium', 'general'),
  ('asses', 'medium', 'general'),
  ('asshole', 'high', 'general'),
  ('assholes', 'high', 'general'),
  ('bitch', 'high', 'general'),
  ('bitches', 'high', 'general'),
  ('bitching', 'high', 'general'),
  ('bastard', 'medium', 'general'),
  ('bastards', 'medium', 'general'),
  ('crap', 'low', 'general'),
  ('crappy', 'low', 'general'),
  ('piss', 'medium', 'general'),
  ('pissing', 'medium', 'general'),
  ('pissed', 'medium', 'general'),
  ('dick', 'medium', 'general'),
  ('dicks', 'medium', 'general'),
  ('dickhead', 'high', 'general'),
  ('cock', 'medium', 'general'),
  ('cocks', 'medium', 'general'),
  ('pussy', 'high', 'general'),
  ('pussies', 'high', 'general'),
  ('tits', 'medium', 'general'),
  ('titties', 'medium', 'general'),
  ('whore', 'high', 'general'),
  ('whores', 'high', 'general'),
  ('slut', 'high', 'general'),
  ('sluts', 'high', 'general'),
  ('cunt', 'high', 'general'),
  ('cunts', 'high', 'general'),
  -- Hate speech and slurs
  ('nigger', 'high', 'hate_speech'),
  ('niggers', 'high', 'hate_speech'),
  ('nigga', 'high', 'hate_speech'),
  ('niggas', 'high', 'hate_speech'),
  ('fag', 'high', 'hate_speech'),
  ('fags', 'high', 'hate_speech'),
  ('faggot', 'high', 'hate_speech'),
  ('faggots', 'high', 'hate_speech'),
  ('retard', 'high', 'hate_speech'),
  ('retarded', 'high', 'hate_speech'),
  ('retards', 'high', 'hate_speech'),
  ('gook', 'high', 'hate_speech'),
  ('gooks', 'high', 'hate_speech'),
  ('chink', 'high', 'hate_speech'),
  ('chinks', 'high', 'hate_speech'),
  ('kike', 'high', 'hate_speech'),
  ('kikes', 'high', 'hate_speech'),
  ('spic', 'high', 'hate_speech'),
  ('spics', 'high', 'hate_speech'),
  -- Other offensive terms
  ('idiot', 'low', 'general'),
  ('idiots', 'low', 'general'),
  ('idiotic', 'low', 'general'),
  ('moron', 'low', 'general'),
  ('morons', 'low', 'general'),
  ('stupid', 'low', 'general'),
  ('stupidity', 'low', 'general'),
  ('dumb', 'low', 'general'),
  ('dumbass', 'medium', 'general'),
  ('loser', 'low', 'general'),
  ('losers', 'low', 'general'),
  -- Violence/threats
  ('kill', 'high', 'violence'),
  ('killing', 'high', 'violence'),
  ('killed', 'high', 'violence'),
  ('killer', 'high', 'violence'),
  ('die', 'medium', 'violence'),
  ('dying', 'medium', 'violence'),
  ('death', 'medium', 'violence'),
  ('murder', 'high', 'violence'),
  ('murdering', 'high', 'violence'),
  ('murdered', 'high', 'violence'),
  ('rape', 'high', 'violence'),
  ('raping', 'high', 'violence'),
  ('raped', 'high', 'violence'),
  ('rapist', 'high', 'violence'),
  ('suicide', 'high', 'violence'),
  ('suicidal', 'high', 'violence'),
  -- Drug references
  ('cocaine', 'medium', 'drugs'),
  ('coke', 'medium', 'drugs'),
  ('heroin', 'medium', 'drugs'),
  ('meth', 'medium', 'drugs'),
  ('methamphetamine', 'medium', 'drugs'),
  ('crack', 'medium', 'drugs'),
  ('marijuana', 'low', 'drugs'),
  ('weed', 'low', 'drugs'),
  ('pot', 'low', 'drugs')
ON CONFLICT (word) DO NOTHING;

