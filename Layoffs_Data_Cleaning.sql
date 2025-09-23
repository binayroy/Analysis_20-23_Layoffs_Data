use layoff_analysis;
select * from layoffs;

#--> Remove Duplicates
select count(*) from layoffs;

CREATE TABLE layoff_staging1 LIKE layoffs;

SELECT * FROM layoff_staging1;

INSERT layoff_staging1
SELECT DISTINCT * FROM layoffs;

SELECT * FROM layoff_staging1;

SELECT count(*) FROM layoff_staging1; #Reduced rows verified


#-->Standardize Data
-- Company
SELECT DISTINCT company 
FROM layoff_staging1 ORDER BY company;

SELECT TRIM(company), company
FROM layoff_staging1 ORDER BY company;

UPDATE layoff_staging1
SET company = TRIM(company);

SELECT company
from layoff_staging1 order by right(company,1); #looks Alright


-- Location
SELECT DISTINCT location
FROM layoff_staging1 ORDER BY location;

SELECT * from layoff_staging1
where location like 'Mal%'; #Spelling mistake MalmÃ¶ in place of Malmo.

UPDATE layoff_staging1
set location = 'Malmo' where location like 'mal%';


-- Industry
SELECT DISTINCT industry
FROM layoff_staging1 ORDER BY industry;
SELECT industry
from layoff_staging1 order by right(industry,1); #No Unwanted characters

SELECT * FROM layoff_staging1
WHERE industry LIKE 'Crypto%';

UPDATE layoff_staging1
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';


-- Total_laid_off
ALTER TABLE layoff_staging1
MODIFY COLUMN Total_laid_off INT;


-- Percentage_laid_off
ALTER TABLE layoff_staging1
MODIFY COLUMN Percentage_laid_off DECIMAL(3,2);

SELECT * FROM layoff_staging1;


-- Date
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoff_staging1;

UPDATE layoff_staging1
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date` FROM layoff_staging1;

ALTER TABLE layoff_staging1
MODIFY `date` DATE;


-- Stage
SELECT DISTINCT stage FROM layoff_staging1 ORDER BY stage; #Looks Alright


-- Country
SELECT DISTINCT Country FROM layoff_staging1 ORDER BY Country;

UPDATE layoff_staging1
set country = trim(Trailing '.' from country);


#--> Deal with the NULL values
-- Industry
SELECT company, industry
FROM layoff_staging1 WHERE industry IS NULL OR industry = '';

UPDATE layoff_staging1
SET industry = NULL WHERE industry = '';

SELECT t1.company, t2.industry, t1.industry
FROM layoff_staging1 t1
JOIN layoff_staging1 t2
ON t1.company = t2.company
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL; #populatable NULL values.ALTER

UPDATE layoff_staging1 t1
JOIN layoff_staging1 t2
ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

SELECT DISTINCT *
FROM layoff_staging1 WHERE industry is NULL;


-- Laid off
SELECT Total_laid_off, Percentage_laid_off
FROM layoff_staging1
WHERE (Percentage_laid_off IS NULL OR Percentage_laid_off = '')
AND (Total_laid_off IS NULL OR Total_laid_off = '');

DELETE FROM layoff_staging1
WHERE Percentage_laid_off IS NULL AND Total_laid_off IS NULL;

#--> Data Cleaned

-- New Table layoff_clean>
CREATE TABLE layoff_clean LIKE layoff_staging1;

SELECT * FROM layoff_clean;

INSERT layoff_clean
SELECT * FROM layoff_staging1;

SELECT count(*) FROM layoff_clean;