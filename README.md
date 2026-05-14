  # **HRMS Database System**

This repository contains the design and implementation of a comprehensive Human Resource Management System (HRMS) database. The platform integrates employee records, performance evaluations, and professional development into a unified system designed to enhance workforce transparency, data accuracy, and organizational efficiency.

**Project Architecture**
The system was developed across four key milestones, moving from conceptual design to a fully functional automated database.

**Milestone 1: Conceptual & Logical Design**
We focused on structuring the foundational data architecture to ensure data integrity and minimize redundancy.

ER Diagram (ERD): Defined entities including Employees, Job Assignments, Contracts, Appraisals, and Training Programs.

Relational Model: Mapped the ERD into a normalized relational schema, identifying all attributes and relationships.

**Milestone 2: Schema Implementation**
The physical database was built using SQL, establishing a rigid structure for data storage.

DDL Scripts: Created schemas and tables.

Integrity Constraints: Implemented Primary Keys and Foreign Keys to maintain referential integrity.

Contract Management: Structured tables to handle demographic data and varying contract types.

**Milestone 3: Advanced Business Logic & Automation**
To ensure the system adheres to real-world business rules, we implemented programmable objects:

Triggers: Developed to automate calculated fields and audit changes.

Check Constraints: Enforced critical business rules, such as:

Ensuring KPI weights always total exactly 100%.

Preventing invalid date entries (e.g., end dates before start dates).

Automation: Set up logic to handle status updates and performance score calculations automatically.

**Milestone 4: Data Visualization**
The final phase involved designing a Dashboard to transform raw data into actionable insights, allowing management to track workforce distribution and training progress at a glance.

**Key Features**
Unified Employee Profiles: Centralized demographic and job assignment tracking.

Structured Performance Management: Integrated appraisal system using objective-based KPIs.

Training & Development: Comprehensive tracking of core training programs and employee skill progression.

Data Consistency: Robust constraints and triggers prevent human error and ensure "Single Source of Truth" reporting.

**Tech Stack**
Database: SQL (MySQL)

Modeling: ERD Design Tools

Visualization: Dashboard Design (Power BI)


