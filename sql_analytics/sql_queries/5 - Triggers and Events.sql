-- ============================================================================
-- Project: SQL Analytics Portfolio - Triggers and Events
-- Dataset: Parks and Recreation Database
-- Description: Demonstrates how to automate database actions using Triggers 
--              (after insert synchronization) and scheduled Events.
-- ============================================================================ 

-- Initial inspection of the baseline tables
SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;


-- ============================================================================
-- 1. TRIGGERS
-- ============================================================================

-- Clean up any existing trigger before creating a new one
DROP TRIGGER IF EXISTS employee_insert;

-- Create a trigger that automatically adds matching demographic records when an employee is inserted into salary
DELIMITER $$

CREATE TRIGGER employee_insert
    AFTER INSERT ON employee_salary
    FOR EACH ROW
BEGIN
    INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$

DELIMITER ;

-- Test the trigger by inserting a new employee record
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13, 'Jean-Ralphio', 'Saperstein', 'Entertainment 720 CEO', 1000000, NULL);


-- ============================================================================
-- 2. EVENTS
-- ============================================================================

-- Inspect demographic records before scheduling automated deletions
SELECT * 
from employee_demographics;

-- Create a scheduled event to periodically prune records based on age criteria
DELIMITER $$
CREATE EVENT delete_retirees
on schedule EVERY 30 SECOND
DO
BEGIN
	DELETE
	FROM employee_demographics
	WHERE age >= 60;
END $$
DELIMITER ;

-- Verify event scheduler configuration and user privileges
SHOW VARIABLES LIKE 'event%'

SHOW GRANTS;