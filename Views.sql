-- Work Views
CREATE VIEW vw_employee_count_by_department AS
SELECT 
    d.Department_Name,
    COUNT(ja.Employee_ID) AS Employee_Count
FROM DEPARTMENT d
LEFT JOIN JOB j ON d.Department_ID = j.Department_ID
LEFT JOIN JOB_ASSIGNMENT ja ON j.Job_ID = ja.Job_ID
GROUP BY d.Department_Name;

CREATE VIEW vw_gender_distribution AS
SELECT 
    Gender,
    COUNT(*) AS Employee_Count
FROM EMPLOYEE
GROUP BY Gender;

CREATE VIEW vw_employment_status_distribution AS
SELECT 
    Employment_Status,
    COUNT(*) AS Employee_Count
FROM EMPLOYEE
GROUP BY Employment_Status;

-- Job Structure Views
CREATE VIEW vw_jobs_by_level AS
SELECT 
    Job_Level,
    GROUP_CONCAT(Job_Title ORDER BY Job_Title SEPARATOR ', ') AS Jobs
FROM JOB
GROUP BY Job_Level;

CREATE OR REPLACE VIEW SalaryStatsByCategory AS
SELECT 
    Job_Category,
    MIN(Min_Salary) AS MinSalary,
    MAX(Max_Salary) AS MaxSalary,
    ROUND(AVG((Min_Salary + Max_Salary)/2), 2) AS AvgSalary
FROM JOB
GROUP BY Job_Category;

CREATE OR REPLACE VIEW vw_active_job_assignments AS
SELECT 
    ja.Assignment_ID,
    e.First_Name, e.Last_Name,
    j.Job_Title,
    ja.Start_Date, ja.End_Date,
    ja.Status
FROM JOB_ASSIGNMENT ja
JOIN EMPLOYEE e ON ja.Employee_ID = e.Employee_ID
JOIN JOB j ON ja.Job_ID = j.Job_ID
WHERE ja.Status = 'Active';



-- Performance Views
CREATE VIEW vw_kpi_scores_summary AS
SELECT 
    e.Employee_ID,
    CONCAT(e.First_Name, ' ', e.Last_Name) AS Employee_Name,
    ja.Job_ID,
    j.Job_Title,
    ecs.Performance_Cycle_ID,
    pc.Cycle_Name,
    SUM(ecs.Employee_Score) AS Total_Score,
    SUM(ecs.Weighted_Score) AS Total_Weighted_Score
FROM EMPLOYEE_KPI_SCORE ecs
JOIN JOB_ASSIGNMENT ja ON ecs.Assignment_ID = ja.Assignment_ID
JOIN EMPLOYEE e ON ja.Employee_ID = e.Employee_ID
JOIN JOB j ON ja.Job_ID = j.Job_ID
JOIN PERFORMANCE_CYCLE pc ON ecs.Performance_Cycle_ID = pc.Cycle_ID
GROUP BY e.Employee_ID, ja.Job_ID, ecs.Performance_Cycle_ID;

CREATE VIEW vw_appraisal_scores_per_cycle AS
SELECT 
    pc.Cycle_ID,
    pc.Cycle_Name,
    AVG(a.Overall_Score) AS Avg_Appraisal_Score,
    COUNT(a.Appraisal_ID) AS Num_Appraisals
FROM APPRAISAL a
JOIN PERFORMANCE_CYCLE pc ON a.Cycle_ID = pc.Cycle_ID
GROUP BY pc.Cycle_ID, pc.Cycle_Name;

CREATE VIEW vw_full_appraisal_summary AS
SELECT 
    e.Employee_ID,
    CONCAT(e.First_Name, ' ', e.Last_Name) AS Employee_Name,
    j.Job_ID,
    j.Job_Title,
    pc.Cycle_ID,
    pc.Cycle_Name,
    a.Overall_Score,
    a.Manager_Comments,
    a.HR_Comments,
    a.Employee_Comments
FROM APPRAISAL a
JOIN JOB_ASSIGNMENT ja ON a.Assignment_ID = ja.Assignment_ID
JOIN EMPLOYEE e ON ja.Employee_ID = e.Employee_ID
JOIN JOB j ON ja.Job_ID = j.Job_ID
JOIN PERFORMANCE_CYCLE pc ON a.Cycle_ID = pc.Cycle_ID;

-- Training Views
CREATE VIEW vw_employee_training_participation AS
SELECT 
    tp.Program_ID,
    tp.Title AS Program_Title,
    COUNT(et.Employee_ID) AS Num_Participants
FROM TRAINING_PROGRAM tp
LEFT JOIN EMPLOYEE_TRAINING et ON tp.Program_ID = et.Program_ID
GROUP BY tp.Program_ID, tp.Title;

CREATE VIEW vw_training_completion_stats AS
SELECT 
    tp.Program_ID,
    tp.Title AS Program_Title,
    SUM(CASE WHEN et.Completion_Status = 'Completed' THEN 1 ELSE 0 END) AS Completed_Count,
    SUM(CASE WHEN et.Completion_Status != 'Completed' THEN 1 ELSE 0 END) AS Not_Completed_Count,
    COUNT(et.Employee_ID) AS Total_Assigned
FROM TRAINING_PROGRAM tp
LEFT JOIN EMPLOYEE_TRAINING et ON tp.Program_ID = et.Program_ID
GROUP BY tp.Program_ID, tp.Title;





-- Employee count by department
SELECT * FROM vw_employee_count_by_department;

-- Gender distribution
SELECT * FROM vw_gender_distribution;

-- Employment status distribution
SELECT * FROM vw_employment_status_distribution;

SELECT * FROM JobsByLevel;
SELECT * FROM vw_active_job_assignments;


SELECT * FROM SalaryStatsByCategory;

SELECT * FROM vw_jobs_by_level;
SELECT * FROM vw_employee_training_participation;


