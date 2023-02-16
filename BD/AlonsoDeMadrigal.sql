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








COMMIT;