create table sucursal (
    idSuc number(3) constraint suc_idk_pk primary key,
    nombre varchar2(25) constraint suc_nom_nn not null
);

create table cliente (
    idCli number(3) constraint cli_idc_pk primary key, 
    nombre varchar2(25) constraint cli_nom_nn not null,
    priApe varchar2(25) constraint cli_pri_nn not null, 
    segApe varchar2(25)
);

/*
El saldo de la cuenta tendrá por defecto el valor 0 y almacenará números reales con 6 
dígitos para la parte entera y 2 para la parte real.
La fecha de alta de la cuenta llevará por defecto la fecha actual del sistema.
    default(SYSDATE)
*/
create table cuenta (
    idCue number(3) constraint cue_idc_pk primary key, 
    saldo number(8,2) default(0)constraint cue_sal_nn not null, 
    fechaAlta date default(SYSDATE),
    idSuc number(3) constraint cue_ids_fk references sucursal (idSuc)
                    constraint cud_ids_nn not null, 
    idCli number(3) constraint cue_idc_fk references cliente (idCli)
                    constraint cue_idc_nn not null
);

create table movimiento (
    idMov number(3) constraint mov_idm_pk primary key, 
    tipo varchar2(1) constraint mov_tip_ck check (tipo IN('I', 'R')), 
    cuantia number(7,2) constraint mov_cua_ck check (cuantia > 0), 
    idCue number(3) constraint mov_idc_fk references cuenta (idCue)
                    constraint mov_idc_nn not null
);


INSERT INTO SUCURSAL
VALUES (1, 'Principal');
INSERT INTO SUCURSAL
VALUES (2, 'Sucursal 2');

INSERT INTO SUCURSAL
VALUES (3, 'Sucursal 3');

INSERT INTO SUCURSAL
VALUES (4, 'Sucursal 4');

INSERT INTO SUCURSAL
VALUES (5, 'Sucursal 5');

INSERT INTO CLIENTE 
VALUES (1, 'Jose', 'Pérez', 'Martín');

INSERT INTO CLIENTE 
VALUES (2, 'Daniel', 'Jiménez', 'Martín');

INSERT INTO CLIENTE 
VALUES (3, 'Miguel', 'López', null);

INSERT INTO CLIENTE 
VALUES (4, 'Ramón', 'Ortiz', 'Berrocal');

INSERT INTO CLIENTE 
VALUES (5, 'Carlos', 'Díaz', 'Merino');

INSERT INTO CLIENTE 
VALUES (6, 'Ruben', 'González', 'Sánchez');

INSERT INTO CUENTA
VALUES (1, default, default, 1, 1);

INSERT INTO CUENTA
VALUES (2, 950.30, default, 2, 1);

INSERT INTO CUENTA
VALUES (3, 10580.50, default, 2, 2);

INSERT INTO CUENTA
VALUES (4, 1400, default, 1, 3);

INSERT INTO CUENTA
VALUES (5, -235.65, default, 1, 4);

INSERT INTO CUENTA
VALUES (6, 50325.80, default, 3, 5);

INSERT INTO CUENTA
VALUES (7, 480, default, 3, 5);

INSERT INTO CUENTA
VALUES (8, -4880, default, 3, 6);

INSERT INTO MOVIMIENTO
VALUES (1, 'R', 1000, 1);

INSERT INTO MOVIMIENTO
VALUES (2, 'R', 850.50, 1);

INSERT INTO MOVIMIENTO
VALUES (3, 'R', 79.85, 2);

INSERT INTO MOVIMIENTO
VALUES (4, 'I', 854.77, 2);

INSERT INTO MOVIMIENTO
VALUES (5, 'R', 2500.80, 3);

INSERT INTO MOVIMIENTO
VALUES (6, 'I', 965.10, 3);

INSERT INTO MOVIMIENTO
VALUES (7, 'R', 874.65, 4);

INSERT INTO MOVIMIENTO
VALUES (8, 'I', 900.80, 4);

INSERT INTO MOVIMIENTO
VALUES (9, 'R', 1200.80, 5);

INSERT INTO MOVIMIENTO
VALUES (10, 'R', 5000, 5);

INSERT INTO MOVIMIENTO
VALUES (11, 'I', 50, 5);

INSERT INTO MOVIMIENTO
VALUES (12, 'I', 15300.80, 6);

INSERT INTO MOVIMIENTO
VALUES (13, 'I', 35000, 6);

INSERT INTO MOVIMIENTO
VALUES (14, 'R', 765.40, 7);

INSERT INTO MOVIMIENTO
VALUES (15, 'I', 920.56, 7);



---------------------------------------------------
--- Crea la vista vsClientes que muestre el nombre y los apellidos de los clientes.
create or replace view vsClientes (nombre, priApe, segApe)
AS (
    select nombre, priApe, segApe
    from cliente
);

-- Comprueba que funciona la vista vsClientes implementando una consulta que 
-- recupere todos los clientes que contengan una A en cualquiera de sus apellidos
SELECT * FROM vsClientes
WHERE UPPER(priApe) LIKE '%A%' OR UPPER(segApe) LIKE '%A%';

--¿Se pueden modificar datos a partir de esta vista? 
--      Con la vista: trata de modificar el apellido de un cliente ¿se puede? Justifica la respuesta
--          SI se puede porque solo hay una tabla en la vista, solo hace referencia a una tabla
        UPDATE vsClientes
        SET priApe = 'Blazquez'
        WHERE nombre = 'Jose';

--      Con la vista: trata de eliminar un cliente ¿se puede? Justifica la respuesta
        DELETE FROM vsClientes
        WHERE nombre = 'Jose';

--      ORA-02292: integrity constraint (SQL_GQFFIDADRAGRDOOUHLQGSMFBR.CUE_IDC_FK) violated - child record found ORA-06512: at "SYS.DBMS_SQL", line 1721
--      No me deja porque hay una restriccion de clave foranea con la tabla CUENTA

--      Con la vista: trata de dar de alta a un cliente ¿se puede? Justifica la respuesta
        INSERT INTO vsClientes (nombre, priApe, segApe)
        VALUES ('Juan', 'Sanchidrian', 'Muñoz');
--      No me deja porque no puedo insertar NULL en una PK
--      ORA-01400: cannot insert NULL into ("SQL_GQFFIDADRAGRDOOUHLQGSMFBR"."CLIENTE"."IDCLI") ORA-06512: at "SYS.DBMS_SQL", line 1721

-- Vuelve a crear la vista vsClientes pero ahora con la opción with read only. ¿Podemos 
-- ahora modificar información a partir de esta vista? Pruébalo
create or replace view vsClientes (nombre, priApe, segApe)
AS (
    select nombre, priApe, segApe
    from cliente
)WITH READ ONLY;

UPDATE vsClientes
SET priApe = 'Perez'
WHERE nombre = 'Jose';
--  NO se podran modificar datos a traves de esta nueva vista
--  ORA-42399: cannot perform a DML operation on a read-only view 

-- Intenta crear la vista vsClientesOrdenados que muestre el nombre y los apellidos de 
-- los clientes ordenados en función del primer apellido, segundo apellido y nombre. 
-- ¿Has podido crear esta vista?
create or replace view vsClientesOrdenados (nombre, priApe, segApe)
AS (
    SELECT nombre, priApe, segApe
    FROM cliente
)
ORDER BY priApe, segApe, nombre; /*el order by tiene que ir fuera de la consulta*/

-- Muestra a partir de la vista vsClientes un listado con todos los clientes ordenados en 
-- función del primer apellido, segundo apellido y nombre.
SELECT nombre, priApe, segApe
FROM vsClientes
ORDER BY priApe, segApe, nombre;

-- Implementar consultas utilizando vistas y tablas:
--      Crea la vista vsCuentasMorosas con el saldo, la fecha de alta y el identificativo 
--      del cliente de las cuentas morosas (es decir las cuentas con un saldo negativo).
create or replace view vsCuentasMorosas (saldo, fechaAlta, idCli)
AS(
    SELECT saldo, fechaAlta, idCli 
    FROM cuenta
    WHERE saldo < 0
);

--      Utilizando la vista vsCuentasMorosas y la tabla cliente, muestra el nombre y el 
--      primer apellido de los clientes que tienen cuentas morosas y el saldo de dichas 
--      cuentas, con el formato que se indica en la imagen. La información debe 
--      aparecer ordena de tal forma que el primer cliente que aparezca sea el más 
--      “moroso”.

SELECT 'Cliente Moroso: '||nombre||' '|| priApe ||'. Saldo:' || saldo "Clientes Morosos"
FROM vscuentasmorosas JOIN cliente USING(idCli)
ORDER BY saldo ASC;

/*
- Crear una vista a partir de otra: a partir de la vista vsCuentasMorosas crear la 
vista vsCuentaMenosMorosa para mostrar únicamente, el saldo y la fecha de 
alta, de la cuenta menos “morosa” del banco (es decir, de las “morosas”, la que 
menos debe).*/

CREATE VIEW vsCuentaMenosMorosa (saldo, fechaalta) 
AS (
    SELECT saldo, fechaalta
    FROM vscuentasmorosas
    WHERE saldo = (SELECT MAX(saldo) FROM vscuentasmorosas)
);

/*
- Borra la vista vsCuentasMorosas. 
    o ¿Qué ha ocurrido con la vista vsCuentaMenosMorosa? ¿Se puede seguir 
utilizando?
*/
DROP VIEW vscuentasmorosas;
--podemos borrarla, pero la otra vista esta invalidada, no se puede usar porque
--depende de la vista que acabamos de borrar.

/*  o Y si volvemos a crear la vista vsCuentasMorosas ¿Se puede seguir 
utilizando ahora la vista vsCuentaMenosMorosa?
*/
create or replace view vsCuentasMorosas (saldo, fechaAlta, idCli)
AS(
    SELECT saldo, fechaAlta, idCli 
    FROM cuenta
    WHERE saldo < 0
);

--volviendola a crear podemos volver a usar la otra vista.

/*
- Crea la vista vsResumenSucursal que mostrará el número de cuentas y el saldo 
total de las cuentas de cada sucursal.*/
CREATE OR REPLACE VIEW vsResumenSucursal (numCuentas, saldoTotal, nombreSuc)
AS (
    SELECT COUNT(idcue), SUM(saldo), suc.nombre
    FROM cuenta
    JOIN sucursal suc USING(idsuc)
    GROUP BY suc.nombre
);

select * from vsResumenSucursal;
/*
    o ¿Podríamos modificar información a partir de esta vista? Compruébalo y
    justifica tu respuesta.*/

-- --> No se puede hacer un update, porque la vista usa funciones de grupo
-- no se pueden cambar los campos resultados de un calculo
UPDATE vsResumenSucursal
SET nombreSuc = 'Sucursal Principal'
WHERE numbreSuc = 'Principal';

-- Al crear una vista ¿para qué sirve la opción with check option?
--  o Crea una vista que te ayude mediante un ejemplo a explicar la utilidad 
--  de la opción with check option

--la vista que vamos a crear es: vsFechas
--vista que muestre las fechas en las que se dieron de alta
--cuentas con un saldo superior a 1000€
CREATE OR REPLACE VIEW vsFechas (idCue, fechaalta, saldo, idSuc, idCli)
AS (
    SELECT idcue, fechaalta, saldo, idSuc, idCli
    FROM cuenta
    WHERE saldo > 1000
)with check option;

select * from vsfechas;

--este insert funciona
INSERT INTO vsfechas(idCue, fechaalta, saldo, idSuc, idCli)
VALUES(100, TO_DATE('18/APR/2023', 'DD/MON/YY'), 3000, 1, 1);

--Este NO deja: ORA-01402: view WITH CHECK OPTION where-clause violation ORA-06512: at "SYS.DBMS_SQL", line 1721
--Necesitamos que cumpla la opcion del check, > 1000. No podemos insertar un saldo menor.
INSERT INTO vsfechas(idCue, fechaalta, saldo, idSuc, idCli)
VALUES(100, TO_DATE('18/APR/2023', 'DD/MON/YY'), 500, 1, 1);

--Este NO deja: ORA-01402: view WITH CHECK OPTION where-clause violation ORA-06512: at "SYS.DBMS_SQL", line 1721
--Necesitamos que cumpla la opcion del check, > 1000. No podemos insertar un saldo menor.
UPDATE vsFechas
SET saldo = 500
WHERE idCue = 100;

--
UPDATE vsFechas
SET saldo = 1300
WHERE idCue = 100;

/*
- Crea la vista vsIngresos para mostrar los movimientos de ingreso de dinero que 
han efectuado los clientes. Esta vista deberá mostrar el nombre completo del 
cliente, la cuantía del ingreso y el saldo total de la cuenta.
*/
CREATE OR REPLACE VIEW vsIngresos (nombre, priApe, segApe, cuantia, saldo)
AS (
    SELECT nombre, priApe, segApe, cuantia, saldo
    FROM cliente
    JOIN cuenta USING(idCli)
    JOIN movimiento USING(idcue)
    WHERE tipo = 'I'
);

select * from vsIngresos;

-- Borra la tabla movimientos
drop table movimientos;

--  o ¿Qué ha ocurrido con la vista vsIngresos? ¿Se puede seguir utilizando?
    -- no, no se puede seguir usando
--  o Y si volvemos a crear la tabla movimientos ¿Se puede seguir utilizando 
--  ahora la vista vsIngresos?
    -- si, si se puede volver a usar


