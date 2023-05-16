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
CREATE OR REPLACE PROCEDURE p_altaAlumno(p_alumno VARCHAR(50),
                            p_email VARCHAR(50), p_fecha DATE,
                            p_tlfno INT, p_direccion VARCHAR(50),
                            p_ciclo VARCHAR(10))
BEGIN
    
    -- Declaración de variables que se van a usar:
    DECLARE v_idAlumno, v_idCiclo, v_idAlumnoAsignatura INT;
    
    -- Se obtiene el identificador del ciclo cuyo nombre nos pasan como parámetro.
    SELECT idCiclo INTO v_idCiclo FROM ciclos
    WHERE ciclo = p_ciclo;
    
    -- Se obtiene el último idAlumno para sumar 1 ypoder usarlo como id para insertarlo en la tabla alumnos.
    SELECT COALESCE(MAX(idAlumno), 0) + 1 INTO v_idAlumno FROM Alumnos;
    
    -- Se insertan los datos en la tabla alumnos.
    INSERT INTO alumnos
    VALUES(v_idalumno, p_alumno, p_email, p_fecha, p_tlfno, v_idciclo, p_direccion);
    
    -- Se obtiene el máximo id de la tabla auxiliar alumnoAsignatura para poder insertarle valores:
    SELECT COALESCE(MAX(idAlumnoAsignatura), 0) INTO v_idAlumnoAsignatura FROM alumnoasignaturas;
    
    -- Se insertan las asignaturas del ciclo para el nuevo alumno.
    INSERT INTO AlumnoAsignaturas(idAlumnoAsignatura, codAlumno, codAsignatura)
    SELECT v_idAlumnoAsignatura + idAsignatura, v_idalumno , idasignatura FROM asignaturas
    WHERE codciclo = v_idciclo ORDER BY idAsignatura;

    COMMIT;
END;

DELIMITER ;

call p_altaAlumno('Prueba', 'prueba@educa.jcyl.es',
     STR_TO_DATE('01/03/2000', '%d/%m/%Y'), 654738847, 'C/J', 'DAW1');

select * from alumnos;

/*
delete from alumnos 
where nombre = 'Prueba';
*/


/*
Procedimiento que elimine al alumno que se le pasa como parametro
(email). Para conservar la integridad referencial primero hay que  
eliminar sus asignaturas.
*/
DELIMITER $$
CREATE OR REPLACE PROCEDURE p_borrarAlumno(p_email VARCHAR(50))
BEGIN
    --variable para guardar el id del alumno
    DECLARE v_idAlumno INT;

    --se obtiene el id del alumno a traves del email y lo guardamos en la variable.
    SELECT idAlumno INTO v_idAlumno
    FROM alumnos
    WHERE email = p_email;

    --se eliminan las asignaturas a las que se ha matriculado el alumno
    --(para mantener la integridad referencial creada por la FK):
    delete from alumnoasignaturas
    WHERE codAlumno = v_idAlumno;

    --borramos al alumno:
    DELETE FROM alumnos
    WHERE idAlumno = v_idAlumno;

    COMMIT;
END;

DELIMITER ;

CALL p_borrarAlumno('prueba@educa.jcyl.es');

SELECT * FROM alumnos;

/*
Los procedures, se usan para lenguage DML (inserts, updates, deletes...), en las 
funciones esto no se puede hacer.
Los procedures pueden devolver 0, 1 o varios objetos 
(las funciones solo pueden devolver 1)
*/


-----
/*Procedimiento que reciba el email y devuelva el nombre del alumno
Y el ciclo en el que esta matriculado*/
DELIMITER $$
CREATE OR REPLACE PROCEDURE p_ObtenerAlumno(
    IN p_email VARCHAR(50),
    OUT p_nombre VARCHAR(50),
    OUT p_ciclo VARCHAR(10)
)
BEGIN

    SELECT a.nombre, c.ciclo INTO p_nombre, p_ciclo
    FROM alumnos a 
    JOIN ciclos c ON a.codCiclo = c.idCiclo
    WHERE a.email = p_email;

END;

DELIMITER ;

/*Procedimiento que cree la tabla Prueba (idPrueba INT PK, valores VARCHAR())
e inserte los valores: (1, 'p1'), (2, 'p2'), (3, 'p3')
Despues debe añadirse una columna fecha no nula llamada fecPrueba.
Darle a la nueva columna el valor de la fecha de hoy.
Insertar en la tabla Prueba todos los ciclos que tenemos en la tabla Ciclo.
A todos los ciclos anteriormente insertados queremos añadirles el prefijo Pru
Queremos borrar la columna fecPrueba de la tabla Pruebas
Queremos borrar todos los datos de la tabla Prueba*/
DELIMITER $$

CREATE OR REPLACE p_crearPrueba()
BEGIN

    CREATE TABLE Prueba (
        idPrueba INT PRIMARY KEY,
        valores VARCHAR(10)
    );

    INSERT INTO Prueba (idPrueba, valores)
    VALUES (1, 'p1'), (2, 'p2'), (3, 'p3');

    COMMIT;

    ALTER TABLE Prueba ADD fecPrueba DATE NOT NULL;

    COMMIT;

    UPDATE Prueba SET fechPrueba = CURRENT DATE() - 1
    WHERE idPrueba = 2; /* == UPDATE Prueba SET fechPrueba = STR_TO_DATE('07/03/2023', '%d/%m/%Y');*/

    COMMIT;

    INSERT INTO Prueba (idPrueba, valores)
    SELECT 4 + idCiclo, ciclo
    FROM Ciclos;

    COMMIT;

    UPDATE Prueba
    SET valores = CONCAT('Pru', valores)
    WHERE idPrueba > 4;

    COMMIT;

    ALTER TABLE Prueba DROP fecPrueba;

    TRUNCATE Prueba; /* == DELETE FROM Prueba;*/

END;
DELIMITER ;

DELIMITER &&

CREATE OR REPLACE FUNCTION f_idAlumno() RETURNS INT
BEGIN
    DECLARE v_idAlumno INT;

    SELECT MAX(idAlumno)
    INTO v_idAlumno
    FROM Alumnos;

    RETURN v_idAlumno;
END;
DELIMITER ;

/*funcion que obtenga la media de las asignaturas a las que estan 
matriculados los alumnos del ciclo pasado como parametro*/

DELIMITER &&

CREATE OR REPLACE FUNCTION f_mediaMatriculas(p_ciclo VARCHAR(10)) RETURNS INT
BEGIN

    SELECT AVG(matriculas)
    FROM (
    SELECT codAlumno, COUNT(aa.codAsignatura)
    FROM AlumnosAsignaturas aa
    WHERE codCiclo = p_ciclo
    )

END;
DELIMITER ;


DELIMITER &&

CREATE OR REPLACE FUNCTION f_mediaMatriculas(p_ciclo VARCHAR(10)) RETURNS INT
BEGIN

    DECLARE v_media DECIMAL;

    SELECT AVG(COUNT(aa.codAsignatura))
    INTO v_media
    FROM AlumnosAsignaturas aa
    JOIN Alumnos a
        ON aa.codAlumno = a.idAlumno
    JOIN Ciclos c
        ON c.idCiclo = a.codCiclo
    WHERE c.idCiclo = p_ciclo
    GROUP BY aa.codAlumno;

    RETURN v_media;
    

END;
DELIMITER ;

/*
Procedimiento que reciba el email de un alumno y devuelva el siguiente mensaje:
El alumno [nmbre] esta matriculado en el ciclo [ciclo] y la media de matriculacion del mismo es [media]
Si no existiera el email devuelve un mensaje de error.
*/

DELIMITER $$

CREATE OR REPLACE p_mensajeAlumno(p_email VARCHAR(50), OUT p_mensaje VARCHAR(200))





END;

DELIMITER ;