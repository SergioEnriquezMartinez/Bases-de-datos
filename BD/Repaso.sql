CREATE TABLE departamentos (
  id_departamento NUMBER(10) PRIMARY KEY,
  nombre_departamento VARCHAR2(50)
);

CREATE TABLE empleados (
  id_empleado NUMBER(10) PRIMARY KEY,
  nombre_empleado VARCHAR2(50),
  salario NUMBER(10, 2),
  id_departamento NUMBER(10),
  CONSTRAINT fk_empleados_departamentos FOREIGN KEY (id_departamento) REFERENCES departamentos (id_departamento)
);

CREATE TABLE ventas (
  id_venta NUMBER(10) PRIMARY KEY,
  fecha DATE,
  id_empleado NUMBER(10),
  cantidad NUMBER(10, 2),
  CONSTRAINT fk_ventas_empleados FOREIGN KEY (id_empleado) REFERENCES empleados (id_empleado)
);

INSERT INTO departamentos VALUES (1, 'Ventas');
INSERT INTO departamentos VALUES (2, 'Marketing');
INSERT INTO departamentos VALUES (3, 'Contabilidad');

INSERT INTO empleados VALUES (1, 'Juan Pérez', 1500, 1);
INSERT INTO empleados VALUES (2, 'María Gómez', 2000, 2);
INSERT INTO empleados VALUES (3, 'Pedro Rodríguez', 1800, 3);
INSERT INTO empleados VALUES (4, 'Laura Martínez', 1700, 1);
INSERT INTO empleados VALUES (5, 'Luisa Sánchez', 1900, 2);

INSERT INTO ventas VALUES (1, TO_DATE('01/01/2022', 'DD/MM/YYYY'), 1, 100);
INSERT INTO ventas VALUES (2, TO_DATE('01/01/2022', 'DD/MM/YYYY'), 2, 200);
INSERT INTO ventas VALUES (3, TO_DATE('01/01/2022', 'DD/MM/YYYY'), 3, 300);
INSERT INTO ventas VALUES (4, TO_DATE('01/01/2022', 'DD/MM/YYYY'), 4, 400);
INSERT INTO ventas VALUES (5, TO_DATE('01/01/2022', 'DD/MM/YYYY'), 5, 500);

/*1. Escribe un bloque PL/SQL que obtenga el salario y la comisión del empleado 2 y los muestro por pantalla.

El salario del empleado 2 es 2000*/

DECLARE
    v_salario empleados.salario%TYPE;
BEGIN
    SELECT salario INTO v_salario
    FROM empleados
    WHERE id_empleado = 2;
    dbms_output.put_line('El salario es: ' || v_salario);
END;

/*2. Escribe un bloque PL/SQL que utilice un cursor para mostrar el nombre y el salario
de todos los empleados que trabajan en el departamento de ventas.

El empleado Juan Pérez tiene un salario de 1500 
El empleado Laura Martínez tiene un salario de 1700*/

DECLARE
    CURSOR cEmpleadosInfo IS
        SELECT nombre_empleado, salario
        FROM empleados e
        JOIN departamentos d ON e.id_departamento = d.id_departamento
        WHERE nombre_departamento LIKE 'Ventas';
BEGIN
    FOR rEmpleadosInfo IN cEmpleadosInfo LOOP
        dbms_output.put_line('El empleado ' || rEmpleadosInfo.nombre_empleado || ' tiene un salario de ' || rEmpleadosInfo.salario);
    END LOOP;
END;

/*3. Escribe un bloque PL/SQL que utilice un cursor con parámetros para mostrar el nombre y el salario
de todos los empleados que trabajan en el departamento de Marketing. 

El departamento se debe pasar por parámetro.

El empleado María Gómez tiene un salario de 2000 
El empleado Luisa Sánchez tiene un salario de 1900*/

DECLARE
    CURSOR cEmpleadosInfo(v_departamento departamentos.nombre_departamento%TYPE) IS
        SELECT nombre_empleado, salario
        FROM empleados e
        JOIN departamentos d ON e.id_departamento = d.id_departamento
        WHERE nombre_departamento LIKE v_departamento;
BEGIN
    FOR rEmpleadosInfo IN cEmpleadosInfo('Marketing') LOOP
        dbms_output.put_line('El empleado ' || rEmpleadosInfo.nombre_empleado || ' tiene un salario de ' || rEmpleadosInfo.salario);
    END LOOP;
END;

/*4. Queremos obtener los datos del empleado 3, y mostrarlos por pantalla utilizando ROWTYPE. La salida será la siguiente: 

Datos del empleado: 
ID de Empleado: 3 
Nombre: Pedro Rodríguez 

Salario: 1800*/

DECLARE
  CURSOR cEmpleados IS
    SELECT id_empleado, nombre_empleado, salario
    FROM empleados
    WHERE id_empleado = 3;
  registro empleados%ROWTYPE;
BEGIN
  FOR registro IN cEmpleados LOOP
    dbms_output.put_line('Datos del empleado: ');
    dbms_output.put_line('Id del empleado: ' || registro.id_empleado);
    dbms_output.put_line('Nombre: ' || registro.nombre_empleado);
    dbms_output.put_line('Salario: ' || registro.salario);
  END LOOP;
END;


/*5. Queremos actualizar los salarios de los empleados que trabajan en el departamento 'Ventas'
y que ganan menos de 5000. Les queremos subir un 2%.*/

UPDATE empleados SET salario WHERE nombre_departamento LIKE 'Ventas';

DECLARE
  CURSOR cEmpleados IS
    SELECT *
    FROM empleados e
    JOIN departamentos d
    ON e.id_departamento = d.id_departamento
    WHERE nombre_departamento LIKE 'Ventas';
BEGIN
  FOR rEmpleados IN cEmpleados LOOP
    IF (rEmpleados.salario < 5000) THEN
      UPDATE empleados SET salario = salario * 1.02;
    END IF;
  END LOOP;
END;