# Migration Guide: Generic Tower Support

This guide walks you through applying the generic aeroponic tower system changes to your Sproutify database.

## Prerequisites

- Supabase CLI installed, OR
- Access to Supabase Dashboard SQL Editor
- Backup of your database (recommended)

## Step-by-Step Migration

### Option A: Using Supabase CLI (Recommended)

1. **Navigate to your project directory:**
   ```bash
   cd c:\Users\clint\Github\sproutify
   ```

2. **Check migration status:**
   ```bash
   supabase migration list
   ```

3. **Apply migrations:**
   ```bash
   supabase db push
   ```

   This will apply both:
   - `005_generic_tower_support.sql` - Schema changes
   - `006_seed_tower_brands.sql` - Brand data

4. **Verify migration:**
   ```bash
   supabase db diff
   ```
   Should show "No changes detected"

### Option B: Using Supabase Dashboard

1. **Open your Supabase project dashboard**

2. **Navigate to SQL Editor**

3. **Run Migration 005 (Schema Changes):**
   - Copy contents of `supabase/migrations/005_generic_tower_support.sql`
   - Paste into SQL Editor
   - Click "Run"
   - Wait for "Success" message

4. **Run Migration 006 (Brand Data):**
   - Copy contents of `supabase/migrations/006_seed_tower_brands.sql`
   - Paste into SQL Editor
   - Click "Run"
   - Wait for "Success" message

5. **Verify the changes:**
   ```sql
   -- Check tower_brands table exists
   SELECT * FROM tower_brands ORDER BY display_order;

   -- Verify existing towers migrated correctly
   SELECT tower_id, tower_name, port_count, tower_brand_id
   FROM my_towers
   LIMIT 10;

   -- Check usertowerdetails view
   SELECT user_email, tower_name, tower_type, ports
   FROM usertowerdetails
   LIMIT 10;
   ```

## What Gets Changed

### Database Changes

✅ **Tables Renamed:**
- `tower_gardens` → `tower_brands`

✅ **Columns Added:**
- `tower_brands.display_order` (for UI sorting)
- `tower_brands.allow_custom_name` (for "Other" option)
- `my_towers.port_count` (user-specified port count)

✅ **Columns Renamed:**
- `tower_gardens.tower_garden` → `tower_brands.brand_name`
- `tower_gardens.tg_corp_image` → `tower_brands.brand_logo_url`
- `my_towers.tower_garden_id` → `my_towers.tower_brand_id`

✅ **Columns Removed:**
- `tower_brands.ports` (moved to my_towers)

✅ **Data Migration:**
- Existing `my_towers` entries get `port_count = 20`
- Tower Garden brand data preserved
- Sample brands replaced with real brands

### App Code Changes

✅ **New Screens:**
- Port Count Input (between brand selection and tower naming)

✅ **Updated Screens:**
- Tower Catalog (grid layout, brand selection)
- Tower Catalog New (updated for new flow)
- Name Tower (passes port count forward)
- Indoor/Outdoor (saves port count to database)
- My Towers (reads port count from my_towers)

## Rollback Plan (If Needed)

If you need to rollback the migration:

### Manual Rollback SQL

```sql
BEGIN;

-- Rename tables back
ALTER TABLE tower_brands RENAME TO tower_gardens;

-- Rename columns back
ALTER TABLE tower_gardens RENAME COLUMN brand_name TO tower_garden;
ALTER TABLE tower_gardens RENAME COLUMN brand_logo_url TO tg_corp_image;
ALTER TABLE my_towers RENAME COLUMN tower_brand_id TO tower_garden_id;

-- Add ports column back to tower_gardens
ALTER TABLE tower_gardens ADD COLUMN ports DOUBLE PRECISION DEFAULT 20;

-- Remove new columns
ALTER TABLE tower_gardens DROP COLUMN display_order;
ALTER TABLE tower_gardens DROP COLUMN allow_custom_name;
ALTER TABLE my_towers DROP COLUMN port_count;

-- Recreate old foreign key
ALTER TABLE my_towers DROP CONSTRAINT my_towers_tower_brand_id_fkey;
ALTER TABLE my_towers
  ADD CONSTRAINT my_towers_tower_garden_id_fkey
  FOREIGN KEY (tower_garden_id)
  REFERENCES tower_gardens(id)
  ON DELETE SET NULL;

-- Recreate old materialized view
DROP MATERIALIZED VIEW IF EXISTS usertowerdetails;
-- [Previous view definition would go here]

COMMIT;
```

**Note:** Rollback will lose port count data for existing towers. They'll default back to 20.

## Post-Migration Tasks

### 1. Test the Flow

- [ ] Open the app
- [ ] Navigate to "Add Tower"
- [ ] Verify grid of brands displays
- [ ] Select a brand
- [ ] Enter port count
- [ ] Complete tower setup
- [ ] Verify tower appears in "My Towers" with correct port count

### 2. Add Brand Logos

Update the `brand_logo_url` for each brand. You can:

**Option 1: Upload to Supabase Storage**
1. Go to Storage in Supabase Dashboard
2. Create bucket `brand-logos` (public)
3. Upload logo images
4. Update database:
   ```sql
   UPDATE tower_brands
   SET brand_logo_url = 'https://[project].supabase.co/storage/v1/object/public/brand-logos/tower-garden.png'
   WHERE brand_name = 'Tower Garden';
   ```

**Option 2: Use External URLs**
```sql
UPDATE tower_brands
SET brand_logo_url = 'https://example.com/logos/aerospring.png'
WHERE brand_name = 'Aerospring';
```

### 3. Monitor for Issues

Check for:
- Users unable to add towers
- Missing port counts in My Towers
- Errors in database logs
- UI rendering issues with grid layout

### 4. Refresh Materialized View (Optional)

The migration automatically creates the view, but if you need to refresh it later:

```sql
REFRESH MATERIALIZED VIEW CONCURRENTLY usertowerdetails;
```

Or use the helper function:
```sql
SELECT refresh_usertowerdetails();
```

## Verification Queries

Run these to verify everything is working:

```sql
-- Check all brands are loaded
SELECT brand_name, is_active, display_order, allow_custom_name
FROM tower_brands
ORDER BY display_order;

-- Expected: 16 active brands + Tower Garden (17 total)

-- Check user towers have port counts
SELECT
  t.tower_name,
  t.port_count,
  b.brand_name
FROM my_towers t
LEFT JOIN tower_brands b ON t.tower_brand_id = b.id
LIMIT 20;

-- All should have port_count populated (20 for existing towers)

-- Check the materialized view works
SELECT
  user_email,
  tower_name,
  tower_type,
  ports,
  indoor_outdoor
FROM usertowerdetails
LIMIT 10;

-- Should return user data with brand names and port counts
```

## Common Issues & Solutions

### Issue: Migration fails with "column already exists"

**Solution:** Tables may have been partially migrated. Check:
```sql
\d tower_brands  -- Shows table structure
```
If `port_count` already exists on `my_towers`, skip that ALTER TABLE command.

### Issue: Old tower_gardens table still exists

**Solution:** The migration renames it. If both exist:
```sql
-- Check if old table has data
SELECT COUNT(*) FROM tower_gardens;
-- If zero, safe to drop
DROP TABLE tower_gardens CASCADE;
```

### Issue: Materialized view doesn't refresh

**Solution:**
```sql
DROP MATERIALIZED VIEW usertowerdetails;
-- Then re-run the CREATE MATERIALIZED VIEW section from migration 005
```

### Issue: App shows "TowerGardensTable not found"

**Solution:** The Dart code was updated to use `TowerBrandsTable`. Make sure you:
1. Deleted old `lib/backend/supabase/database/tables/tower_gardens.dart`
2. Have new `lib/backend/supabase/database/tables/tower_brands.dart`
3. Updated `database.dart` export

## Support

If you encounter issues:
1. Check Supabase logs in Dashboard → Logs
2. Review Flutter app console for errors
3. Verify migration files are present in `supabase/migrations/`
4. Ensure database export from `database.dart` matches new table names

---

**Last Updated:** 2025-01-09
**Migrations:** 005, 006
**Database Version:** PostgreSQL 15+
