-- MYSQL 8.0+ ; do NOT execute over an existing database you wish to preserve.
CREATE DATABASE IF NOT EXISTS butterfly_database CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
USE butterfly_database;
SET NAMES utf8mb4;
CREATE TABLE IF NOT EXISTS book (
 book_id INT PRIMARY KEY, book_name VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS source_reference (
 source_id INT PRIMARY KEY, book_id INT NULL, resource_code VARCHAR(120) NULL,
 CONSTRAINT fk_source_book FOREIGN KEY (book_id) REFERENCES book(book_id) ON DELETE RESTRICT ON UPDATE CASCADE,
 UNIQUE KEY uq_source_book_resource(book_id,resource_code)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS taxon (
 taxon_id INT PRIMARY KEY, genus VARCHAR(140) NOT NULL, species_name VARCHAR(200) NULL
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS trait_type (
 trait_type_id INT PRIMARY KEY, trait_type_name VARCHAR(40) NOT NULL UNIQUE
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS trait_code (
 trait_code_id INT PRIMARY KEY, trait_type_id INT NOT NULL, code_value VARCHAR(8) NOT NULL,
 UNIQUE KEY uq_type_code(trait_type_id,code_value),
 CONSTRAINT fk_code_type FOREIGN KEY (trait_type_id) REFERENCES trait_type(trait_type_id) ON DELETE RESTRICT
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS trait_record (
 row_no INT PRIMARY KEY, record_id VARCHAR(80) NOT NULL, legacy_id VARCHAR(100) NULL,
 source_id INT NULL, taxon_id INT NULL, page_number VARCHAR(255) NULL,
 CONSTRAINT fk_record_source FOREIGN KEY(source_id) REFERENCES source_reference(source_id) ON DELETE RESTRICT ON UPDATE CASCADE,
 CONSTRAINT fk_record_taxon FOREIGN KEY(taxon_id) REFERENCES taxon(taxon_id) ON DELETE RESTRICT ON UPDATE CASCADE,
 INDEX idx_record_external(record_id)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS measurement (
 row_no INT NOT NULL, measurement_type VARCHAR(20) NOT NULL,
 sex_code VARCHAR(20) NOT NULL, lower_value DECIMAL(12,4) NULL, upper_value DECIMAL(12,4) NULL,
 PRIMARY KEY(row_no,measurement_type,sex_code),
 CONSTRAINT fk_measure_record FOREIGN KEY(row_no) REFERENCES trait_record(row_no) ON DELETE CASCADE,
 CONSTRAINT ck_measure_nonempty CHECK (lower_value IS NOT NULL OR upper_value IS NOT NULL),
 CONSTRAINT ck_measure_type CHECK (measurement_type IN ('WingSpan','Forewing')),
 CONSTRAINT ck_measure_sex CHECK (sex_code IN ('Female','Male','Unspecified'))
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS flight_activity (
 row_no INT PRIMARY KEY,
 jan TINYINT NULL, feb TINYINT NULL, mar TINYINT NULL, apr TINYINT NULL,
 may TINYINT NULL, jun TINYINT NULL, jul TINYINT NULL, aug TINYINT NULL,
 sep TINYINT NULL, oct TINYINT NULL, nov TINYINT NULL, `dec` TINYINT NULL,
 CONSTRAINT fk_flight_record FOREIGN KEY(row_no) REFERENCES trait_record(row_no) ON DELETE CASCADE,
 CONSTRAINT ck_month_values CHECK (
  (jan IS NULL OR jan IN (0,1)) AND (feb IS NULL OR feb IN (0,1)) AND
  (mar IS NULL OR mar IN (0,1)) AND (apr IS NULL OR apr IN (0,1)) AND
  (may IS NULL OR may IN (0,1)) AND (jun IS NULL OR jun IN (0,1)) AND
  (jul IS NULL OR jul IN (0,1)) AND (aug IS NULL OR aug IN (0,1)) AND
  (sep IS NULL OR sep IN (0,1)) AND (oct IS NULL OR oct IN (0,1)) AND
  (nov IS NULL OR nov IN (0,1)) AND (`dec` IS NULL OR `dec` IN (0,1)) )
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS record_trait_code (
 row_no INT NOT NULL, trait_code_id INT NOT NULL,
 PRIMARY KEY(row_no,trait_code_id),
 CONSTRAINT fk_rtc_record FOREIGN KEY(row_no) REFERENCES trait_record(row_no) ON DELETE CASCADE,
 CONSTRAINT fk_rtc_code FOREIGN KEY(trait_code_id) REFERENCES trait_code(trait_code_id) ON DELETE RESTRICT
) ENGINE=InnoDB;
