-- Drop and recreate the materialized view to include pH/EC review lookups
DROP MATERIALIZED VIEW IF EXISTS usertowerdetails CASCADE;

CREATE MATERIALIZED VIEW usertowerdetails AS
SELECT
  u.id AS user_id,
  u.email AS user_email,
  mt.tower_id,
  mt.tower_name,
  tb.brand_name AS tower_type,
  mt.port_count AS ports,
  mt.indoor_outdoor,
  mt.archive,
  tb.brand_logo_url AS tg_corp_image,

  -- pH monitoring data with lookups
  ph_latest.ph_value AS latest_ph_value,
  ph_lookup.image_url AS ph_image_url,
  ph_lookup.ph_review AS ph_review,
  ph_lookup.review_image_url AS review_image_url,

  -- EC monitoring data with lookups
  ec_latest.ec_value AS latest_ec_value,
  ec_lookup.ec_image_url AS ec_image_url,
  ec_lookup.ec_review AS ec_review,
  ec_lookup.ec_review_image_url AS ec_review_image_url

FROM auth.users u
INNER JOIN my_towers mt ON u.id::text = mt.user_id::text
LEFT JOIN tower_brands tb ON mt.tower_brand_id = tb.id
-- Get latest non-null pH value
LEFT JOIN LATERAL (
  SELECT ph_value
  FROM ph_echistory
  WHERE tower_id = mt.tower_id
    AND ph_value IS NOT NULL
  ORDER BY timestamp DESC
  LIMIT 1
) ph_latest ON true

-- Get latest non-null EC value
LEFT JOIN LATERAL (
  SELECT ec_value
  FROM ph_echistory
  WHERE tower_id = mt.tower_id
    AND ec_value IS NOT NULL
  ORDER BY timestamp DESC
  LIMIT 1
) ec_latest ON true

-- Lookup pH review based on latest pH value
LEFT JOIN LATERAL (
  SELECT image_url, ph_review, review_image_url
  FROM ph_values
  WHERE ph_value <= ph_latest.ph_value
  ORDER BY ph_value DESC
  LIMIT 1
) ph_lookup ON ph_latest.ph_value IS NOT NULL

-- Lookup EC review based on latest EC value
LEFT JOIN LATERAL (
  SELECT ec_image_url, ec_review, ec_review_image_url
  FROM ec_values
  WHERE ec_value <= ec_latest.ec_value
  ORDER BY ec_value DESC
  LIMIT 1
) ec_lookup ON ec_latest.ec_value IS NOT NULL;

-- Recreate indexes
CREATE UNIQUE INDEX idx_usertowerdetails_user_tower ON usertowerdetails(user_id, tower_id);
CREATE INDEX idx_usertowerdetails_user ON usertowerdetails(user_id);

-- Add comment
COMMENT ON MATERIALIZED VIEW usertowerdetails IS 'Denormalized view of user towers with latest pH/EC data and review lookups. pH and EC are fetched independently to handle separate updates.';
