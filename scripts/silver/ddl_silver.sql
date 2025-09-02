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

DROP TABLE IF EXISTS silver.ess_mnp;
CREATE TABLE silver.ess_mnp (
    name VARCHAR(255),
    nessie INT,
    date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2),
    ess_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 

DROP TABLE IF EXISTS silver.ess_inm;
CREATE TABLE silver.ess_inm(
    name VARCHAR(255),
    nessie INT,
    date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2),
    ess_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS silver.wfm_employees;
CREATE TABLE silver.wfm_employees (
    nessie INT,
    internal_or_external VARCHAR(50),
    name VARCHAR(50),
    gcm_level INT,
    hourly_rate NUMERIC(5,2),
    competence VARCHAR(255),
    daily_rate NUMERIC(6,2),
    wfm_create_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
