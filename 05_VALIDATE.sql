USE butterfly_database;
-- All tables must contain at least 2 rows (the professor specifically requires this).
SELECT 'book' table_name,COUNT(*) row_count FROM book UNION ALL SELECT 'source_reference',COUNT(*) FROM source_reference UNION ALL SELECT 'taxon',COUNT(*) FROM taxon UNION ALL SELECT 'trait_record',COUNT(*) FROM trait_record UNION ALL SELECT 'measurement',COUNT(*) FROM measurement UNION ALL SELECT 'flight_activity',COUNT(*) FROM flight_activity UNION ALL SELECT 'trait_type',COUNT(*) FROM trait_type UNION ALL SELECT 'trait_code',COUNT(*) FROM trait_code UNION ALL SELECT 'record_trait_code',COUNT(*) FROM record_trait_code;
-- Foreign key orphan checks (all must be zero).
SELECT 'record->source' test,COUNT(*) violations FROM trait_record r LEFT JOIN source_reference s ON s.source_id=r.source_id WHERE r.source_id IS NOT NULL AND s.source_id IS NULL
UNION ALL SELECT 'record->taxon',COUNT(*) FROM trait_record r LEFT JOIN taxon t ON t.taxon_id=r.taxon_id WHERE r.taxon_id IS NOT NULL AND t.taxon_id IS NULL
UNION ALL SELECT 'measurement->record',COUNT(*) FROM measurement m LEFT JOIN trait_record r ON r.row_no=m.row_no WHERE r.row_no IS NULL
UNION ALL SELECT 'flight->record',COUNT(*) FROM flight_activity f LEFT JOIN trait_record r ON r.row_no=f.row_no WHERE r.row_no IS NULL
UNION ALL SELECT 'code_assignment->record',COUNT(*) FROM record_trait_code rc LEFT JOIN trait_record r ON r.row_no=rc.row_no WHERE r.row_no IS NULL;
-- Expected row counts are also written into DATA_PROFILE.json
