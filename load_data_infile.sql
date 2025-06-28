CREATE TABLE layoffs(
	company varchar(191),
	location varchar(191),
	industry varchar(191),
	total_laid_off int,
	precentage_laid_off decimal(3, 2),
	date date,
	stage varchar(191),
	country varchar (191),
	funds_raised_millions int,
	PRIMARY KEY (company)
)

ALTER TABLE layoffs MODIFY location varchar(191) NOT NULL;
ALTER TABLE layoffs MODIFY country varchar(191) NOT NULL;

SHOW GLOBAL VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 
'C:/Users/shiva/OneDrive/Desktop/Study/SQL/datasets/layoffs.csv'
INTO TABLE layoffs
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(company, location, industry, @laid_off, @percent, @dt, stage, country, @funds)
SET
    total_laid_off = NULLIF(@laid_off, 'NULL'),
    percentage_laid_off = NULLIF(@percent, 'NULL'),
    date = STR_TO_DATE(@dt, '%m/%d/%Y'),
    funds_raised_millions = NULLIF(@funds, 'NULL');
