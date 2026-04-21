show databases;
use hr_project;
show tables;
select count(*) from  hr_1;
select count(*) from  hr_2;
SET SQL_SAFE_UPDATES = 0;
select * from hr_1;
select * from hr_2;
alter table hr_1 change column Age Age int;
SELECT `Employee ID` FROM hr_2;
ALTER TABLE hr_2 CHANGE `Employee ID` EmployeeID INT;

-- KPI-1 Average Attrition rate for all Departments
SELECT 
    Department,
    CONCAT(
        ROUND(
            AVG(CASE 
                    WHEN Attrition = 'Yes' THEN 1 
                    ELSE 0 
                END) * 100, 2
        ),
        '%'
    ) AS Attrition_Rate
FROM hr_1
GROUP BY Department;

-- KPI-2 Average Hourly rate of Male Research Scientist
Select * from hr_1;
SELECT 
    JobRole,
    Gender,
    ROUND(AVG(HourlyRate), 2) AS Avg_Hourly_Rate
FROM hr_1
WHERE JobRole = 'Research Scientist'
  AND Gender = 'Male'
GROUP BY JobRole, Gender;

-- KPI-3 Attrition rate Vs Monthly income stats
SELECT 
    h1.Attrition,
    COUNT(*)                                                          AS EmployeeCount,
    ROUND(AVG(h2.MonthlyIncome), 2)                                   AS AvgMonthlyIncome,
    MIN(h2.MonthlyIncome)                                             AS MinMonthlyIncome,
    MAX(h2.MonthlyIncome)                                             AS MaxMonthlyIncome,
    ROUND(
        (COUNT(*) * 100.0) / SUM(COUNT(*)) OVER (), 2
    )                                                                 AS AttritionRate_Pct
FROM HR_1 h1
JOIN HR_2 h2 ON h1.EmployeeNumber = h2.EmployeeID
GROUP BY h1.Attrition;

-- KPI-4 Average working years for each Department

SELECT 
    h1.Department,
    COUNT(*)                                AS EmployeeCount,
    ROUND(AVG(h2.TotalWorkingYears), 2)     AS AvgTotalWorkingYears,
    ROUND(AVG(h2.YearsAtCompany), 2)        AS AvgYearsAtCompany,
    ROUND(AVG(h2.YearsInCurrentRole), 2)    AS AvgYearsInCurrentRole
FROM HR_1 h1
JOIN HR_2 h2 ON h1.EmployeeNumber = h2.EmployeeID
GROUP BY h1.Department
ORDER BY AvgTotalWorkingYears DESC;


-- KPI-5 Job Role Vs Work life balance

SELECT 
    h1.JobRole,
    COUNT(*)                                                          AS EmployeeCount,
    ROUND(AVG(h2.WorkLifeBalance), 2)                                 AS AvgWorkLifeBalance,
    SUM(CASE WHEN h2.WorkLifeBalance = 1 THEN 1 ELSE 0 END)           AS Poor,
    SUM(CASE WHEN h2.WorkLifeBalance = 2 THEN 1 ELSE 0 END)           AS Fair,
    SUM(CASE WHEN h2.WorkLifeBalance = 3 THEN 1 ELSE 0 END)           AS Good,
    SUM(CASE WHEN h2.WorkLifeBalance = 4 THEN 1 ELSE 0 END)           AS Excellent
FROM HR_1 h1
JOIN HR_2 h2 ON h1.EmployeeNumber = h2.EmployeeID
GROUP BY h1.JobRole
ORDER BY AvgWorkLifeBalance DESC;


-- KPI-6 Attrition rate Vs Year since last promotion relation
SELECT 
    h2.YearsSinceLastPromotion,
    COUNT(*)                                                          AS TotalEmployees,
    SUM(CASE WHEN h1.Attrition = 'Yes' THEN 1 ELSE 0 END)            AS AttritionCount,
    ROUND(
        (SUM(CASE WHEN h1.Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0)
        / COUNT(*), 2
    )                                                                 AS AttritionRate_Pct
FROM HR_1 h1
JOIN HR_2 h2 ON h1.EmployeeNumber = h2.EmployeeID
GROUP BY h2.YearsSinceLastPromotion
ORDER BY h2.YearsSinceLastPromotion;





