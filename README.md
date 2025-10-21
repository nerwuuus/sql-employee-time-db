 # ess Database Project

This portfolio project showcases a comprehensive database solution designed for analytics, from structured data modelling to generating actionable insights. It follows industry best practices in data engineering, including the use of the Medallion architecture and star schema design.
<br>**Due to the presence of personal data, raw datasets are not available for external use.**

---
## 🏗️ Data Architecture

The data architecture for this project follows Medallion Architecture **Bronze**, **Silver**, and **Gold** layers:
<img width="971" height="586" alt="HLD Architecture" src="https://github.com/user-attachments/assets/9619ff89-3da0-46c9-9bf1-1b66ba1c434a" />
<br>
Data Flow:
<img width="999" height="491" alt="Data Flow Diagram" src="https://github.com/user-attachments/assets/fb92e0b9-17ae-43ac-9c68-fb5d19f279d7" />

<br>
1.**Bronze Layer**: Stores raw data from the source systems. Data is loaded from .csv files into a PostgreSQL database using the '/copy' command in pgAdmin4 or running the Python script.<br>
2.**Silver Layer**: This layer includes data cleansing, standardisation, and normalisation processes to prepare data for analysis.<br>
3.**Gold Layer**: Contains business-ready data structured in a star schema to support reporting and analytics.<br>

---
## 📖 Project Overview

This project involves:

1. **Data Architecture**: Designing a modern database architecture based on the Medallion model, incorporating **Bronze**, **Silver**, and **Gold** layers.<br>
2. **ETL Pipelines**: Extracting, transforming, and loading data from source systems into a centralised database for analysis and reporting.<br>
3. **Data Modelling**: Developing fact and dimension tables designed for efficient analytical querying within a star schema.<br>
4. **Analytics & Reporting**: Creating SQL-based reports and dashboards to deliver actionable business insights.

---


## 🚀 Project Requirements

### Building the database (Data Engineering)

#### Objective
Develop a modern PostgreSQL database to consolidate employee time bookings from SAP and workforce data, enabling analytical reporting and informed decision-making.

#### Specifications
- **Data Sources**: Import data from two source systems (SAP and WFM database), provided as .csv files.
- **Data Quality**: Cleanse and resolve data quality issues before analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: The solution must retain both current (from the last month) and past data to support tracking changes over time.
- **Documentation**: Provide clear documentation of the data model.

---

## 📂 Repository Structure
```
sql-employee-time-db/
│
├── docs/                               # Project documentation and architecture details
│   ├── data_architecture.drawio        # Draw.io file shows the project's architecture
│   ├── data_flow.drawio                # Draw.io file for the data flow diagram
│   ├── data_model.drawio               # Draw.io file for data model (star schema)
│   ├── naming_convention.md            # Naming guideline
│   ├── data_catalog.md                 # Catalog of datasets
│
├── scripts/                            # SQL scripts for ETL and transformations
│   ├── bronze/                         # Scripts for extracting and loading raw data
│   ├── silver/                         # Scripts for cleaning and transforming data
│   ├── gold/                           # Scripts for creating analytical models
│
├── tests/                              # Test scripts and quality files
│
├── README.md                           # Project overview and instructions

```
---
