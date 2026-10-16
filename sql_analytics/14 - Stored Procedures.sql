-- 14 Stored Procedures 

SELECT * 
FROM employee_salary
WHERE salary > 50000;



CREATE PROCEDURE large_salaries()
SELECT * 
FROM employee_salary
WHERE salary > 50000;

CALL large_salaries();


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


CALL  large_salaries3()


CALL  new_procedure()


DELIMITER $$
CREATE PROCEDURE large_salaries4(employee_id_param INT)
BEGIN
	SELECT salary 
	FROM employee_salary
	WHERE employee_id = employee_id_param;
END $$
DELIMITER ;

CALL  large_salaries4(1)
