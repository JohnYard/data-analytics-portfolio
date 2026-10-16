-- ============================================================================
-- Project: SQL Analytics Portfolio - End-to-End Data Cleaning
-- Dataset: Global Layoffs Dataset (`layoffs.csv`)
-- Description: Comprehensive data cleaning pipeline including duplicate removal, 
--              data standardization, handling null/blank values, and structural cleanup.
-- ============================================================================

-- Initial inspection of the raw dataset
SELECT * 
FROM layoffs;
-- ============================================================================
-- DATA CLEANING PHASES:
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Handle Null or Blank Values
-- 4. Remove Unnecessary Columns / Rows
-- ============================================================================


-- ============================================================================
-- PHASE 1: REMOVE DUPLICATES
-- ============================================================================

-- Create a staging table to preserve raw data
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;


-- Test row numbering across all key columns to identify duplicates
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num 
FROM layoffs_staging;


-- Using a CTE to locate duplicate records
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;


-- Spot-check a specific company for duplicate patterns
SELECT *
FROM layoffs_staging
WHERE company = 'Casper'

-- 
DELETE
FROM duplicate_cte
WHERE row_num > 1;

-- Note: Directly deleting from a CTE is not supported in MySQL, 
-- so we created a second staging table (`layoffs_staging2`) with a `row_num` column.

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- Populate staging2 with row numbers
SELECT * 
FROM layoffs_staging2
WHERE row_num > 1; 


-- Populate staging2 with row numbers
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoffs_staging;


-- Delete duplicate rows where row_num is greater than 1
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2


-- ============================================================================
-- PHASE 2: STANDARDIZE THE DATA
-- ============================================================================

-- Trim whitespace from company names
SELECT DISTINCT (company)
FROM layoffs_staging2

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- Standardize industry naming variants (e.g., merging variations under 'Crypto')
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1
;

SELECT * 
FROM layoffs_staging2
WHERE industry LIKE 'Crypto'

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%'


-- Standardize country names (removing trailing periods like 'United States.')
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1
;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1


UPDATE layoffs_staging2
SET country = TRIM(trailing '.' FROM country)
WHERE country LIKE 'United States%'


-- Convert text-based date strings into proper SQL DATE format
SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y')

SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
modify COLUMN `date` DATE;


-- ============================================================================
-- PHASE 3: HANDLE NULL AND BLANK VALUES
-- ============================================================================

-- Check rows where both layoff metrics are null
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL


-- Inspect blank or null industries
SELECT *
FROM layoffs_staging2
WHERE industry is NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'juul'

-- Revert an accidental update where 'Crypto' was incorrectly assigned, setting it back to blank
UPDATE layoffs_staging2
SET industry = ''
WHERE company = 'juul' AND total_laid_off = 400

SELECT *
FROM layoffs_staging2
WHERE company = 'airbnb'

-- Populate missing industries using a self-join where another record for the same company has the industry
SELECT t1.company, t1.industry, t2.company, t2.industry
FROM layoffs_staging2 as t1
JOIN layoffs_staging2 as t2 
	on t1.company = t2.company
	AND t1.location = t2.location 
WHERE t1.industry is NULL
AND t2.industry is NOT NULL

UPDATE layoffs_staging2
set industry = NULL
WHERE industry = ''

SELECT *
FROM layoffs_staging2
WHERE industry is NULL

UPDATE layoffs_staging2 as t1
JOIN layoffs_staging2 as t2
	on t1.company = t2.company
set t1.industry = t2.industry
WHERE t1.industry is NULL
AND t2.industry is NOT NULL;

-- Remove rows where both layoff metrics are completely null (unusable for layoff analysis)
SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
and percentage_laid_off is NULL

DELETE 
FROM layoffs_staging2
WHERE total_laid_off is NULL
and percentage_laid_off is NULL


-- ============================================================================
-- PHASE 4: REMOVE UNNECESSARY COLUMNS
-- ============================================================================

SELECT *
FROM layoffs_staging2;

-- Drop the temporary row numbering column used during duplicate removal
ALTER TABLE layoffs_staging2
DROP COLUMN row_num
