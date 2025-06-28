-- ========================================
-- 🔧 Table Creation with Constraints
-- ========================================

CREATE TABLE layoffs (
    company VARCHAR(191),
    location VARCHAR(191) NOT NULL,
    industry VARCHAR(191),
    total_laid_off INT,
    percentage_laid_off DECIMAL(5, 2),
    date DATE,
    stage VARCHAR(191),
    country VARCHAR(191) NOT NULL,
    funds_raised_millions INT,
    PRIMARY KEY (company)
);

-- ========================================
-- ⚙️ Server-Side Local Infile Setup
-- ========================================

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- ========================================
-- 📥 Load CSV Data into Table
-- ========================================

LOAD DATA LOCAL INFILE 
'C:/Users/shiva/OneDrive/Desktop/Study/SQL/datasets/layoffs.csv'
INTO TABLE layoffs
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(company, location, industry, @laid_off, @percent, @dt, stage, country, @funds)
SET
    total_laid_off = NULLIF(@laid_off, 'NULL'),
    percentage_laid_off = NULLIF(@percent, 'NULL'),
    date = STR_TO_DATE(@dt, '%m/%d/%Y'),
    funds_raised_millions = NULLIF(@funds, 'NULL');
