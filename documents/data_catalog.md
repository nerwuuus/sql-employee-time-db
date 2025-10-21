# Data Catalog for Gold Layer

## Overview
The Gold Layer is the business-level data representation, structured to support analytical and reporting use cases. It consists of **dimension tables** and **fact tables** for specific business metrics.

---

### 1. **gold.dim_wbs**
- **Purpose:** Stores WBS number, description and flag.
- **Columns:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| wbs              | VARCHAR(50)   | Surrogate key uniquely identifying each WBS record in the dimension table.                    |
| wbs_description  | VARCHAR(255)  | WBS text description.                                                                         |
| wbs_flag         | VARCHAR(50)   | Subcontract identifier: MNP, iNM and BIP.                                                     |

---

### 2. **gold.fact_current_year**
- **Purpose:** Contains detailed records of product-related attributes including time registration, contract details, rates, and employee competencies for the current year.
- **Columns:**

| Column Name            | Data Type               | Description                                                                                   |
|------------------------|-------------------------|-----------------------------------------------------------------------------------------------|
| name                   | VARCHAR(255)            | The employee's full name (first and last name), as recorded in the system.                    |
| nessie                 | INTEGER                 | Internal identifier or reference number for the employee.                                     |
| time_registration_date | DATE                    | The date when the time entry was registered.                                                  |
| status                 | VARCHAR(255)            | Current status of the time entry (e.g., active, pending).                                     |
| wbs                    | VARCHAR(255)            | Work Breakdown Structure code used for project tracking.                                      |
| wbs_description        | VARCHAR(255)            | Description of the WBS code.                                                                  |
| hours                  | NUMERIC                 | Number of hours worked or allocated.                                                          |
| contract               | VARCHAR(50)             | Contract type or identifier associated with the employee.                                     |
| gcm_level              | VARCHAR(50)             | Global Career Model level or classification.                                                  |
| hourly_rate            | NUMERIC                 | Hourly compensation rate.                                                                     |
| daily_rate             | NUMERIC                 | Daily compensation rate.                                                                      |
| competence             | VARCHAR(50)             | Skill or competence area of the employee.                                                     |
| active_flag            | VARCHAR(50)             | Flag indicating whether the record is active.                                                 |  
---
---

### 3. **gold.fact_last_month**
- **Purpose:** Stores product-related data and employee time registration details specific to the previous month, including contract information, rates, and competencies.
- **Columns:**

| Column Name            | Data Type               | Description                                                                                   |
|------------------------|-------------------------|-----------------------------------------------------------------------------------------------|
| name                   | VARCHAR(255)            | The employee's full name (first and last name), as recorded in the system.                    |
| nessie                 | INTEGER                 | Internal identifier or reference number for the employee.                                     |
| time_registration_date | DATE                    | The date when the time entry was registered.                                                  |
| status                 | VARCHAR(255)            | Current status of the time entry (e.g., active, pending).                                     |
| wbs                    | VARCHAR(255)            | Work Breakdown Structure code used for project tracking.                                      |
| wbs_description        | VARCHAR(255)            | Description of the WBS code.                                                                  |
| hours                  | NUMERIC                 | Number of hours worked or allocated.                                                          |
| contract               | VARCHAR(50)             | Contract type or identifier associated with the employee.                                     |
| gcm_level              | VARCHAR(50)             | Global Career Model level or classification.                                                  |
| hourly_rate            | NUMERIC                 | Hourly compensation rate.                                                                     |
| daily_rate             | NUMERIC                 | Daily compensation rate.                                                                      |
| competence             | VARCHAR(50)             | Skill or competence area of the employee.                                                     |
| active_flag            | VARCHAR(50)             | Flag indicating whether the record is active.                                                 |  
---
---

### 4. **gold.fact_time_all**
- **Purpose:** Aggregates comprehensive time registration data across all periods, including employee details, WBS codes, contract types, rates, and competencies.
- **Columns:**

| Column Name            | Data Type               | Description                                                                                   |
|------------------------|-------------------------|-----------------------------------------------------------------------------------------------|
| name                   | VARCHAR(255)            | The employee's full name (first and last name), as recorded in the system.                    |
| nessie                 | INTEGER                 | Internal identifier or reference number for the employee.                                     |
| time_registration_date | DATE                    | The date when the time entry was registered.                                                  |
| status                 | VARCHAR(255)            | Current status of the time entry (e.g., active, pending).                                     |
| wbs                    | VARCHAR(255)            | Work Breakdown Structure code used for project tracking.                                      |
| wbs_description        | VARCHAR(255)            | Description of the WBS code.                                                                  |
| hours                  | NUMERIC                 | Number of hours worked or allocated.                                                          |
| contract               | VARCHAR(50)             | Contract type or identifier associated with the employee.                                     |
| gcm_level              | VARCHAR(50)             | Global Career Model level or classification.                                                  |
| hourly_rate            | NUMERIC                 | Hourly compensation rate.                                                                     |
| daily_rate             | NUMERIC                 | Daily compensation rate.                                                                      |
| competence             | VARCHAR(50)             | Skill or competence area of the employee.                                                     |
| active_flag            | VARCHAR(50)             | Flag indicating whether the record is active.                                                 |  
---
