/*(REDONDEAR LOS SUELDOS DE LOS EMPLEADOS A SU SUELDO MÁS BAJO O MÁS ALTO, EN FUNCIÓN DEL RANGO DE SUELDOS EN SU TRABAJO:

Por cada trabajo cuyo titulo empiece por SALES sacar su salario mínimo y el salario máximo.
A continuación sacar el sueldo medio de ese trabajo.
Para finalizar sacar por cada empleado de ese trabajo si se le sube o se le baja su sueldo en función de:
- Si tiene un sueldo mayor a la media LE SUBIMOS EL SUELDO y le actualizamos al salario máximo de su trabajo. 
- Si tiene un sueldo menor a la media, LE BAJAMOS EL SUELDO y le actualizamos al salario mínimo de su trabajo.

TRABAJOS
-------------------------------------------------------
Sales Manager: Sueldo entre 10000 y 20000
-------------------------------------------------------
El sueldo medio es: 15000
 + Empleado: Cambrault, Gerald
 --- se BAJA su sueldo de 11000 a 10000
 + Empleado: Errazuriz, Alberto
 --- se BAJA su sueldo de 12000 a 10000
...
-------------------------------------------------------
Sales Representative: Sueldo entre 6000 y 12000
-------------------------------------------------------
El sueldo medio es: 9000
 + Empleado: Ande, Sundar
 --- se BAJA su sueldo de 6400 a 6000
 + Empleado: Banda, Amit
 --- se BAJA su sueldo de 6200 a 6000
 + Empleado: Bernstein, David
 --- se SUBE su sueldo de 9500 a 12000
 + Empleado: Cambrault, Nanette
 --- se BAJA su sueldo de 7500 a 6000
 + Empleado: Doran, Louise
 --- se BAJA su sueldo de 7500 a 6000
 + Empleado: Greene, Danielle
 --- se SUBE su sueldo de 9500 a 12000
 + Empleado: Hall, Peter
 --- se SUBE su sueldo de 9000 a 12000
*/


DECLARE
    CURSOR nombreCursor IS
        SELECT job_title, min_salary, max_salary, (min_salary + max_salary) / 2 AS media 
        FROM jobs
        WHERE UPPER(job_title) like 'SALES%';
    CURSOR nombreCursor2(nombreVariable jobs.job_title%TYPE) IS
        SELECT first_name, last_name, salary, job_title
        FROM employees e
        JOIN jobs j ON e.job_id = j.job_id
        WHERE j.job_title LIKE nombreVariable;
BEGIN
    FOR rNombreRegistro IN nombreCursor LOOP
        dbms_output.put_line(rNombreRegistro.job_title || ', ' || rNombreRegistro.max_salary || ', ' || rNombreRegistro.min_salary);
        dbms_output.put_line('El sueldo medio es: ' || rNombreRegistro.media);
        FOR rNombreRegistro2 IN nombreCursor2(rNombreRegistro.job_title) LOOP
            dbms_output.put_line('Empleado: ' || rNombreRegistro2.first_name || ' ' || rNombreRegistro2.last_name);
            IF (rNombreRegistro2.salary < rNombreRegistro.media) THEN
                dbms_output.put_line('Se baja el sueldo de: ' || rNombreRegistro2.salary || ' a: ' || rNombreRegistro.min_salary);
                UPDATE employees SET salary = rNombreRegistro.min_salary WHERE salary LIKE rNombreRegistro.job_title;
            ELSE
                dbms_output.put_line('Se sube el sueldo de: ' || rNombreRegistro2.salary || ' a: ' || rNombreRegistro.max_salary);
                UPDATE employees SET salary = rNombreRegistro.max_salary WHERE salary LIKE rNombreRegistro.job_title;
            END IF;
        END LOOP;
    END LOOP;
END;

/*QUEREMOS LAS DOS VENTAS CON LA CANTIDAD MAS ALTA Y A QUE EMPLEADO Y DEPARTAMENTO PERTENECEN*/

SELECT * FROM (
    SELECT v.id_venta, v.cantidad, e.nombre_empleado, d.nombre_departamento
    FROM ventas v
    JOIN empleados e USING id_empleado
    JOIN departamentos d USING id_departamento
    GROUP BY v.cantidad DESC
    )
WHERE ROWNUM <= 2;

/*QUIERO TODAS LAS CIUDADES EUROPEAS ORDENADAS ALFABETICAMENTE Y QUE SOLO ME MUESTRE LA PRIMERA Y LA ULTIMA
QUEREMOS VER LA CIUDAD, EL PAIS Y LA REGION A LA QUE PERTENECEN*/

SELECT *  FROM
    (
    SELECT l.city, c.country_name, r.region_name
    FROM hr.locations l
    JOIN hr.countries c USING (country_id)
    JOIN hr.regions r USING (region_id)
    WHERE r.region_name LIKE 'Europe'
    ORDER BY l.city DESC
    )
WHERE ROWNUM <=1
UNION
SELECT *  FROM
    (
    SELECT l.city, c.country_name, r.region_name
    FROM hr.locations l
    JOIN hr.countries c USING (country_id)
    JOIN hr.regions r USING (region_id)
    WHERE r.region_name LIKE 'Europe'
    ORDER BY l.city ASC
    )
WHERE ROWNUM <=1;

/*Muestra los 2 empleados que estén cobrando el máximo del 
salario en función del trabajo que están realizando.*/


SELECT * FROM
    (
    SELECT first_name, last_name, salary, job_title, max_salary
    FROM hr.employees e
    JOIN hr.jobs j USING (job_id)
    WHERE salary = max_salary
    ORDER BY max_salary DESC
    )
WHERE ROWNUM <= 2;

/*CREATE OR REPLACE VIEW nombre AS (
    select * from empleados where salario > 1000
) WITH CHECK OPTION;

CON WITH CHECK OPTION SE TIENE QUE CUMPLIR EL WHERE SI O SI, ES DECIR SOLO SE PUEDE INSERTAR EMPLEADOS QUE TENGAN UN SULEDO
     MAYOR A 1000
/

CREATE OR REPLACE VIEW nombre AS (
    select from empleados where salario > 1000
) WITH READ ONLY;

LA TABLA ES DE SOLO LECTURA NO SE PUEDE HACER NADA CON ELLA/


select (salario+salario) as Salario2 from empleados;

/SI EL CAMPO QUE VAS A MODIFICAR ES EL CALCULO DE VARIOS CAMPOS ESE CAMPO NO SE PUEDE MODIFICAR*/

/*NOMBRE EMPLEADO, SALARIO, DEPARTAMENTO PARA EMPLEADO 1*/

DECLARE
    v_empleados empleados.nombre_empleado%TYPE;
    v_departamentos departamentos.nombre_departamento%TYPE;
	v_salario empleados.salario%TYPE;
BEGIN
    SELECT e.nombre_empleado, d.nombre_departamento, e.salario
    INTO v_empleados, v_departamentos, v_salario
    FROM empleados e
    JOIN departamentos d USING (id_departamento)
    WHERE e.id_empleado = 1;

    DBMS_OUTPUT.PUT_LINE('El empleado ' || v_empleados || ' trabaja en el departamento ' || v_departamentos || ' y cobra ' || v_salario);
END;

/*Mostrarme todos los trabajadores que trabajan en marketing. nombre y departamento*/


DECLARE
    CURSOR cEmpleados IS
        SELECT e.nombre_empleado
        FROM empleados e
        JOIN departamentos d USING (id_departamento)
        WHERE d.nombre_departamento LIKE 'Marketing';
BEGIN
    FOR rEmpleados IN cEmpleados LOOP
        DBMS_OUTPUT.PUT_LINE('Empleado ' || rEmpleados.nombre_empleado);
    END LOOP;
END;

/*Duplicamos todos los salarios de la gente que trabaje en marketing*/

DECLARE
    CURSOR cEmpleados IS
        SELECT *
        FROM empleados e
        JOIN departamentos d USING (id_departamento)
        FOR UPDATE OF salario NOWAIT;
BEGIN
    FOR rEmpleados IN cEmpleados LOOP
        IF (rEmpleados.nombre_departamento LIKE 'Marketing') THEN
            UPDATE empleados SET salario = salario * 2
            WHERE CURRENT OF cEmpleados;
        END IF;
    END LOOP;
    COMMIT;
END;

