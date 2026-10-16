-- ============================================================================
-- Project: SQL Analytics Portfolio - Exploratory Data Analysis (EDA)
-- Dataset: Global Layoffs Dataset (`layoffs.csv`) (Querying `layoffs_staging2`)
-- Description: Exploratory data analysis uncovering layoff trends by country,
--              company, stage, and time, including rolling totals and annual rankings.
-- ============================================================================

-- Initial inspection of the cleaned dataset
SELECT * 
FROM layoffs_staging2;


-- Find the maximum number of layoffs and maximum percentage laid off (1 = 100%)
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2


-- Look at companies that went completely under (100% laid off), ordered by funding
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER by funds_raised_millions DESC


-- Total layoffs grouped by country, ordered from highest to lowest
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER by 2 DESC;


-- Find the date range of the dataset (start and end dates)
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;


-- Total layoffs grouped by company funding stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER by 1 DESC;


-- Total percentage laid off grouped by company
SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER by 2 DESC;


-- Progression of layoffs by month (extracting YYYY-MM from date)
SELECT SUBSTRING(`DATE`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`DATE`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC;


-- Calculating a rolling cumulative total of layoffs over time using a CTE
with Rolling_Total AS 
(SELECT SUBSTRING(`DATE`,1,7) AS `MONTH`, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`DATE`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC)

SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) as rolling_total
FROM Rolling_Total;


-- Total layoffs per company broken down by year
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC


-- Finding the top 5 companies with the most layoffs each year using DENSE_RANK()
WITH Company_Year (company, years, total_laid_off) as 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank as
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years and total_laid_off is not NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5 
; 


