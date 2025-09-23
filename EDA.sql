USE layoff_analysis;

#--> EDA (Exploratory Data Analysis)
SELECT * FROM layoff_analysis.layoff_clean;


#--> Country AND Industry #(This Part will show which industry has the highest layoff for each particular country)

WITH Cnt_in AS(
SELECT Country, Industry,
sum(total_laid_off) OVER(PARTITION BY Country, industry ORDER BY Country ASC) AS Laid_off_by_industry
FROM layoff_clean
), cnt_in_laid AS
(
SELECT DISTINCT * from cnt_in
WHERE Laid_off_by_industry IS NOT NULL
)
SELECT *,
sum(laid_off_by_industry) OVER(PARTITION BY country ORDER BY laid_off_by_industry DESC) Country_Rolling_SUM,
RANK() OVER(PARTITION BY country ORDER BY laid_off_by_industry DESC) Rank_in_Country
FROM cnt_in_laid;

#--> Industry based Layoff
SELECT Industry, sum(total_laid_off) Layoff
FROM layoff_clean WHERE Industry IS NOT NULL
GROUP BY Industry ORDER BY layoff DESC;


#--> Company based Layoff
-- Frequency:
SELECT Company, concat(count(company), ' Times') Layoffs_Frec
FROM layoff_clean WHERE company IS NOT NULL
GROUP BY company ORDER BY Layoffs_Frec DESC;


-- Total Layoffs by Company:
SELECT Company, sum(total_laid_off) Layoffs_Total
FROM layoff_clean WHERE Industry IS NOT NULL
GROUP BY Company ORDER BY Layoffs_Total DESC;


#--> Stage based Layoff
SELECT Stage, sum(total_laid_off) Layoff
FROM layoff_clean WHERE stage IS NOT NULL
GROUP BY stage ORDER BY layoff DESC;


#--> Time Series Analysis
-- Yearly Laid Off
SELECT year(`date`) AS `Year`, sum(total_laid_off) Laid_Off
FROM layoff_clean where `date` IS NOT NULL
GROUP BY `Year` ORDER BY `Year`;


-- Rolling Sum (Monthly)
WITH rolling AS(
	SELECT substring(`date`,1,7) Months, sum(total_laid_off) Laid_off
	FROM layoff_clean where `date` IS NOT NULL
	GROUP BY Months ORDER BY Months ASC
)
SELECT Months, Laid_off,
sum(laid_off) OVER(ORDER BY Months ASC) Rolling_SUM
FROM rolling;


-- Rolling Sum (Per Year Roll)
WITH rolling AS(
	SELECT substring(`date`,1,7) Months, sum(total_laid_off) Laid_off
	FROM layoff_clean where `date` IS NOT NULL
	GROUP BY Months ORDER BY Months ASC
)
SELECT Months, Laid_off,
sum(laid_off) OVER(PARTITION BY substring(Months,1,4) ORDER BY Months ASC) Rolling_SUM
FROM rolling;



-- Top Most 5 Laid off Company per year
WITH year_com AS
(
SELECT year(`date`) Years, Company,
sum(total_laid_off) OVER(PARTITION BY year(`date`), Company ORDER BY year(`date`)) Laid_off
FROM layoff_clean
),
year_top AS
(
SELECT DISTINCT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY laid_off DESC) Yearly_Rank
FROM year_com WHERE years IS NOT NULL AND laid_off IS NOT NULL
)
SELECT * FROM year_top
WHERE Yearly_Rank<=5;