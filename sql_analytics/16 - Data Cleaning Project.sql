-- Data Cleaning Project




SELECT * 
FROM layoffs;


-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank Values
-- 4. Remove Any Columns


CREATE TABLE layoffs_staging
LIKE layoffs;


SELECT *
FROM layoffs_staging;


INSERT layoffs_staging
SELECT *
FROM layoffs;



SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num 
FROM layoffs_staging;



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


SELECT *
FROM layoffs_staging
WHERE company = 'Casper'

DELETE
FROM duplicate_cte
WHERE row_num > 1;



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


SELECT * 
FROM layoffs_staging2
WHERE row_num > 1; 

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num 
FROM layoffs_staging;


DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2


-- Standartizing Data

SELECT DISTINCT (company)
FROM layoffs_staging2

SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
set company = TRIM(company);


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


SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
set `date` = STR_TO_DATE(`date`, '%m/%d/%Y')


SELECT `date`
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
modify COLUMN `date` DATE;


SELECT * 
FROM layoffs_staging2
WHERE total_laid_off is NULL
AND percentage_laid_off IS NULL


SELECT *
FROM layoffs_staging2
WHERE industry is NULL
OR industry = '';

SELECT *
FROM layoffs_staging2
WHERE company = 'juul'

-- из того что я случайно некоторым значениям присвоил "Crypto" я теперь их ставлю "Empty"
UPDATE layoffs_staging2
SET industry = ''
WHERE company = 'juul' AND total_laid_off = 400

SELECT *
FROM layoffs_staging2
WHERE company = 'airbnb'


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


SELECT *
FROM layoffs_staging2
WHERE total_laid_off is NULL
and percentage_laid_off is NULL

DELETE 
FROM layoffs_staging2
WHERE total_laid_off is NULL
and percentage_laid_off is NULL


SELECT *
FROM layoffs_staging2

ALTER TABLE layoffs_staging2
DROP COLUMN row_num
