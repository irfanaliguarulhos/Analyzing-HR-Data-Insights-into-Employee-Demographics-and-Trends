# Analyzing-HR-Data-Insights-into-Employee-Demographics-and-Trends
Analyzing HR Data: Insights into Employee Demographics and Trends
## Introduction:
In today's data-driven world, organizations rely on data analysis to gain valuable insights into various aspects of their operations. One crucial area is human resources (HR), where analyzing employee data can provide valuable information about the workforce. In this article, we will explore a comprehensive analysis of HR data, including the gender breakdown, race/ethnicity distribution, age demographics, location distribution, employment length, gender distribution across departments and job titles, job title distribution, turnover rate by department, employee distribution across locations, and changes in employee count over time. The analysis is conducted using MySQL for data cleaning and analysis, and PowerBI for data visualization.
## Data Used:
The analysis is based on HR data consisting of over 22,000 rows from the year 2000 to 2020. The dataset includes information such as employee IDs, gender, race/ethnicity, age, location, hire and termination dates, departments, and job titles.

**Data Cleaning & Analysis** - MySQL Workbench
The provided MySQL code performs various data cleaning and transformation steps on the 'hr' table in the 'projects' database. Here's a breakdown of each step:

1. Creating a Database:
```sql
CREATE DATABASE projects;
```
This code creates a new database named 'projects'.

2. Selecting the Database:
```sql
USE projects;
```
This code selects the 'projects' database for further operations.

3. Viewing Table Structure:
```sql
DESCRIBE hr;
```
This code displays the structure of the 'hr' table, including the column names and data types.

4. Cleaning Birthdate Column:
```sql
UPDATE hr
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN date_format(str_to_date(birthdate, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN birthdate LIKE '%-%' THEN date_format(str_to_date(birthdate, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
```
This code converts the 'birthdate' column values to the 'YYYY-MM-DD' date format. It handles different date formats and sets any invalid dates as NULL.

5. Modifying Birthdate Column Data Type:
```sql
ALTER TABLE hr
MODIFY COLUMN birthdate DATE;
```
This code modifies the data type of the 'birthdate' column to DATE.

6. Cleaning Hire Date Column:
```sql
UPDATE hr
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN date_format(str_to_date(hire_date, '%m/%d/%Y'), '%Y-%m-%d')
    WHEN hire_date LIKE '%-%' THEN date_format(str_to_date(hire_date, '%m-%d-%Y'), '%Y-%m-%d')
    ELSE NULL
END;
```
This code converts the 'hire_date' column values to the 'YYYY-MM-DD' date format. It handles different date formats and sets any invalid dates as NULL.

7. Modifying Hire Date Column Data Type:
```sql
ALTER TABLE hr
MODIFY COLUMN hire_date DATE;
```
This code modifies the data type of the 'hire_date' column to DATE.

8. Cleaning Term Date Column:
```sql
UPDATE hr
SET termdate = date(str_to_date(termdate, '%Y-%m-%d %H:%i:%s UTC'))
WHERE termdate IS NOT NULL AND termdate != ' ';
```
This code converts the 'termdate' column values to the 'YYYY-MM-DD' date format. It handles a specific date format containing UTC information and excludes empty or spaces-only values.

9. Modifying Term Date Column Data Type:
```sql
ALTER TABLE hr
MODIFY COLUMN termdate DATE;
```
This code modifies the data type of the 'termdate' column to DATE.

10. Adding Age Column:
```sql
ALTER TABLE hr ADD COLUMN age INT;
```
This code adds a new column named 'age' with the INT data type to the 'hr' table.

11. Calculating Age:
```sql
UPDATE hr
SET age = timestampdiff(YEAR, birthdate, CURDATE());
```
This code calculates the age of each employee based on their birthdate and the current date.

12. Finding Youngest and Oldest Employees:
```sql
SELECT
    min(age) AS youngest,
    max(age) AS oldest
FROM hr;
```
This code retrieves the minimum and maximum age values from the 'age' column, providing the youngest and oldest employee ages.

13. Counting Employees Under 18:
```sql
SELECT count(*) FROM hr WHERE age < 18;
```
This code counts the number of employees in the 'hr' table who are under 18 years old.

14. Counting Active Employees:
```sql
SELECT COUNT(*) FROM hr WHERE termdate > CURDATE();
```
This code counts the number of active employees in the 'hr' table based on the current date.

15. Counting Employees with Unknown Termination Date:
```sql
SELECT COUNT(*)
FROM hr
WHERE termdate = '0000-00-00';
```
This code counts the number of employees in the 'hr' table with an unknown (0000-00-00) termination date.

16. Retrieving Employee Locations:
```sql
SELECT location FROM hr;
```
This code retrieves the 'location' column values from the 'hr' table, which represents employee locations.

Please note that the provided code assumes the existence of a 'hr' table within the 'projects' database and performs data cleaning and transformation on that specific table.

## Questions

1. What is the gender breakdown of employees in the company?
2. What is the race/ethnicity breakdown of employees in the company?
3. What is the age distribution of employees in the company?
4. How many employees work at headquarters versus remote locations?
5. What is the average length of employment for employees who have been terminated?
6. How does the gender distribution vary across departments and job titles?
7. What is the distribution of job titles across the company?
8. Which department has the highest turnover rate?
9. What is the distribution of employees across locations by state?
10. How has the company's employee count changed over time based on hire and term dates?
11. What is the tenure distribution for each department?

The provided MySQL code answers various questions about the employee data in the 'hr' table. Here's a description of each question and its corresponding query:

1. Gender Breakdown:
```sql
SELECT gender, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY gender;
```
This query calculates the count of employees in the 'hr' table based on their gender, considering only employees aged 18 and above.

2. Race/Ethnicity Breakdown:
```sql
SELECT race, count(*) AS count
FROM hr
WHERE age >= 18
GROUP BY race
ORDER BY count DESC;
```
This query calculates the count of employees in the 'hr' table based on their race/ethnicity, considering only employees aged 18 and above. The results are sorted in descending order of count.

3. Age Distribution:
```sql
SELECT
    min(age) AS youngest,
    max(age) AS oldest
FROM hr
WHERE age >= 18;

SELECT
    CASE
        WHEN age >= 18 AND age <= 24 THEN '18-24'
        WHEN age >= 25 AND age <= 34 THEN '25-34'
        WHEN age >= 35 AND age <= 44 THEN '35-44'
        WHEN age >= 45 AND age <= 54 THEN '45-54'
        WHEN age >= 55 AND age <= 64 THEN '55-64'
        ELSE '65+'
    END AS age_group,
    count(*) AS count
FROM hr
WHERE age >= 18
GROUP BY age_group
ORDER BY age_group;
```
The first query retrieves the minimum and maximum ages of employees in the 'hr' table who are aged 18 and above. The second query calculates the count of employees in different age groups (18-24, 25-34, 35-44, 45-54, 55-64, 65+) and presents the results in ascending order of age groups.

4. Headquarters vs. Remote Locations:
```sql
SELECT location, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY location;
```
This query calculates the count of employees in the 'hr' table based on their location (headquarters or remote), considering only employees aged 18 and above.

5. Average Length of Employment for Terminated Employees:
```sql
SELECT round(avg(datediff(termdate, hire_date))/365,0) AS avg_length_employment
FROM hr
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >= 18;
```
This query calculates the average length of employment for employees who have been terminated. The result is rounded to the nearest whole number.

6. Gender Distribution across Departments and Job Titles:
```sql
SELECT department, gender, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY department, gender
ORDER BY department;
```
This query calculates the count of employees in the 'hr' table based on their gender and department. It provides the gender distribution across departments, considering only employees aged 18 and above.

7. Job Title Distribution:
```sql
SELECT jobtitle, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY jobtitle
ORDER BY jobtitle DESC;
```
This query calculates the count of employees in the 'hr' table based on their job titles, considering only employees aged 18 and above. The results are sorted in descending order of job titles.

8. Department with the Highest Turnover Rate:
```sql
SELECT department,
    total_count,
    terminated_count,
    terminated_count/total_count AS termination_rate
FROM (
    SELECT department,
        COUNT(*) AS total_count,
        SUM(CASE WHEN termdate <= curdate() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) AS terminated_count
    FROM hr
    WHERE age >= 18
    GROUP BY department
) AS subquery
ORDER BY termination_rate;
```
This query calculates the termination rate (as a percentage) for each department in the 'hr' table. It considers only employees aged 18 and above and sorts the departments based on the termination rate in ascending order.

9. Distribution of Employees across Locations (City and State):
```sql
SELECT location_state, COUNT(*) AS count
FROM hr
WHERE age >= 18
GROUP BY location_state
ORDER BY count DESC;
```
This query calculates the count of employees in the 'hr' table based on their location (city and state), considering only employees aged 18 and above. The results are sorted in descending order of the count.

10. Employee Count Change over Time (Based on Hire and Term Dates):
```sql
SELECT
    year,
    hires,
    terminations,
    hires - terminations AS net_change,
    ROUND((hires - terminations) / hires * 100, 2) AS net_change_percent
FROM (
    SELECT
        YEAR(hire_date) AS year,
        COUNT(*) AS hires,
        SUM(CASE WHEN termdate <= curdate() AND termdate <> '0000-00-00' THEN 1 ELSE 0 END) AS terminations
    FROM hr
    WHERE age >= 18
    GROUP BY YEAR(hire_date)
) AS subquery
ORDER BY year ASC;
```
This query calculates the employee count change over time based on the hire and termination dates. It provides the number of hires, terminations, net change (hires - terminations), and net change percentage (net change divided by hires, multiplied by 100) for each year. The results are ordered in ascending order of the year.

11. Tenure Distribution for Each Department:
```sql
SELECT department, round(avg(datediff(termdate, hire_date) / 365), 0) AS avg_tenure
FROM hr
WHERE termdate <= curdate() AND termdate <> '0000-00-00' AND age >= 18
GROUP BY department;
```
This query calculates the average tenure (in years) for each department in the 'hr' table. It considers only employees aged 18 and above and have been terminated. The results provide the average tenure rounded to the nearest whole number for each department.

**Data Visualization** - PowerBI


## Summary of Findings
 - There are more male employees
 - White race is the most dominant while Native Hawaiian and American Indians are the least dominant.
 - The youngest employee is 20 years old and the oldest is 57 years old
 - 5 age groups were created (18-24, 25-34, 35-44, 45-54, 55-64). A large number of employees were between 25-34 followed by 35-44 while the smallest group was 55-64.
 - A large number of employees work at the headquarters versus remotely.
 - The average length of employment for terminated employees is around 7 years.
 - The gender distribution across departments is fairly balanced but there are generally more male than female employees.
 - The Marketing department has the highest turnover rate followed by Training. The lowest turnover rate is in the Research and development, Support, and Legal departments.
 - A large number of employees come from the state of Ohio.
 - The net change in employees has increased over the years.
- The average tenure for each department is about 8 years with Legal and Auditing having the highest and Services, Sales, and Marketing having the lowest.

## Limitations

- Some records had negative ages and these were excluded during querying(967 records). Ages used were 18 years and above.
- Some termdates were far into the future and were not included in the analysis(1599 records). The only term dates used 
