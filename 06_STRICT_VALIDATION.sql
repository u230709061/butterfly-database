USE butterfly_database;
-- Phase I strict checks. Expect all table row counts > 1, pk_count = 1, orphan_count = 0.
SELECT t.table_name, t.table_rows AS estimated_rows, COUNT(k.column_name) AS pk_columns
FROM information_schema.tables AS t
LEFT JOIN information_schema.key_column_usage AS k
 ON k.table_schema=t.table_schema AND k.table_name=t.table_name AND k.constraint_name='PRIMARY'
WHERE t.table_schema='butterfly_database' AND t.table_type='BASE TABLE'
GROUP BY t.table_name,t.table_rows ORDER BY t.table_name;
-- ACTUAL row counts (not INFORMATION_SCHEMA estimates):
SELECT 'book' table_name,COUNT(*) actual_rows FROM book UNION ALL
SELECT 'source_reference',COUNT(*) FROM source_reference UNION ALL
SELECT 'taxon',COUNT(*) FROM taxon UNION ALL
SELECT 'trait_record',COUNT(*) FROM trait_record UNION ALL
SELECT 'measurement',COUNT(*) FROM measurement UNION ALL
SELECT 'flight_activity',COUNT(*) FROM flight_activity UNION ALL
SELECT 'trait_type',COUNT(*) FROM trait_type UNION ALL
SELECT 'trait_code',COUNT(*) FROM trait_code UNION ALL
SELECT 'record_trait_code',COUNT(*) FROM record_trait_code;
-- All foreign key targets must exist, 0 otherwise.
SELECT 'source_reference.book_id' test,COUNT(*) orphan_count FROM source_reference s LEFT JOIN book b ON b.book_id=s.book_id WHERE s.book_id IS NOT NULL AND b.book_id IS NULL
UNION ALL SELECT 'trait_record.source_id',COUNT(*) FROM trait_record r LEFT JOIN source_reference s ON r.source_id=s.source_id WHERE r.source_id IS NOT NULL AND s.source_id IS NULL
UNION ALL SELECT 'trait_record.taxon_id',COUNT(*) FROM trait_record r LEFT JOIN taxon t ON r.taxon_id=t.taxon_id WHERE r.taxon_id IS NOT NULL AND t.taxon_id IS NULL
UNION ALL SELECT 'measurement.row_no',COUNT(*) FROM measurement m LEFT JOIN trait_record r ON r.row_no=m.row_no WHERE r.row_no IS NULL
UNION ALL SELECT 'flight_activity.row_no',COUNT(*) FROM flight_activity f LEFT JOIN trait_record r ON r.row_no=f.row_no WHERE r.row_no IS NULL
UNION ALL SELECT 'trait_code.trait_type_id',COUNT(*) FROM trait_code c LEFT JOIN trait_type t ON t.trait_type_id=c.trait_type_id WHERE t.trait_type_id IS NULL
UNION ALL SELECT 'record_trait_code.row_no',COUNT(*) FROM record_trait_code c LEFT JOIN trait_record r ON r.row_no=c.row_no WHERE r.row_no IS NULL
UNION ALL SELECT 'record_trait_code.trait_code_id',COUNT(*) FROM record_trait_code c LEFT JOIN trait_code t ON t.trait_code_id=c.trait_code_id WHERE t.trait_code_id IS NULL;
-- Constraints must be installed:
SELECT table_name, constraint_name, constraint_type FROM information_schema.table_constraints
WHERE table_schema='butterfly_database' ORDER BY table_name,constraint_type,constraint_name;
-- Spot checks (original RecordID intentionally not unique):
SELECT COUNT(*) source_rows,COUNT(DISTINCT row_no) unique_row_numbers,COUNT(DISTINCT record_id) distinct_record_ids FROM trait_record;
SELECT * FROM vw_record_overview ORDER BY row_no LIMIT 5;
SET @minimum=100; CALL sp_genus_summary('Papilio',@count,@minimum); SELECT @count AS genus_count,@minimum AS threshold_met;
