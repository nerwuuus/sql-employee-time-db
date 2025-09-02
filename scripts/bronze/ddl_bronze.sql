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

DROP TABLE IF EXISTS bronze.sap_mnp;
CREATE TABLE bronze.sap_mnp (
    name VARCHAR(255),
    nessie INT,
    work_date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2)
);

DROP TABLE IF EXISTS bronze.sap_inm;
CREATE TABLE bronze.sap_inm (
    name VARCHAR(255),
    nessie INT,
    work_date DATE,
    status VARCHAR(255),
    wbs VARCHAR(255),
    wbs_description VARCHAR(255),
    hours NUMERIC(4,2)
);

DROP TABLE IF EXISTS bronze.wfm_employees;
CREATE TABLE bronze.wfm_employees (
    nessie INT,
    internal_or_external VARCHAR(50),
    name VARCHAR(50),
    GCM_level INT,
    hourly_rate NUMERIC(5,2),
    competence VARCHAR(255)
);

DROP TABLE bronze.ess_mnp