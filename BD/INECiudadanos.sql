CREATE DATABASE ciudadanosine;
USE ciudadanosine;

CREATE TABLE municipio (
    idMunicipio INT PRIMARY KEY,
    municipio VARCHAR(50) NOT NULL,
    codCapital INT,
    FOREIGN KEY (codCapital) REFERENCES municipio (idMunicipio)
);
COMMIT;

CREATE TABLE persona (
    idPersona INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    codResidencia INT NOT NULL,
    codAlcaldia INT,
    FOREIGN KEY (codResidencia) REFERENCES municipio (idMunicipio),
    FOREIGN KEY (codAlcaldia) REFERENCES municipio (idMunicipio)
);
COMMIT;

CREATE TABLE progenitores (
    idProgenitores INT PRIMARY KEY,
    codProgenitor INT,
    codProgenitora INT,
    codHijo INT,
    FOREIGN KEY (codProgenitor) REFERENCES persona (idPersona),
    FOREIGN KEY (codProgenitora) REFERENCES persona (idPersona),
    FOREIGN KEY (codHijo) REFERENCES persona (idPersona)
);
COMMIT;

INSERT INTO municipio VALUES (1, 'Ávila', 1),
(2, 'Arévalo', 1),
(3, 'Arenas de San Pedro', 1);
COMMIT;

INSERT INTO persona VALUES (1, 'Marta', 'Izquierdo', 2, 1),
(2, 'Rosa', 'Palomero', 2, NULL),
(3, 'Jesús', 'Izquierdo', 3, NULL);
COMMIT;

INSERT INTO progenitores VALUES (1, 3, 2, 1);
COMMIT;