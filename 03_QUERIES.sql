USE butterfly_database;
-- Q1 How many observations are recorded for each genus?
SELECT t.genus, COUNT(*) total_records FROM trait_record r JOIN taxon t ON t.taxon_id=r.taxon_id GROUP BY t.genus ORDER BY total_records DESC;
-- Q2 How many records originate from each book?
SELECT b.book_name, COUNT(*) total_records FROM book b JOIN source_reference s ON s.book_id=b.book_id JOIN trait_record r ON r.source_id=s.source_id GROUP BY b.book_id,b.book_name ORDER BY total_records DESC;
-- Q3 What is the mean lower unspecified wingspan by genus?
SELECT t.genus, AVG(m.lower_value) average_wingspan FROM measurement m JOIN trait_record r ON r.row_no=m.row_no JOIN taxon t ON t.taxon_id=r.taxon_id WHERE m.measurement_type='WingSpan' AND m.sex_code='Unspecified' AND m.lower_value IS NOT NULL GROUP BY t.genus;
-- Q4 What is the highest recorded female wingspan upper bound by genus?
SELECT t.genus, MAX(m.upper_value) maximum_female_wingspan FROM measurement m JOIN trait_record r ON r.row_no=m.row_no JOIN taxon t ON t.taxon_id=r.taxon_id WHERE m.measurement_type='WingSpan' AND m.sex_code='Female' AND m.upper_value IS NOT NULL GROUP BY t.genus;
-- Q5 For each genus, how many records indicate June flight activity?
SELECT t.genus, COUNT(*) june_active FROM flight_activity f JOIN trait_record r ON r.row_no=f.row_no JOIN taxon t ON t.taxon_id=r.taxon_id WHERE f.jun=1 GROUP BY t.genus;
-- Q6 How many records indicate each overwintering code?
SELECT c.code_value,COUNT(*) total_records FROM record_trait_code rc JOIN trait_code c ON c.trait_code_id=rc.trait_code_id JOIN trait_type tt ON tt.trait_type_id=c.trait_type_id WHERE tt.trait_type_name='Overwintering' GROUP BY c.code_value;
-- Q7 How many records indicate each oviposition code?
SELECT c.code_value,COUNT(*) total_records FROM record_trait_code rc JOIN trait_code c ON c.trait_code_id=rc.trait_code_id JOIN trait_type tt ON tt.trait_type_id=c.trait_type_id WHERE tt.trait_type_name='Oviposition' GROUP BY c.code_value;
-- Q8 What is the maximum unspecified forewing upper bound by genus?
SELECT t.genus,MAX(m.upper_value) maximum_forewing FROM measurement m JOIN trait_record r ON r.row_no=m.row_no JOIN taxon t ON t.taxon_id=r.taxon_id WHERE m.measurement_type='Forewing' AND m.sex_code='Unspecified' AND m.upper_value IS NOT NULL GROUP BY t.genus;
-- Q9 What is the sum of active months for each genus, for complete monthly rows?
SELECT t.genus,SUM(f.jan+f.feb+f.mar+f.apr+f.may+f.jun+f.jul+f.aug+f.sep+f.oct+f.nov+f.`dec`) total_active_months FROM flight_activity f JOIN trait_record r ON r.row_no=f.row_no JOIN taxon t ON t.taxon_id=r.taxon_id WHERE f.jan IS NOT NULL AND f.feb IS NOT NULL AND f.mar IS NOT NULL AND f.apr IS NOT NULL AND f.may IS NOT NULL AND f.jun IS NOT NULL AND f.jul IS NOT NULL AND f.aug IS NOT NULL AND f.sep IS NOT NULL AND f.oct IS NOT NULL AND f.nov IS NOT NULL AND f.`dec` IS NOT NULL GROUP BY t.genus;
-- Q10 What is the mean number of active months per source book for complete monthly rows?
SELECT b.book_name,AVG(f.jan+f.feb+f.mar+f.apr+f.may+f.jun+f.jul+f.aug+f.sep+f.oct+f.nov+f.`dec`) mean_active_months FROM flight_activity f JOIN trait_record r ON r.row_no=f.row_no JOIN source_reference s ON s.source_id=r.source_id JOIN book b ON b.book_id=s.book_id WHERE f.jan IS NOT NULL AND f.feb IS NOT NULL AND f.mar IS NOT NULL AND f.apr IS NOT NULL AND f.may IS NOT NULL AND f.jun IS NOT NULL AND f.jul IS NOT NULL AND f.aug IS NOT NULL AND f.sep IS NOT NULL AND f.oct IS NOT NULL AND f.nov IS NOT NULL AND f.`dec` IS NOT NULL GROUP BY b.book_id,b.book_name;
