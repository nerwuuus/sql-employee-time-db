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

DROP TABLE IF EXISTS bronze.ess_mnp;
CREATE TABLE bronze.ess_mnp (
    name VARCHAR(255),
    nessie INT,
    date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2)
);

DROP TABLE IF EXISTS bronze.ess_inm;
CREATE TABLE bronze.ess_inm (
    name VARCHAR(255),
    nessie INT,
    date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2)
);

DROP TABLE IF EXISTS bronze.wfm_employees;
CREATE TABLE bronze.ess_wfm (
    name VARCHAR(50),
    nessie INT,
    hourly_rate NUMERIC(4,2),
    GCM_level INT,
    position VARCHAR(50)
);
