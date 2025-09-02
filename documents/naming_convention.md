# **Naming Convention**

This document outlines the naming conventions used for schemas, tables, views, columns, and other objects in the 'ess' database.

## **Table of Contents**

1. [General Principles](#general-principles)
2. [Table Naming Conventions](#table-naming-conventions)
   - [Bronze Rules](#bronze-rules)
   - [Silver Rules](#silver-rules)
   - [Gold Rules](#gold-rules)
3. [Column Naming Conventions](#column-naming-conventions)
   - [Technical Columns](#technical-columns)
4. [Stored Procedure](#stored-procedure-naming-conventions)
---

## **General Principles**

- **Naming Convention**: Use snake_case, with lowercase letters and underscores (`_`) to separate words.
- **Language**: Use English language.
- **Avoid Reserved Words**: Do not use SQL reserved words as object names.

## **Table Naming Convention**

### **Bronze Rules**
- All names must start with the source system name, and table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**  
  - `<sourcesystem>`: Name of the source system (e.g., `sap`).  
  - `<entity>`: Exact table name from the source system.  
  - Example: `sap_mnp` → Time booking information from the SAP system.

### **Silver Rules**
- All names must start with the source system name, and table names must match their original names without renaming.
- **`<sourcesystem>_<entity>`**  
  - `<sourcesystem>`: Name of the source system (e.g., `sap`). 
  - `<entity>`: Exact table name from the source system.  
  - Example: `sap_mnp` → Time booking information from the SAP system.

### **Gold Rules**
- All names must use meaningful, business-aligned names for tables, starting with the category prefix.
- **`<category>_<entity>`**  
  - `<category>`: Describes the role of the table, such as `dim` (dimension) or `fact` (fact table).  
  - `<entity>`: Descriptive name of the table, aligned with the business domain (e.g., `time`, `recent_approved_hours`, `employees`).  
  - Examples:
    - `dim_employees` → Dimension table for employee data.  
    - `fact_time_all` → Fact table containing all employee time transactions.  

#### **Glossary of Category Patterns**

| Pattern     | Meaning                           | Example(s)                              |
|-------------|-----------------------------------|-----------------------------------------|
| `dim_`      | Dimension table                  | `dim_employees`          |
| `fact_`     | Fact table                       | `fact_time_all`                            |
| `report_`   | Report table                     | N/A  |

## **Column Naming Conventions**

### **Technical Columns**
- All technical columns must start with the prefix `ess_`, followed by a descriptive name indicating the column's purpose.
- **`ess_<column_name>`**  
  - `ess`: Prefix exclusively used for system-generated metadata.  
  - `<column_name>`: Descriptive name indicating the column's purpose.  
  - Example: `ess_create_date` → A system-generated column that records the timestamp when each record was loaded into the database.
 
## **Stored Procedures**

- All stored procedures used for loading data must follow the naming pattern:
- **`<layer>.load_<layer>`**.
  
  - `<layer>`: Represents the layer being loaded, such as `bronze`, `silver`, or `gold`.
  - Example: 
    - `bronze.load_bronze` → Stored procedure for loading data into the Bronze layer.
    - `silver.load_silver` → Stored procedure for loading data into the Silver layer.
