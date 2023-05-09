/*
CURSORES: selecciona el id de departamento junto con tu nombre, separado por dos puntos
*/
DECLARE
    CURSOR cursorNombre IS 
        SELECT department_id, department_name
        FROM hr.departments;
    
    v_id hr.departments.department_id%TYPE;
    v_nombre hr.departments.department_name%TYPE;

BEGIN
    OPEN cursorNombre;
    LOOP
        FETCH cursorNombre INTO v_id, v_nombre; 
        EXIT WHEN cursorNombre%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_id || ' : ' || v_nombre ); 
    END LOOP;
    CLOSE cursorNombre;
END;

---------------
DECLARE 
    CURSOR cursorNombre IS
        SELECT department_id as id, department_name as nombre
        FROM hr.departments;
BEGIN 
    FOR rNombres IN cursorNombre LOOP
        DBMS_OUTPUT.PUT_LINE (rNombres.id || ' : ' || rNombres.nombre); 
    END LOOP; 
END;

----------------

create table empleadosVIP (
    employee_id number(3) primary key, 
    first_name varchar2(100), 
    last_name varchar2(100), 
    salary number(6)
);

/*CURSORES: En la tabla empleadosVIP, tendrás que insertar a los
empleados cuyo sueldo sea mayor a 10000*/
DECLARE 
    CURSOR cursorEmpVip IS
        SELECT employee_id, first_name, last_name, salary 
        FROM hr.employees;
BEGIN 
    FOR regVip IN cursorEmpVip LOOP
        IF regVip.salary >= 10000 THEN
            INSERT INTO empleadosVIP 
            VALUES(regVip.employee_id, regVip.first_name, 
                    regVip.last_name, regVip.salary);
        END IF;
    END LOOP; 
END;

select * from empleadosVIP;

---------------------
/*
Sacar lo siguiente de cada empleado, 
si el departamento es Sales sacamos el sueldo triplicado y sino el sueldo duplicado:

Empleado: Abel, Ellen
Trabaja en: Sales. Su sueldo TRIPLICADO ES: 33000
----------------------------------------
Empleado: Ande, Sundar
Trabaja en: Sales. Su sueldo TRIPLICADO ES: 19200
----------------------------------------
Empleado: Atkinson, Mozhe
Trabaja en: Shipping. Su sueldo DUPLICADO ES: 5600
----------------------------------------
*/
DECLARE 
    CURSOR cursorSueldos IS
        SELECT first_name, last_name, salary, department_name
        FROM hr.employees
        JOIN hr.ADDdepartments USING(department_id)
        ORDER BY last_name, first_name;
BEGIN 
    FOR regSueldos IN cursorSueldos LOOP
        DBMS_OUTPUT.PUT_LINE ('Empleado: ' || regSueldos.first_name || ', ' || regSueldos.last_name);

        IF regSueldos.department_name = 'Sales' THEN
            DBMS_OUTPUT.PUT_LINE ('Trabaja en: ' || regSueldos.department_name || '. Su sueldo TRIPLICADO ES: ' || regSueldos.salary * 3);
        ELSE  
            DBMS_OUTPUT.PUT_LINE ('Trabaja en: ' || regSueldos.department_name || '. Su sueldo DUPLICADO ES: ' || regSueldos.salary * 2);
        END IF;
        DBMS_OUTPUT.PUT_LINE ('-------------------------');
    END LOOP; 
END;


------REGISTROS--------------------

create table personas(
    codigo number(2), 
    nombre varchar2(40), 
    edad number
);

DECLARE
    TYPE RegPersona IS RECORD(
        codigo number(2), 
        nombre varchar2(40), 
        edad number
    );
    Pepe RegPersona;
BEGIN
    Pepe.codigo := 1;
    Pepe.nombre := 'Pepe';
    Pepe.edad := 30;
    DBMS_OUTPUT.PUT_LINE('Codigo ' || Pepe.codigo);
    DBMS_OUTPUT.PUT_LINE('Nombre ' || Pepe.nombre);
    DBMS_OUTPUT.PUT_LINE('Edad ' || Pepe.edad);
    INSERT INTO personas values Pepe;
END;

----
DECLARE
    TYPE RegPersona IS RECORD(
        codigo personas.codigo%TYPE, 
        nombre personas.nombre%TYPE, 
        edad personas.edad%TYPE
    );
    Pepe RegPersona;
BEGIN
    Pepe.codigo := 1;
    Pepe.nombre := 'Pepe';
    Pepe.edad := 30;
    DBMS_OUTPUT.PUT_LINE('Codigo ' || Pepe.codigo);
    DBMS_OUTPUT.PUT_LINE('Nombre ' || Pepe.nombre);
    DBMS_OUTPUT.PUT_LINE('Edad ' || Pepe.edad);
    INSERT INTO personas values Pepe;
END;


---------------------------
create table hotel(
    codigo number(2) primary key, 
    nhabs number(3)
);

insert into hotel values(1, 10);
insert into hotel values(2, 60);
insert into hotel values(3, 200);
insert into hotel values(99, NULL);

/*Declarar un registro  con los campos de la tabla usando %TYPE
Sacar por pantalla los datos de los hoteles usando el registro.*/
declare 
type regHotel is record
	(
    	id hotel.id%type,
    	nhabs hotel.nhabs%type
    );
	hoteles regHotel;
begin
    for hoteles in (select * from hotel)
    loop
        dbms_output.put_line('ID: ' || hoteles.id);
        dbms_output.put_line('HABS: ' || hoteles.nhabs);
    end loop;
END;


--------------
declare 
    Hotel99 Hotel%ROWTYPE;
begin
    for hoteles in (select * from hotel)
    loop
        dbms_output.put_line('ID: ' || hoteles.id);
        dbms_output.put_line('HABS: ' || hoteles.nhabs);
    end loop;
END;

------------
declare 
    CURSOR hoteles IS
        select * from hotel;
BEGIN
    for registro IN hoteles
    loop
        dbms_output.put_line('ID: ' || hoteles.id);
        dbms_output.put_line('HABS: ' || hoteles.nhabs);
    end loop;
END;

---------
DECLARE 
    CURSOR hoteles IS
        select * from hotel;
    registro hoteles%ROWTYPE;
BEGIN
    OPEN hoteles;
    loop
        fetch hoteles INTO registro;
        EXIT WHEN hoteles%NOTFOUND;
        dbms_output.put_line('ID: ' || hoteles.id);
        dbms_output.put_line('HABS: ' || hoteles.nhabs);
    end loop;
	close hoteles;
END;

-------
/*Para los departamentos SALES y ADMINISTRACION sacar el nombre, apellido y sueldo con el
sguiente formato: 

--EMPLEADOS DEL DEPARTAMENTO "SALES"--
------------------------------------------------
Empleado: s, x. Su sueldo es: ----
...
------------------------------------------------
--EMPLEADOS DEL DEPARTAMENTO "ADMINISTRACION"--
------------------------------------------------
Empleado: s, x. Su sueldo es: ----
...
*/

DECLARE
    type regEmpleados is record (
    	first_name hr.employees.first_name%type,
    	last_name hr.employees.last_name%type,
		salary hr.employees.salary%type,
		department_name hr.departments.department_name%type
    );
	empleado regEmpleados;
	CURSOR listaEmpleados (departamento hr.departments.department_name%type) IS
		select e.first_name, e.last_name, e.salary, d.department_name from hr.employees e join hr.departments d on e.department_id=d.department_id where d.department_name=departamento;
BEGIN
	OPEN listaEmpleados('Sales');
    dbms_output.put_line('------------------------------------');
	dbms_output.put_line('--EMPLEADOS DEL DEPARTAMENTO SALES--');
	dbms_output.put_line('------------------------------------');
  	LOOP
    	FETCH listaEmpleados INTO empleado;
    	EXIT WHEN listaEmpleados%notfound;
    	dbms_output.put_line('Empleado: '|| empleado.first_name || ', ' || empleado.last_name || '. ' ||'Su sueldo es: ' || empleado.salary);
  	END LOOP;
  	CLOSE listaEmpleados;
	OPEN listaEmpleados('Administration');
    dbms_output.put_line('---------------------------------------------');
	dbms_output.put_line('--EMPLEADOS DEL DEPARTAMENTO ADMINISTRATION--');
	dbms_output.put_line('---------------------------------------------');
	LOOP
    	FETCH listaEmpleados INTO empleado;
    	EXIT WHEN listaEmpleados%notfound;
    	dbms_output.put_line('Empleado: '|| empleado.first_name || ', ' || empleado.last_name || '. ' ||'Su sueldo es: ' || empleado.salary);
  	END LOOP;
  	CLOSE listaEmpleados;
END;




-----------version de la prfe
DECLARE
     cursor cursorEmp(filtroDep hr.departments.department_name%TYPE) IS 
        select first_name, last_name, salary
        from hr.employees join hr.departments using(department_id)
        where (UPPER(department_name) = filtroDep)
        ORDER BY last_name, first_name;
BEGIN
    dbms_output.put_line('------------------------------------');
	dbms_output.put_line('--EMPLEADOS DEL DEPARTAMENTO SALES--');
	dbms_output.put_line('------------------------------------');
  	FOR regEmp IN cursorEmp('SALES') LOOP
    	dbms_output.put_line('Empleado: '|| regEmp.first_name || ', ' || regEmp.last_name || '. ' ||'Su sueldo es: ' || regEmp.salary);
    END LOOP;
    dbms_output.put_line('---------------------------------------------');
	dbms_output.put_line('--EMPLEADOS DEL DEPARTAMENTO ADMINISTRATION--');
	dbms_output.put_line('---------------------------------------------');
  	FOR regEmp IN cursorEmp('ADMINISTRATION') LOOP
    	dbms_output.put_line('Empleado: '|| regEmp.first_name || ', ' || regEmp.last_name || '. ' ||'Su sueldo es: ' || regEmp.salary);
    END LOOP;
END;

----------------------
/*
Sacar a los empleados cuyo apellido empiece con B y luego los que tengan una U en su apellido.
Sacar el nombre, apellido y el departamento en el que trabaja con el siguiente formato:

EMPLEADOS DE LA LETRA "B"
-------------------------------------------------------
Empleado: Baer, Hermann. Trabaja en el departamento: Public Relations
Empleado: Baida, Shelli. Trabaja en el departamento: Purchasing
Empleado: Banda, Amit. Trabaja en el departamento: Sales
...
EMPLEADOS QUE TIENEN UNA "U" EN SU APELLIDO
-------------------------------------------------------
Empleado: Austin, David. Trabaja en el departamento: IT
Empleado: Bull, Alexis. Trabaja en el departamento: Shipping
Empleado: Cambrault, Gerald. Trabaja en el departamento: Sales*/

DECLARE
     cursor cursorEmp(filtroApe hr.employees.last_name%TYPE) IS 
        select first_name, last_name, salary, department_name
        from hr.employees join hr.departments using(department_id)
        where (UPPER(last_name) LIKE filtroApe)
        ORDER BY last_name, first_name;
BEGIN
    dbms_output.put_line('------------------------------------');
	dbms_output.put_line('--EMPLEADOS DE LA LETRA B--');
	dbms_output.put_line('------------------------------------');
  	FOR regEmp IN cursorEmp('B%') LOOP
    	dbms_output.put_line('Empleado: '|| regEmp.first_name || ', ' || regEmp.last_name || '. ' ||'Trabaja en el departamento: ' || regEmp.department_name);
    END LOOP;
    dbms_output.put_line('---------------------------------------------');
	dbms_output.put_line('--EMPLEADOS CON UNA U EN SU APELLIDO--');
	dbms_output.put_line('---------------------------------------------');
  	FOR regEmp IN cursorEmp('%U%') LOOP
    	dbms_output.put_line('Empleado: '|| regEmp.first_name || ', ' || regEmp.last_name || '. ' ||'Trabaja en el departamento: ' || regEmp.department_name);
    END LOOP;
END;

/*Para cada tipo de trabajo sacar su sueldo minimo y el maximo, y a continuacion sacar los empleados de ese trabajo con su sueldo. 
En el tipo de trabajo solo deben salir los que tengan salario minimo 5000.

 

El formato de la salida es el siguiente:

 

TRABAJOS
-------------------------------------------------------
Accounting Manager: Sueldo entre 8200 y 16000
-------------------------------------------------------
 + Empleado: Higgins, Shelley. Sueldo: 12008
-------------------------------------------------------
Administration Vice President: Sueldo entre 15000 y 30000
-------------------------------------------------------
 + Empleado: De Haan, Lex. Sueldo: 17000
 + Empleado: Kochhar, Neena. Sueldo: 17000
-------------------------------------------------------
Finance Manager: Sueldo entre 8200 y 16000
-------------------------------------------------------
 + Empleado: Greenberg, Nancy. Sueldo: 12008
 ...
 
 */

DECLARE
    type regJobs is record (
    job_title hr.jobs.job_title%type,
    min_salary hr.jobs.min_salary%type,
    max_salary hr.jobs.max_salary%type
    
    );
	type regEmployees is record (
        first_name hr.employees.first_name%type,
        last_name hr.employees.last_name%type,
        salary hr.employees.salary%type
    );
	jobs regJobs;
	employees regEmployees;
    CURSOR jobsList IS    
        select job_title, min_salary, max_salary from hr.jobs;
	CURSOR employeeList(sueldo hr.employees.salary%type) IS
	 select e.first_name, e.last_name, e.salary from hr.employees e join hr.jobs j on e.job_id=j.job_id where  j.job_title like 'Accounting Manager' and e.salary > sueldo;
BEGIN
	OPEN jobsList;
	OPEN employeeList(5000);
	dbms_output.put_line('TRABAJOS');
	dbms_output.put_line('--------');
	LOOP
		FETCH jobsList INTO jobs;
		EXIT WHEN jobsList%notfound;
		dbms_output.put_line(jobs.job_title || ' Sueldo entre ' || jobs.min_salary || ' ' || jobs.max_salary);
	END LOOP;
		LOOP
		FETCH employeeList INTO employees;
		EXIT WHEN employeeList%notfound;
		dbms_output.put_line(employees.first_name ||' '|| employees.last_name ||' Sueldo ' || employees.salary);
	END LOOP;
	close jobsList;
	close employeeList;
END;

DECLARE
    CURSOR cursorTrabajos(filtro hr.jobs.min_salary%TYPE) IS
        SELECT job_id, job_tittle, min_salary, max_salary
        FROM hr.jobs
        WHERE (min_salary >= filtro)
        ORDER BY job_titlle;
    
    CURSOR cursorEmp(filtroTrabajo hr.employees.job_id&TYPE) IS
        SELECT first_name, last_name, salary
        FROM hr.employees
        WHERE job_id = filtroTrabajo;
BEGIN
    dbms_output.put_line('TRABAJOS');
    
    FOR regTrab IN cursorTrabajos(5000) LOOP
        dbms_output.put_line('---------------------------------------------------------');
        dbms_output.put_line(regTrab.job_title || ': Sueldo entre ' || regTrab.min_salary || ' y ' || regTrab.max_salary);
        dbms_output.put_line('---------------------------------------------------------');
        FOR regEmp IN cursorEmp(regTrab.job_id) LOOP
            dbms_output.put_line(' + Empleado: ' || regEmp.last_name || ', ' || regEmp.first_name || '. Sueldo: ' || regEmp.salary);
        END LOOP;
    END LOOP;
END;

/*Actualizar salario de empleados un 30% mas*/

DECLARE
	CURSOR cursorEmp IS
		SELECT first_name, last_name, salary
		FROM employees
		FOR UPDATE OF salary NOWAIT;
BEGIN
	FOR regEmp IN cursorEmp LOOP
		IF (regEmp.salary < 2600) THEN
			dbms_output.put_line('Empleado ' || regEmp.last_name || ' ' || regEmp.first_name || '. Para ganar ' || regEmp.salary || '  a ganar ' || regEmp.salary * 1.30);
			UPDATE employees SET salary = salary * 1.30
			WHERE CURRENT OF cursorEmp;
		END IF;
	END LOOP;
	COMMIT;
END;