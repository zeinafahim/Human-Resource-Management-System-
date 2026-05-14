-- Employee Procedures:
DELIMITER $$

CREATE PROCEDURE AddNewEmployee(
    IN p_First_Name VARCHAR(50),
    IN p_Middle_Name VARCHAR(50),
    IN p_Last_Name VARCHAR(50),
    IN p_Arabic_Name VARCHAR(100),
    IN p_Gender VARCHAR(10),
    IN p_Nationality VARCHAR(50),
    IN p_DOB DATE,
    IN p_Place_of_Birth VARCHAR(100),
    IN p_Marital_Status VARCHAR(20),
    IN p_Religion VARCHAR(20),
    IN p_Employment_Status VARCHAR(50),
    IN p_Mobile_Phone VARCHAR(20),
    IN p_Work_Phone VARCHAR(20),
    IN p_Work_Email VARCHAR(100),
    IN p_Personal_Email VARCHAR(100),
    IN p_Emergency_Contact_Name VARCHAR(100),
    IN p_Emergency_Contact_Phone VARCHAR(20),
    IN p_Emergency_Contact_Relationship VARCHAR(50),
    IN p_Residential_City VARCHAR(100),
    IN p_Residential_Area VARCHAR(100),
    IN p_Residential_Street VARCHAR(100),
    IN p_Residential_Country VARCHAR(50),
    IN p_Permanent_City VARCHAR(100),
    IN p_Permanent_Area VARCHAR(100),
    IN p_Permanent_Street VARCHAR(100),
    IN p_Permanent_Country VARCHAR(50),
    IN p_Medical_Clearance_Status VARCHAR(50),
    IN p_Criminal_Status VARCHAR(50)
)
BEGIN
    -- Insert employee
    INSERT INTO EMPLOYEE (
        First_Name, Middle_Name, Last_Name, Arabic_Name, Gender, Nationality, DOB, Place_of_Birth, Marital_Status, Religion,
        Employment_Status, Mobile_Phone, Work_Phone, Work_Email, Personal_Email,
        Emergency_Contact_Name, Emergency_Contact_Phone, Emergency_Contact_Relationship,
        Residential_City, Residential_Area, Residential_Street, Residential_Country,
        Permanent_City, Permanent_Area, Permanent_Street, Permanent_Country,
        Medical_Clearance_Status, Criminal_Status
    )
    VALUES (
        p_First_Name, p_Middle_Name, p_Last_Name, p_Arabic_Name, p_Gender, p_Nationality, p_DOB, p_Place_of_Birth,
        p_Marital_Status, p_Religion, p_Employment_Status, p_Mobile_Phone, p_Work_Phone, p_Work_Email, p_Personal_Email,
        p_Emergency_Contact_Name, p_Emergency_Contact_Phone, p_Emergency_Contact_Relationship,
        p_Residential_City, p_Residential_Area, p_Residential_Street, p_Residential_Country,
        p_Permanent_City, p_Permanent_Area, p_Permanent_Street, p_Permanent_Country,
        p_Medical_Clearance_Status, p_Criminal_Status
    );

    -- Get last inserted employee ID
    SET @new_employee_id = LAST_INSERT_ID();

    -- Insert basic social insurance record
    INSERT INTO SOCIAL_INSURANCE (Employee_ID, Registration_Date)
    VALUES (@new_employee_id, CURDATE());
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AddEmployeeDisability(
    IN p_Employee_ID INT,
    IN p_Disability_Type VARCHAR(100),
    IN p_Description TEXT
)
BEGIN
    INSERT INTO EMPLOYEE_DISABILITY(Employee_ID, Disability_Type, Description)
    VALUES (p_Employee_ID, p_Disability_Type, p_Description);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE GetEmployeeFullProfile(
    IN p_Employee_ID INT
)
BEGIN
    SELECT e.*, 
           d.Department_Name, j.Job_Title, ja.Start_Date, ja.End_Date, ja.Status AS Job_Status,
           td.Disability_Type, td.Description AS Disability_Description,
           tp.Title AS Training_Title, et.Completion_Status,
           tc.certificate_file_path, tc.Issue_Date AS Certificate_Issue
    FROM EMPLOYEE e
    LEFT JOIN JOB_ASSIGNMENT ja ON e.Employee_ID = ja.Employee_ID
    LEFT JOIN JOB j ON ja.Job_ID = j.Job_ID
    LEFT JOIN DEPARTMENT d ON j.Department_ID = d.Department_ID
    LEFT JOIN EMPLOYEE_DISABILITY td ON e.Employee_ID = td.Employee_ID
    LEFT JOIN EMPLOYEE_TRAINING et ON e.Employee_ID = et.Employee_ID
    LEFT JOIN TRAINING_PROGRAM tp ON et.Program_ID = tp.Program_ID
    LEFT JOIN TRAINING_CERTIFICATE tc ON et.ET_ID = tc.ET_ID
    WHERE e.Employee_ID = p_Employee_ID;
END $$

DELIMITER ;

-- Job & Assignment procedures

DELIMITER $$

CREATE PROCEDURE AddNewJob(
    IN p_Job_Code VARCHAR(50),
    IN p_Job_Title VARCHAR(255),
    IN p_Job_Level VARCHAR(50),
    IN p_Job_Category VARCHAR(50),
    IN p_Job_Grade VARCHAR(20),
    IN p_Min_Salary DECIMAL(12,2),
    IN p_Max_Salary DECIMAL(12,2),
    IN p_Job_Description TEXT,
    IN p_Status VARCHAR(50),
    IN p_Department_ID INT,
    IN p_Reports_To INT
)
BEGIN
    INSERT INTO JOB (
        Job_Code, Job_Title, Job_Level, Job_Category, Job_Grade,
        Min_Salary, Max_Salary, Job_Description, Status, Department_ID, Reports_To
    )
    VALUES (
        p_Job_Code, p_Job_Title, p_Job_Level, p_Job_Category, p_Job_Grade,
        p_Min_Salary, p_Max_Salary, p_Job_Description, p_Status, p_Department_ID, p_Reports_To
    );
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AddJobObjective(
    IN p_Job_ID INT,
    IN p_Objective_Title VARCHAR(255),
    IN p_Description TEXT,
    IN p_Weight DECIMAL(5,2),
    IN p_Salary DECIMAL(12,2)
)
BEGIN
    DECLARE total_weight DECIMAL(5,2);

    SELECT IFNULL(SUM(Weight),0) INTO total_weight
    FROM JOB_OBJECTIVE
    WHERE Job_ID = p_Job_ID;

    IF total_weight + p_Weight > 100 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Total objective weight exceeds 100%';
    ELSE
        INSERT INTO JOB_OBJECTIVE(Job_ID, Objective_Title, Description, Weight, Salary)
        VALUES (p_Job_ID, p_Objective_Title, p_Description, p_Weight, p_Salary);
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AddKPIToObjective(
    IN p_Objective_ID INT,
    IN p_KPI_Name VARCHAR(255),
    IN p_Description TEXT,
    IN p_Measurement_Unit VARCHAR(50),
    IN p_Target_Value DECIMAL(12,2),
    IN p_Weight DECIMAL(5,2)
)
BEGIN
    INSERT INTO OBJECTIVE_KPI(
        Objective_ID, KPI_Name, Description, Measurement_Unit, Target_Value, Weight
    )
    VALUES (p_Objective_ID, p_KPI_Name, p_Description, p_Measurement_Unit, p_Target_Value, p_Weight);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AssignJobToEmployee(
    IN p_Employee_ID INT,
    IN p_Job_ID INT,
    IN p_Contract_ID INT,
    IN p_Start_Date DATE,
    IN p_End_Date DATE,
    IN p_Assigned_Salary DECIMAL(12,2)
)
BEGIN
    DECLARE cnt INT;

    -- Validate contract exists
    SELECT COUNT(*) INTO cnt
    FROM CONTRACT
    WHERE Contract_ID = p_Contract_ID;
    IF cnt = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Contract does not exist';
    END IF;

    -- Check overlapping active jobs
    SELECT COUNT(*) INTO cnt
    FROM JOB_ASSIGNMENT
    WHERE Employee_ID = p_Employee_ID
      AND Status = 'Active'
      AND (p_End_Date IS NULL OR End_Date IS NULL OR
           p_Start_Date <= End_Date AND Start_Date <= p_End_Date);
    IF cnt > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Employee has overlapping active job';
    END IF;

    -- Insert job assignment
    INSERT INTO JOB_ASSIGNMENT(Employee_ID, Job_ID, Contract_ID, Start_Date, End_Date, Status, Assigned_Salary)
    VALUES (p_Employee_ID, p_Job_ID, p_Contract_ID, p_Start_Date, p_End_Date, 'Active', p_Assigned_Salary);
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE CloseJobAssignment(
    IN p_Assignment_ID INT,
    IN p_End_Date DATE
)
BEGIN
    UPDATE JOB_ASSIGNMENT
    SET End_Date = p_End_Date,
        Status = 'Closed'
    WHERE Assignment_ID = p_Assignment_ID;
END $$

DELIMITER ;

-- Performance Management procedures
DELIMITER $$

CREATE PROCEDURE CreatePerformanceCycle(
    IN p_Cycle_Name VARCHAR(255),
    IN p_Cycle_Type VARCHAR(50),
    IN p_Start_Date DATE,
    IN p_End_Date DATE,
    IN p_Submission_Deadline DATE
)
BEGIN
    INSERT INTO PERFORMANCE_CYCLE (Cycle_Name, Cycle_Type, Start_Date, End_Date, Submission_Deadline)
    VALUES (p_Cycle_Name, p_Cycle_Type, p_Start_Date, p_End_Date, p_Submission_Deadline);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AddEmployeeKPIScore(
    IN p_Assignment_ID INT,
    IN p_KPI_ID INT,
    IN p_Performance_Cycle_ID INT,
    IN p_Actual_Value DECIMAL(12,2),
    IN p_Employee_Score DECIMAL(5,2),
    IN p_Reviewer_ID INT,
    IN p_Comments TEXT,
    IN p_Review_Date DATE
)
BEGIN
    INSERT INTO EMPLOYEE_KPI_SCORE (
        Assignment_ID, KPI_ID, Performance_Cycle_ID, Actual_Value, Employee_Score, Reviewer_ID, Comments, Review_Date
    )
    VALUES (p_Assignment_ID, p_KPI_ID, p_Performance_Cycle_ID, p_Actual_Value, p_Employee_Score, p_Reviewer_ID, p_Comments, p_Review_Date);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE CalculateEmployeeWeightedScore(
    IN p_Assignment_ID INT,
    IN p_Performance_Cycle_ID INT
)
BEGIN
    DECLARE total_weighted_score DECIMAL(5,2);

    SELECT IFNULL(SUM(Weighted_Score),0) INTO total_weighted_score
    FROM EMPLOYEE_KPI_SCORE
    WHERE Assignment_ID = p_Assignment_ID
      AND Performance_Cycle_ID = p_Performance_Cycle_ID;

    -- Update Appraisal if exists, else insert
    IF EXISTS (SELECT 1 FROM APPRAISAL WHERE Assignment_ID = p_Assignment_ID AND Cycle_ID = p_Performance_Cycle_ID) THEN
        UPDATE APPRAISAL
        SET Overall_Score = total_weighted_score
        WHERE Assignment_ID = p_Assignment_ID AND Cycle_ID = p_Performance_Cycle_ID;
    ELSE
        INSERT INTO APPRAISAL (Assignment_ID, Cycle_ID, Overall_Score)
        VALUES (p_Assignment_ID, p_Performance_Cycle_ID, total_weighted_score);
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE CreateAppraisal(
    IN p_Assignment_ID INT,
    IN p_Cycle_ID INT,
    IN p_Appraisal_Date DATE,
    IN p_Manager_Comments TEXT,
    IN p_HR_Comments TEXT,
    IN p_Employee_Comments TEXT,
    IN p_Reviewer_ID INT
)
BEGIN
    INSERT INTO APPRAISAL (
        Assignment_ID, Cycle_ID, Appraisal_Date, Manager_Comments, HR_Comments, Employee_Comments, Reviewer_ID
    )
    VALUES (
        p_Assignment_ID, p_Cycle_ID, p_Appraisal_Date, p_Manager_Comments, p_HR_Comments, p_Employee_Comments, p_Reviewer_ID
    );
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE SubmitAppeal(
    IN p_Appraisal_ID INT,
    IN p_Submission_Date DATE,
    IN p_Reason TEXT
)
BEGIN
    DECLARE orig_score DECIMAL(5,2);

    SELECT Overall_Score INTO orig_score
    FROM APPRAISAL
    WHERE Appraisal_ID = p_Appraisal_ID;

    INSERT INTO APPEAL (Appraisal_ID, Submission_Date, Reason, Original_Score, Approval_Status)
    VALUES (p_Appraisal_ID, p_Submission_Date, p_Reason, orig_score, 'Pending');
END $$

DELIMITER ;

-- Training procedures
DELIMITER $$

CREATE PROCEDURE AddTrainingProgram(
    IN p_Program_Code VARCHAR(50),
    IN p_Title VARCHAR(255),
    IN p_Objectives TEXT,
    IN p_Type VARCHAR(50),
    IN p_Subtype VARCHAR(50),
    IN p_Delivery_Method VARCHAR(50),
    IN p_Approval_Status VARCHAR(50)
)
BEGIN
    INSERT INTO TRAINING_PROGRAM (Program_Code, Title, Objectives, Type, Subtype, Delivery_Method, Approval_Status)
    VALUES (p_Program_Code, p_Title, p_Objectives, p_Type, p_Subtype, p_Delivery_Method, p_Approval_Status);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE AssignTrainingToEmployee(
    IN p_Employee_ID INT,
    IN p_Program_ID INT,
    IN p_Completion_Status VARCHAR(50)
)
BEGIN
    INSERT INTO EMPLOYEE_TRAINING (Employee_ID, Program_ID, Completion_Status)
    VALUES (p_Employee_ID, p_Program_ID, p_Completion_Status);
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE RecordTrainingCompletion(
    IN p_ET_ID INT,
    IN p_Completion_Status VARCHAR(50)
)
BEGIN
    UPDATE EMPLOYEE_TRAINING
    SET Completion_Status = p_Completion_Status
    WHERE ET_ID = p_ET_ID;
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE IssueTrainingCertificate(
    IN p_ET_ID INT,
    IN p_Issue_Date DATE,
    IN p_Certificate_File_Path VARCHAR(255)
)
BEGIN
    -- Validate if ET_ID exists
    IF EXISTS (SELECT 1 FROM EMPLOYEE_TRAINING WHERE ET_ID = p_ET_ID) THEN
        INSERT INTO TRAINING_CERTIFICATE (ET_ID, Issue_Date, certificate_file_path)
        VALUES (p_ET_ID, p_Issue_Date, p_Certificate_File_Path);
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Training assignment does not exist.';
    END IF;
END $$

DELIMITER ;

