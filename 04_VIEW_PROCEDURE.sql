USE butterfly_database;
CREATE OR REPLACE VIEW vw_record_overview AS
SELECT r.row_no,r.record_id,t.genus,t.species_name,b.book_name,
 CASE WHEN f.row_no IS NULL THEN NULL ELSE
 (COALESCE(f.jan,0)+COALESCE(f.feb,0)+COALESCE(f.mar,0)+COALESCE(f.apr,0)+COALESCE(f.may,0)+COALESCE(f.jun,0)+COALESCE(f.jul,0)+COALESCE(f.aug,0)+COALESCE(f.sep,0)+COALESCE(f.oct,0)+COALESCE(f.nov,0)+COALESCE(f.`dec`,0)) END AS duration_calculated
FROM trait_record r LEFT JOIN taxon t ON t.taxon_id=r.taxon_id
LEFT JOIN source_reference s ON s.source_id=r.source_id LEFT JOIN book b ON b.book_id=s.book_id
LEFT JOIN flight_activity f ON f.row_no=r.row_no;
DROP PROCEDURE IF EXISTS sp_genus_summary;
DELIMITER $$
CREATE PROCEDURE sp_genus_summary(IN p_genus VARCHAR(140), OUT p_record_count INT, INOUT p_min_count INT)
BEGIN
 DECLARE v_count INT DEFAULT 0;
 SELECT COUNT(*) INTO v_count FROM trait_record r JOIN taxon t ON t.taxon_id=r.taxon_id WHERE t.genus=p_genus;
 SET p_record_count=v_count;
 SET p_min_count=IF(v_count >= p_min_count,1,0);
END$$
DELIMITER ;
-- Example: SET @threshold=100; CALL sp_genus_summary('Papilio',@total,@threshold); SELECT @total,@threshold;
