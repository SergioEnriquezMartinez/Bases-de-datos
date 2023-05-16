SELECT ((max_salary - min_salary)/max_salary)*100 from jobs;

select date_format(hire_date, '%d/%m/%Y') 
from employees;

select date_format(hire_date, '%d/%m/%y') as FechaContratacion 
from employees;

select date_format(hire_date, '%d/%m/%y') as "Fecha Contratacion" 
from employees;

select job_id as "Identificador", job_title as "Nombre trabajo", min_salary as "Salario Minimo", max_salary as "Salario Maximo" 
from jobs;

select department_id as "Clave", department_name as "Nombre departamento", manager_id as "Clave Manager", location_id as "Clave localidad" 
from departments;

select job_title 
from jobs where min_salary >=7000 AND min_salary <=10000;

------------------IMPORTANTE AL TRABAJAR CON FECHAS ES  --> AÑO / MES / DIA

select first_name, last_name 
from employees where hire_date>='1980/01/01' AND hire_date<'1990/01/01';

select first_name, last_name 
from employees where commission_pct IS NULL;


--sacar la lista de localizaciones ordenado por el nombre de la lozalizacion:
select location_id as "Clave", street_address AS "Direccion", postal_code AS "CP", city AS "Ciudad",
state_province AS "Provincia", country_id AS "Pais"
from locations
order by city;

--filtrar ahora por aquellos que esten en el pais mexico  (country = mx)
select location_id as "Clave", street_address AS "Direccion", postal_code AS "CP", city AS "Ciudad",
state_province AS "Provincia", country_id AS "Pais"
from locations
where country_id = 'MX'
order by city;

--alias en las tablas:
select * from locations l  --la  l es el alias que le ponemos a locations
where l.country_id = 'MX';



--------------------JOINS------------------
SELECT e.first_name AS "nombre", d.department_name AS "Dept"
FROM Employees e 
JOIN Departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance'
ORDER BY e.first_name;

--
SELECT l.city AS "Ciudad", c.country_name AS "Pais"
FROM locations l
JOIN countries C ON l.country_id = c.country_id
ORDER BY c.country_name, l.city;


--paises con regiones --> sacar el nombre del pais y el de la region
--ordenar por nombre de region ASC
--ordenar por nombre de pais DESC
SELECT c.country_name AS "Nombre del pais", r.region_name AS "Nombre de la region"
FROM countries c 
JOIN regions r ON c.region_id = r.region_id
ORDER BY  r.region_name ASC, c.country_name DESC;

--ordenar por nombre de region ASC
SELECT c.country_name AS "Nombre del pais", r.region_name AS "Nombre de la region"
FROM countries c 
JOIN regions r ON c.region_id = r.region_id
ORDER BY r.region_name ASC;

--ordenar por nombre de pais DESC
SELECT c.country_name AS "Nombre del pais", r.region_name AS "Nombre de la region"
FROM countries c 
JOIN regions r ON c.region_id = r.region_id
ORDER BY c.country_name DESC;


--sacar ahora la ciudad y a la region a la que pertenece
SELECT l.city AS "Ciudad", r.region_name AS "Nombre de la region"
FROM locations l
JOIN countries c ON l.country_id = c.country_id
JOIN regions r ON c.region_id = r.region_id
ORDER BY l.city;

--sacar el nombre de un empleado y el nombre de su responsable
SELECT concat(e.first_name, ' ', e.last_name) AS "Nombre del empleado",
       concat(m.first_name,' ', m.last_name) AS "Responsable"
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.first_name, m.first_name;

---al reves:
SELECT concat(e.first_name, ' ', e.last_name) AS "Nombre del empleado",
       concat(m.first_name,' ', m.last_name) AS "Responsable"
FROM employees m
JOIN employees e ON e.manager_id = m.employee_id
ORDER BY e.first_name, m.first_name;

SELECT e.first_name AS 'Nombre',
e.last_name AS 'Apellido',
j.job_title AS 'Puesto de trabajo'
FROM employees e
JOIN job_history jh
ON e.employee_id = jh.employee_id
JOIN jobs j
ON j.job_id = jh.job_id
ORDER BY 1, 2, 3;

SELECT e.first_name AS 'Nombre',
e.last_name AS 'Apellido'
FROM employees e
JOIN job_history jh
ON e.employee_id = jh.employee_id
ORDER BY 2;

SELECT DISTINCT e.first_name AS 'Nombre',
e.last_name AS 'Apellido'
FROM employees e
JOIN job_history jh
ON e.employee_id = jh.employee_id
ORDER BY 2;

SELECT e.first_name AS 'Nombre',
e.last_name AS 'Apellido',
j.job_title AS 'Puesto de trabajo',
d.department_name AS 'Departamento'
FROM employees e
JOIN job_history jh
ON e.employee_id = jh.employee_id
JOIN jobs j
ON j.job_id = jh.job_id
JOIN departments d
ON d.department_id = jh.department_id;

--Nombre y apellidos de los empleados y nombre del departamento al que pertenecen
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido',
       d.department_name AS 'Departamento'
FROM employees e
JOIN departments d ON e.department_id = d.department_id;

--Empleados que esten en el departamento de administracion
--ordenado por apellido
SELECT e.first_name AS "Nombre", e.last_name AS "Apellido",
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Administration'
ORDER BY 2;

---------
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido',
       h.job_id AS "Trabajo"
FROM employees e 
LEFT JOIN job_history h 
ON e.job_id = h.job_id
ORDER BY 3, 2;

--sacar el listado de TODOS los empleados y el nombre del departamento 
--de cada uno de ellos TENGAN O NO.
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido',
       d.department_name AS 'Departamento'
FROM employees e 
LEFT JOIN departments d ON e.department_id = d.department_id
ORDER BY 2;

--sacar el listado de TODOS los departamentos y el nombre del empleado 
--de cada uno de ellos TENGAN O NO.
SELECT d.department_name AS "Nombre Dept.",
       e.first_name AS "Nombre", e.last_name AS "Apellidos"
FROM departments d 
LEFT JOIN employees e ON d.department_id = e.department_id
ORDER BY 1, 3;

---aqui solo salen 107 resultados.
SELECT d.department_name AS "Nombre Dept.",
       e.first_name AS "Nombre", e.last_name AS "Apellidos"
FROM departments d 
RIGHT JOIN employees e ON d.department_id = e.department_id
ORDER BY 1, 3;

-------------------

SELECT e.first_name AS 'Nombre',
e.last_name AS 'Apellidos',
j.job_title AS 'Trabajo'
FROM employees e
LEFT JOIN jobs j
ON j.job_id = e.job_id;
-------------------

SELECT e.first_name AS 'Nombre',
e.last_name AS 'Apellidos',
j.job_title AS 'Trabajo'
FROM employees e
RIGHT JOIN jobs j
ON e.job_id = j.job_id;
-------------------

SELECT e.first_name AS 'Nombre',
e.last_name AS 'Apellidos',
j.job_title AS 'Historial trabajos'
FROM employees e
LEFT JOIN job_history jh
ON e.employee_id = jh.employee_id
LEFT JOIN jobs j
ON j.job_id = jh.job_id
ORDER BY 3, 2;
-------------------

SELECT d.department_name AS 'Dept',
r.region_name AS 'Region'
FROM departments d
LEFT JOIN locations l
ON d.location_id = l.location_id
LEFT JOIN countries c
ON c.country_id = l.country_id
LEFT JOIN regions r
ON r.region_id = c.region_id
ORDER BY 1;
-------------------
--sacar listado de empleados del dpt de marketing o Shipping
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido',
       d.department_name AS 'Departamento'
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Shipping' 
OR d.department_name = 'Marketing'
ORDER BY 3, 2, 1;

---empleados que trabajen en esos dos dpt anteriores y que cobren entre 6000 y 7000
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', e.salary AS 'Salario',
       d.department_name AS 'Departamento'
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
WHERE (d.department_name = 'Shipping' OR d.department_name = 'Marketing')
AND (e.salary > 6000 AND e.salary < 7000)
ORDER BY 3, 2, 1;

--con el IN
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', e.salary AS 'Salario',
       d.department_name AS 'Departamento'
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name IN('Shipping', 'Marketing')
AND (e.salary > 6000 AND e.salary < 7000)
ORDER BY 3, 2, 1;



----saber los empleados que esten en marketing, IT y sales
--y que cobren mas de 7000.00
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', e.salary AS 'Salario',
       d.department_name AS 'Departamento'
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name IN('Sales', 'Marketing', 'IT')
AND (e.salary > 7000)
ORDER BY 4, 3, 2, 1;

--epleados cuyo apelido empieze por h
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', e.salary AS 'Salario',
       d.department_name AS 'Departamento'
FROM employees e 
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name IN('Sales', 'Marketing', 'IT')
AND e.salary > 7000
AND (e.last_name LIKE 'H%')
ORDER BY 4, 3, 2, 1;


--------------------------
--------------------------

--empleados que tengan un trabajo cuyo salario sea min >= 9k or max <= 9k
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido'
FROM employees e 
JOIN jobs J ON e.job_id = j.job_id
WHERE j.min_salary >= 9000 OR j.max_salary <= 9000
ORDER BY 2;


--listado de trabajos que tengan en el nombre 'it'
SELECT * FROM jobs
WHERE job_id LIKE '%IT%';


--empleados cuyo salario des exactamente 9000 o 8000
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido'
FROM employees e 
WHERE e.salary IN(9000, 8000)
ORDER BY Apellido DESC;

--Empleados que no tengan departamento
SELECT first_name AS 'Nombre', last_name AS 'Apellido'
FROM employees 
WHERE department_id IS NULL
ORDER BY Nombre;

 
--nom, ape, trabaj y depart de los trabajadores que cobren 8k, 8k, 10k
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', j.job_title AS 'Trabajo',
       d.department_name AS 'Departamento'
FROM employees e 
LEFT JOIN jobs J 
    ON e.job_id = j.job_id
LEFT JOIN departments d
     ON e.department_id = d.department_id
WHERE e.salary IN(8000, 9000, 10000)
ORDER BY 4 ASC, 3 DESC, 2 ASC;



----
--nom y ape de todos los empleados, y los trabajos por los que han pasado

desc job_history;
+---------------+------------------+------+-----+---------+-------+
| Field         | Type             | Null | Key | Default | Extra |
+---------------+------------------+------+-----+---------+-------+
| employee_id   | int(11) unsigned | NO   | PRI | NULL    |       |
| start_date    | date             | NO   | PRI | NULL    |       |
| end_date      | date             | NO   |     | NULL    |       |
| job_id        | varchar(10)      | NO   | MUL | NULL    |       |
| department_id | int(11) unsigned | NO   | MUL | NULL    |       |
+---------------+------------------+------+-----+---------+-------+

SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', j.job_title
FROM employees e 
JOIN job_history jh 
    ON e.employee_id = jh.employee_id
JOIN jobs j 
    ON j.job_id = jh.job_id;

--añadir la fecha en la que empezaron cada uno de estos trabajosç
--y ordenarlo por ape, nombre y fecha
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', 
       j.job_title, DATE_FORMAT(jh.start_date, '%d/%m/%Y') AS 'Fecha inicio'
FROM employees e 
JOIN job_history jh 
    ON e.employee_id = jh.employee_id
JOIN jobs j 
    ON j.job_id = jh.job_id
ORDER BY 2, 1, jh.start_date;

--añadir ahora el trabajo actual de TODOS los trabajadores
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', 
       j.job_title, DATE_FORMAT(jh.start_date, '%d/%m/%Y') AS 'Fecha inicio'
FROM employees e 
JOIN job_history jh 
    ON e.employee_id = jh.employee_id
JOIN jobs j 
    ON j.job_id = jh.job_id
UNION ALL
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', 
       j.job_title, DATE_FORMAT(e.hire_date, '%d/%m/%Y') AS 'Fecha inicio'
FROM employees e 
JOIN jobs j 
    ON e.job_id = j.job_id
ORDER BY 2, 1;

-----
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', 
       j.job_title, DATE_FORMAT(jh.start_date, '%d/%m/%Y') AS 'Fecha inicio',
       "Historico" AS "trabajo"
FROM employees e 
JOIN job_history jh 
    ON e.employee_id = jh.employee_id
JOIN jobs j 
    ON j.job_id = jh.job_id
UNION ALL
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', 
       j.job_title, DATE_FORMAT(e.hire_date, '%d/%m/%Y') AS 'Fecha inicio',
       "Actual" AS "trabajo"
FROM employees e 
JOIN jobs j 
    ON e.job_id = j.job_id
ORDER BY 2, 1;


----AHORA EN VEZ DE CON EL HISTORICO, CON LOS DEPARTAMENTOS
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', 
       d.department_name, DATE_FORMAT(jh.start_date, '%d/%m/%Y') AS 'Fecha inicio',
       "Historico" AS "Actual"
FROM employees e 
JOIN job_history jh 
    ON e.employee_id = jh.employee_id
JOIN departments d
    ON d.department_id = jh.department_id
UNION ALL
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido', 
       d.department_name, DATE_FORMAT(e.hire_date, '%d/%m/%Y') AS 'Fecha inicio',
       "Actual" AS "Actual"
FROM employees e 
LEFT JOIN departments d 
    ON e.department_id = d.department_id
ORDER BY 2, 1;

-------
SELECT first_name, last_name, Dept, FechaInicio, esActual
FROM (
    SELECT e.first_name, e.last_name, 
            d.department_name AS "Dept",
            DATE_FORMAT(jh.start_date, '%d/%m/%Y')
            AS "FechaInicio",
            "Historico" AS "esActual",
            jh.start_date AS "fecha"
    FROM Employees e
    JOIN Job_history jh
        ON e.employee_id = jh.employee_id
    JOIN Departments d
        ON d.department_id = jh.department_id
    UNION ALL
    SELECT e.first_name, e.last_name, 
            COALESCE(d.department_name, '--') AS "Dept",
            DATE_FORMAT(e.hire_date, '%d/%m/%Y')
            AS "FechaInicio",
            "Actual" AS "esActual",
            e.hire_date AS "fecha"
    FROM Employees e
    LEFT JOIN Departments d
        ON e.department_id = d.department_id
    ) a
ORDER BY last_name, first_name, fecha;

--------------
-------------
--nom y ape de emp en dep de marketing y sales
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido',
       "Ventas" AS "Departamento"
FROM employees e 
JOIN departments d 
    ON e.department_id = d.department_id
WHERE d.department_name = 'Sales'
UNION 
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido',
       "Marketing" AS "Departamento"
FROM employees e 
JOIN departments d 
    ON e.department_id = d.department_id
WHERE d.department_name = 'Marketing'
ORDER BY 2, 1;


---------
--------
--Region a la que pertenece el dptm de ventas
SELECT r.region_name AS 'Nombre de la region del dpt de Ventas'
from regions r 
JOIN countries c 
    ON r.region_id = c.region_id 
JOIN locations l 
    ON l.country_id = c.country_id 
JOIN departments d 
    ON l.location_id = d.location_id 
WHERE d.department_name = 'Sales';


---Que deps estan en la region de europa ?
SELECT d.department_name AS 'Depts en Europa'
from regions r 
JOIN countries c 
    ON r.region_id = c.region_id 
JOIN locations l 
    ON l.country_id = c.country_id 
JOIN departments d 
    ON l.location_id = d.location_id 
WHERE r.region_name = 'Europe';


--------
.--departamentos que estan en la misma region que el de ventas
--exceptuando a ventas
SELECT d.department_name
FROM regions r 
JOIN countries c 
    ON r.region_id = c.region_id 
JOIN locations l 
    ON l.country_id = c.country_id 
JOIN departments d 
    ON l.location_id = d.location_id 
WHERE r.region_name = (select r.region_name
                       FROM regions r
                        JOIN countries c 
                            ON r.region_id = c.region_id 
                        JOIN locations l 
                            ON l.country_id = c.country_id 
                        JOIN departments d 
                            ON l.location_id = d.location_id 
                        WHERE d.department_name = 'Sales')
AND d.department_name <> 'Sales';


-----------------
--listado de empleados que esten en el mismo departamento que 'Ki Gee'

SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Nombre empleados'
FROM employees e 
WHERE e.department_id = (SELECT department_id
                        FROM employees
                        WHERE last_name = 'Gee' and first_name = 'Ki');



--
SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Empleados'
FROM employees e 
WHERE e.department_id IN (SELECT department_id
                        FROM employees
                        WHERE last_name = 'King');

SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Nombre empleados'
FROM employees e 
JOIN employee e2
    ON e.department_id = e2.department_id
WHERE e2.last_name = 'King'

------------------
--compañeros de trabajo de ki gee, los que tienen el mismo puesto de trabajo 
SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Compañeros de Ki'
FROM employees e 
WHERE e.job_id = (SELECT job_id
                 FROM employees
                 WHERE first_name = 'Ki' and last_name = 'Gee');


SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Compañeros de Ki'
FROM employees e 
JOIN employees e2
    ON e.job_id = e2.job_id
WHERE e2.last_name = 'Gee';


---todos los que no son compañeros de trabajo de ki gee
SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Compañeros de Ki'
FROM employees e 
WHERE e.job_id <> (SELECT job_id
                 FROM employees
                 WHERE first_name = 'Ki' and last_name = 'Gee');


SELECT CONCAT(e.first_name, ' ', e.last_name) AS 'Compañeros de Ki'
FROM employees e 
JOIN employees e2
    ON e.job_id <> e2.job_id
WHERE e2.last_name = 'Gee' AND e2.first_name = 'Ki';

--------------
--compañeros que ha tenido, o tiene, jonathon Taylor



--------------
--empleados que hay en los deps de treasury, finance y sales
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido',
        "Ventas" AS "Dept"
FROM Employees e
JOIN Departments d
    ON e.department_id = d.department_id
WHERE d.department_name = 'Sales'
UNION
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido',
        "Finaciero" AS "Dept"
FROM Employees e
JOIN Departments d
    ON e.department_id = d.department_id
WHERE d.department_name = 'Finance'
UNION
SELECT e.first_name AS 'Nombre', e.last_name AS 'Apellido',
        "Tesorería" AS "Dept"
FROM Employees e
JOIN Departments d
    ON e.department_id = d.department_id
WHERE d.department_name = 'Treasury';

--otra posibilidad, pero esto NO ENTRA
SELECT e.first_name, e.last_name AS Empleado,
        DECODE_ORACLE(d.department_name, 'Sales', 'Ventas',
        'Finance', 'Finanzas',
        'Treasury', 'Tesoreria', 'Nada de lo anterior') AS 'Dept.'
FROM Employees e
JOIN Departments d
    ON e.department_id = d.department_id
WHERE d.department_name IN('Sales','Treasury','Finance');


----------------
--empleados de la empresa con el nombre del dpt en el que estan y por donde han estado
--indicar si ese es el dpt en el que estan actuamente o no
SELECT CONCAT(e.first_name,'', e.last_name) AS EMPLEADO,
d.department_name as departamento, "actual" as tipo
from employees e 
join departments d 
    on e.department_id = d.department_id
union 
SELECT CONCAT(e.first_name,'', e.last_name) AS EMPLEADO,
d.department_name as departamento, "historico" as tipo
from employees e 
join job_history jh
    on e.employee_id = jh.employee_id
join departments d 
    on d.department_id = jh.department_id
order by 1
;






