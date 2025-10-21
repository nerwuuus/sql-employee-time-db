/*
============================================================================
DDL Script: Create Silver Tables
============================================================================
Script Purpose:
  This script creates tables in the 'silver' schema, dropping existing tables
  if they already exist.
Run this script to redefine the DDL structure of 'silver' Tables.
============================================================================
*/
DROP TABLE IF EXISTS silver.sap_ess;
CREATE TABLE silver.sap_ess (
    name VARCHAR(255),
    nessie INT,
    time_registration_date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2),
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

DROP TABLE IF EXISTS silver.wfm_employees;
CREATE TABLE silver.wfm_employees (
    nessie INT,
    employment_type VARCHAR(50),
    country VARCHAR(50),
    name VARCHAR(50),
    contract VARCHAR(50),
    gcm_level VARCHAR(50),
    hourly_rate NUMERIC(5,2),
    competence VARCHAR(255),
    daily_rate NUMERIC(6,2),
    active_flag VARCHAR(50),
    insert_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver.sap_wbs;
CREATE TABLE silver.sap_wbs (
    wbs VARCHAR(50),
    wbs_description VARCHAR(255),
    wbs_flag VARCHAR(50)
);
