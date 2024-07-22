-- Data Cleaning Project

SELECT * 
FROM layoffs;

-- 1. Remove dupicates
-- 2. Standardise the data
-- 3. Deal with any null or blank values
-- 4. Remove any surperfluous columns or rows

-- this creates a staging table to work n to preserve the integrity of the original data set.
CREATE TABLE layoffs_staging
LIKE layoffs;

-- this copies the data from the original data table into the staging table.
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- this creates a new column in the table so we can add a unique field to remove duplicates, placing a number in each record.
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

-- this populates the new column with a number, usually just '1', but if anything is duplicated it will add a 1 for each duplicate.
-- and displays anything that is duplicated.
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >1;


-- this looks at the details of a duplicated company.
SELECT *
FROM layoffs_staging
WHERE company = 'casper';

-- this deletes any duplicated rows. unable to delete these rows in this table.
WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num >1;


-- this creates a new table to work on to delete duplicates and start standardising the data.
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

-- this populates the new table. 
INSERT INTO layofs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, 
industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- this deletes all duplictated data rows
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- these next 2 commands remove the spaces for the company name that were noticed
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- this line identifies any industries that are similar but not exact.
SELECT DISTINCT industry
FROM layoffs_staging2;

-- this changes any industry that is similar to crypto to a standardised 'crypto'
UPDATE layoffs_staging2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

-- these lines remove extra punctuation not needed.
SELECT DISTINCT country, TRIM(TRAILING  '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING  '.' FROM country)
WHERE country LIKE 'United States%';

-- these lines change the date column from a string to a date format.
SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2date
MODIFY COLUMN `date` DATE;

-- this identifies any null values.
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- this turns any blank values to null
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- this is to check all is copmlete
SELECT *
FROM layoffs_staging2
WHERE industry IS NULL
OR INDUSTRY = "";

SELECT *
FROM layoffs_staging2
WHERE company LIKE 'BALLY%';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

-- this polulates any null values with data if available
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

SELECT *
FROM layoffs_staging2;

-- this deletes any rows where the null values mean the data is useless to us.
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging2;

-- finally this deletes the row number column, created earlier that is no longer needed.
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;






























