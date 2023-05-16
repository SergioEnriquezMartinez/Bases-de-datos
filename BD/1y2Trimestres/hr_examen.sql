SELECT c.cust_first_name, c.cust_last_name, e.first_name, e.last_name
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN employees e
ON c.account_mgr_id = e.employee_id
WHERE o.promotion_id != null
ORDER BY 4 DESC, 3 ASC

SELECT l.city AS Nombre
FROM locations l
JOIN countries c
ON l.country_id = c.country_id
JOIN regions r
ON c.region_id = r.region_id
UNION
SELECT c.country_name AS Nombre
FROM locations l
JOIN countries c
ON l.country_id = c.country_id
JOIN regions r
ON c.region_id = r.region_id
UNION
SELECT r.region_name AS Nombre
FROM locations l
JOIN countries c
ON l.country_id = c.country_id
JOIN regions r
ON c.region_id = r.region_id
ORDER BY ASC;

SELECT e.first_name AS 'Nombre',
e.last_name AS 'Apellido',
((e.salary * 12) + (commission_pct * 300)) AS 'Salario'
FROM employees e;

SELECT CONCAT(e.first_name,'', e.last_name) AS 'Empleado',
d.department_name as departamento, "actual" AS 'Tipo'
FROM employees e 
JOIN departments d 
    ON e.department_id = d.department_id
UNION 
SELECT CONCAT(e.first_name,'', e.last_name) AS 'Empleado',
d.department_name AS departamento, "historico" AS 'Tipo'
FROM employees e 
JOIN job_history jh
    ON e.employee_id = jh.employee_id
JOIN departments d 
    ON d.department_id = jh.department_id
ORDER BY 1;

SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Empleado',
d.department_name AS 'Departamento'
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
WHERE e.salary >(
                    SELECT e.salary
                    FROM employees e
                    WHERE e.first_name = 'Peter'
                    AND e.last_name = 'Vargas'
                )
ORDER BY d.department_name ASC;

SELECT j.job_title, e.first_name, e.last_name
FROM jobs j
JOIN employees e
ON j.job_id = e.job_id
ORDER BY 1, 2;

SELECT e.first_name, e.last_name, j.job_title, d.department_name
FROM employees e
JOIN jobs j
ON e.job_id = j.job_id
JOIN departments d
ON e.manager_id = d.manager_id
ORDER BY 1, 4;