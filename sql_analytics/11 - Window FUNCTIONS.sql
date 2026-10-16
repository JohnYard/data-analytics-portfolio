-- Window FUNCTIONS

-- Мы можем вывести тут результат, только если сгрупируем по gender

SELECT gender, AVG(salary) as avg_salary
FROM employee_demographics as dem
JOIN employee_salary as sal
	on dem.employee_id = sal.employee_id
GROUP BY gender;


-- тут мы выводим результат AVG(salary) без групировки и и таким образом можем вывести и другие значения из таблицы как имена и т.п.

SELECT gender, AVG(salary) OVER(PARTITION by gender)
FROM employee_demographics as dem
JOIN employee_salary as sal
	on dem.employee_id = sal.employee_id


SELECT dem.last_name, dem.last_name, gender, AVG(salary) OVER(PARTITION by gender)
FROM employee_demographics as dem
JOIN employee_salary as sal
	on dem.employee_id = sal.employee_id


SELECT dem.last_name, dem.last_name, gender, salary,
SUM(salary) OVER(PARTITION by gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics as dem
JOIN employee_salary as sal
	on dem.employee_id = sal.employee_id



SELECT dem.employee_id, dem.last_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics as dem
JOIN employee_salary as sal
	on dem.employee_id = sal.employee_id 



