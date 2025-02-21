-- Exploratory Data Analysis

Select *
from layoffs_staging2;

select max(total_laid_off), Max(percentage_laid_off)
from layoffs_staging2
where percentage_laid_off = 1;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions DESC;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 DESC;

Select Min(`date`) , Max(`date`)
from layoffs_staging2;

-- What industry has the most laid off? Consumer
select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 DESC;

-- What country had the most laid off? United States
select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 DESC;

-- What year had the most layoff? 2022
select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 DESC;

-- What is the stage of the company?
select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 DESC;

-- Percentage of companies?
select company, sum(percentage_laid_off)
from layoffs_staging2
group by company
order by 2 DESC;

-- Rolling total of layoffs
select substring(`date`, 1,7) as `month`, sum(total_laid_off)
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `month`
order by 1 ASC
;

with rolling_Total as
(select substring(`date`, 1,7) as `month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1,7) is not null
group by `month`
order by 1 ASC
)
select `month`, total_off
 ,sum(total_off) over(order by `month`) as rolling_total
from rolling_total;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 DESC;

select company, Year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
order by 2 ASC;

select company, Year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
order by 3 DESC;

WITH company_Year (company, years, total_laid_off) as
(select company, Year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, Year(`date`)
), company_year_rank as
(select *, 
dense_rank() over (partition by years order by total_laid_off DESC ) as ranking
from Company_Year
where years is not null
)
select *
from company_year_rank
where ranking <=5
;

SELECT 
    DISTINCT SUBSTRING(date,1,7) as Month, 
    SUM(total_laid_off) OVER(ORDER BY SUBSTRING(date, 1,7)) as layoffs_rolling,
    SUM(total_laid_off) OVER(PARTITION BY SUBSTRING(date, 1,7)) as total_layoffs
FROM 
    layoffs_staging2
WHERE 
     SUBSTRING(date,1,7) IS NOT NULL
ORDER BY 1
