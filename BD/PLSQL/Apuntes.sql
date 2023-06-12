----------------EXCEPCIONES PREDEFINIDAS----------------

DECLARE 

x NUMBER := 0;
y NUMBER := 3;
res NUMBER;

BEGIN 
res := y / x;
DBMS_OUTPUT.PUT_LINE(res);

EXCEPTION
WHEN ZERO_DIVIDE THEN 
    DBMS_OUTPUT.PUT_LINE('No se puede dividir por cero');

WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('Error inesperado');
END;
/

----------------EXCEPCION SIN DEFINIR----------------
DECLARE 
e_integridad EXCEPTION; 
PRAGMA EXCEPTION_INIT ( e_integridad, -02292);  <-- CODIGO ERROR DADO POR MYSQL (SE VE A LA HORA DE EJECUTAR LIVESQL)

BEGIN 
DELETE FROM piezas WHERE tipo='TU' AND modelo=6; 

EXCEPTION 
WHEN e_integridad THEN
    DBMS_OUTPUT.PUT_LINE(‘No se puede borrar esa pieza’); 
END;

----------------EXCEPCION DE USUARIO----------------
BEGIN 
DELETE FROM piezas WHERE tipo='ZU' AND modelo=26; 
IF SQL%NOTFOUND THEN 
    RAISE_APPLICATION_ERROR(-20001, 'No existe esa pieza'); <-- DAR UN CODIGO A PARTIR DE -20000
END IF; 
END; 

----------------EJEMPLOS----------------
DECLARE 
    v_id NUMBER(2);
    v_nombre VARCHAR2(100);
    v_salario NUMBER(10);
BEGIN 
    v_id := 1;
    v_nombre := 'Sara';
    v_salario := 2000;

    IF(v_salario < 0) THEN 
        RAISE VALUE_ERROR;

    END IF;

INSERT INTO empleados(id, nombre, salario) VALUES (v_id, v_nombre, v_salario);
DBMS_OUTPUT.PUT_LINE('Los datos han sido guardados correctamente.');

EXCEPTION
    WHEN VALUE_ERROR THEN 
        DBMS_OUTPUT.PUT_LINE('Error, el salario del empleado debe ser positivo.');

    WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('Error, ha habido un problema al guardar al empleado.');

END;
----------------------------------------------
DECLARE 
    v_id_tabla empleados.id%TYPE;
    v_id NUMBER(2);
    v_salario NUMBER(10);
    exc_no_empleado EXCEPTION;

BEGIN 
    v_id := 1;
    v_salario := 2000;
    SELECT id INTO v_id_tabla FROM Empleados;
    UPDATE Empleados SET salario = v_salario WHERE id = v_id;

    IF(SQL%NOTFOUND) THEN 
        raise exc_no_empleado;
    END IF;
    DBMS_OUTPUT.PUT_LINE('Se ha actualizado correctamente.');

EXCEPTION
    WHEN exc_no_empleado THEN 
        DBMS_OUTPUT.PUT_LINE('Error, el empleado no se encuentra registrado.');

    WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error, ha habido un problema al actualizar la tabla.');

END;

-------------------------------------------

DECLARE 
    ex_salario_invalido EXCEPTION;
    v_id NUMBER(2);
    v_nombre VARCHAR2(100);
    v_salario NUMBER(10);

BEGIN 
    v_id := 2;
    v_nombre := 'Juan';
    v_salario := -2000;

INSERT INTO
    empleados(id, nombre, salario) VALUES (v_id, v_nombre, v_salario);

    IF(v_salario < 0) THEN 
        RAISE_APPLICATION_ERROR(-20001, 'No puedes insertar un saldo negativo');

    END IF;
    DBMS_OUTPUT.PUT_LINE('Empleado insertado correctamente.');
END;

--------------PROCEDURES--------------

CREATE OR REPLACE PROCEDURE TAMHOTEL(IDHOT NUMBER) AS 
	v_numHab hotel.nhab%type;
BEGIN 
    SELECT nhab INTO v_numHab FROM hotel WHERE id = IDHOT;
	IF v_numHab <= 50 THEN 
        dbms_output.put_line('El hotel es pequeño');
	ELSIF v_numHab > 50 AND v_numHab <= 100 THEN 
        dbms_output.put_line('El hotel es mediano');
	ELSIF v_numHab > 100 THEN 
        dbms_output.put_line('El hotel es grande');
	ELSE 
    dbms_output.put_line('El hotel es de tamaño ideterminado');
	END IF;
END; 
---LLAMADA A LA PROCEDURE

BEGIN 
TAMHOTEL(1);
END;

EXECUTE TAMHOTEL(1);

EXEC TAMHOTEL(1);
---------------------------------------

CREATE OR REPLACE PROCEDURE SUMA(NUMERO1 IN NUMBER, NUMERO2 IN NUMBER, RESULTADO OUT NUMBER) AS 
BEGIN 
    resultado:=numero1+numero2;
END; 

DECLARE 
    resultado number;

BEGIN 
    suma(5,5,resultado);
    dbms_output.put_line(resultado);
END;
---------------------------------------
CREATE OR REPLACE PROCEDURE CONSULTAREMPLEADO(APELLIDO IN HR.EMPLOYEES.LAST_NAME%TYPE, NOMBRE OUT HR.EMPLOYEES.FIRST_NAME%TYPE, SALARIO OUT HR.EMPLOYEES.SALARY%TYPE) AS 
BEGIN
	SELECT first_name,salary INTO nombre,salario FROM hr.employees WHERE last_name LIKE apellido;
	IF SQL%NOTFOUND THEN 
        RAISE NO_DATA_FOUND;
	ELSIF SQL%ROWCOUNT > 1 THEN 
        RAISE TOO_MANY_ROWS;
	END IF;
EXCEPTION
	WHEN NO_DATA_FOUND THEN 
        dbms_output.put_line('Empleado no encontrado');
	WHEN TOO_MANY_ROWS THEN 
        dbms_output.put_line('Se encontró más de un usuario');
	WHEN OTHERS THEN 
        dbms_output.put_line('Error no encontrado');
END; 

DECLARE 
    v_nombre hr.employees.first_name%type;
    v_salario hr.employees.salary%type;
BEGIN 
    consultarEmpleado('Steve', v_nombre, v_salario);
END;


-----------------------------------------------------
CREATE OR REPLACE PROCEDURE FINANZAS(NUMEMPLEADOS OUT NUMBER, SALMIN OUT NUMBER, SALMAX OUT NUMBER, SALAVG OUT NUMBER) AS 
BEGIN
	select count(e.employee_id) as NUMEMPLEADOS, max(e.salary) as SALMAX, min(e.salary) as SALMIN,  avg(e.salary) as SALAVG into
     numempleados,  salmax, salmin, salavg
	from hr.employees e
	    join hr.departments d on e.department_id = d.department_id
	where
	    d.department_name like ('Finance');
END; 

DECLARE 
    numEmpleados number;
    maxSalary number;
    minSalary number;
    avgSalary number;
BEGIN 
FINANZAS(numEmpleados,minSalary,maxSalary,avgSalary);
dbms_output.put_line(
    numEmpleados || maxSalary || minSalary || avgSalary);
END;

--------------FUNCIONES--------------
CREATE OR REPLACE FUNCTION cuadrado (x NUMBER) RETURN NUMBER AS 
BEGIN 
    RETURN x*x; 
END;
-----------------------------------------------------
CREATE OR REPLACE FUNCTION SUMAFUNCION (num1 IN number, num2 IN number) return number AS 
    resultado NUMBER; 
BEGIN 
    resultado:=num1+num2;
    return resultado;
END;
--------------LLAMADA A UNA FUNCION:
BEGIN 
    DBMS_OUTPUT.PUT_LINE (SUMAFUNCION(5,10)); 
END; 

DECLARE
    resultado NUMBER(8,0);
BEGIN 
    resultado :=SUMAFUNCION(5,10);
    DBMS_OUTPUT.PUT_LINE (‘El resultado es: ‘ || resultado); 
END; 

--------------PAQUETES--------------
--HEAD
CREATE OR REPLACE PACKAGE paquete1 AS 
    v_cont NUMBER := 0; 
    PROCEDURE reset_cont (v_nuevo_cont NUMBER); 
    FUNCTION devolver_cont RETURN NUMBER; 
END paquete1;
--BODY
CREATE OR REPLACE PACKAGE BODY paquete1 AS 
    PROCEDURE reset_cont (v_nuevo_cont NUMBER) AS 
    BEGIN 
        v_cont:=v_nuevo_cont; 
    END reset_cont; 
    FUNCTION devolver_cont RETURN NUMBER AS 
    BEGIN 
        RETURN v_cont; 
    END devolver_cont;
END paquete1; 

--------------EJEMPLOS
CREATE OR REPLACE PACKAGE CALCULADORA AS 
    V_VERSION NUMBER :  =1.0; 
    PROCEDURE MOSTRAR_INFO; 
    FUNCTION SUMA (A NUMBER, B NUMBER) RETURN NUMBER; 
    FUNCTION RESTA (A NUMBER, B NUMBER) RETURN NUMBER; 
    FUNCTION MULTIPLICACION (A NUMBER, B NUMBER) RETURN NUMBER; 
    FUNCTION DIVIDE (A NUMBER, B NUMBER) RETURN NUMBER; 
END CALCULADORA;

CREATE OR REPLACE PACKAGE BODY CALCULADORA AS 
    PROCEDURE MOSTRAR_INFO AS 
    BEGIN 
        DBMS_OUTPUT.PUT_LINE('Paquete de operaciones. Version' || v_version);
    END MOSTRAR_INFO;
    FUNCTION suma(a NUMBER, b NUMBER) RETURN NUMBER AS 
    BEGIN
        RETURN(a + b);
    END suma;
    FUNCTION resta(a NUMBER, b NUMBER) RETURN NUMBER AS 
    BEGIN
        RETURN (a - b);
    END resta;
    FUNCTION multiplicacion (a NUMBER, b NUMBER) RETURN NUMBER AS 
    BEGIN
        RETURN (a * b);
    END multiplicacion;
    FUNCTION dividir (a NUMBER, b NUMBER) RETURN NUMBER AS 
    BEGIN
        RETURN (a / b);
    END dividir;
END calculadora;

--LLAMADA
DECLARE 
    num1 number := 2;
    num2 number := 5;
    resultado number 
BEGIN 
    calculadora.mostrar_info
    select calculadora.suma(num1, num2) into resultado from dual;
END;

--------------SEQUENCIAS--------------

CREATE SEQUENCE SAP START WITH 1 INCREMENT BY 1;


--------------TRIGGERS--------------

CREATE OR REPLACE TRIGGER AL_PRO AFTER INSERT ON PRODUCTO 
BEGIN 
	INSERT INTO
	    CAMBIOS(NUMERO, TIPO, USUARIO, MOMENTO)
	VALUES (SAP.NEXTVAL,'ALTA DE PRODUCTO',USER,TO_CHAR(SYSDATE, 'DD-MM-YY HH24:MI'));
END;

CREATE OR REPLACE TRIGGER FD_PED AFTER DELETE ON PEDIDOS FOR EACH ROW 
DECLARE 
BEGIN
    INSERT INTO CAMBIOS(NUMERO, TIPO, USUARIO, MOMENTO) VALUES (SAP.NEXTVAL,'SE HA BORRADO UN PEDIDO',USER,TO_CHAR(SYSDATE, 'DD-MM-YY HH24:MI'));
END;

CREATE OR REPLACE FI_PRO AFTER INSERT  ON PRODUCTO FOR EACH ROW WHEN (NEW.PRECIO_PRODUCTO > 100)
DECLARE
    TIPO:='ERROR EN LA INSERCION';
BEGIN
    INSERT INTO CAMBIOS (NUMERO,TIPO,USUARIO,MOMENTO) VALUES (SAP.NEXTVAL,TIPO,USER,TO_CHAR(SYSDATE, 'DD-MM-YY HH24:MI'));
    UPDATE PRODUCTO SET :NEW.PRECIO_VENTA=50 WHERE :OLD.PRECIO_VENTA > 100;
END;
