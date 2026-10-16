-- CTEs Common Table Expression


WITH CTE_Example(Gender, Avg_Sal, MAX_Sal, MIN_Sal, Count_Sal) as

(
SELECT gender, AVG(salary) avg_sal, MAX(salary) max_sal, MIN(salary) min_sal, COUNT(salary) count_sal
FROM employee_demographics as dem
JOIN employee_salary as sal
	on dem.employee_id = sal.employee_id
GROUP BY gender
)

SELECT *
FROM CTE_Example
;



WITH CTE_Example as

(
SELECT employee_id, gender, birth_date
FROM employee_demographics 
WHERE birth_date > '1985-01-01'
),
CTE_Example2 as
(SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)

SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_ID = CTE_Example2.employee_id
;