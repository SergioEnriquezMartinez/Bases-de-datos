
/*EXCEPCIONES*/

/*Ejemplo captura de excepciones:*/
DECLARE
    var_salario hr.employees.salary%TYPE;
BEGIN
    SELECT salary INTO var_salario
    FROM hr.employees 
    WHERE first_name = 'Alfredo';
    dbms_output.put_line(' Salario: ' || var_salario);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Excepcion: la consulta no devuelve ningun resultado.');
    WHEN OTHERS THEN
        dbms_output.put_line('Excepcion de tipo OTROS.');
END;

/*Ejemplo del PDF, excepciones predefinidas.*/
DECLARE 
    x NUMBER := 0; 
    y NUMBER := 3; 
    res NUMBER; 
BEGIN 
    res := y/x; 
    DBMS_OUTPUT.PUT_LINE(res); 
EXCEPTION 
    WHEN ZERO_DIVIDE THEN 
        DBMS_OUTPUT.PUT_LINE('No se puede dividir por cero'); 
    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error inesperado'); 
END; 

---------------------------
/*Usando HR de nuestro script, no el propio de oracle.*/
BEGIN
    DELETE FROM departments WHERE department_name = 'Executive';
END;    

/*No puede porque sino tendria que borrar TODOS los empleados de ese departamento. Viola una FK.
ORA-02292: integrity constraint (SQL_JSATDDRFGIUJIPOMRVUOAHWIP.JHIST_DEPT_FK) violated - child record found ORA-06512: at line 2
ORA-06512: at "SYS.DBMS_SQL", line 1721*/

DECLARE
    e_integridad EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_integridad, -02292);
BEGIN
    -- Este SI deja pq no tiene trabajadores asociados --> DELETE FROM departments WHERE department_name = 'Administration';
    DELETE FROM departments WHERE department_name = 'Executive';
EXCEPTION   
    WHEN e_integridad THEN 
        DBMS_OUTPUT.PUT_LINE('No se puede eliminar el departamento porque tiene trabajadores asociados.');
END;

------------------------------------------------------
/*Funciones de uso con Excepciones:
-- SQLCODE: retorna el código de error del error ocurrido.
-- SQLERRM: devuelve el mensaje de error de Oracle asociado a ese número de error.*/
DECLARE
    e_integridad EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_integridad, -02292);
BEGIN
    DELETE FROM departments WHERE department_name = 'Executive';
EXCEPTION   
    WHEN e_integridad THEN 
        DBMS_OUTPUT.PUT_LINE('No se puede eliminar el departamento porque tiene trabajadores asociados.');
        DBMS_OUTPUT.PUT_LINE('Codigo del error de Oracle: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Mensaje del error de Oracle: ' || SQLERRM);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado.');
        DBMS_OUTPUT.PUT_LINE('Codigo del error de Oracle: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Mensaje del error de Oracle: ' || SQLERRM);
END;

-------------------------pag 35 PDF.---------------------------
/*Excepciones de usuario: excepciones que creamos nosotros.

Forma mas extensa:*-
DECLARE
    exc_no_empleado EXCEPTION;
BEGIN
    DELETE FROM employees 
    WHERE UPPER(first_name) = 'Rodrigo';
    IF(SQL%NOTFOUND) THEN
        RAISE exc_no_empleado;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Fin de ejecucion');

EXCEPTION
    WHEN exc_no_empleado THEN
        DBMS_OUTPUT.PUT_LINE('No existe el empleado');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado.');
END;

/*Mismo ej anterior reducido:*/
DECLARE

BEGIN
    DELETE FROM employees 
    WHERE UPPER(first_name) = 'Rodrigo';
    IF(SQL%NOTFOUND) THEN
        RAISE_APPLICATION_ERROR(-20001, 'No existe el empleado.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Fin de ejecucion');
END;


--------------------------------------------------
/*EXCEPCION PREFEFINIDA, DE PRAGMA:
Mostrar por pantalla los empleados de un departamento que quiero
borrar y no deja.*/

DECLARE
    CURSOR curEmp(filtroNombreDep departments.department_name%TYPE) IS
        SELECT employee_id, last_name, first_name 
        FROM employees JOIN departments USING (department_id)
        WHERE (department_name = filtroNombreDep);  

    var_nombre_dep departments.department_name%TYPE;

e_integridad EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_integridad, -2292);

BEGIN
    var_nombre_dep := 'Executive';
    DELETE FROM departments WHERE (department_name = var_nombre_dep);
EXCEPTION    
    WHEN e_integridad THEN    
        dbms_output.put_line('No se puede eliminar el Departamento porque tiene Trabajadores asociados.');
        FOR regEmp IN curEmp(var_nombre_dep) LOOP
            dbms_output.put_line(' + ' || regEmp.employee_id || ' ' || regEmp.last_name || ' ' || regEmp.first_name);
        END LOOP;
END;


/*Escribir un bloque PL/SQL en Oracle que inserte los datos en la siguiente tabla llamada "Empleados"
y maneje las siguientes excepciones:
    Create table Empleados (
        id number(2) primary key,
        nombre varchar2(100),
        salario number(10)
    );
- Si el salario insertado es negativo, debe mostrar un mensaje de error indicando que el salario debe ser
un valor positivo.
- Si se produce un error al insertar datos en la tabla, debe mostrar un mensaje de error indicando que ha
ocurrido un problema al guardar los datos.*/

CREATE TABLE Empleados (
        id NUMBER(2) PRIMARY KEY,
        nombre VARCHAR2(100),
        salario NUMBER(10)
    );

DECLARE
    v_id NUMBER(2);
    v_nombre VARCHAR2(100);
    v_salario NUMBER(10);
BEGIN
    v_id := 1;
    v_nombre := 'Juan';
    v_salario := 2000;

    IF (v_salario < 0) THEN
        RAISE VALUE_ERROR;
    END IF;

    INSERT INTO Empleados(id, nombre, salario)
    VALUES (v_id, v_nombre, v_salario);

    DBMS_OUTPUT.PUT_LINE('Los datos han sido guardados correctamente');
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Error: El salario del empleado debe ser positivo.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Ha habido un problema al guardar los datos.');
END;

/*Escribir un bloque PL/SQL en Oracle que actualice la tabla "Empleados" con el nuevo salario de un empleado
y maneje las siguientes excepciones: 
    • Si el código del empleado no existe en la tabla,
    debe mostrar un mensaje de error indicando que el empleado no se encuentra registrado. 
    • Si se produce un error al actualizar la tabla,
    debe mostrar un mensaje de error indicando que ha ocurrido un problema al actualizar los datos.*/

DECLARE

    v_id NUMBER(2);
    v_nombre VARCHAR2(100);
    v_salario NUMBER(10);

BEGIN

    v_id := 2;
    v_nombre := 'Juan';
    v_salario := 6000;

  /*IF (v_id <> ) THEN
        RAISE NO_DATA_FOUND;
    END IF;*/


    UPDATE Empleados
    SET salario = v_salario
    WHERE id = v_id;

    DBMS_OUTPUT.PUT_LINE('El salario ha sido actualizado correctamente.')

EXCEPTION

    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: El empleado no se encuentra registrado.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Ha ocurrido un problema al actualizar los datos.');

END;

/*En la tabla Empleados captura la excepción NO_DATA_FOUND cuando se intente buscar un empleado por su ID y no se encuentre en la tabla.
En la excepción deberá mostrar el id del empleado que no ha encontrado. */

DECLARE
	v_id_empleado NUMBER := 1;
	v_nombre_empleado VARCHAR2(100);
BEGIN
	SELECT nombre INTO v_nombre_empleado
	FROM empleado
	WHERE id = v_id_empleado;

	DBMS_OUTPUT.PUT_LINE('El nombre de empleado con ID ' || v_id_empleado || ' es ' || v_nombre_empleado);
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('Error: No se encontró ningún empleado con ID ' || v_id_empleado);
	WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Error: Ha ocurrido un problema al buscar el empleado con ID ' || v_id_empleado);
END;


/*Crear una excepción llamada salario_invalido y asígnala el número -20001.
Esta excepción se disparará cuando se intente insertar un empleado con un salario negativo.*/

DECLARE
    e_salario_invalido EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_salario_invalido, -20001); 
    v_salario NUMBER(10) := -200;
    v_id_empeleado NUMBER := 2;
BEGIN
    IF (v_salario > 0) THEN
        INSERT INTO Empleados VALUES(v_id_empeleado, 'Sergio', v_salario);
        DBMS_OUTPUT.PUT_LINE('Empleado insertado con éxito.');
    ELSE
        RAISE e_salario_invalido; --En este caso seria con RAISE_APLICATION_ERROR porque la excepcion supera el 20.000
    END IF;
EXCEPTION
    WHEN e_salario_invalido THEN
        DBMS_OUTPUT.PUT_LINE('Error: Ha intentado insertar un salario negativo.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Ha habido un problema al insertar el empleado.');
END;


/*PROCEDURES*/

CREATE TABLE Hotel (
    ID NUMBER(2) PRIMARY KEY,
    NHABS NUMBER(3)
);

INSERT INTO Hotel VALUES (1, 10);
INSERT INTO Hotel VALUES (2, 60);
INSERT INTO Hotel VALUES (3, 200);
INSERT INTO Hotel VALUES (99, null);

/*
crea un procedimiento en el que si ejecutamos:

BEGIN
    TAMHOTEL(1);
    TAMHOTEL(2);
    TAMHOTEL(3);
    TAMHOTEL(99);
END;

obtengamos el siguiente resultado según su tamaño:

El hotel con el ID 1 es Pequeño (El hotel tiene menos de 50 habitaciones)
El hotel con el ID 2 es Mediano (El hotel tiene entre 50 y 100 habitaciones)
El hotel con el ID 3 es Grande (El hotel tiene mas de 100 habitaciones)
El hotel con el ID 99 es de tamaño indeterminado

*/

CREATE OR REPLACE PROCEDURE TAMHOTEL (cod Hotel.ID%TYPE)
AS
    v_numHabs HOTEL.NHABS%TYPE;
BEGIN
    SELECT NHABS INTO v_numHabs
    FROM Hotel
    WHERE ID = cod;

    IF v_numHabs IS NULL THEN
        Comentario := 'de tamaño indeterminado';
    ELSEIF v_numHabs < 50 THEN
        Comentario := 'Pequeño';
    ELSEIF v_numHabs < 100 THEN
        Comentario := 'Mediano';
    ELSE 
        Comentario := 'Grande';
    END IF;
        
    DBMS_OUTPUT.PUT_LINE('El hotel con el ID ' || cod || ' es ' || Comentario);
END;

BEGIN
    TAMHOTEL(1);
    TAMHOTEL(2);
    TAMHOTEL(3);
    TAMHOTEL(99);
END;


/*PAQUETES

tiene una cabecera y un cuerpo que han de llamarse igual
la cabecera se crea con package y el cuerpo con package body
al finalizar el paquete podemos poner end nombrePaquete, al igual que en las funciones
*/

