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
SELECT MAX(idAlumno) + 1, 'Pepe', 'pepe@gmail.com', STR_TO_DATE('24/12/2002', '%d/%m/%Y'), 111222333, 2
FROM Alumnos;
INSERT INTO Alumnos
SELECT MAX(idAlumno) + 1, 'Pepa', 'pepa@gmail.com', STR_TO_DATE('25/12/2002', '%d/%m/%Y'), 444555666, 3
FROM Alumnos;
INSERT INTO Alumnos
SELECT MAX(idAlumno) + 1, 'Jacinto', 'jacinto@gmail.com', STR_TO_DATE('26/12/2002', '%d/%m/%Y'), 777888999, 4
FROM Alumnos;

SELECT * FROM Alumnos;