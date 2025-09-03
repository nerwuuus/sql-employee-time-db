# Data Catalog - Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

---

### 1. **gold.dim_employees**
- **Purpose:** Stores key employee attributes such as ID, name, seniority, hourly rate, and competence for reporting and analysis.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| id               | INT           | Primary key uniquely identifying each employee record.                                         |
| name             | VARCHAR(255)  | The employees's full name (first and last name), as recorded in the system.                    |
| seniority        | VARCHAR(50)  | Represents an employee's level or rank within the organization.                               |
| hourly_rate      | NUMERIC(6,2)  | Specifies the employee's compensation per hour of work.                              |
| competence       | VARCHAR(255)  | Indicates an employee’s area of expertise.                                  |


---

### 2. **gold.fact_employees_hours**
- **Purpose:** Captures detailed employee work hour records, including project assignments, approved hours, and related attributes for reporting and analysis.
- **Columns:**

| Column Name         | Data Type     | Description                                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| id               | INT           | Primary key uniquely identifying each employee record.                                       |
| name             | VARCHAR(255)  | The employees's full name (first and last name), as recorded in the system.                    |
| work_date        | DATE          | Date of the recorded work activity.                    |
| wbs              | VARCHAR(255)  | Work Breakdown Structure code identifying the project or task.                   |
| daily_approved_hours             | NUMERIC(4,2)  | Number of work hours approved for a single day.                   |
| total_approved_hours             | NUMERIC(6,2)  | Cumulative approved work hours over a given period.                    |
| seniority        | VARCHAR(50)  | Represents an employee's level or rank within the organization.                               |
| hourly_rate      | NUMERIC(6,2)  | Specifies the employee's compensation per hour of work.                              |
| competence       | VARCHAR(255)  | Indicates an employee’s area of expertise.                                  |
---

### 3. **gold.fact_recent_approved_hours**
- **Purpose:** Stores the most recent approved work hour records for employees, including project codes and work dates, for reporting and tracking purposes.
- **Columns:**

| Column Name     | Data Type     | Description                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| id               | INT           | Primary key uniquely identifying each employee record.                                       |
| name             | VARCHAR(255)  | The employees's full name (first and last name), as recorded in the system.                    |
| work_date        | DATE          | Date of the recorded work activity.                    |
| wbs              | VARCHAR(255)  | Work Breakdown Structure code identifying the project or task.                   |
| daily_approved_hours             | NUMERIC(4,2)  | Number of work hours approved for a single day.                   |
| total_approved_hours             | NUMERIC(6,2)  | Cumulative approved work hours over a given period.                    |


---

### 4. **gold.fact_time_all**
- **Purpose:** Tracks all recorded employee work hours, including status and project details, for comprehensive time reporting.
- **Columns:**

| Column Name     | Data Type     | Description                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| id               | INT           | Primary key uniquely identifying each employee record.                                       |
| name             | VARCHAR(255)  | The employees's full name (first and last name), as recorded in the system.                    |
| work_date        | DATE          | Date of the recorded work activity.                    |
| status           | VARCHAR(255)  | Indicates the current state of a record, such as 'Approved' or 'Rejected'.                  |
| wbs              | VARCHAR(255)  | Work Breakdown Structure code identifying the project or task.                   |
| wbs_description  | VARCHAR(255)  | Provides a textual description of the project or task associated with the Work Breakdown Structure (WBS) code.                              |
| hours      | NUMERIC(6,2)  | Captures all work hours (including 'Rejected') for each employee record.                              |

