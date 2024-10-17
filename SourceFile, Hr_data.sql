create database Hr_analysis;
use Hr_analysis;
DELETE FROM general_data;
set sql_safe_updates = 0;
Select * from general_data;
select * from employee_survey_data;
select * from manager_survey_data;

-- 1. Retrieve the total number of employees in the dataset.

SELECT COUNT(*) AS TotalEmployees
FROM general_data;

-- 2. List all unique job roles in the dataset.

SELECT DISTINCT JobRole
FROM general_data;

-- 3. Find the average age of employees.

SELECT round(AVG(Age))  AS AverageAge
FROM general_data;

-- 4. Retrieve the names and ages of employees who have worked at the company for more than 5 years.

SELECT EmpName, Age, YearsAtCompany
FROM general_data
WHERE YearsAtCompany > 5;

-- 5. Get a count of employees grouped by their department.

SELECT Department, COUNT(*) AS EmployeeCount
FROM general_data
GROUP BY Department;

-- 6. List employees who have 'High' Job Satisfaction.

SELECT g.EmpName, e.JobSatisfaction
FROM general_data g
JOIN employee_survey_data e ON g.EmployeeID = e.EmployeeID
WHERE e.JobSatisfaction >= 4;

-- 7. Find the highest Monthly Income in the dataset.

SELECT MAX(MonthlyIncome) AS HighestMonthlyIncome
FROM general_data;

-- 8. List employees who have 'Travel_Rarely' as their BusinessTravel type.

SELECT EmpName,BusinessTravel
FROM general_data
WHERE BusinessTravel = 'Travel_Rarely';

-- 9. Retrieve the distinct MaritalStatus categories in the dataset.

SELECT DISTINCT MaritalStatus
FROM general_data;

-- 10. Get a list of employees with more than 2 years of work experience but less than 4 years in their current role.

SELECT EmpName, TotalWorkingYears, (TotalWorkingYears - YearsAtCompany) as years_at_current_role
FROM general_data
WHERE TotalWorkingYears > 2 AND TotalWorkingYears - YearsAtCompany < 4;

-- 11. List employees who have changed their job roles within the company (JobLevel and JobRole differ from their previous job).

SELECT DISTINCT current.EmpName
FROM general_data AS current
JOIN general_data AS previous
    ON current.EmployeeID = previous.EmployeeID
    AND current.YearsAtCompany > previous.YearsAtCompany
WHERE current.JobLevel <> previous.JobLevel
    OR current.JobRole <> previous.JobRole;

-- 12. Find the average distance from home for employees in each department.

SELECT Department, AVG(DistanceFromHome) AS AvgDistanceFromHome
FROM general_data
GROUP BY Department;

-- 13. Retrieve the top 5 employees with the highest MonthlyIncome.

SELECT EmpName, MonthlyIncome, ranked
FROM (
    SELECT EmpName, MonthlyIncome, DENSE_RANK() OVER (ORDER BY MonthlyIncome DESC) AS ranked
    FROM general_data
) AS ranked_data
WHERE ranked BETWEEN 1 AND 5;

-- 14. Calculate the percentage of employees who have had a promotion in the last year.

SELECT 
    COUNT(CASE WHEN YearsSinceLastPromotion = 1 THEN 1 END) * 100.0 / COUNT(*) AS PromotionPercentage
FROM general_data;

-- 15. List the employees with the highest and lowest EnvironmentSatisfaction.

SELECT gd.EmpName, es.EnvironmentSatisfaction
FROM general_data gd
JOIN employee_survey_data es ON gd.EmployeeID = es.EmployeeID
WHERE es.EnvironmentSatisfaction = (
    SELECT MAX(EnvironmentSatisfaction) FROM employee_survey_data
)
OR es.EnvironmentSatisfaction = (
    SELECT MIN(EnvironmentSatisfaction) FROM employee_survey_data
);

-- 16. Find the employees who have the same JobRole and MaritalStatus.

SELECT EmpName, JobRole, MaritalStatus
FROM general_data
WHERE (JobRole, MaritalStatus) IN (
    SELECT JobRole, MaritalStatus
    FROM general_data
    GROUP BY JobRole, MaritalStatus
    HAVING COUNT(*) > 1
);

-- 17. List the employees with the highest TotalWorkingYears who also have a PerformanceRating of 4.

SELECT gd.EmpName, gd.TotalWorkingYears, ms.PerformanceRating
FROM general_data gd
JOIN manager_survey_data ms ON gd.EmployeeID = ms.EmployeeID
WHERE gd.TotalWorkingYears = (
    SELECT MAX(gd.TotalWorkingYears)
    FROM general_data gd
    JOIN manager_survey_data ms ON gd.EmployeeID = ms.EmployeeID
    WHERE ms.PerformanceRating = 4
)
AND ms.PerformanceRating = 4;

-- 18. Calculate the average Age and JobSatisfaction for each BusinessTravel type.

SELECT BusinessTravel,
       AVG(gd.Age) AS AvgAge,
       AVG(es.JobSatisfaction) AS AvgJobSatisfaction
FROM general_data gd
JOIN employee_survey_data es ON gd.EmployeeID = es.EmployeeID
GROUP BY BusinessTravel;

-- 19. Retrieve the most common EducationField among employees.

SELECT EducationField
FROM general_data
GROUP BY EducationField
ORDER BY COUNT(*) DESC
LIMIT 1;

-- 20. List the employees who have worked for the company the longest but haven't had a promotion.

SELECT EmpName, YearsSinceLastPromotion, YearsAtCompany
FROM general_data
WHERE YearsSinceLastPromotion = 0
ORDER BY YearsAtCompany DESC limit 1;

