CREATE DATABASE tienda;

--2 ver bbdd
SHOW DATABASES;

--3 habilitar bbdd tienda
USE tienda;

---generar tablas:
CREATE TABLE fabricantes(
    idFabricante int primary key,
    nombre varchar(30)
);

CREATE TABLE articulos(
    idArticulo int primary key,
    nombre varchar(30),
    precio int,
    codFabricante int,
    FOREIGN KEY (codFabricante) REFERENCES fabricantes(idFabricante)
);

--5 mostrar las tablas de la bbdd:
SHOW TABLES;
+------------------+
| Tables_in_tienda |
+------------------+
| articulos        |
| fabricantes      |
+------------------+

--6 mostrar articulos de la tabla articulos
DESC articulos;
+---------------+-------------+------+-----+---------+-------+
| Field         | Type        | Null | Key | Default | Extra |
+---------------+-------------+------+-----+---------+-------+
| idArticulo    | int(11)     | NO   | PRI | NULL    |       |
| nombre        | varchar(30) | YES  |     | NULL    |       |
| precio        | int(11)     | YES  |     | NULL    |       |
| codFabricante | int(11)     | YES  | MUL | NULL    |       |
+---------------+-------------+------+-----+---------+-------+

--7 Introducir datos en la tabla
--TABLA FABRICANTES
INSERT INTO fabricantes (idFabricante, nombre)
VALUES (1, 'Kingston'), (2, 'Adata'), (3, 'Logitech'), (4, 'Lexar'), (5, 'Seagate');

--TABLA ARTICULOS
INSERT INTO articulos (idArticulo, nombre, precio, codFabricante)
VALUES (1, 'Teclado', 100, 3), (2, 'Disco duro 300 Gb', 500, 5),
       (3, 'Mouse', 80, 3), (4, 'Memoria USB', 140, 4),
       (5, 'Memoria RAM', 290, 1), (6, 'Disco duro extraible 250Gb', 650, 5),
       (7, 'Memoria USB', 279, 1), (8, 'DVD Rom', 450, 2), (9, 'CD Rom', 200, 2),
       (10, 'Tarjeta de red', 180, 3);


----------CONSULTAS----------

--a)  Obtener todos los datos de los productos de la tienda
SELECT * FROM articulos;

+------------+----------------------------+--------+---------------+
| idArticulo | nombre                     | precio | codFabricante |
+------------+----------------------------+--------+---------------+
|          1 | Teclado                    |    100 |             3 |
|          2 | Disco duro 300 Gb          |    500 |             5 |
|          3 | Mouse                      |     80 |             3 |
|          4 | Memoria USB                |    140 |             4 |
|          5 | Memoria RAM                |    290 |             1 |
|          6 | Disco duro extraible 250Gb |    650 |             5 |
|          7 | Memoria USB                |    279 |             1 |
|          8 | DVD Rom                    |    450 |             2 |
|          9 | CD Rom                     |    200 |             2 |
|         10 | Tarjeta de red             |    180 |             3 |
+------------+----------------------------+--------+---------------+

--b)  Obtener los nombres de los productos de la tienda
SELECT nombre
FROM articulos;

+----------------------------+
| nombre                     |
+----------------------------+
| Teclado                    |
| Disco duro 300 Gb          |
| Mouse                      |
| Memoria USB                |
| Memoria RAM                |
| Disco duro extraible 250Gb |
| Memoria USB                |
| DVD Rom                    |
| CD Rom                     |
| Tarjeta de red             |
+----------------------------+
--c) Obtener los nombres y precio de los productos de la tienda
SELECT nombre, precio 
FROM articulos;

+----------------------------+--------+
| nombre                     | precio |
+----------------------------+--------+
| Teclado                    |    100 |
| Disco duro 300 Gb          |    500 |
| Mouse                      |     80 |
| Memoria USB                |    140 |
| Memoria RAM                |    290 |
| Disco duro extraible 250Gb |    650 |
| Memoria USB                |    279 |
| DVD Rom                    |    450 |
| CD Rom                     |    200 |
| Tarjeta de red             |    180 |
+----------------------------+--------+

--d) Obtener los nombres de los artículos sin repeticiones 
SELECT DISTINCT nombre
FROM articulos;

+----------------------------+
| nombre                     |
+----------------------------+
| Teclado                    |
| Disco duro 300 Gb          |
| Mouse                      |
| Memoria USB                |
| Memoria RAM                |
| Disco duro extraible 250Gb |
| DVD Rom                    |
| CD Rom                     |
| Tarjeta de red             |
+----------------------------+

--e) Obtener todos los datos del artículo cuya clave de producto es ‘5’ 
SELECT * FROM articulos
WHERE idArticulo = 5;

+------------+-------------+--------+---------------+
| idArticulo | nombre      | precio | codFabricante |
+------------+-------------+--------+---------------+
|          5 | Memoria RAM |    290 |             1 |
+------------+-------------+--------+---------------+

--f) Obtener todos los datos del artículo cuyo nombre del producto es ‘’Teclado” 
SELECT * FROM articulos
WHERE nombre = 'Teclado';

+------------+---------+--------+---------------+
| idArticulo | nombre  | precio | codFabricante |
+------------+---------+--------+---------------+
|          1 | Teclado |    100 |             3 |
+------------+---------+--------+---------------+

--g) Obtener todos los datos de la Memoria RAM y memorias USB 
SELECT * FROM articulos
WHERE nombre
IN('Memoria RAM', 'Memoria USB');

+------------+-------------+--------+---------------+
| idArticulo | nombre      | precio | codFabricante |
+------------+-------------+--------+---------------+
|          4 | Memoria USB |    140 |             4 |
|          5 | Memoria RAM |    290 |             1 |
|          7 | Memoria USB |    279 |             1 |
+------------+-------------+--------+---------------+

--h) Obtener todos los datos de los artículos que empiezan con ‘M’ 
SELECT * FROM articulos
WHERE nombre LIKE 'M%';

+------------+-------------+--------+---------------+
| idArticulo | nombre      | precio | codFabricante |
+------------+-------------+--------+---------------+
|          3 | Mouse       |     80 |             3 |
|          4 | Memoria USB |    140 |             4 |
|          5 | Memoria RAM |    290 |             1 |
|          7 | Memoria USB |    279 |             1 |
+------------+-------------+--------+---------------+

--i) Obtener el nombre de los productos donde el precio sea $ 100 
SELECT nombre, precio
FROM articulos
WHERE precio = 100;

+---------+--------+
| nombre  | precio |
+---------+--------+
| Teclado |    100 |
+---------+--------+

--j) Obtener el nombre de los productos donde el precio sea mayor a $ 200 
SELECT nombre, precio
FROM articulos
WHERE precio > 200;

+----------------------------+--------+
| nombre                     | precio |
+----------------------------+--------+
| Disco duro 300 Gb          |    500 |
| Memoria RAM                |    290 |
| Disco duro extraible 250Gb |    650 |
| Memoria USB                |    279 |
| DVD Rom                    |    450 |
+----------------------------+--------+

--k) Obtener todos los datos de los artículos cuyo precio este entre $100 y $350 
SELECT nombre, precio
FROM articulos
WHERE precio
BETWEEN 100 AND 350;

+----------------+--------+
| nombre         | precio |
+----------------+--------+
| Teclado        |    100 |
| Memoria USB    |    140 |
| Memoria RAM    |    290 |
| Memoria USB    |    279 |
| CD Rom         |    200 |
| Tarjeta de red |    180 |
+----------------+--------+

--l) Obtener el precio medio de todos los productos 
SELECT avg(precio) AS 'MEDIA PRECIOS'
FROM articulos;

+---------------+
| MEDIA PRECIOS |
+---------------+
|      286.9000 |
+---------------+

--m) Obtener el precio medio de los artículos cuyo código de fabricante sea 3
SELECT avg(precio) AS 'MEDIA PRECIOS'
FROM articulos
where codFabricante = 3;

+---------------+
| MEDIA PRECIOS |
+---------------+
|      120.0000 |
+---------------+

--n) Obtener el nombre y precio de los artículos ordenados por Nombre 
SELECT nombre, precio
FROM articulos
ORDER BY nombre;

+----------------------------+--------+
| nombre                     | precio |
+----------------------------+--------+
| CD Rom                     |    200 |
| Disco duro 300 Gb          |    500 |
| Disco duro extraible 250Gb |    650 |
| DVD Rom                    |    450 |
| Memoria RAM                |    290 |
| Memoria USB                |    140 |
| Memoria USB                |    279 |
| Mouse                      |     80 |
| Tarjeta de red             |    180 |
| Teclado                    |    100 |
+----------------------------+--------+

--o) Obtener todos los datos de los productos ordenados descendentemente por 
--Precio 
SELECT * FROM articulos
ORDER BY precio DESC;

+------------+----------------------------+--------+---------------+
| idArticulo | nombre                     | precio | codFabricante |
+------------+----------------------------+--------+---------------+
|          6 | Disco duro extraible 250Gb |    650 |             5 |
|          2 | Disco duro 300 Gb          |    500 |             5 |
|          8 | DVD Rom                    |    450 |             2 |
|          5 | Memoria RAM                |    290 |             1 |
|          7 | Memoria USB                |    279 |             1 |
|          9 | CD Rom                     |    200 |             2 |
|         10 | Tarjeta de red             |    180 |             3 |
|          4 | Memoria USB                |    140 |             4 |
|          1 | Teclado                    |    100 |             3 |
|          3 | Mouse                      |     80 |             3 |
+------------+----------------------------+--------+---------------+

--p) Obtener el nombre y precio de los artículos cuyo precio sea mayor a $ 250 y 
--ordenarlos descendentemente por precio y luego ascendentemente por nombre
SELECT nombre, precio
FROM articulos
WHERE precio > 250
ORDER BY precio DESC;

+----------------------------+--------+
| nombre                     | precio |
+----------------------------+--------+
| Disco duro extraible 250GB |    650 |
| Disco duro 300GB           |    500 |
| DVD Rom                    |    450 |
| Memoria RAM                |    290 |
| Memoria USB                |    279 |
+----------------------------+--------+

SELECT nombre, precio
FROM articulos
WHERE precio > 250
ORDER BY nombre ASC;

+----------------------------+--------+
| nombre                     | precio |
+----------------------------+--------+
| Disco duro 300GB           |    500 |
| Disco duro extraible 250GB |    650 |
| DVD Rom                    |    450 |
| Memoria RAM                |    290 |
| Memoria USB                |    279 |
+----------------------------+--------+

--q) Obtener un listado completo de los productos, incluyendo por cada articulo los 
--datos del articulo y del fabricante
SELECT a.nombre AS 'Nombre artículo', a.precio, f.nombre AS 'Nombre fabricante' 
FROM articulos a
LEFT JOIN fabricantes f
ON f.idFabricante = a.codFabricante
ORDER BY a.idArticulo;

+----------------------------+--------+-------------------+
| Nombre art?culo            | precio | Nombre fabricante |
+----------------------------+--------+-------------------+
| Teclado                    |    100 | Logitech          |
| Disco duro 300GB           |    500 | Seagate           |
| Mouse                      |     80 | Logitech          |
| Memoria USB                |    140 | Lexar             |
| Memoria RAM                |    290 | Kingston          |
| Disco duro extraible 250GB |    650 | Seagate           |
| Memoria USB                |    279 | Kingston          |
| DVD Rom                    |    450 | Adata             |
| CD ROM                     |    200 | Adata             |
| Tarjeta de red             |    180 | Logitech          |
+----------------------------+--------+-------------------+

--r) Obtener la clave de producto, nombre del producto y nombre del fabricante de 
--todos los productos en venta
SELECT a.idArticulo, a.nombre AS 'Nombre artículo', f.nombre AS 'Nombre fabricante'
FROM articulos a 
JOIN fabricantes f
ON f.idFabricante = a.codFabricante;

+------------+----------------------------+-------------------+
| idArticulo | Nombre art?culo            | Nombre fabricante |
+------------+----------------------------+-------------------+
|          5 | Memoria RAM                | Kingston          |
|          7 | Memoria USB                | Kingston          |
|          8 | DVD Rom                    | Adata             |
|          9 | CD ROM                     | Adata             |
|          1 | Teclado                    | Logitech          |
|          3 | Mouse                      | Logitech          |
|         10 | Tarjeta de red             | Logitech          |
|          4 | Memoria USB                | Lexar             |
|          2 | Disco duro 300GB           | Seagate           |
|          6 | Disco duro extraible 250GB | Seagate           |
+------------+----------------------------+-------------------+

--s) Obtener el nombre y precio de los artículos donde el fabricante sea Logitech 
--ordenarlos alfabéticamente por nombre del producto
SELECT a.nombre AS 'Nombre artículo', a.precio, f.nombre AS 'Nombre fabricante' 
FROM articulos a
JOIN fabricantes f
ON f.idFabricante = a.codFabricante
WHERE f.nombre = 'Logitech'
ORDER BY a.nombre;

+-----------------+--------+-------------------+
| Nombre art?culo | precio | Nombre fabricante |
+-----------------+--------+-------------------+
| Mouse           |     80 | Logitech          |
| Tarjeta de red  |    180 | Logitech          |
| Teclado         |    100 | Logitech          |
+-----------------+--------+-------------------+

--t) Obtener el nombre, precio y nombre de fabricante de los productos que son marca 
--Lexar o Kingston ordenados descendentemente por precio
SELECT a.nombre AS 'Nombre artículo', a.precio, f.nombre AS 'Nombre fabricante' 
FROM articulos a
JOIN fabricantes f
ON f.idFabricante = a.codFabricante
WHERE f.nombre
IN ('Lexar', 'Kingston')
ORDER BY a.precio DESC;

+-----------------+--------+-------------------+
| Nombre art?culo | precio | Nombre fabricante |
+-----------------+--------+-------------------+
| Memoria RAM     |    290 | Kingston          |
| Memoria USB     |    279 | Kingston          |
| Memoria USB     |    140 | Lexar             |
+-----------------+--------+-------------------+

--u) Añade un nuevo producto: Clave del producto 11, Altavoces de $ 120 del 
--fabricante 2
INSERT INTO articulos
VALUES (11, 'Altavoces', 120, 2);

+------------+----------------------------+--------+---------------+
| idArticulo | nombre                     | precio | codFabricante |
+------------+----------------------------+--------+---------------+
|          1 | Teclado                    |    100 |             3 |
|          2 | Disco duro 300 Gb          |    500 |             5 |
|          3 | Mouse                      |     80 |             3 |
|          4 | Memoria USB                |    140 |             4 |
|          5 | Memoria RAM                |    290 |             1 |
|          6 | Disco duro extraible 250Gb |    650 |             5 |
|          7 | Memoria USB                |    279 |             1 |
|          8 | DVD Rom                    |    450 |             2 |
|          9 | CD Rom                     |    200 |             2 |
|         10 | Tarjeta de red             |    180 |             3 |
|         11 | Altavoces                  |    120 |             2 |
+------------+----------------------------+--------+---------------+

--v) Cambia el nombre del producto 6 a ‘Impresora Laser’ 
UPDATE articulos
SET nombre = 'Impresora Laser'
WHERE idArticulo = 6;

+------------+-------------------+--------+---------------+
| idArticulo | nombre            | precio | codFabricante |
+------------+-------------------+--------+---------------+
|          1 | Teclado           |    100 |             3 |
|          2 | Disco duro 300 Gb |    500 |             5 |
|          3 | Mouse             |     80 |             3 |
|          4 | Memoria USB       |    140 |             4 |
|          5 | Memoria RAM       |    290 |             1 |
|          6 | Impresora Laser   |    650 |             5 |
|          7 | Memoria USB       |    279 |             1 |
|          8 | DVD Rom           |    450 |             2 |
|          9 | CD Rom            |    200 |             2 |
|         10 | Tarjeta de red    |    180 |             3 |
|         11 | Altavoces         |    120 |             2 |
+------------+-------------------+--------+---------------+

--w) Aplicar un descuento del 10% a todos los productos. 
UPDATE articulos
SET precio = precio * 0.9;

+------------+-------------------+--------+---------------+
| idarticulo | nombre            | precio | codfabricante |
+------------+-------------------+--------+---------------+
|          1 | Teclado           |     90 |             3 |
|          2 | Disco duro 300GB  |    450 |             5 |
|          3 | Mouse             |     72 |             3 |
|          4 | Memoria USB       |    126 |             4 |
|          5 | Memoria RAM       |    261 |             1 |
|          6 | Impresora Laser   |    593 |             5 |
|          7 | Memoria USB       |    251 |             1 |
|          8 | DVD Rom           |    405 |             2 |
|          9 | CD ROM            |    180 |             2 |
|         10 | Tarjeta de red    |    162 |             3 |
|         11 | Altavoces         |    108 |             2 |
+------------+------------------+--------+---------------+

--x) Aplicar un descuento de $ 10 a todos los productos cuyo precio sea mayor o 
--igual a $ 300

UPDATE articulos
SET precio = precio - 10
WHERE precio >= 300;

+------------+-------------------+--------+---------------+
| idarticulo | nombre            | precio | codfabricante |
+------------+-------------------+--------+---------------+
|          1 | Teclado           |     90 |             3 |
|          2 | Disco duro 300GB  |    440 |             5 |
|          3 | Mouse             |     72 |             3 |
|          4 | Memoria USB       |    126 |             4 |
|          5 | Memoria RAM       |    261 |             1 |
|          6 | Impresora Laser   |    640 |             5 |
|          7 | Memoria USB       |    251 |             1 |
|          8 | DVD Rom           |    395 |             2 |
|          9 | CD ROM            |    180 |             2 |
|         10 | Tarjeta de red    |    162 |             3 |
|         11 | Altavoces         |    108 |             2 |
+------------+------------------+--------+---------------+

--y) Borra el producto numero 6 
DELETE FROM articulos WHERE idArticulo = 6;

+------------+------------------+--------+---------------+
| idarticulo | nombre           | precio | codfabricante |
+------------+------------------+--------+---------------+
|          1 | Teclado          |    100 |             3 |
|          2 | Disco duro 300GB |    500 |             5 |
|          3 | Mouse            |     80 |             3 |
|          4 | Memoria USB      |    140 |             4 |
|          5 | Memoria RAM      |    290 |             1 |
|          7 | Memoria USB      |    279 |             1 |
|          8 | DVD Rom          |    450 |             2 |
|          9 | CD ROM           |    200 |             2 |
|         10 | Tarjeta de red   |    180 |             3 |
|         11 | Altavoces        |    120 |             2 |
+------------+------------------+--------+---------------+
