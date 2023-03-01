CREATE DATABASE AlonsoDeMadrigal;

USE AlonsoDeMadrigal;

CREATE TABLE Ciclos (
    idCiclo INT PRIMARY KEY,
    ciclo VARCHAR(10) NOT NULL
);

CREATE TABLE Alumnos (
    idAlumno INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    fecNac DATE,
    telefono INT(9),
    codCiclo INT,
    FOREIGN KEY (codCiclo) REFERENCES Ciclos (idCiclo)
);

INSERT INTO Ciclos (idCiclo, ciclo)
VALUES (1, 'DAW1');

SET AUTOCOMMIT = 0;

INSERT INTO Ciclos (idCiclo, ciclo)
SELECT 2, 'DAW2';

COMMIT;

SELECT * FROM Ciclos;

INSERT INTO Ciclos (idCiclo, ciclo)
SELECT MAX(idCiclo) + 1, 'ASIR1'
FROM Ciclos;

INSERT INTO Ciclos
SELECT MAX(idCiclo) + 1, 'ASIR2'
FROM Ciclos;

INSERT INTO Alumnos
SELECT MAX(idAlumno) + 1, 'Sergio Enriquez', 'sergioenmar@gmail.com', STR_TO_DATE('14/02/1995', '%d/%m/%Y'), 605651471, 1
FROM Alumnos;

INSERT INTO Alumnos
SELECT MAX(idAlumno) + 1, 'Pepe', 'pepe@gmail.com', STR_TO_DATE('24/12/2002', '%d/%m/%Y'), 111222333, 2, null
FROM Alumnos;
INSERT INTO Alumnos
SELECT MAX(idAlumno) + 1, 'Pepa', 'pepa@gmail.com', STR_TO_DATE('25/12/2002', '%d/%m/%Y'), 444555666, 3, null
FROM Alumnos;
INSERT INTO Alumnos
SELECT MAX(idAlumno) + 1, 'Jacinto', 'jacinto@gmail.com', STR_TO_DATE('26/12/2002', '%d/%m/%Y'), 777888999, 4, null
FROM Alumnos;

SELECT * FROM Alumnos;

ALTER TABLE Alumnos ADD direccion VARCHAR(50);

UPDATE Alumnos
SET direccion = 'C/ Juan Grande s/n';

COMMIT;

UPDATE Alumnos
SET telefono = 123456789
WHERE codCiclo = (SELECT idCiclo FROM Ciclos WHERE ciclo = 'DAW1');

UPDATE Alumnos
SET nombre = CONCAT('N', nombre), email = CONCAT('n', email);

CREATE TABLE Asignaturas (
    idAsignatura INT PRIMARY KEY,
    asignatura VARCHAR(15),
    codCiclo INT REFERENCES Ciclos (idCiclo)
);

INSERT INTO Asignaturas
VALUES(1, 'Programacion', 1),
(2, 'Leng. Marcas', 1),
(3, 'FOL', 1),
(4, 'Sistemas JJ', 1),
(5, 'BD', 1),
(6, 'Ent. Desarr.', 1);

CREATE TABLE AlumnoAsignatura (
    idAlumnoAsignatura INT PRIMARY KEY,
    codAlumno INT REFERENCES Alumnos (idAlumno),
    codAsignatura INT REFERENCES Asignaturas (idAsignatura)
);

INSERT INTO AlumnoAsignatura
SELECT (10 * al.idAlumno) + ag.idAsignatura AS id, al.idAlumno, ag.idAsignatura
FROM Alumnos al
JOIN asignaturas ag
WHERE al.codCiclo = 1;

SELECT al.nombre, ag.asignatura
FROM Alumnos al
LEFT JOIN AlumnoAsignatura aa ON aa.codAlumno = al.idAlumno
LEFT JOIN Asignaturas ag ON ag.idAsignatura = aa.codAsignatura
ORDER BY 1;

CREATE VIEW vDatosAlumnos AS
SELECT al.nombre, al.email, cl.ciclo, ag.asignatura
FROM Alumnos al
JOIN Ciclos cl ON al.codCiclo = cl.idCiclo
LEFT JOIN AlumnoAsignatura aa ON al.idAlumno = aa.codAlumno
LEFT JOIN Asignaturas ag ON ag.idAsignatura = aa.codAsignatura;

SELECT * FROM vDatosAlumnos;



-- Active: 1675155518857@@127.0.0.1@3306@alonsodemadrigal
-----PROCEDURES

DELIMITER $$
CREATE OR REPLACE PROCEDURE p_insertarAlumno(p_nombre VARCHAR(50), p_email VARCHAR(50))
BEGIN

    INSERT INTO alumnos (idAlumno, nombre, email)
    SELECT COALESCE(MAX(idAlumno), 0) + 1 AS idAlumno, p_nombre, p_email
    FROM alumnos;

    COMMIT;
END;

DELIMITER ;

--para usar procedures usamos 'call'
CALL p_insertarAlumno('nomAlumno', 'noal@educa.jcyl.es');
SELECT * FROM alumnos;


--procedure al que se le pase el mail y cambie el num asociado a ese mail
DELIMITER $$

CREATE OR REPLACE PROCEDURE p_actualizaTlfno(p_email varchar(50), p_tlfno INT)
BEGIN
    
    UPDATE alumnos
    SET telefono = p_tlfno
    WHERE email = p_email;

    COMMIT;
END

DELIMITER ;

CALL p_actualizaTlfno('noal@educa.jcyl.es', 5788849339);
SELECT * FROM alumnos;

--ahora uno que actualice la fecha de nacimiento y la direccion
--a partir del email
DELIMITER $$
CREATE OR REPLACE PROCEDURE p_actualizaNacDir(p_email VARCHAR(50), p_fecha DATE, p_direccion VARCHAR(50))
BEGIN
    
    UPDATE alumnos
    SET fechaNac = p_fecha, direccion = p_direccion
    WHERE email = p_email;

    COMMIT;
END;

DELIMITER ;

CALL p_actualizaNacDir('noal@educa.jcyl.es', '2003/06/09', 'C/Tom n5');

SELECT * FROM alumnos;

---------------------
/*
Procedimiento que reciba los datos del alumno (nombre, mail, fechaNac, 
telefono, direccion) y el nombre del ciclo al que se matricula. 
El procedimiento debe insertar dicho alumno en su tabla y tambien 
matricularlo en todas las asignaturas del ciclo.
*/
DELIMITER $$
CREATE OR REPLACE PROCEDURE p_altaAlumno(p_nombre VARCHAR(50),
                            p_email VARCHAR(50), p_fechaNac DATE,
                            p_tlfno INT, p_direccion VARCHAR(50),
                            p_ciclo VARCHAR(10))
BEGIN
    --Declaracion de variables que se van a usar
    DECLARE v_idCiclo, v_idAlumno, v_idAlumnoAsignatura INT;
    --se obtiene el identificador del ciclo cuyo nombre nos pasan como parámetro
    --tenemos que mirar el id que tiene el ciclo que nos pasan 
    --para poder hacer el insert 
    SELECT idCiclo INTO v_idCiclo
    FROM ciclos 
    
    WHERE ciclo = p_ciclo;
    --Se obtiene el ultimo idAlumno para sumar 1 y poder usarlo como id para insertarlo en la tabla alumnos
    SELECT COALESCE(MAX(idAlumno), 0) + 1 INTO v_idAlumno
    FROM alumnos;
    --Se insertan los datos en la tabla alumnos
    INSERT INTO alumnos
    VALUES(v_idAlumno, p_nombre, p_email, p_fechaNac, p_tlfno, v_idCiclo, p_direccion);
    --se obtiene el maximo id de la tabla auxiliar alumnoAsignatura para poder insertarle valores
    SELECT COALESCE(MAX(idAlumnoAsignatura), 0) INTO v_idAlumnoAsignatura
    FROM AlumnoAsignatura;
    --ahora hay que matricular al alumno en las asignaturas del ciclo:
    INSERT INTO alumnoasignatura(idAlumnoAsignatura, codAlumno, codAsignatura)
    SELECT v_idAlumnoAsignatura + idAsignatura, v_idAlumno, idAsignatura
    FROM asignaturas
    WHERE codCiclo = v_idCiclo;

    COMMIT;
END;

DELIMITER ;

CALL p_altaAlumno('NOmbre Alumno', 'email@educa.jcyl.es', STR_TO_DATE('01/03/2000', '%d&m%Y'), 654321987, 'calle juan grande s/n', 'DAW1');

select * from alumnos;





COMMIT;