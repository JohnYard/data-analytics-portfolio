-- ============================================================================
-- Project: SQL Analytics Portfolio - Temporary Tables
-- Dataset: Parks and Recreation Database
-- Description: Demonstrates how to create, insert data into, and query 
--              Temporary Tables for intermediate or session-specific storage.
-- ============================================================================

-- 1. Manual Creation and Data Insertion:
-- Creates an empty temporary table with a custom schema, then inserts a row manually.
CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

SELECT * 
FROM temp_table;

-- Explicitly specifying columns during insert is a best practice for maintainability
INSERT INTO	 temp_table
values('Alex','Freberd', 'Lord of the Rings: The Two Towers');

SELECT *
FROM temp_table;

-- 2. Creation via Subquery (Create Table As Select):
-- Automatically creates a temporary table populated with rows from an existing table 
-- where the salary meets a specific threshold.
CREATE TEMPORARY TABLE salary_over_50K
SELECT *
FROM employee_salary
WHERE salary >= 50000;


SELECT *
FROM salary_over_50K;

