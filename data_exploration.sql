-- Data exploration analysis


SELECT *
FROM layoffs_stagging2;

-- QUERIES

SELECT MAX(total_laid_off)
FROM layoffs_stagging2;

-- Percentage

SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoffs_stagging2
WHERE percentage_laid_off IS NOT NULL;


-- Which companies had 1 which is basically 100 percent of they company laid off

SELECT *
FROM layoffs_stagging2
WHERE percentage_laid_off = 1;

-- these are mostly startups and the percentage 1 means they wen out of business


-- ordering funds_raised_millions to understand which comoany is bigger

SELECT *
FROM layoffs_stagging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;


-- BritishVolt looks like an EV company, raised like 2 billion dollars and went out of business









----- USING GROUP BY---------------------

-- Companies with the biggest single Layoff
SELECT company, total_laid_off
FROM layoffs_stagging2
ORDER BY 2 DESC
LIMIT 5;

-- now that's just on a single day

-- Companies with the most Total Layoffs

SELECT company, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;

-- by location
SELECT location, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- by year

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC
LIMIT 10;


SELECT industry, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_stagging2
GROUP BY stage
ORDER BY 2 DESC;


-- Companies layoffs by year

WITH company_year AS 
(
SELECT company, YEAR(date) AS years , SUM(total_laid_off) AS total_laid_off
FROM layoffs_stagging2
GROUP BY company, YEAR(date)
),
Company_Year_Rank AS (
SELECT company, years, total_laid_off, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year 
)
SELECT company, years, total_laid_off, ranking
FROM Company_Year_Rank
WHERE ranking <= 3
AND years IS NOT NULL
ORDER BY years ASC, total_laid_off DESC;

-- Total of Layoffs Per Month

SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_stagging2
GROUP BY dates
ORDER BY dates ASC;

WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoffs_stagging2
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates,SUM(total_laid_off) OVER (ORDER BY dates ASC) AS rolling_total_laid_off
FROM DATE_CTE
ORDER BY dates ASC;



