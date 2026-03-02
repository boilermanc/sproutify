-- Fix: Remove ::text cast from userid comparison in get_supply_costs
-- The userid column is uuid type, not text

CREATE OR REPLACE FUNCTION public.get_supply_costs(_user_id uuid)
RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  _monthly_cost  numeric;
  _quarterly_cost numeric;
  _yearly_cost   numeric;
BEGIN
  -- Monthly: current calendar month
  SELECT COALESCE(SUM(userpurchasecost), 0)
    INTO _monthly_cost
    FROM userproducts
   WHERE userid = _user_id
     AND (archive IS NULL OR archive = false)
     AND userpurchasedate >= date_trunc('month', now());

  -- Quarterly: current calendar month and two prior months
  SELECT COALESCE(SUM(userpurchasecost), 0)
    INTO _quarterly_cost
    FROM userproducts
   WHERE userid = _user_id
     AND (archive IS NULL OR archive = false)
     AND userpurchasedate >= date_trunc('month', now()) - interval '2 months';

  -- Yearly: current calendar year
  SELECT COALESCE(SUM(userpurchasecost), 0)
    INTO _yearly_cost
    FROM userproducts
   WHERE userid = _user_id
     AND (archive IS NULL OR archive = false)
     AND userpurchasedate >= date_trunc('year', now());

  RETURN json_build_object(
    'monthly_cost',   _monthly_cost,
    'quarterly_cost', _quarterly_cost,
    'yearly_cost',    _yearly_cost
  );
END;
$$;

GRANT EXECUTE ON FUNCTION public.get_supply_costs(uuid) TO authenticated;
GRANT EXECUTE ON FUNCTION public.get_supply_costs(uuid) TO anon;
