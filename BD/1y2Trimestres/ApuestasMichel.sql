CREATE DATABASE ApuestasMichel;

USE DATABASE ApuestasMichel;

CREATE TABLE Deportes(
    idDeporte INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Apuestas(
    idApuesta INT PRIMARY KEY,
    cuota DOUBLE NOT NULL,
    cantidad DOUBLE NOT NULL,
    codDeporte INT NOT NULL,
    FOREIGN KEY (codDeporte) REFERENCES Deportes(idDeporte)
);

INSERT INTO Deportes(idDeporte, nombre)
VALUES SELECT MAX(idDeporte) + 1, 'Futbol'
FROM Deportes;

INSERT INTO Deportes(idDeporte, nombre)
VALUES SELECT MAX(idDeporte) + 1, 'Hockey hierba'
FROM Deportes;

INSERT INTO Deportes(idDeporte, nombre)
VALUES SELECT MAX(idDeporte) + 1, 'Tenis'
FROM Deportes;

INSERT INTO Deportes(idDeporte, nombre)
VALUES SELECT MAX(idDeporte) + 1, 'Basket'
FROM Deportes;

INSERT INTO Deportes(idDeporte, nombre)
VALUES SELECT MAX(idDeporte) + 1, 'Carreras de cerdos';

INSERT INTO Deportes(idDeporte, nombre)
VALUES SELECT MAX(idDeporte) + 1, 'Tenis de mesa'
FROM Deportes;

INSERT INTO Deportes(idDeporte, nombre)
VALUES SELECT MAX(idDeporte) + 1, 'Lanzamiento de hueso de aceituna'
FROM Deportes;

INSERT INTO Apuestas(idApuesta, cuota, cantidad, codDeporte)
VALUES SELECT MAX(idApuesta) + 1, 2.5, 5, 2
FROM Apuestas;

INSERT INTO Apuestas(idApuesta, cuota, cantidad, codDeporte)
VALUES SELECT MAX(idApuesta) + 1, 1.5, 5, 4
FROM Apuestas;

INSERT INTO Apuestas(idApuesta, cuota, cantidad, codDeporte)
VALUES SELECT MAX(idApuesta) + 1, 0.9, 5, 3
FROM Apuestas;

INSERT INTO Apuestas(idApuesta, cuota, cantidad, codDeporte)
VALUES SELECT MAX(idApuesta) + 1, 0.5, 10, 1
FROM Apuestas;

/*CON UN ALTER TABLE CREAMOS LA COLUMNA Y CON UPDATE SET INTRODUCIMOS LOS DATOS
DROP ES PARA BORRAR UNA COLUMNA O LA TABLA
TRUNCATE Y DELETE VACIAN LA TABLA

select COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_COLUMN_NAME, REFERENCED_TABLE_NAME
from information_schema.KEY_COLUMN_USAGE;

ALTER TABLE apuestas DROP FOREIGN KEY apuestas_ibfk_1;

ALTER TABLE apuestas DROP codDeporte <- PARA BUSCAR LAS CONSTRAINT Y BORRAR LAS FOREING Y LAS PRIMARY KEY

*/

ALTER TABLE Apuestas ADD fecApuesta DATE NOT NULL;

UPDATE Apuesta SET fecApuesta = CURRENT DATE();