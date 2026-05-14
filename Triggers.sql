-- JOB_OBJECTIVE: Validate Objective Weight
DELIMITER //
CREATE TRIGGER trg_validate_objective_weight
BEFORE INSERT ON JOB_OBJECTIVE
FOR EACH ROW
BEGIN
    DECLARE totalWeight DECIMAL(5,2);
    SELECT IFNULL(SUM(Weight), 0) INTO totalWeight
    FROM JOB_OBJECTIVE
    WHERE Job_ID = NEW.Job_ID;
    
    IF (totalWeight + NEW.Weight) > 100 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Total objective weight for this job cannot exceed 100%';
    END IF;
END;
//
DELIMITER ;

-- OBJECTIVE_KPI: Prevent Deleting Objective if KPIs Exist
DELIMITER //
CREATE TRIGGER trg_prevent_objective_delete
BEFORE DELETE ON JOB_OBJECTIVE
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM OBJECTIVE_KPI WHERE Objective_ID = OLD.Objective_ID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete objective with existing KPIs';
    END IF;
END;
//
DELIMITER ;

-- EMPLOYEE: Prevent Deleting Employee with Active Assignments
DELIMITER //
CREATE TRIGGER trg_prevent_employee_delete
BEFORE DELETE ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM JOB_ASSIGNMENT 
               WHERE Employee_ID = OLD.Employee_ID AND Status = 'Active') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete employee with active job assignments';
    END IF;
END;
//
DELIMITER ;


-- EMPLOYEE_KPI_SCORE: Auto-Calculate Weighted Score
DELIMITER //
CREATE TRIGGER trg_auto_weighted_score
AFTER INSERT ON EMPLOYEE_KPI_SCORE
FOR EACH ROW
BEGIN
    DECLARE kpiWeight DECIMAL(5,2);
    DECLARE weightedScore DECIMAL(5,2);
    
    SELECT Weight INTO kpiWeight 
    FROM OBJECTIVE_KPI 
    WHERE KPI_ID = NEW.KPI_ID;
    
    SET weightedScore = NEW.Employee_Score * (kpiWeight / 100);
    
    UPDATE EMPLOYEE_KPI_SCORE
    SET Weighted_Score = weightedScore
    WHERE Score_ID = NEW.Score_ID;
END;
//
DELIMITER ;

-- TRAINING_PROGRAM: Prevent Deleting Program Assigned to Employees

DELIMITER //
CREATE TRIGGER trg_prevent_training_delete
BEFORE DELETE ON TRAINING_PROGRAM
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM EMPLOYEE_TRAINING WHERE Program_ID = OLD.Program_ID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete training program assigned to employees';
    END IF;
END;
//
DELIMITER ;

-- TRAINING_CERTIFICATE: Validate Training Attendance
DELIMITER //
CREATE TRIGGER trg_validate_certificate
BEFORE INSERT ON TRAINING_CERTIFICATE
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM EMPLOYEE_TRAINING WHERE ET_ID = NEW.ET_ID) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot issue certificate: Employee training record does not exist';
    END IF;
END;
//
DELIMITER ;

-- 