-- Check the structure of userplants and categories tables
SELECT 
    column_name, 
    data_type,
    table_name
FROM information_schema.columns 
WHERE table_schema = 'public' 
  AND table_name IN ('userplants', 'categories', 'userplantdetails', 'plants')
ORDER BY table_name, ordinal_position;
