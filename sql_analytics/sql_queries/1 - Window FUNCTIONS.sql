-- ============================================================================
-- Project: SQL Analytics Portfolio - Window Functions
-- Dataset: Parks and Recreation Database
-- Description: Demonstrates the practical differences between GROUP BY and 
--              Window Functions (PARTITION BY), rolling totals, and ranking functions.
-- ============================================================================

-- 1. Standard GROUP BY Aggregation:
-- Collapses rows by gender to return a single summary row with the average salary.
SELECT gender, AVG(salary) as avg_salary
FROM employee_demographics as dem
JOIN employee_salary as sal
	on dem.employee_id = sal.employee_id
GROUP BY gender;


-- 2. Window Function with PARTITION BY:
-- Calculates the average salary per gender without collapsing rows, 
-- allowing individual employee records to remain visible alongside aggregate metrics.
SELECT gender, AVG(salary) OVER(PARTITION by gender)
FROM employee_demographics as dem
JOIN employee_salary as sal
	on dem.employee_id = sal.employee_id


-- 3. Retaining Individual Attributes:
-- Combining employee details (first and last name) with partitioned window aggregates.
SELECT dem.last_name, dem.last_name, gender, AVG(salary) OVER(PARTITION by gender)
FROM employee_demographics as dem
JOIN employee_salary as sal
	on dem.employee_id = sal.employee_id


-- 4. Rolling Total (Cumulative Sum):
-- Calculates a running total of salaries partitioned by gender and ordered sequentially by employee ID.
SELECT dem.last_name, dem.last_name, gender, salary,
SUM(salary) OVER(PARTITION by gender ORDER BY dem.employee_id) AS Rolling_Total
FROM employee_demographics as dem
JOIN employee_salary as sal
	on dem.employee_id = sal.employee_id


-- 5. Ranking Functions Comparison:
-- Compares ROW_NUMBER(), RANK(), and DENSE_RANK() to evaluate salary hierarchies within each gender partition.
SELECT dem.employee_id, dem.last_name, dem.last_name, gender, salary,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) AS row_num,
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS rank_num,
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) AS dense_rank_num
FROM employee_demographics as dem
JOIN employee_salary as sal
	on dem.employee_id = sal.employee_id 

