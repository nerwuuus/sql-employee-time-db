/*
============================================================================
DDL Script: Create Bronze Tables
============================================================================
Script Purpose:
  This script creates tables in the 'bronze' schema, dropping existing tables
  if they already exist.
Run this script to redefine the DDL structure of 'bronze' Tables
============================================================================
*/
DROP TABLE IF EXISTS bronze.sap_ess;
CREATE TABLE bronze.sap_ess (
    name VARCHAR(255),
    nessie INT,
    time_registration_date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4, 2)
);

DROP TABLE IF EXISTS bronze.wfm_employees;
CREATE TABLE bronze.wfm_employees (
    nessie INT,
    employment_type VARCHAR(50),
    country VARCHAR(50),
    name VARCHAR(50),
    contract VARCHAR(50),
    gcm_level INT,
    hourly_rate NUMERIC(5,2),
    competence VARCHAR(255),
    daily_rate NUMERIC(6,2),
    active_flag INT
);

DROP TABLE IF EXISTS bronze.sap_wbs;
CREATE TABLE bronze.sap_wbs (
    wbs VARCHAR(50),
    wbs_description VARCHAR(255)
);
