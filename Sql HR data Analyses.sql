-- CREATE DATABASE ______

-- USE ______;

SELECT * FROM hr;

# change the column name in a porper way 
ALTER TABLE hr CHANGE `ï»¿id` emp_id VARCHAR(20) NULL;

select * from hr;

describe hr;

select birthdate
from hr;

# the bither data is not in porper date format so we need to in order 

set sql_safe_updates = 0;

update hr
set birthdate = case
when birthdate like '%/%' then date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
when birthdate like '%-%' then date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
else null

END;



select birthdate from hr;
alter table hr
modify column birthdate date;

# now to fix the porblem in the hire_date column alter

Set sql_safe_updates = 0;

UPDATE hr 
SET hire_date = CASE 
    WHEN hire_date LIKE '%/%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m/%d/%Y'), '%Y-%m-%d') 
    WHEN hire_date LIKE '%-%' THEN DATE_FORMAT(STR_TO_DATE(hire_date, '%m-%d-%y'), '%Y-%m-%d') 
    ELSE NULL 
END;

Alter table hr
modify column hire_date date;

# now to fix te termdate issue 

update hr
set termdate = date(str_to_date(termdate, '%Y-%m-%d  %H:%i:%s UTC'))
where termdate is not null and termdate != ' ';

Alter table hr
modify column termdate Date;

# Create a new column that is age which can represent the age in Years 
Alter table hr add column age int;

update hr
set age = timestampdiff(year, birthdate, curdate());

select 
	min(age) as youngest,
    max(age) as oldest
    
from hr;

select count(*) from hr where age < 18;

select count(*) from hr where termdate > curdate();

select count(*)
from hr
where termdate = '0000-00-00';

select location from hr;



-- QUESTIONS

-- 1. What is the gender breakdown of employees in the company?
select gender, count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by gender;


-- 2. What is the race/ethnicity breakdown of employees in the company?

select race, count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by race
order by count(*) desc;

-- 3. What is the age distribution of employees in the company?
select 
min(age) as youngest,
max(age) as oldest
from hr
where age >= 18 and termdate = '0000-00-00';
select 
	case
		when age>= 18 and age <=24 then '18-24'
        when age>= 25 and age <=34 then '25-34'
        when age>= 35 and age <=44 then '35-44'
        when age>= 45 and age <=54 then '45-54'
        when age>= 55 and age <=64 then '55-64'
        else '65+' 
        
	end as age_group, gender,
    count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by age_group, gender
order by age_group, gender;
-- 4. How many employees work at headquarters versus remote locations?

select location, count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by location;

-- 5. What is the average length of employment for employees who have been terminated?
select 
	round(avg(datediff(termdate, hire_date))/365,0) as avg_length_employme
from hr
where termdate <= curdate() and termdate<>'0000-00-00' and termdate >=18;
-- 6. How does the gender distribution vary across departments and job titles?
select department, gender, count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by department, gender
order by department;

-- 7. What is the distribution of job titles across the company?

select jobtitle, count(*) as count
from hr
where age >= 18 and termdate = '0000-00-00'
group by jobtitle
order by jobtitle desc;


-- 8. Which department has the highest turnover rate?
select department,
	total_count,
    terminated_count,
    terminated_count/total_count as termination_rate
from (
	select department,
    count(*) as total_count,
    sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminated_count
	from hr
    where age >= 18
    group by department
    ) as subquery
order by termination_rate desc;


-- 9. What is the distribution of employees across locations by city and state?

select location_state, count(*) as count
from hr
where age>=18 and termdate = '0000-00-00'
group by location_state
order by count desc;

-- 10. How has the company's employee count changed over time based on hire and term dates?
select
	year,
    hires,
    terminations,
    round((hires - terminations)/hires * 100, 2) as net_change_percent
from(
	select
    year(hire_date) as year,
    count(*) as hires,
    sum(case when termdate <> '0000-00-00' and termdate <= curdate() then 1 else 0 end) as terminations
    from hr
    where age >= 18
    group by year(hire_date)
    ) as subquery
order by year asc;

    


-- 11. What is the tenure distribution for each department?

select department, round(avg(datediff(termdate, hire_date)/365),0) AS avg_tenure
from hr
where termdate <= curdate() and termdate <> '0000-00-00' and termdate >= 18
group by department;

