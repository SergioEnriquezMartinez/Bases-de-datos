-- departamentos
CREATE TABLE departamentos (
	numde NUMBER(3) PRIMARY KEY,				
	nomde VARCHAR2(30)
);
-- empleados
CREATE TABLE empleados (
	numem NUMBER(3) PRIMARY KEY,
	fechna DATE,
	fechini DATE,
	salario NUMBER(5),
	comision NUMBER(3),
	numhi NUMBER(1),
	nomem VARCHAR2(30),
	numde NUMBER(3) REFERENCES departamentos (numde)
);

INSERT INTO departamentos VALUES(100,'DIRECCIÓN GENERAL');
INSERT INTO departamentos VALUES(110,'DIRECC.COMERCIAL');
INSERT INTO departamentos VALUES(111,'SECTOR INDUSTRIAL');
INSERT INTO departamentos VALUES(112,'SECTOR SERVICIOS');
INSERT INTO departamentos VALUES(120,'ORGANIZACIÓN');
INSERT INTO departamentos VALUES(121,'PERSONAL');
INSERT INTO departamentos VALUES(122,'PROCESO DE DATOS');
INSERT INTO departamentos VALUES(130,'FINANZAS');

INSERT INTO empleados VALUES(110, TO_DATE('10/11/1970', 'dd/mm/yyyy'), TO_DATE('15/02/1985', 'dd/mm/yyyy'),1800,NULL,3,'CESAR', 121);
INSERT INTO empleados VALUES(120, TO_DATE('09/06/1968', 'dd/mm/yyyy'), TO_DATE('01/10/1988', 'dd/mm/yyyy'),1900,110,1,'MARIO', 112);
INSERT INTO empleados VALUES(130, TO_DATE('09/09/1965', 'dd/mm/yyyy'), TO_DATE('01/02/1981', 'dd/mm/yyyy'),1500,110,2,'LUCIANO', 112);
INSERT INTO empleados VALUES(150, TO_DATE('10/08/1972', 'dd/mm/yyyy'), TO_DATE('15/01/1997', 'dd/mm/yyyy'),2600,NULL,0,'JULIO', 121);
INSERT INTO empleados VALUES(160, TO_DATE('09/07/1980', 'dd/mm/yyyy'), TO_DATE('11/11/2005', 'dd/mm/yyyy'),1800,110,2,'AUREO', 111);
INSERT INTO empleados VALUES(180, TO_DATE('18/10/1974', 'dd/mm/yyyy'), TO_DATE( '18/03/1996', 'dd/mm/yyyy'),2800,50,2,'MARCOS', 110);
INSERT INTO empleados VALUES(190, TO_DATE('12/05/1972', 'dd/mm/yyyy'), TO_DATE('11/02/1992', 'dd/mm/yyyy'),1750,NULL,4,'JULIANA', 121);
INSERT INTO empleados VALUES(210, TO_DATE('28/09/1970', 'dd/mm/yyyy'), TO_DATE('22/01/2018', 'dd/mm/yyyy'),1910,NULL,2,'PILAR', 100);
INSERT INTO empleados VALUES(240, TO_DATE('26/02/1967', 'dd/mm/yyyy'), TO_DATE('24/02/1989', 'dd/mm/yyyy'),1700,100,3,'LAVINIA',111);
INSERT INTO empleados VALUES(250, TO_DATE('27/10/1976', 'dd/mm/yyyy'), TO_DATE('01/03/1997', 'dd/mm/yyyy'),2700,NULL,0,'ADRIANA',100);
INSERT INTO empleados VALUES(260, TO_DATE('03/12/1973', 'dd/mm/yyyy'), TO_DATE('12/07/2001', 'dd/mm/yyyy'),720,NULL,6,'ANTONIO',100);
INSERT INTO empleados VALUES(270, TO_DATE('21/05/1975', 'dd/mm/yyyy'), TO_DATE('10/09/2003', 'dd/mm/yyyy'),1910,80,3,'OCTAVIO',112);
INSERT INTO empleados VALUES(280, TO_DATE('10/01/1978', 'dd/mm/yyyy'), TO_DATE('08/10/2010', 'dd/mm/yyyy'),1500,NULL,5,'DOROTEA',130);
INSERT INTO empleados VALUES(285, TO_DATE('25/10/1979', 'dd/mm/yyyy'), TO_DATE('15/02/2011', 'dd/mm/yyyy'),1910,NULL,0,'OTILIA',122);
INSERT INTO empleados VALUES(290, TO_DATE('30/11/1967', 'dd/mm/yyyy'), TO_DATE('14/02/1988', 'dd/mm/yyyy'),1790,NULL,3,'GLORIA',120);
INSERT INTO empleados VALUES(310, TO_DATE('21/11/1976', 'dd/mm/yyyy'), TO_DATE('15/01/2001', 'dd/mm/yyyy'),1950,NULL,0,'AUGUSTO',130);
INSERT INTO empleados VALUES(320, TO_DATE('25/12/1977', 'dd/mm/yyyy'), TO_DATE('05/02/2003', 'dd/mm/yyyy'),2400,NULL,2,'CORNELIO',122);
INSERT INTO empleados VALUES(330, TO_DATE('19/08/1958', 'dd/mm/yyyy'), TO_DATE('01/03/1915', 'dd/mm/yyyy'),1700,90,0,'AMELIA',112);
INSERT INTO empleados VALUES(350, TO_DATE('13/04/1979', 'dd/mm/yyyy'), TO_DATE('10/09/1999', 'dd/mm/yyyy'),2700,NULL,1,'AURELIO',122);
INSERT INTO empleados VALUES(360, TO_DATE('29/10/1978', 'dd/mm/yyyy'), TO_DATE('10/10/1919', 'dd/mm/yyyy'),1800,100,2,'DORINDA',111);
INSERT INTO empleados VALUES(370, TO_DATE('22/06/1977', 'dd/mm/yyyy'), TO_DATE('20/01/2022', 'dd/mm/yyyy'),1860,NULL,1,'FABIOLA',121);
INSERT INTO empleados VALUES(380, TO_DATE('30/03/1978', 'dd/mm/yyyy'), TO_DATE('01/01/1999', 'dd/mm/yyyy'),1100,NULL,0,'MICAELA',112);

/*1*/

CREATE OR REPLACE PROCEDURE subirSalarios (cod IN OUT empleados.numen%TYPE, nombre IN OUT empleados.nomem%TYPE)
AS
    v_salario empleados.salario%TYPE;
    v_nuevo_salario empleados.salario%TYPE;
    exc_no_actulaizado EXCEPCION;
    PRAGMA EXCEPTION_INIT(exc_no_actulaizado, -20001);
BEGIN
    SELECT numen, nomem, salario INTO cod, nombre, salario
    FROM empleados;
    v_nuevo_salario := v_salario * 1.10;

    UPDATE empleados SET salary = v_nuevo_salario
    WHERE numhi > 2 AND salario < 2000;

    IF SQL%NOTFOUND THEN
        RAISE ex_salario_invalido;
    END IF;
EXCEPCION
    WHEN ex_salario_invalido THEN
        DBMS_OUTPUT.PUT_LINE('La actualización no ha sido completada.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ha habido un error inesperado.');
END;


/*2*/

CREATE OR REPLACE PROCEDURE dpto_empleados_Hijos (codDep IN OUT empleados.numde%TYPE, hijos IN OUT empleados.numhi%TYPE)
AS
    codEmp empleados.numem%TYPE;
    nombre empleados.nomem%TYPE;
BEGIN
    SELECT numem, nomem, numde, numhi INTO codEmp, nombre, codDep, hijos
    FROM empleados WHERE numde = codDep AND numhi = hijos;

    DBMS_OUTPUT.PUT_LINE('El empleado con número ' || codEmp || ' es ' || nombre || ' tiene ' || hijos || ' hijos y pertenece al departamento ' || codDep);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No existen empleados con ese id.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error inesperado.');
END;

exec dpto_empleados_Hijos(111, 2);


/*3*/

/*CREATE OR REPLACE FUNCION (codEmp empleados.numem%TYPE) RETURN DATE AS
    fechaNacimiento empleados.fechna%TYPE;
    PRAGMA EXCEPTION_INIT()
BEGIN
    SELECT fechna 
*/




/*4*/

CREATE OR REPLACE PACKAGE gestion AS
    PROCEDURE crearDepartamentos(codDep IN departamentos.numde%TYPE, nombre IN departamentos.nomde%TYPE);
    PROCEDURE mostrarNombreDepartamento(codDep IN departamentos.numde%TYPE);
END;

CREATE OR REPLACE PACKAGE BODY gestion AS
    PROCEDURE crearDepartamentos(codDep IN departamentos.numde%TYPE, nombre IN departamentos.nomde%TYPE) AS
    BEGIN
        SELECT numde, nomde FROM departamentos;

        IF codDep = departamenos.numde THEN
            DBMS_OUTPUT.PUT_LINE('El departamento ya existe');
        ELSE THEN
            RAISE NO_DATA_FOUND;
        END IF;
    EXCEPCION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO departamentos VALUES (codDep, nombre);
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error.');
    END;

    PROCEDURE mostrarNombreDepartamento(codDep IN departamentos.numde%TYPE) AS
    BEGIN
        SELECT numde, nomde FROM departamentos;

        IF codDep = departamentos.numde THEN
            DBMS_OUTPUT.PUT_LINE('Num.Dpto: ' || numde || ' - Nombre Dpto: ' || nomde);
        ELSE THEN
            RAISE NO_DATA_FOUND;
        END IF;
    EXCEPCION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No existe ningun departamento con ese nombre.');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error.');
    END;
END;
        

/*5*/

CREATE TABLE OR REPLACE auditoria_emple (descripcion VARCHAR2(200));

CREATE OR REPLACE TRIGGER indelEmpleado
AFTER INSERT OR DELETE ON empleados
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO auditoria_emple
        VALUES ('Insert'); 
    ELSIF DELETING THEN
        INSERT INTO auditoria_emple
        VALUES ('Delete');
    END IF;
END;