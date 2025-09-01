/*
===============================================================
Create Database and Schemas
===============================================================
Script Purpose:
  This script creates a new database named 'ess' after checking if it already exists.
  If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas
  within the database: 'bronze', 'silver', and 'gold'.

WARNING:
  Running this script will drop the entire 'ess' database if it exists.
  All data in the database will be permanently deleted. Proceed with caution
  and ensure you have proper backups before running this script.
*/

-- Drop if exists and create 'ess' database
DROP DATABASE IF EXISTS 'ess';
CREATE DATABASE 'ess';

-- Create schemas
CREATE SCHEMA bronze;
CREATE SCHEMA silver;
CREATE SCHEMA gold;
