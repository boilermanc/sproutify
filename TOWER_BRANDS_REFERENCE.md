# Tower Brands Reference Guide

This document provides reference information for the aeroponic tower brands supported in Sproutify.

## Supported Brands & Typical Configurations

### Premium Tier

| Brand | Typical Port Counts | Price Range | Notes |
|-------|-------------------|-------------|-------|
| **Tower Garden** | 20, 28 | $650-$850 | Original system, educational popularity |
| **Aerospring** | 27 | $700+ | Hexagonal modular design |
| **Lettuce Grow Farmstand** | 18, 24, 36 | $600-$900 | Self-watering, sustainable |
| **Gardyn** | 30 | $800+ | AI-assisted, smart monitoring |
| **Rise Gardens** | 12, 24, 30 | $400-$900 | Modular, Wi-Fi control |

### Mid-Range

| Brand | Typical Port Counts | Price Range | Notes |
|-------|-------------------|-------------|-------|
| **AeroGarden** | 6, 9, 12, 24, 30 | $100-$900 | WiFi automation, beginner-friendly |
| **EXO Tower** | 24, 28 | $350-$500 | Cost-effective, plug-and-play |
| **ALTO Garden GX** | 20, 24, 30 | $600-$650 | Compact, balanced size/cost |
| **iHarvest** | 30 | $500-$700 | Hybrid hydro-aeroponic |

### Budget-Friendly

| Brand | Typical Port Counts | Price Range | Notes |
|-------|-------------------|-------------|-------|
| **Nutraponics** | 20, 30, 40 | $200-$400 | Space-saving, rapid growth |
| **AVUX Hydroponic Tower** | 30 | $130-$200 | Budget-friendly, reliable |
| **4P6 Hydro Tower** | 24 | $130+ | Compact, affordable |

### High Capacity

| Brand | Typical Port Counts | Price Range | Notes |
|-------|-------------------|-------------|-------|
| **ZMXT 80-Pot Tower** | 80 | $400-$800 | True spray aeroponic |

### Specialty

| Brand | Typical Port Counts | Price Range | Notes |
|-------|-------------------|-------------|-------|
| **Garden Tower Project** | 30, 50 | $200-$500 | Vertical composting hybrid |
| **Mother** | Varies | $150-$400 | Microgreens, decorative |
| **Auk Hydroponic System** | 12, 20 | $300+ | European market |

### Custom

| Brand | Typical Port Counts | Notes |
|-------|-------------------|-------|
| **Other** | Any (1-100) | User specifies their own brand name and port count |

---

## Common Port Count Options

Based on the systems above, here are the most common port counts users might enter:

- **Small**: 6, 9, 12
- **Medium**: 18, 20, 24, 27, 30
- **Large**: 36, 40, 50
- **Extra Large**: 80

## Implementation Notes

### Database Structure

Users select a **brand** first, then enter their **port count**. This allows flexibility for:
- Different models of the same brand (e.g., AeroGarden 6 vs AeroGarden 30)
- Custom configurations
- Modular systems with variable sizes
- Future expansion without schema changes

### Logo Assets

Brand logos should be added to the `tower_brands.brand_logo_url` field. You can:

1. **Upload to Supabase Storage:**
   ```sql
   UPDATE tower_brands
   SET brand_logo_url = 'https://your-supabase-project.supabase.co/storage/v1/object/public/brand-logos/tower-garden.png'
   WHERE brand_name = 'Tower Garden';
   ```

2. **Use External URLs:**
   - Make sure images are properly licensed
   - Recommended size: 200x200px minimum
   - Format: PNG with transparent background preferred

3. **Fallback:**
   - If `brand_logo_url` is NULL or empty, the app shows: `assets/images/Tower_Garden_Clip_100x100.png`

### Adding New Brands

To add a new brand to the system:

```sql
INSERT INTO tower_brands (brand_name, brand_logo_url, is_active, display_order, allow_custom_name)
VALUES ('New Brand Name', 'https://...logo-url...', true, 17, false);
```

**Parameters:**
- `brand_name`: Display name of the brand
- `brand_logo_url`: URL to logo image (NULL for fallback)
- `is_active`: `true` to show in selection screen
- `display_order`: Lower numbers appear first (use 17, 18, 19... for new brands)
- `allow_custom_name`: `false` for preset brands, `true` only for "Other"

### Deactivating Brands

To temporarily hide a brand without deleting user data:

```sql
UPDATE tower_brands
SET is_active = false
WHERE brand_name = 'Brand Name';
```

---

## User Flow Example

1. **User selects "Aerospring"** from grid
2. **System navigates to port count input** with "Aerospring" pre-filled
3. **User enters "27"** (standard Aerospring configuration)
4. **User names their tower** "Patio Garden"
5. **User selects location** "Outside"
6. **System creates tower:**
   ```
   tower_brand_id: 2 (Aerospring)
   port_count: 27
   tower_name: "Patio Garden"
   indoor_outdoor: "Outside"
   ```

## Testing Checklist

After running migrations:

- [ ] Verify all brands appear in tower selection grid
- [ ] Brands are sorted by `display_order`
- [ ] Clicking each brand navigates to port count input
- [ ] "Other" brand shows custom name input field
- [ ] Port count validation works (1-100 range)
- [ ] Tower creation succeeds with all data saved
- [ ] Existing towers still display correctly with 20 ports
- [ ] My Towers page shows custom port counts

---

## References

Based on market research as of 2025:
- Tower Garden remains the gold standard for education and reliability
- Smart systems (Gardyn, Rise Gardens) are trending for home automation
- Budget systems (AVUX, 4P6) opening market to more users
- High-capacity systems (ZMXT 80-pot) for serious home growers
