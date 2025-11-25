-- Migration: Create and fix permissions for category cost calculation function
-- Description: Creates the calculate_all_yearly_costs_by_category function and grants permissions

-- First, check if function exists and drop it if needed (to handle recreation)
DROP FUNCTION IF EXISTS public.calculate_all_yearly_costs_by_category(json);

-- Create the function to calculate yearly costs by category for a user
CREATE OR REPLACE FUNCTION public.calculate_all_yearly_costs_by_category(_userid json)
RETURNS TABLE (
  category_id INTEGER,
  category_name TEXT,
  yearly_category_cost NUMERIC
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  user_id_text TEXT;
BEGIN
  -- Extract the user ID from the JSON parameter
  user_id_text := _userid->>'_userid';

  -- Return aggregated cost data by category for the user's supplies/products
  -- This calculates the yearly cost for each product category
  RETURN QUERY
  SELECT
    c.categoryid as category_id,
    c.categoryname::TEXT as category_name,
    COALESCE(SUM(up.userpurchasecost), 0)::NUMERIC as yearly_category_cost
  FROM
    categories c
  LEFT JOIN
    products p ON p.categoryid = c.categoryid
  LEFT JOIN
    userproducts up ON up.productid = p.productid
      AND up.userid = user_id_text::uuid
      AND (up.archive IS NULL OR up.archive = false)
  GROUP BY
    c.categoryid, c.categoryname
  ORDER BY
    c.categoryname;
END;
$$;

-- Grant execute permission on the RPC function to authenticated users
GRANT EXECUTE ON FUNCTION public.calculate_all_yearly_costs_by_category(json) TO authenticated;

-- Grant execute permission to anon role as well
GRANT EXECUTE ON FUNCTION public.calculate_all_yearly_costs_by_category(json) TO anon;

-- Grant usage on the public schema (if not already granted)
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO anon;

-- Grant table permissions to ensure SECURITY DEFINER works
GRANT SELECT ON public.categories TO postgres, authenticated, anon;
GRANT SELECT ON public.products TO postgres, authenticated, anon;
GRANT SELECT ON public.userproducts TO postgres, authenticated, anon;

-- Comment for clarity
COMMENT ON FUNCTION public.calculate_all_yearly_costs_by_category(json) IS
  'Calculates yearly costs by category for a given user. Accessible by authenticated and anonymous users.';
