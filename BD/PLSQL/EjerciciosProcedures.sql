/*1. Crear un procedimiento que triplique un número pasado por parámetro.
A continuación, realizar la llamada al procedimiento desde un bloque PL/SQL.*/

CREATE OR REPLACE PROCEDURE tripilcar(num IN NUMBER, triple OUT NUMBER)
IS
BEGIN
    triple := 3 * num;
END;
-------------------------------------------------------------
DECLARE
    res NUMBER;
BEGIN
    tripilcar (3, res);
    DBMS_OUTPUT.PUT_LINE('El triple es: ' || res);
END;

/*2. Crear un procedimiento llamado ‘suma’ que reciba por parámetro dos números y devuelva su suma.
A continuación, realizar la llamada al procedimiento desde un bloque PL/SQL.*/

CREATE OR REPLACE PROCEDURE suma(num1 IN NUMBER, num2 IN NUMBER, sum OUT NUMBER)
IS
BEGIN
    sum := num1 + num2;
END;
-------------------------------------------------------------
DECLARE
    res NUMBER;
BEGIN
    suma (3, 5, res);
    DBMS_OUTPUT.PUT_LINE('La suma es: ' || res);
END;

/*3. Realiza la suma de dos números, pero ahora creando una función llamada ‘sumaFunción’.
A continuación, realiza la llamada a la función.*/

CREATE OR REPLACE FUNCTION sumaFuncion(num1 IN NUMBER, num2 IN NUMBER) RETURN NUMBER
IS
    resultado NUMBER(4);
BEGIN
    resultado := num1 + num2;
    RETURN resultado;
END;
------------------------------------------------------------
BEGIN
    DBMS_OUTPUT.PUT_LINE('La suma es: ' || sumaFuncion(10, 10));
END;

/*4. Crear un procedimiento llamado 'consultarEmpleado' que reciba por parámetro un apellido de un empleado
y devuelva su nombre y su salario si contiene dicho apellido.
Captura las siguientes excepciones:
• NO_DATA_FOUND: en el caso de que no haya empleados que contengan ese apellido.
• TOO_MANY_ROWS: en el caso de que haya varios empleados que contengan ese apellido.
A continuación, realizar la llamada al procedimiento desde un bloque PL/SQL*/

CREATE OR REPLACE PROCEDURE consultarEmpleado(apellido IN OUT VARCHAR2, nombre OUT VARCHAR2, salario OUT NUMBER)
IS
BEGIN
    SELECT first_name, last_name, salary INTO nombre, apellido, salario
    FROM hr.employees
    WHERE last_name LIKE apellido;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No hay ningún empleado con ese apellido.');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Hay más de un empleado con ese apellido.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado.');
END;
----------------------------------------------------------
DECLARE
    v_nombre hr.employees.first_name%TYPE;
    v_apellido hr.employees.last_name%TYPE;
    v_salario hr.employees.salary%TYPE;
BEGIN
    v_apellido := 'King';
    consultarEmpleado(v_apellido, v_nombre, v_salario);
    DBMS_OUTPUT.PUT_LINE('Empleados con el apellido ' || v_apellido || ': ' || v_nombre || ' ' || v_salario);
END;

/*5. Escribe un procedimiento llamado ‘Finanzas’ que muestre el número de empleados y el salario mínimo,
máximo y medio del departamento de FINANZAS (FINANCE).
A continuación, llama al procedimiento.*/

CREATE OR REPLACE PROCEDURE finanzas(numEmp OUT NUMBER, minSal OUT NUMBER, maxSal OUT NUMBER, avgSal OUT NUMBER) IS
BEGIN
    SELECT COUNT(employee_id), MIN(salary), MAX(salary), AVG(salary) INTO numEmp, minSal, maxSal, avgSal
    FROM hr.employees
    JOIN hr.departments USING (department_id)
    WHERE department_name LIKE 'FINANCE';
END;
-----------------------------
execute finanzas;

--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
CREATE OR REPLACE PROCEDURE Finanzas
AS
     numero NUMBER;
    maximo NUMBER;
    minimo NUMBER;
    media NUMBER;
    dpto NUMBER;
BEGIN
    SELECT DEPARTMENT_ID INTO dpto 
    FROM HR.DEPARTMENTS
    WHERE UPPER(DEPARTMENT_NAME) = 'FINANCE';

    SELECT COUNT(*), MAX(SALARY), MIN(SALARY), ROUND(AVG(SALARY), 2)
    INTO numero, maximo, minimo, media
    FROM HR.EMPLOYEES
    WHERE DEPARTMENT_ID =dpto;

    DBMS_OUTPUT.PUT_LINE('Departamento de FINANZAS');
    DBMS_OUTPUT.PUT_LINE(numero || ' Empleados');
    DBMS_OUTPUT.PUT_LINE(maximo || ' € es el salario máximo');
    DBMS_OUTPUT.PUT_LINE(minimo || ' € es el salario mínimo');
    DBMS_OUTPUT.PUT_LINE(media || ' € es el salario medio');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se han encontrado datos');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error no previsto');
END;
-------------------------------------------
exec Finanzas();

/*6. Crea una función NOTA que reciba un parámetro que será una nota numérica entre 0 y 10, y
devuelva una cadena de texto con la calificación (Suficiente, Bien, Notable, ...).*/

CREATE OR REPLACE FUNCTION nota(numNota IN NUMBER) RETURN VARCHAR2
IS
    resNota VARCHAR2(20);
BEGIN
    IF (numNota < 5) THEN
        resNota := 'Insuficiente';
    ELSIF (numNota = 5) THEN
        resNota := 'Suficiente';
    ELSIF (numNota = 6) THEN
        resNota := 'Bien';
    ELSIF (numNota = 7) THEN
        resNota := 'Muy bien';
    ELSIF (numNota = 8) THEN
        resNota := 'Notable';
    ELSIF (numNota = 9) THEN
        resNota := 'Sobresaliente';
    ELSIF (numNota = 10) THEN
        resNota := 'Matricula de honor';
    END IF;

    RETURN resNota;
END nota;

BEGIN
    DBMS_OUTPUT.PUT_LINE(nota(7));
END;