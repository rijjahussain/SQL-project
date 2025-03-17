-- Data cleaning

SELECT *
FROM layoffs;

SELECT COUNT(*) 
FROM layoffs;

-- 1.Remove duplicates
-- 2.Strandize the Data
-- 3.Null values
-- 4. Removing unneccesay column

create table layoffs_stagging
LIKE layoffs;

SELECT *
FROM layoffs_stagging;


Insert layoffs_stagging
Select *
FROM layoffs;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
FROM layoffs_stagging;

With duplicate_cte as
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, funds_raised_millions, country) AS row_num
FROM layoffs_stagging
)
Select *
FROM duplicate_cte
where row_num > 1;

SELECT *
FROM layoffs_stagging;

With duplicate_cte as
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, 
'date', stage, funds_raised_millions, country) AS row_num
FROM layoffs_stagging
)

DELETE 
FROM duplicate_cte
where row_num > 1;


CREATE TABLE `layoffs_stagging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_stagging2;

Insert into layoffs_stagging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, 
'date', stage, funds_raised_millions, country) AS row_num
FROM layoffs_stagging;

SELECT *
FROM layoffs_stagging2;


Delete
FROM layoffs_stagging2
where row_num >=2;

SELECT *
FROM layoffs_stagging2;


-- Strandize the data


Select company, trim(company)
From layoffs_stagging2;

update layoffs_stagging2
SET company = trim(company);

SELECT DISTINCT industry
from layoffs_stagging2;

SELECT *
from layoffs_stagging2
WHERE industry like 'crypt%';


UPDATE layoffs_stagging2
SET industry = 'Crypto'
WHERE industry like 'crypto%';

SELECT  Distinct country , trim(TRAILING '.' FROM country)
from layoffs_stagging2
order by 1;

UPDATE layoffs_stagging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
STR_TO_DATE (`date`, '%m/%d/%Y')
from layoffs_stagging2;

UPDATE  layoffs_stagging2
SET date = STR_TO_DATE (`date`, '%m/%d/%Y');


SELECT *
from layoffs_stagging2;

ALTER TABLE layoffs_stagging2
MODIFY COLUMN `date` DATE;


-- NULL values


SELECT *
from layoffs_stagging2
where total_laid_off is null
AND percentage_laid_off is null;


SELECT *
from layoffs_stagging2
WHERE industry IS NULL
OR industry = '';

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

SELECT *
from layoffs_stagging2
WHERE company = 'Airbnb';


SELECT *
FROM layoffs_stagging2 t1
JOIN layoffs_stagging2 t2
     ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '' )
AND t2.industry IS NOT NULL; 
   
SELECT *
FROM layoffs_stagging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;

SELECT DISTINCT industry
FROM layoffs_stagging2
ORDER BY industry;     
 
UPDATE layoffs_stagging2
SET industry = NULL
WHERE industry = '';
     
SELECT *
FROM layoffs_stagging2;
     
     
delete 
from layoffs_stagging2
where total_laid_off is null
AND percentage_laid_off is null;

SELECT *
FROM layoffs_stagging2;

Alter table layoffs_stagging2
drop column row_num;



