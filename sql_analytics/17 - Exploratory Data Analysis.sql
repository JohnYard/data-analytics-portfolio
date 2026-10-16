-- Exploratory Data Analysis (EDA)

SELECT * 
FROM layoffs_staging2;


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER by funds_raised_millions DESC

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER by 2 DESC;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER by 1 DESC;


SELECT company, SUM(percentage_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER by 2 DESC;



SELECT SUBSTRING(`DATE`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`DATE`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC;


with Rolling_Total AS 
(SELECT SUBSTRING(`DATE`,1,7) AS `MONTH`, SUM(total_laid_off) as total_off
FROM layoffs_staging2
WHERE SUBSTRING(`DATE`,1,7) IS NOT NULL
GROUP BY `MONTH` 
ORDER BY 1 ASC)

SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) as rolling_total
FROM Rolling_Total;


SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC



WITH Company_year (company, years, total_laid_off) as 
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank as
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years and total_laid_off is not NULL
)
SELECT * 
FROM Company_Year_Rank
WHERE Ranking <= 5 
; 


