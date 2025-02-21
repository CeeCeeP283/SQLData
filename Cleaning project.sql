-- Cleaning data

select *
from layoffs;

-- 1. Remove duplicate
-- 2. standadize the data
-- 3. Null values or blank values
-- 4. Remove any columns and rows

create table layoffs_staging
like layoffs;

insert layoffs_staging
select *
from layoffs;

select *,
row_number() over(partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

with duplicate_cte as
(
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,
 stage, country,funds_raised_millions) as row_num
from layoffs_staging
)
Select*
from duplicate_cte
where row_num > 1;

select*
from layoffs_staging
where company ='casper';


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

select*
from layoffs_staging2;

Insert into layoffs_staging2
select *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, `date`,
 stage, country,funds_raised_millions) as row_num
from layoffs_staging;

Delete
from layoffs_staging2
where row_num >1;

select *
from layoffs_staging2;

-- Standardizing data

select company, (Trim(company))
from layoffs_staging2;

Update layoffs_staging2
set company = trim(company);

select distinct industry
from layoffs_staging2
Order by 1;

select *
from layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry = 'crypto'
where industry like 'crypto%';

select distinct industry
from layoffs_staging2;

select distinct location
from layoffs_staging2
order by 1;

select distinct country
from layoffs_staging2
order by 1;

select Distinct country, Trim(Trailing    '.'   from    country)
from layoffs_staging2
order by 1;

update layoffs_staging2
set country = Trim(Trailing    '.'   from    country)
where country like 'united states%';

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

Update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');

Alter table layoffs_staging2
Modify column `date` Date;

select *
From layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

update layoffs_staging2
set industry = null
where industry = '';


Select *
from layoffs_staging2
where industry is null
or industry = '';

select *
from layoffs_staging2
where company ='Airbnb';

select t1.industry, t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
	and t1.location = t2.location
where (t1.industry is null or t1.industry ='')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
	and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;

select *
from layoffs_staging2
where company like 'Bally%';

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

Delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layoffs_staging2;

Alter table layoffs_staging2
drop column row_num;
