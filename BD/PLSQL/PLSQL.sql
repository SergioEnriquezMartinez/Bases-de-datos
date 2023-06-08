
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

--el paquete en cuestion:

CREATE OR REPLACE PACKAGE paquete1 
IS 
    v_cont NUMBER(2) := 0;
    PROCEDURE reset_cont (v_nuevo_cont NUMBER); 
    FUNCTION devolver_cont RETURN NUMBER; 
END paquete1;


CREATE OR REPLACE PACKAGE BODY paquete1 
IS 
    PROCEDURE reset_cont (v_nuevo_cont NUMBER) IS 
    BEGIN 
    v_cont := v_nuevo_cont; 
    END reset_cont; 

    FUNCTION devolver_cont RETURN NUMBER IS 
    BEGIN 
    RETURN v_cont; 
    END devolver_cont;
END paquete1;

--empezamos a hacer cositas con el paquete

DECLARE
    contador NUMBER(2);
BEGIN
    paquete1.reset.cont(10);
    SELECT paquete1.devolver_cont() INTO contador FROM DUAL;
    DBMS_OUTPUT.PUT_LINE('El contador es: ' || contador);
END;

--OTRA FORMA DE HACER ESTO:

DECLARE
    contador NUMBER(2);
BEGIN
    paquete1.reset.cont(0);
    contador := paquete1.devolver_cont();
    DBMS_OUTPUT.PUT_LINE('El contador es: ' || contador);
END;

--Y OTRA FORMA ADICIONAL:

DECLARE
    contador NUMBER(2);
BEGIN
    paquete1.v_cont := 16;
    contador := paquete1.devolver_cont();
    DBMS_OUTPUT.PUT_LINE('El contador es: ' || contador);
END;

/*
Crear un paquete que tenga lo siguiente:
 - una variable versión 
 - un procedimiento que me muestre el valor de la versión
 - una función suma que sume dos números y devuelva la SUMA
 - una función resta que reste dos números y devuelva la RESTA
 - una función multiplica que multiplique dos números y devuelva la MULTIPLICACIÓN
 - una función divide que divida dos números y devuelva la DIVISIÓN
*/

CREATE OR REPLACE PACKAGE paquete2
IS
    v_version NUMBER := 1.0;
    PROCEDURE mostrarInfo;
    FUNCTION suma(a NUMBER, b NUMBER) RETURN NUMBER;
    FUNCTION resta(a NUMBER, b NUMBER) RETURN NUMBER;
    FUNCTION multiplica(a NUMBER, b NUMBER) RETURN NUMBER;
    FUNCTION divide(a NUMBER, b NUMBER) RETURN NUMBER;
END paquete2;

CREATE OR REPLACE PACKAGE BODY paquete2
IS
    PROCEDURE mostrarInfo (v_version) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(v_version);
    END;

    FUNCTION suma(a NUMBER, b NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN (a + b);
    END;

    FUNCTION resta(a NUMBER, b NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN (a - b);
    END;
    
    FUNCTION multiplica(a NUMBER, b NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN (a * b);
    END;
    
    FUNCTION divide(a NUMBER, b NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN (a / b);
    END;
END paquete2;

/*---------------TRIGGERS------------------*/

CREATE OR REPLACE TRIGGER trAltaEmp
    BEFORE INSERT ON employees
BEGIN
    IF (TO_CHAR(SYSDATE, 'HH24')) NOT IN ('10', '11', '12') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error, solo se puede dar de alta Empleados entre las 10 y las 12:59');
    END IF;
END;

ALTER TRIGGER trAltaEmp ENABLE;

INSERT INTO employees(employee_id, first_name, last_name, email, hire_date, job_id, salary)
VALUES (998, 'Luis', 'Fernandez', 'luis.fernandez', '03/02/2015', 'ST_MAN', 7000);

------------------------------------------------------------------






-------------------------------------------------------------------

CREATE TABLE SUBIDAS_SUELDO(
    subidas_sueldo_id number(6) constraint sub_sue_pk primary key,
    employee_id number(6),
    first_name varchar2(20),
    last_name varchar2(25),
    old_salary number(8,2),
    new_salary number(8,2),
    fecha date
);

CREATE SEQUENCE seq_subidas_sueldo
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trCambioSueldo
    BEFORE UPDATE OF salary
    ON employees
    FOR EACH ROW
    WHEN (OLD.salary < NEW.salary)
BEGIN
    INSERT INTO SUBIDAS_SUELDO
    VALUES (seq_subidas_sueldo.nextval,
    :OLD.employee_id,
    :OLD.first_name,
    :OLD.last_name,
    :OLD.salary, :NEW.salary, SYSDATE);
END;

UPDATE employees
SET salary = salary + 100
WHERE employee_id = 100;


/*
1. Crea una tabla llamada CAMBIOS con cuatro campos:
NUMERO: entero clave primaria
TIPO: cadena de hasta 80 caracteres
USUARIO: cadena de hasta 20 caracteres
MOMENTO: cadena de 14 caracteres (dia-mes-año hora:min)
*/
CREATE TABLE
    cambios (
        numero int primary key,
        tipo varchar2(80),
        usuario varchar2(20),
        momento varchar2(14)
    );


/*
2. Crea una secuencia llamada SAP que servirá para dar valores automáticamente al campo
NUMERO y que avance de 1 en 1 
*/
CREATE SEQUENCE SAP START WITH 1 INCREMENT BY 1;

/*
3. Asocia a la tabla PRODUCTOS un trigger llamado AL_PRO que:
a. Creará un nuevo registro en CAMBIOS cada vez que se introduce un nuevo registro en PRODUCTOS
b. En el campo TIPO almacenará el texto “alta de productos”
c. En el campo MOMENTO se almacenará la fecha y la hora
*/
CREATE OR REPLACE TRIGGER AL_PRO AFTER INSERT ON PRODUCTO 
BEGIN 
	INSERT INTO
	    CAMBIOS(NUMERO, TIPO, USUARIO, MOMENTO)
	VALUES (
	        SAP.NEXTVAL,
	        'ALTA DE PRODUCTO',
	        USER,
	        TO_CHAR(SYSDATE, 'DD-MM-YY HH24:MI')
	    );
END; 

/*
4. Asocia a la tabla CLIENTES un trigger llamado ABC que:
a. Se ejecutará cada vez que se lleve a cabo una operación de inserción o borrado de registros en la misma
b. Creará un nuevo registro en CAMBIOS almacenando en TIPO el texto ‘alta o baja de clientes’
*/

--Volvemos a crear el sap del ejercicio 2

CREATE OR REPLACE TRIGGER abc
AFTER INSERT OR DELETE ON cliente
DECLARE
    tip cambios.tipo%TYPE;
BEGIN
    IF INSERTING
    THEN
        tip := 'Alta cliente';
    ELSIF DELETING
    THEN
        tip := 'Baja cliente';
    END IF;

    INSERT INTO cambios(numero, tipo, usuario, momento)
    VALUES (sap.NEXTVAL, 'alta cliente', USER, TO_CHAR(SYSDATE, 'DD-MM-YY HH24:MI'));
END; 


/*
5. Crea una tabla PEDIDOS con tres campos:
CLIENTE: contiene la clave de un cliente
PRODUCTO: contiene el código de un producto
CANTIDAD: entero positivo 
*/

CREATE OR REPLACE TABLE pedidos(
    cliente NUMBER(2) REFERENCES cliente(codigo_cliente),
    producto VARCHAR2(15) REFERENCES producto(codigo_producto),
    cantidad NUMBER(5) CHECK (cantidad > 0),
    CONSTRAINT pedidos_pk PRIMARY KEY (cliente, producto, cantidad)
);


/*
6. Asocia a la tabla PEDIDOS un trigger llamado AB_PED que:
a. Creará un nuevo registro en CAMBIOS cada vez que se ejecute una orden que añadan o eliminen registros de de la tabla PEDIDOS
b. En el campo TIPO se almacenará el texto ‘inserción de pedidos’, o ‘borrado de pedidos’ según corresponda 
*/

CREATE OR REPLACE TRIGGER AB_PED
AFTER INSERT OR DELETE ON pedidos
DECLARE
    tip:= cambios.tipo%TYPE;
BEGIN
    IF INSERTING THEN
        tip:='Insercción de pedidos';
    ELSIF DELETING THEN
        tip:='Borrado de pedidos';
    END IF;

    INSERT INTO cambios(numero, tipo, usuario, momento)
    VALUES (sap.NEXTVAL, tip, USER, TO_CHAR('DD-MM-YY HH24:MI'));
END;

--Inserción
INSERT INTO pedidos
VALUES (1, '11679', 50);
--Borrado
DELETE FROM pedidos
WHERE cliente = 1;

/*
7. Asocia a la tabla PRODUCTOS un trigger llamado CAM_PRE que:
a. Creará un nuevo registro en CAMBIOS cada vez que se ejecute una orden que modifique el valor de la columna PRECIO de PRODUCTOS
b. Almacenará en TIPO el texto ‘cambio de precios’ 
*/

CREATE OR REPLACE TRIGGER cam_pre
AFTER INSERT OR DELETE ON productos
BEGIN
    INSERT INTO cambios(numero, tipo, usuario, momento)
    VALUES (sap.NEXTVAL, 'Cambio de precios', USER, TO_CHAR('DD-MM-YY HH24:MI'));
END;

UPDATE producto
SET precio_venta = 20
WHERE codigo_producto = '11679';

/*
8. Asocia a la tabla PEDIDOS un trigger llamado CAM_PED que:
a. Creará un registro en CAMBIOS cada vez que se ejecute una orden que modifique el contenido del campo PRODUCTO o el campo CANTIDAD
b. Almacenará en TIPO el texto ‘cambio de producto o cantidad’ 
*/

CREATE OR REPLACE TRIGGER CAM_PED
AFTER UPDATE OF PRODUCTO, CANTIDAD ON PEDIDOS
DECLARE
BEGIN 
	INSERT INTO CAMBIOS(NUMERO, TIPO, USUARIO, MOMENTO)
	VALUES (SAP.NEXTVAL, 'CAMBIO_PRODUCTO', USER, TO_CHAR(SYSDATE, 'DD-MM-YY HH24:MI'));
END; 

update pedidos set cantidad = 20 where cliente = 1;

select * from cambios

/*
9. Asocia a la tabla PEDIDOS un trigger llamado FD_PED que:
a. Creará un registro en CAMBIOS por cada uno de los registros que se eliminen en PEDIDOS
b. Almacenará en TIPO el texto ‘Se ha borrado un pedido’ 
*/

CREATE OR REPLACE TRIGGER FD_PED
AFTER DELETE ON PEDIDOS FOR EACH ROW DECLARE BEGIN
INSERT INTO CAMBIOS(NUMERO, TIPO, USUARIO, MOMENTO)
VALUES (SAP.NEXTVAL, 'SE HA BORRADO UN PEDIDO', USER, TO_CHAR(SYSDATE, 'DD-MM-YY HH24:MI'));
END;

/*
10. Asocia a la tabla PRODUCTO un trigger FU_PRO que:
a. Creará un nuevo registro en CAMBIOS cada vez que se cambie el precio_venta en un registro de PRODUCTO
b. Almacenará en TIPO el texto ‘El precio de nombre pasa de precio_i a precio_f’
*/

CREATE OR REPLACE TRIGGER fu_pro
AFTER UPDATE OF precio_venta ON producto
FOR EACH ROW WHEN(OLD.precio_venta != NEW.precio_venta)

DECLARE
    tip cambios.tipo%TYPE;
BEGIN
    tip := 'el precio de ' || :OLD.nombre || ' pasa de ' || :OLD.precio_venta || ' a ' || :NEW.precio_venta;
    INSERT INTO CAMBIOS(NUMERO, TIPO, USUARIO, MOMENTO)
	VALUES (SAP.NEXTVAL, tip, USER, TO_CHAR(SYSDATE, 'DD-MM-YY HH24:MI'));
END;


/*
11. Asocia a la tabla CLIENTE un trigger llamado FD_CLI que:
a. Creará un nuevo registro en CAMBIOS cada vez que se borre un cliente
b. Almacenará en TIPO el texto ‘Borrado el cliente CODIGO CLIENTE llamado NOMBRE CLIENTE’ 
*/

CREATE OR REPLACE TRIGGER fd_cli
AFTER DELETE ON cliente
FOR EACH ROW
DECLARE
    tip cambios.tipo%TYPE;
BEGIN
    tip := 'Borrado el cliente: ' || :OLD.codigo_cliente || ' llamado ' || :OLD.nombre_cliente;
    INSERT INTO cambios(numero, tipo, usuario, momento)
    VALUES (sap.NEXTVAL, tip, USER, TO_CHAR(SYSDATE, 'DD-MM-YY 24HH:MI'));
END;

/*
12. Asocia a la tabla PRODUCTO un trigger FI_PRO que:
a. Si se intenta dar de alta un producto con un precio superior a 100 le asigne un precio de 50 
*/

CREATE OR REPLACE TRIGGER fd_pro
AFTER INSERT ON productos
FOR EACH ROW WHEN NEW.precio_producto > 100
DECLARE
    tip := 'Error en la inserción'
BEGIN
    UPDATE producto
    SET precio_venta = 50
    WHERE :OLD.precio_venta > 100;
END;

INSERT INTO productos VALUES(6, 'plato', '10CM', 'Leroy', 100, 120, 99);