--
DECLARE 
    v_salario NUMBER(9,2); 
    v_nombre VARCHAR2(50); 
BEGIN 
	SELECT salary, first_name 
    INTO v_salario, v_nombre
	FROM hr.employees WHERE employee_id = 200; 

    DBMS_OUTPUT.PUT_LINE('El nuevo salario de ' || v_nombre ||
    ' si se incrementa en un 20% será de ' || v_salario*1.2 || ' euros'); 
END; 

--
/*
IF: Dependiendo del número de la nota indicar si es sobresaliente (9 ó 1@), notable (7 u 8),
bien (6), suficiente (5) o insuficiente (Menor a 5).
En cualquier otro caso indicar 'Nota no válida '
*/

DECLARE
	nota number(9);
BEGIN
    nota := 6;
    if (nota > 8 and nota < 11) then
    	DBMS_OUTPUT.PUT_LINE ('Sobresaliente');
    elsif (nota > 7 and nota < 9) then
        DBMS_OUTPUT.PUT_LINE ('Notable');
    elsif (nota = 6) then
        DBMS_OUTPUT.PUT_LINE ('Bien');
    elsif (nota < 6) then
        DBMS_OUTPUT.PUT_LINE ('Insuficiente');
    else
        DBMS_OUTPUT.PUT_LINE ('Nota no valida');
    end if;
END;

----------------CASE NORMAL-----------------------------------
DECLARE
	nota number(2);
BEGIN
    nota := 6;
	CASE 
    when (nota > 8 and nota < 11) then
    	DBMS_OUTPUT.PUT_LINE ('Sobresaliente');
    when (nota > 7 and nota < 9) then
        DBMS_OUTPUT.PUT_LINE ('Notable');
    when (nota = 6) then
        DBMS_OUTPUT.PUT_LINE ('Bien');
    when (nota < 5) then
        DBMS_OUTPUT.PUT_LINE ('Insuficiente');
    else DBMS_OUTPUT.PUT_LINE ('Nota no valida');
    end case;
END;

-------------CASE EJ2------------------------------------------
DECLARE
	nota number(2);
	texto varchar2(100);
BEGIN
    nota := 6;
	texto := CASE nota 
        when 10 then 'Sobresaliente'
        when 9 then 'Sobresaliente'
        when 8 then 'Notable'
        when 7 then 'Notable'
        when 6 then 'Bien'
        when 5 then 'Sufciente'
        when 4 then 'Insuficiente'
        when 3 then 'Insuficiente'
        when 2 then 'Insuficiente'
        when 1 then 'Insuficiente'
        when 0 then 'Insuficiente'
        else 'Nota no valida'
	END;
	DBMS_OUTPUT.PUT_LINE(texto);
END;

-----------MEJOR FORMA--------------------------------------------
DECLARE
	nota number(2);
	texto varchar2(100);
BEGIN
    nota := 6;
	texto := CASE  
        when nota = 10 OR nota = 9 then 'Sobresaliente'
        when nota = 8 OR nota = 7 then 'Notable'
        when nota = 6 then 'Bien'
        when nota = 5 then 'Suficiente'
        when nota <= 5 OR nota >= 0 then 'Insuficiente'
        else 'Nota no valida'
	END;
	DBMS_OUTPUT.PUT_LINE(texto);
END;

--------------BUCLE LOOP-------------------------------------------
DECLARE 
	cont NUMBER :=1; 
BEGIN 
    LOOP 
        DBMS_OUTPUT.PUT_LINE(cont); 
        EXIT WHEN cont=10; 
 		cont:=cont+1;
	END LOOP;
END;

--------------BUCLE WHILE--------------------------------------------
DECLARE 
	cont NUMBER := 1; 
BEGIN 
    WHILE (cont<=10) LOOP
        DBMS_OUTPUT.PUT_LINE(cont); 
        cont:=cont+1; 
	END LOOP; 
END; 

--------------------------------------------
BEGIN 
    FOR contador IN 1..10 LOOP
    	DBMS_OUTPUT.PUT_LINE(contador); 
	END LOOP; 
END;

BEGIN 
    FOR contador IN REVERSE 1..10 LOOP
    	DBMS_OUTPUT.PUT_LINE(contador); 
	END LOOP; 
END;
--------------------------------------------
/*
Ejercicio:
*/
create table tabla_temp(
    id number(4) primary key
);

-- LOOP Insertar los numeros del 1 al diez usando cada tipo de bucle:
DECLARE 
	cont number(4):= 1; 
BEGIN 
    LOOP 
        INSERT INTO tabla_temp values (cont);
 		cont := cont+1;
		exit when cont > 10;
	END LOOP;
END;

-- WHILE insertar los numeros de 10 en 10 hasta el 100
-- 20 30 40 50 60 70 80 90 100
DECLARE 
	cont NUMBER := 2; 
BEGIN 
    WHILE (cont<=10) LOOP
        INSERT INTO tabla_temp values (cont*10);
        cont:=cont+1; 
	END LOOP; 
END; 

-- FOR metemos los numeros de 100 en 100 hasta 1000
BEGIN 
    FOR contador IN 2..10 LOOP
        INSERT INTO tabla_temp values (contador*100);
	END LOOP; 
END;

-- Mostrar la fecha actual (usando SYSDATE)

/*
La tabla DUAL es una tabla especial de una sola columna presente de manera predeterminada 
en todas las instalaciones de bases de datos de Oracle. Se utiliza para seleccionar una 
seudocolumna como SYSDATE o USER. La tabla tiene una sola columna VARCHAR2 (1) llamada 
DUMMY que tiene un valor de 'X'.*/
DECLARE
    fecha date;
BEGIN
    SELECT SYSDATE INTO fecha FROM dual;
    DBMS_OUTPUT.PUT_LINE('Fecha actual: ' || fecha);
END;

-- BBDD HR --> Utilizando %TYPE, mostrar el nombre y apellido del empleaod 150
DECLARE
    v_nombre hr.employees.first_name%TYPE;
    v_apellido hr.employees.last_name%TYPE;
BEGIN
    SELECT first_name, last_name
    INTO v_nombre, v_apellido
    FROM hr.employees
    WHERE employee_id = 150;
    DBMS_OUTPUT.PUT_LINE('Nombre: ' || v_nombre || '. ' || 'Apellido: ' || v_apellido || '.');
END;
