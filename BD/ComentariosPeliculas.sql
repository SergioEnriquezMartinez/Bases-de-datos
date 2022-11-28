/*Esta bd es el ejercicio comentariospeliculas*/
CREATE DATABASE peliculas;
use peliculas;
CREATE TABLE Usuario (
    idUsuario INT PRIMARY KEY,
    nickname VARCHAR NOT NULL UNIQUE,
    DNI VARCHAR NOT NULL UNIQUE
);

CREATE TABLE peliculas (
    idPelicula INT PRIMARY KEY,
    titulo VARCHAR NOT NULL
);

CREATE TABLE comentario (
    idComentario INT PRIMARY KEY,
    texto VARCHAR,
    codUsuario INT,
    codPelicula INT NOT NULL,
    codValoracion BOOLEAN,
    FOREIGN KEY (codUsuario) REFERENCES Usuario (idUsuario),
    FOREIGN KEY (codPelicula) REFERENCES peliculas (idPelicula),
    FOREIGN KEY (codValoracion) REFERENCES peliculas (idPelicula)
);

/*Esta bd es para el ejercicio sin nombres*/
CREATE DATABASE entidades;
use entidades;
CREATE TABLE entidad_1 (
    atributo_1_1 INT PRIMARY KEY,
    atributo_1_2 VARCHAR(50) NOT NULL
);
CREATE TABLE entidad_3 (
    atributo_3_1 INT PRIMARY KEY,
    atributo_3_2 VARCHAR(50) NOT NULL
);
CREATE TABLE entidad_2 (
    atributo_2_1 INT PRIMARY KEY,
    atributo_2_2 VARCHAR(50) NOT NULL
)
CREATE TABLE entidad_23 (
    atributo_23_1 INT PRIMARY KEY,
    atributo_23_2 INT NOT NULL,
    atributo_23_3 INT NOT NULL,
    FOREIGN KEY (atributo_23_2) REFERENCES entidad_2 (atributo_2_1),
    FOREIGN KEY (atributo_23_3) REFERENCES entidad_3 (atributo_3_1)
);
insert into entidad_1 values (1, 'valor_1_1');
insert into entidad_1 values (2, 'valor_1_2');
insert into entidad_1 values (3, 'valor_1_3');

insert into entidad_2 values (1, 'valor_2_1');
insert into entidad_2 values (2, 'valor_2_2');
insert into entidad_2 values (3, 'valor_2_3');

insert into entidad_3 values (1, 'valor_3_1');
insert into entidad_3 values (2, 'valor_3_2');
insert into entidad_3 values (3, 'valor_3_3');

insert into entidad_23 values (1, 1, 1);
insert into entidad_23 values (2, 2, 3);
insert into entidad_23 values (3, 1, 2);
insert into entidad_23 values (4, 3, 2);



/*BD para una empresa
se quieren guardar los departamentos de la empresa
también se van a guardar los empleados de dicha empresa
de los empleados se van a guardar los siguientes datos:
-id
-nombre
-apellidos
-telefono de contacto
-fecha de contratación
-departamento al que pertenece
-su responsable*/

CREATE DATABASE hr;
use hr;
CREATE TABLE departamentos (
    idDepartamento INT PRIMARY KEY,
    departamento VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE empleados (
    idEmpleado INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    telefono VARCHAR(15),
    fechaContratacion DATE NOT NULL,
    codDepartamento INT NOT NULL,
    codResponsable INT,
    FOREIGN KEY (codDepartamento) REFERENCES departamentos (idDepartamento),
    FOREIGN KEY (codResponsable) REFERENCES empleados (idEmpleado)
);

INSERT INTO departamentos VALUES (1, 'Consejo'),
(2, 'Directiva'),
(3, 'Marketing'),
(4, 'Ventas'),
(5, 'RR.HH.');

COMMIT;

INSERT INTO empleados (idEmpleado, nombre, apellidos, telefono, fechaContratacion, codDepartamento, codResponsable)
VALUES (1, 'Jefe', 'Presidente', '+34666777666', '11-16-2021', 1);
INSERT INTO empleados VALUES (2, 'Semijefe', 'Directivo', '654234567', '11-18-2021', 2, 1),
(3, 'Maquetador', 'Diseñador', '666666666', '12-16-2021', 3, 2);

COMMIT;

UPDATE empleados SET fechaContratacion = '2021-3-2' WHERE idEmpleado = 1;
UPDATE empleados SET fechaContratacion = STR_TO_DATE('18/11/2021', '%d/%m/%Y') WHERE idEmpleado = 2;

CREATE TABLE trabajos (
    idTrabajo INT PRIMARY KEY,
    trabajo VARCHAR(50) NOT NULL UNIQUE
/*    codEmpleados INT,
    FOREIGN KEY codEmpleados REFERENCES empleados (idEmpleado)*/
);

ALTER TABLE empleados ADD COLUMN codTrabajo INT;

COMMIT;

ADD TABLE empleados ADD CONSTRAINT
    FOREIGN KEY (codTrabajo) REFERENCES trabajos (codTrabajo);

COMMIT;

ALTER TABLE empleados CHANGE COLUMN fechaContratacion fechaContrato DATE;

COMMIT;

ALTER TABLE empleados DROP COLUMN telefono;

COMMIT;

SELECT * FROM information_schema.TABLE_CONSTRAINTS WHERE table_name = 'empleados';

ALTER TABLE empleados DROP CONSTRAINT codTrabajo;


/*BD de un censo de votos*/
CREATE DATABASE censo;
USE censo;

CREATE TABLE mesa (
    idMesa INT PRIMARY KEY,
    mesa VARCHAR(50) NOT NULL
);

CREATE TABLE personas (
    idPersona INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    codMesa INT NOT NULL,
    codVoto INT,
    FOREIGN KEY (codMesa) REFERENCES mesa (idMesa),
    FOREIGN KEY (codVoto) REFERENCES personas (idPersona)
);
COMMIT;
/*Si es 1 no puede ser null
Si es 0 puede ser null
Si es N no puede ser unico
0:1 NULL UNIQUE
1:1 NOT NULL UNIQUE
0:N NULL NOT UNIQUE
1:N NOT NULL NOT UNIQUE
N:M tabla auxiliar NOT NULL NOT UNIQUE*/

/*Nos piden que una persona pueda votar a varias personas, por lo tanto tenemos que hacer una tabla auxiliar para los nuevos datos y procedemos a borrar el codVoto
En primer lugar hacemos una consulta para saber cual es la foreign key correspoindiente y procedemos a borrar esa fk con el DROP CONSTRAINT
Seguido a ello, borramos al columna codVoto*/
SELECT TABLE_NAME, COLUMN_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE REFERENCED_TABLE_SCHEMA = 'censo' 
AND REFERENCED_TABLE_NAME = 'personas'

ALTER TABLE personas DROP CONSTRAINT personas_(la que te diga la consulta anterior);
ALTER TABLE personas DROP COLUMN codVoto;

