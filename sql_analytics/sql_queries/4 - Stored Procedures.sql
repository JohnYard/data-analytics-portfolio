-- ============================================================================
-- Project: SQL Analytics Portfolio - Stored Procedures
-- Dataset: Parks and Recreation Database
-- Description: Demonstrates how to create, modify delimiters for, and execute 
--              stored procedures with and without input parameters.
-- ============================================================================

-- 1. Baseline Query:
-- Standard query retrieving employees with a salary greater than 50,000.
SELECT * 
FROM employee_salary
WHERE salary > 50000;


-- 2. Basic Stored Procedure:
-- Encapsulates the baseline query into a reusable stored procedure.
CREATE PROCEDURE large_salaries()
SELECT * 
FROM employee_salary
WHERE salary > 50000;

-- Execute the procedure
CALL large_salaries();


-- 3. Multi-Statement Stored Procedure:
-- Uses a custom delimiter to execute multiple queries sequentially within a block.
DELIMITER $$
CREATE PROCEDURE large_salaries3()
BEGIN
	SELECT * 
	FROM employee_salary
	WHERE salary > 50000;

	SELECT * 
	FROM employee_salary
	WHERE salary > 10000;
END $$
DELIMITER ;

-- Execute the multi-statement procedure.
CALL  large_salaries3()


-- 4. Stored Procedure with Input Parameters:
-- Accepts an employee ID parameter to query a specific employee's salary.
DELIMITER $$
CREATE PROCEDURE large_salaries4(employee_id_param INT)
BEGIN
	SELECT salary 
	FROM employee_salary
	WHERE employee_id = employee_id_param;
END $$
DELIMITER ;

-- Execute the parameterized procedure for employee ID 1.
CALL  large_salaries4(1)
