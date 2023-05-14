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