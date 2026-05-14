CREATE TABLE UNIVERSITY (
    University_ID INT PRIMARY KEY AUTO_INCREMENT,
    University_Name VARCHAR(255) NOT NULL,
    Acronym VARCHAR(50),
    Established_Year INT,
    Accreditation_Body VARCHAR(255),
    Address VARCHAR(255),
    Contact_Email VARCHAR(255),
    Website_URL VARCHAR(255)
);
CREATE TABLE FACULTY (
    Faculty_ID INT PRIMARY KEY,
    Faculty_Name VARCHAR(255) NOT NULL,
    Location VARCHAR(255),
    Contact_Email VARCHAR(255),
    University_ID INT NOT NULL,
    FOREIGN KEY (University_ID) REFERENCES UNIVERSITY(University_ID) ON DELETE CASCADE
);
CREATE TABLE DEPARTMENT (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(255) NOT NULL,
    Department_Type VARCHAR(50),
    Location VARCHAR(255),
    Contact_Email VARCHAR(255)
);
CREATE TABLE ACADEMIC_DEPARTMENT (
    Department_ID INT NOT NULL,
    Faculty_ID INT NOT NULL,
    PRIMARY KEY (Department_ID, Faculty_ID),
    FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID) ON DELETE CASCADE,
    FOREIGN KEY (Faculty_ID) REFERENCES FACULTY(Faculty_ID) ON DELETE CASCADE
);
CREATE TABLE ADMINISTRATIVE_DEPARTMENT (
    Department_ID INT NOT NULL,
    University_ID INT NOT NULL,
    PRIMARY KEY (Department_ID, University_ID),
    FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID) ON DELETE CASCADE,
    FOREIGN KEY (University_ID) REFERENCES UNIVERSITY(University_ID) ON DELETE CASCADE
);
CREATE TABLE EMPLOYEE (
    Employee_ID INT PRIMARY KEY AUTO_INCREMENT,
    First_Name VARCHAR(50) NOT NULL,
    Middle_Name VARCHAR(50),
    Last_Name VARCHAR(50) NOT NULL,
    Arabic_Name VARCHAR(100),
    Gender VARCHAR(10),
    Nationality VARCHAR(50),
    DOB DATE,
    Place_of_Birth VARCHAR(100),
    Marital_Status VARCHAR(20),
    Religion VARCHAR(20),
    Employment_Status VARCHAR(50),
    Mobile_Phone VARCHAR(20),
    Work_Phone VARCHAR(20),
    Work_Email VARCHAR(100),
    Personal_Email VARCHAR(100),
    Emergency_Contact_Name VARCHAR(100),
    Emergency_Contact_Phone VARCHAR(20),
    Emergency_Contact_Relationship VARCHAR(50),
    Residential_City VARCHAR(100),
    Residential_Area VARCHAR(100),
    Residential_Street VARCHAR(100),
    Residential_Country VARCHAR(50),
    Permanent_City VARCHAR(100),
    Permanent_Area VARCHAR(100),
    Permanent_Street VARCHAR(100),
    Permanent_Country VARCHAR(50),
    Medical_Clearance_Status VARCHAR(50),
    Criminal_Status VARCHAR(50)
);
CREATE TABLE CONTRACT (
    Contract_ID INT PRIMARY KEY AUTO_INCREMENT,
    Contract_Name VARCHAR(255) NOT NULL,
    Type VARCHAR(50),
    Description TEXT,
    Default_Duration INT, -- in months
    Work_Modality VARCHAR(50),
    Eligibility_Criteria TEXT
);
CREATE TABLE JOB (
    Job_ID INT PRIMARY KEY AUTO_INCREMENT,
    Job_Code VARCHAR(50) UNIQUE,
    Job_Title VARCHAR(255) NOT NULL,
    Job_Level VARCHAR(50),
    Job_Category VARCHAR(50),
    Job_Grade VARCHAR(20),
    Min_Salary DECIMAL(12,2),
    Max_Salary DECIMAL(12,2),
    Job_Description TEXT,
    Status VARCHAR(50),
    Department_ID INT NOT NULL,
    Reports_To INT,
    FOREIGN KEY (Department_ID) REFERENCES DEPARTMENT(Department_ID) ON DELETE CASCADE,
    FOREIGN KEY (Reports_To) REFERENCES JOB(Job_ID) ON DELETE SET NULL
);
CREATE TABLE JOB_OBJECTIVE (
    Objective_ID INT PRIMARY KEY AUTO_INCREMENT,
    Job_ID INT NOT NULL,
    Objective_Title VARCHAR(255) NOT NULL,
    Description TEXT,
    Weight DECIMAL(5,2),
    Salary DECIMAL(12,2),
    FOREIGN KEY (Job_ID) REFERENCES JOB(Job_ID) ON DELETE CASCADE
);
CREATE TABLE OBJECTIVE_KPI (
    KPI_ID INT PRIMARY KEY AUTO_INCREMENT,
    Objective_ID INT NOT NULL,
    KPI_Name VARCHAR(255) NOT NULL,
    Description TEXT,
    Measurement_Unit VARCHAR(50),
    Target_Value DECIMAL(12,2),
    Weight DECIMAL(5,2),
    FOREIGN KEY (Objective_ID) REFERENCES JOB_OBJECTIVE(Objective_ID) ON DELETE CASCADE
);
CREATE TABLE JOB_ASSIGNMENT (
    Assignment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Employee_ID INT NOT NULL,
    Job_ID INT NOT NULL,
    Contract_ID INT NOT NULL,
    Start_Date DATE,
    End_Date DATE,
    Status VARCHAR(50),
    Assigned_Salary DECIMAL(12,2),
    FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID) ON DELETE CASCADE,
    FOREIGN KEY (Job_ID) REFERENCES JOB(Job_ID) ON DELETE CASCADE,
    FOREIGN KEY (Contract_ID) REFERENCES CONTRACT(Contract_ID) ON DELETE CASCADE
);
CREATE TABLE PERFORMANCE_CYCLE (
    Cycle_ID INT PRIMARY KEY AUTO_INCREMENT,
    Cycle_Name VARCHAR(255) NOT NULL,
    Cycle_Type VARCHAR(50),
    Start_Date DATE,
    End_Date DATE,
    Submission_Deadline DATE
);
CREATE TABLE EMPLOYEE_KPI_SCORE (
    Score_ID INT PRIMARY KEY AUTO_INCREMENT,
    Assignment_ID INT NOT NULL,
    KPI_ID INT NOT NULL,
    Performance_Cycle_ID INT NOT NULL,
    Actual_Value DECIMAL(12,2),
    Employee_Score DECIMAL(5,2),
    Weighted_Score DECIMAL(5,2),
    Reviewer_ID INT,
    Comments TEXT,
    Review_Date DATE,
    FOREIGN KEY (Assignment_ID) REFERENCES JOB_ASSIGNMENT(Assignment_ID) ON DELETE CASCADE,
    FOREIGN KEY (KPI_ID) REFERENCES OBJECTIVE_KPI(KPI_ID) ON DELETE CASCADE,
    FOREIGN KEY (Performance_Cycle_ID) REFERENCES PERFORMANCE_CYCLE(Cycle_ID) ON DELETE CASCADE,
    FOREIGN KEY (Reviewer_ID) REFERENCES EMPLOYEE(Employee_ID) ON DELETE SET NULL
);
CREATE TABLE APPRAISAL (
    Appraisal_ID INT PRIMARY KEY AUTO_INCREMENT,
    Assignment_ID INT NOT NULL,
    Cycle_ID INT NOT NULL,
    Appraisal_Date DATE,
    Overall_Score DECIMAL(5,2),
    Manager_Comments TEXT,
    HR_Comments TEXT,
    Employee_Comments TEXT,
    Reviewer_ID INT,
    FOREIGN KEY (Assignment_ID) REFERENCES JOB_ASSIGNMENT(Assignment_ID) ON DELETE CASCADE,
    FOREIGN KEY (Cycle_ID) REFERENCES PERFORMANCE_CYCLE(Cycle_ID) ON DELETE CASCADE,
    FOREIGN KEY (Reviewer_ID) REFERENCES EMPLOYEE(Employee_ID) ON DELETE SET NULL
);
CREATE TABLE APPEAL (
    Appeal_ID INT PRIMARY KEY AUTO_INCREMENT,
    Appraisal_ID INT NOT NULL,
    Submission_Date DATE,
    Reason TEXT,
    Original_Score DECIMAL(5,2),
    Approval_Status VARCHAR(50),
    appeal_outcome_Score DECIMAL(5,2),
    FOREIGN KEY (Appraisal_ID) REFERENCES APPRAISAL(Appraisal_ID) ON DELETE CASCADE
);
CREATE TABLE TRAINING_PROGRAM (
    Program_ID INT PRIMARY KEY AUTO_INCREMENT,
    Program_Code VARCHAR(50) UNIQUE,
    Title VARCHAR(255),
    Objectives TEXT,
    Type VARCHAR(50),
    Subtype VARCHAR(50),
    Delivery_Method VARCHAR(50),
    Approval_Status VARCHAR(50)
);

CREATE TABLE EMPLOYEE_TRAINING (
    ET_ID INT PRIMARY KEY AUTO_INCREMENT,
    Employee_ID INT NOT NULL,
    Program_ID INT NOT NULL,
    Completion_Status VARCHAR(50),
    FOREIGN KEY (Employee_ID) REFERENCES EMPLOYEE(Employee_ID) ON DELETE CASCADE,
    FOREIGN KEY (Program_ID) REFERENCES TRAINING_PROGRAM(Program_ID) ON DELETE CASCADE
);

CREATE TABLE TRAINING_CERTIFICATE (
    Certificate_ID INT PRIMARY KEY AUTO_INCREMENT,
    ET_ID INT NOT NULL,
    Issue_Date DATE,
    certificate_file_path VARCHAR(255),
    FOREIGN KEY (ET_ID) REFERENCES EMPLOYEE_TRAINING(ET_ID) ON DELETE CASCADE
);




INSERT INTO UNIVERSITY (University_Name, Acronym, Established_Year, Accreditation_Body, Address, Contact_Email, Website_URL)
VALUES
('German International University', 'GIU', 2002, 'FIBAA', '123 GIU Street, Cairo, Egypt', 'info@giu.edu', 'https://www.giu.edu');

INSERT INTO faculty (Faculty_ID, Faculty_Name, Location, Contact_Email, University_ID)
VALUES
(100, 'Faculty of Engineering', 'S Building', 'eng@giu.edu', 1),
(185, 'Faculty of Dentistry', 'Clinic', 'dentistry@giu.edu', 1),
(213, 'Faculty of Business Informatics', 'A Building', 'bi@giu.edu', 1),
(231, 'Faculty of Economics', 'Main Building', 'eco@giu.edu', 1),
(547, 'Faculty of Medicine', 'Hospital', 'medi@giu.edu', 1),
(551, 'Faculty of Computer Science', 'Tech Building', 'cs@giu.edu', 1),
(552, 'Faculty of Business', 'Admin Building', 'business@giu.edu', 1),
(553, 'Faculty of Arts', 'Main Campus', 'arts@giu.edu', 1);

INSERT INTO department (Department_ID, Department_Name, Department_Type, Location, Contact_Email)
VALUES
(10, 'Human Resource Dept.', 'Administrative', 'Offices', 'hr@giu.edu'),
(40, 'Admissions & Enrollment Dept.', 'Administrative', 'Admissions Office', 'admissions@giu.edu'),
(50, 'IT Services Dept.', 'Administrative', 'Main Campus', 'it@giu.edu'),
(51, 'Finance Dept.', 'Administrative', 'Finance Office', 'finance@giu.edu'),
(52, 'Admission', 'Academic', 'Admission Office', 'admission@giu.edu'),
(55, 'Test Department', 'Administrative', 'Test Office', 'test@giu.edu'),
(57, 'Artificial Intelligence', 'Academic', 'Engineering Building', 'ai@giu.edu'),
(58, 'Business Informatics', 'Academic', 'Business Informatics Building', 'bi@giu.edu'),
(59, 'Engineering', 'Academic', 'Engineering Building', 'eng@giu.edu'),
(60, 'Design', 'Academic', 'Design Studio', 'design@giu.edu'),
(62, 'Test Academic', 'Academic', 'Test Building', 'testacademic@giu.edu');

INSERT INTO academic_department (Department_ID, Faculty_ID)
VALUES
(57, 100),  -- AI → Faculty of Engineering
(58, 213),  -- Business Informatics → Faculty of Business Informatics
(59, 100),  -- Engineering → Faculty of Engineering
(60, 551),  -- Design → Faculty of Computer Science
(62, 552);  -- Test Academic → Faculty of Business

INSERT INTO administrative_department (Department_ID, University_ID)
VALUES
(10, 1),  -- HR → GIU
(40, 1),  -- Admissions & Enrollment → GIU
(50, 1),  -- IT Services → GIU
(51, 1),  -- Finance → GIU
(55, 1);  -- Test Department → GIU

INSERT INTO employee
(Employee_ID, First_Name, Middle_Name, Last_Name, Arabic_Name, Gender, Nationality, DOB, Place_of_Birth, Marital_Status, Religion, Employment_Status,
Mobile_Phone, Work_Phone, Work_Email, Personal_Email, Emergency_Contact_Name, Emergency_Contact_Phone, Emergency_Contact_Relationship,
Residential_City, Residential_Area, Residential_Street, Residential_Country, Permanent_City, Permanent_Area, Permanent_Street, Permanent_Country,
Medical_Clearance_Status, Criminal_Status)
VALUES
(1, 'Omar', 'Mahmoud', 'Saleh', 'عمر محمود صالح', 'Male', 'Egyptian', '1995-03-12', 'Cairo', 'Single', 'Muslim', 'Active',
'01000990001', '0220090009', 'omar.saleh@uni.edu', 'omar.saleh@gmail.com', 'Ahmed Saleh', '01090080088', 'Father',
'Cairo', 'Nasr City', 'Street 10', 'Egypt', 'Cairo', 'Nasr City', 'Street 10', 'Egypt', 'Cleared', 'Clean'),
(2, 'Sara', 'Ali', 'Hassan', 'سارة علي حسن', 'Female', 'Egyptian', '1998-07-25', 'Alexandria', 'Married', 'Muslim', 'Leave',
'01000986008', '0220098002', 'sara.hassan@uni.edu', 'sara.personal@gmail.com', 'Noura Ali', '01097700002', 'Mother',
'Cairo', 'Heliopolis', 'Street 5', 'Egypt', 'Alexandria', 'Smouha', 'Street 20', 'Egypt', 'Cleared', 'Clean'),
(3, 'Youssef', 'Khaled', 'Fathy', 'يوسف خالد فتحي', 'Male', 'Egyptian', '2001-01-10', 'Cairo', 'Married', 'Muslim', 'Active',
'01000000543', '0220000705', 'youssef.fathy@uni.edu', 'youssef.personal@gmail.com', 'Khaled Fathy', '01290000077', 'Father',
'Giza', 'Dokki', 'Street 3', 'Egypt', 'Giza', 'Mohandessin', 'Street 7', 'Egypt', 'Cleared', 'Clean');
INSERT INTO employee
(Employee_ID, First_Name, Middle_Name, Last_Name, Arabic_Name, Gender, Nationality, DOB, Place_of_Birth, Marital_Status, Religion, Employment_Status,
Mobile_Phone, Work_Phone, Work_Email, Personal_Email, Emergency_Contact_Name, Emergency_Contact_Phone, Emergency_Contact_Relationship,
Residential_City, Residential_Area, Residential_Street, Residential_Country, Permanent_City, Permanent_Area, Permanent_Street, Permanent_Country,
Medical_Clearance_Status, Criminal_Status)
VALUES
(4, 'Mariam', 'Adel', 'Nabil', 'مريم عادل نبيل', 'Female', 'Egyptian', '1997-11-02', 'Giza', 'Single', 'Christian', 'On Probation',
 '01100008765', '0220000435', 'mariam.nabil@uni.edu', 'mariam.personal@gmail.com', 'Adel Nabil', '01190090004', 'Father',
 'Giza', 'Haram', 'Street 15', 'Egypt', 'Giza', 'Haram', 'Street 15', 'Egypt', 'Cleared', 'Clean'),
(5, 'Karim', 'Samir', 'Ibrahim', 'كريم سمير إبراهيم', 'Male', 'Egyptian', '1985-09-18', 'Tanta', 'Married', 'Muslim', 'Retired',
 '01007200015', '0220640000', 'karim.ibrahim@uni.edu', 'karim.personal@gmail.com', 'Samir Ibrahim', '01269000000', 'Father',
 'Cairo', 'Maadi', 'Street 8', 'Egypt', 'Tanta', 'Downtown', 'Street 4', 'Egypt', 'Cleared', 'Clean'),
(6, 'Zeina', 'Fahim', '', 'زينه فهيم', 'Female', 'Egyptian', '1990-05-10', 'Cairo', 'Single', 'Muslim', 'Active',
 '01233366549', '', 'zeina.fahim@uni.edu', 'zeinafahim@gmail.com', 'N/A', '00000000000', 'N/A',
 'Cairo', 'Nasr City', 'Street 11', 'Egypt', 'Cairo', 'Nasr City', 'Street 11', 'Egypt', 'Cleared', 'Clean'),
(7, 'Omar', 'Hassan', 'Ali', 'عمر حسن علي', 'Male', 'Egyptian', '1990-01-10', 'Cairo', 'Married', 'Muslim', 'Active',
 '01000010001', '0220001001', 'omar1@uni.edu', 'omar1@gmail.com', 'Hassan Ali', '01000020001', 'Father',
 'Cairo', 'Nasr City', 'Street 1', 'Egypt', 'Cairo', 'Nasr City', 'Street 1', 'Egypt', 'Cleared', 'Clean'),
(8, 'Sara', 'Khaled', 'Mohamed', 'سارة خالد محمد', 'Female', 'Egyptian', '1992-02-20', 'Alexandria', 'Single', 'Muslim', 'Active',
 '01000010002', '0220001002', 'sara1@uni.edu', 'sara1@gmail.com', 'Khaled Mohamed', '01000020002', 'Father',
 'Alexandria', 'Smouha', 'Street 2', 'Egypt', 'Alexandria', 'Smouha', 'Street 2', 'Egypt', 'Cleared', 'Clean'),
(9, 'Amr', 'Omar', 'Fathy', 'عمرو عمر فتحي', 'Male', 'Egyptian', '1991-03-15', 'Giza', 'Married', 'Muslim', 'Active',
 '01000010003', '0220001003', 'amr1@uni.edu', 'amr1@gmail.com', 'Omar Fathy', '01000020003', 'Father',
 'Giza', 'Dokki', 'Street 3', 'Egypt', 'Giza', 'Dokki', 'Street 3', 'Egypt', 'Cleared', 'Clean'),
(10, 'Laila', 'Mona', 'Hassan', 'ليلى منى حسن', 'Female', 'Egyptian', '1993-04-12', 'Cairo', 'Single', 'Muslim', 'Active',
 '01000010004', '0220001004', 'laila1@uni.edu', 'laila1@gmail.com', 'Mona Hassan', '01000020004', 'Mother',
 'Cairo', 'Heliopolis', 'Street 4', 'Egypt', 'Cairo', 'Heliopolis', 'Street 4', 'Egypt', 'Cleared', 'Clean'),
(11, 'Khaled', 'Ali', 'Samir', 'خالد علي سمير', 'Male', 'Egyptian', '1990-05-05', 'Cairo', 'Married', 'Muslim', 'Active',
 '01000010005', '0220001005', 'khaled1@uni.edu', 'khaled1@gmail.com', 'Ali Samir', '01000020005', 'Father',
 'Cairo', 'Maadi', 'Street 5', 'Egypt', 'Cairo', 'Maadi', 'Street 5', 'Egypt', 'Cleared', 'Clean'),
(12, 'Noha', 'Mahmoud', 'Fawzy', 'نهى محمود فوزي', 'Female', 'Egyptian', '1995-06-10', 'Cairo', 'Single', 'Muslim', 'Active',
 '01000011001', '0220001101', 'noha.fawzy@uni.edu', 'noha.personal@gmail.com', 'Mahmoud Fawzy', '01000021001', 'Father',
 'Cairo', 'Maadi', 'Street 6', 'Egypt', 'Cairo', 'Maadi', 'Street 6', 'Egypt', 'Cleared', 'Clean'),
(13, 'Hassan', 'Adel', 'Ragab', 'حسن عادل رجب', 'Male', 'Egyptian', '1988-12-22', 'Alexandria', 'Married', 'Muslim', 'Active',
 '01000011002', '0220001102', 'hassan.ragab@uni.edu', 'hassan.personal@gmail.com', 'Adel Ragab', '01000021002', 'Father',
 'Alexandria', 'Smouha', 'Street 6', 'Egypt', 'Alexandria', 'Smouha', 'Street 6', 'Egypt', 'Cleared', 'Clean'),
(14, 'Aya', 'Fahmy', 'Sami', 'آية فهمي سامي', 'Female', 'Egyptian', '1996-09-18', 'Cairo', 'Single', 'Muslim', 'Active',
 '01000011003', '0220001103', 'aya.sami@uni.edu', 'aya.personal@gmail.com', 'Fahmy Sami', '01000021003', 'Father',
 'Cairo', 'Nasr City', 'Street 12', 'Egypt', 'Cairo', 'Nasr City', 'Street 12', 'Egypt', 'Cleared', 'Clean'),
(15, 'Tamer', 'Mohamed', 'Mostafa', 'تامر محمد مصطفى', 'Male', 'Egyptian', '1989-11-11', 'Giza', 'Married', 'Muslim', 'Active',
 '01000011004', '0220001104', 'tamer.mostafa@uni.edu', 'tamer.personal@gmail.com', 'Mohamed Mostafa', '01000021004', 'Father',
 'Giza', 'Dokki', 'Street 8', 'Egypt', 'Giza', 'Dokki', 'Street 8', 'Egypt', 'Cleared', 'Clean');

INSERT INTO contract (Contract_ID, Contract_Name, Type, Description, Default_Duration, Work_Modality, Eligibility_Criteria)
VALUES
(2000, 'Full-Time Standard', 'Full-Time', 'Standard full-time contract', 12, 'On-site', 'Eligible for all staff'),
(2001, 'Full-Time Extended', 'Full-Time', 'Full-time contract with extended benefits', 24, 'On-site', 'Eligible for senior staff'),
(2002, 'Part-Time', 'Part-Time', 'Part-time contract', 12, 'Remote/On-site', 'Eligible for part-time staff'),
(2003, 'Internship', 'Internship', 'Internship contract', 6, 'On-site', 'Eligible for interns'),
(2004, 'Temporary', 'Temporary', 'Temporary contract', 3, 'On-site', 'Eligible for temp staff');

INSERT INTO job (Job_ID, Job_Code, Job_Title, Job_Level, Job_Category, Job_Grade, Min_Salary, Max_Salary, Job_Description, Status, Department_ID, Reports_To)
VALUES
(500, 'ENG001', 'Software Engineer', 'Level 1', 'Engineering', 'G1', 12000, 25000, 'Develops software', 'Active', 57, NULL),
(501, 'ENG002', 'Senior Software Engineer', 'Level 2', 'Engineering', 'G2', 20000, 35000, 'Leads development', 'Active', 57, 500),
(502, 'DS001', 'Designer', 'Level 1', 'Design', 'G1', 10000, 20000, 'Creates designs', 'Active', 60, NULL),
(503, 'HR001', 'HR Specialist', 'Level 1', 'HR', 'G1', 9000, 15000, 'Manages HR tasks', 'Active', 52, NULL),
(504, 'FIN001', 'Finance Analyst', 'Level 1', 'Finance', 'G1', 10000, 18000, 'Handles finance', 'Active', 51, NULL);

INSERT INTO job_assignment (Assignment_ID, Employee_ID, Job_ID, Contract_ID, Start_Date, End_Date, Status, Assigned_Salary)
VALUES
(601, 1, 500, 2000, '2025-01-01', NULL, 'Active', 15000),
(602, 2, 501, 2001, '2025-02-01', NULL, 'Active', 18000),
(603, 3, 502, 2002, '2025-03-01', NULL, 'Active', 13000),
(604, 4, 503, 2003, '2025-04-01', NULL, 'Active', 14000),
(605, 5, 504, 2004, '2025-05-01', NULL, 'Active', 15000),
(606, 6, 500, 2000, '2025-06-01', NULL, 'Active', 16000),
(607, 7, 501, 2001, '2025-07-01', NULL, 'Active', 19000),
(608, 8, 502, 2002, '2025-08-01', NULL, 'Active', 13500),
(609, 9, 503, 2003, '2025-09-01', NULL, 'Active', 14500),
(610, 10, 504, 2004, '2025-10-01', NULL, 'Active', 15500),
(611, 11, 500, 2000, '2025-01-15', NULL, 'Active', 17000),
(612, 12, 501, 2001, '2025-02-15', NULL, 'Active', 18500),
(613, 13, 502, 2002, '2025-03-15', NULL, 'Active', 14000),
(614, 14, 503, 2003, '2025-04-15', NULL, 'Active', 15000),
(615, 15, 504, 2004, '2025-05-15', NULL, 'Active', 16000);

INSERT INTO job_objective (Objective_ID, Job_ID, Objective_Title, Description, Weight, Salary)
VALUES
(1001, 500, 'Develop Core Modules', 'Develop and maintain core software modules', 50, 15000),
(1002, 501, 'Lead Team Projects', 'Manage software projects and teams', 60, 20000),
(1003, 502, 'Design UI/UX', 'Create designs for products', 50, 13000),
(1004, 503, 'Recruitment & HR', 'Manage recruitment and HR tasks', 50, 12000),
(1005, 504, 'Financial Reporting', 'Handle reports and budgeting', 50, 14000);

INSERT INTO objective_kpi (KPI_ID, Objective_ID, KPI_Name, Description, Measurement_Unit, Target_Value, Weight)
VALUES
(13001, 1001, 'File Accuracy', 'Accuracy of code/files', '%', 95, 30),
(13002, 1001, 'Feature Delivery', 'Features delivered on time', 'Count', 10, 30),
(13003, 1002, 'Code Reviews', 'Completed code reviews', 'Count', 20, 20),
(13004, 1003, 'Report Timeliness', 'Reports submitted on time', '%', 100, 10),
(13005, 1004, 'Strategic Milestones', 'HR milestones achieved', '%', 100, 10),
(13006, 1005, 'Bug Fix Rate', 'Number of bugs fixed', 'Count', 50, 20);

INSERT INTO performance_cycle (Cycle_ID, Cycle_Name, Cycle_Type, Start_Date, End_Date, Submission_Deadline)
VALUES
(1, 'Mid-Year 2025', 'Semi-Annual', '2025-01-01', '2025-06-30', '2025-07-05'),
(2, 'End-Year 2025', 'Annual', '2025-07-01', '2025-12-31', '2026-01-05'),
(3, 'Quarter 1 2025', 'Quarterly', '2025-01-01', '2025-03-31', '2025-04-05'),
(4, 'Quarter 2 2025', 'Quarterly', '2025-04-01', '2025-06-30', '2025-07-05'),
(5, 'Quarter 3 2025', 'Quarterly', '2025-07-01', '2025-09-30', '2025-10-05');




INSERT INTO employee_kpi_score (Score_ID, Assignment_ID, KPI_ID, Performance_Cycle_ID, Actual_Value, Employee_Score, Weighted_Score, Reviewer_ID, Comments, Review_Date)
VALUES
(1, 601, 13001, 1, 96, 4.8, 4.6, 1, 'Excellent', '2025-06-15'),
(2, 601, 13002, 1, 9, 4.5, 4.3, 1, 'Good delivery', '2025-06-15'),
(3, 602, 13003, 1, 18, 4.2, 4.0, 2, 'Solid code reviews', '2025-06-15'),
(4, 602, 13004, 1, 100, 4.9, 4.7, 2, 'Timely reports', '2025-06-15'),
(5, 603, 13005, 1, 95, 4.7, 4.5, 3, 'HR tasks done', '2025-06-15'),
(6, 603, 13006, 1, 45, 4.3, 4.1, 3, 'Bug fixes good', '2025-06-15'),
(7, 604, 13001, 1, 94, 4.6, 4.4, 4, 'Strong work', '2025-06-15'),
(8, 605, 13002, 1, 8, 4.4, 4.2, 5, 'Feature delivery ok', '2025-06-15'),
(9, 606, 13003, 1, 19, 4.7, 4.5, 6, 'Great code reviews', '2025-06-15'),
(10, 607, 13004, 1, 100, 4.8, 4.6, 7, 'Reports timely', '2025-06-15');

INSERT INTO employee_kpi_score 
(Assignment_ID, KPI_ID, Performance_Cycle_ID, Actual_Value, Employee_Score, Weighted_Score, Reviewer_ID, Comments, Review_Date)
VALUES 
(608, 13005, 1, 92, 4.5, 4.3, 9, 'Good coordination', '2025-06-15'),
(609, 13006, 1, 50, 4.6, 4.4, 10, 'Solid work', '2025-06-15'),
(610, 13001, 1, 97, 4.9, 4.7, 11, 'Excellent delivery', '2025-06-15'),
(611, 13002, 1, 10, 4.8, 4.6, 12, 'Well done', '2025-06-15'),
(612, 13003, 1, 20, 4.7, 4.5, 13, 'Strong reviews', '2025-06-15');

INSERT INTO TRAINING_PROGRAM (Program_Code, Title, Objectives, Type, Subtype, Delivery_Method, Approval_Status)
VALUES
('TP101', 'Leadership Essentials', 'Develop leadership skills', 'Professional', 'Soft Skills', 'Online', 'Approved'),
('TP102', 'Advanced Python', 'Improve Python programming', 'Technical', 'Programming', 'In-Person', 'Approved'),
('TP103', 'Project Management', 'Manage projects effectively', 'Professional', 'Management', 'Online', 'Pending'),
('TP104', 'Data Analytics', 'Learn data analysis techniques', 'Technical', 'Analytics', 'Online', 'Approved'),
('TP105', 'Communication Skills', 'Enhance communication', 'Professional', 'Soft Skills', 'In-Person', 'Approved');

INSERT INTO EMPLOYEE_TRAINING (Employee_ID, Program_ID, Completion_Status)
VALUES
(1, 1, 'Completed'),
(2, 2, 'In Progress'),
(3, 3, 'Completed'),
(4, 1, 'Completed'),
(5, 2, 'In Progress'),
(6, 4, 'Completed'),
(7, 5, 'Completed'),
(8, 3, 'Pending'),
(9, 4, 'Completed'),
(10, 1, 'Completed'),
(11, 2, 'In Progress'),
(12, 5, 'Completed'),
(13, 4, 'Completed'),
(14, 3, 'Pending'),
(15, 5, 'Completed');

INSERT INTO TRAINING_CERTIFICATE (ET_ID, Issue_Date, certificate_file_path)
VALUES
(1, '2025-06-01', '/certificates/1.pdf'),
(3, '2025-06-05', '/certificates/3.pdf'),
(4, '2025-06-10', '/certificates/4.pdf'),
(6, '2025-06-15', '/certificates/6.pdf'),
(7, '2025-06-20', '/certificates/7.pdf'),
(9, '2025-06-25', '/certificates/9.pdf'),
(10, '2025-06-30', '/certificates/10.pdf'),
(12, '2025-07-05', '/certificates/12.pdf'),
(13, '2025-07-10', '/certificates/13.pdf'),
(15, '2025-07-15', '/certificates/15.pdf');

INSERT INTO APPRAISAL (Assignment_ID, Cycle_ID, Appraisal_Date, Overall_Score, Manager_Comments, HR_Comments, Employee_Comments, Reviewer_ID)
VALUES
(601, 1, '2025-06-15', 4.8, 'Excellent work', 'HR ok', 'Very satisfied', 1),
(602, 1, '2025-06-16', 4.5, 'Strong performance', 'HR reviewed', 'Happy', 2),
(603, 1, '2025-06-17', 4.6, 'Reliable', 'HR ok', 'Satisfied', 3),
(604, 1, '2025-06-18', 4.2, 'Good progress', 'HR ok', 'Content', 4),
(605, 1, '2025-06-19', 4.7, 'Outstanding', 'HR reviewed', 'Very pleased', 5);

INSERT INTO APPRAISAL (Assignment_ID, Cycle_ID, Appraisal_Date, Overall_Score, Manager_Comments, HR_Comments, Employee_Comments, Reviewer_ID)
VALUES
(606, 1, '2025-06-20', 4.5, 'Strong work', 'HR ok', 'Satisfied', 7),
(607, 1, '2025-06-21', 4.6, 'Reliable', 'HR reviewed', 'Happy', 8),
(608, 1, '2025-06-22', 4.4, 'Good coordination', 'HR ok', 'Content', 9),
(609, 1, '2025-06-23', 4.3, 'Solid delivery', 'HR ok', 'Satisfied', 10),
(610, 1, '2025-06-24', 4.7, 'Excellent', 'HR reviewed', 'Very pleased', 11),
(611, 1, '2025-06-25', 4.6, 'Strong', 'HR ok', 'Happy', 12),
(612, 1, '2025-06-26', 4.5, 'Reliable', 'HR reviewed', 'Content', 13),
(613, 1, '2025-06-27', 4.8, 'Outstanding', 'HR ok', 'Very satisfied', 14),
(614, 1, '2025-06-28', 4.6, 'Good work', 'HR reviewed', 'Happy', 15),
(615, 1, '2025-06-29', 4.7, 'Excellent', 'HR ok', 'Very pleased', 1);

INSERT INTO APPEAL (Appraisal_ID, Submission_Date, Reason, Original_Score, Approval_Status, appeal_outcome_Score)
VALUES
(1, '2025-06-20', 'Request for score review', 4.8, 'Approved', 4.9),
(3, '2025-06-21', 'Discrepancy in performance', 4.6, 'Pending', 4.6);

INSERT INTO APPEAL (Appraisal_ID, Submission_Date, Reason, Original_Score, Approval_Status, appeal_outcome_Score)
VALUES
(7, '2025-06-25', 'Request reevaluation', 4.6, 'Approved', 4.7);





