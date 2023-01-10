/*Titulo de la pelicula, genero de la pelicula cuyo director sea alonso de madrigal*/

SELECT p.titulo, g.genero
FROM peliculas p
JOIN genero g
ON p.codGenero = g.idGenero
JOIN directores d
ON p.codDirector = d.idDirector
WHERE d.nombre = 'Alonso de Madrigal'

/*Nombre de los representantes del reparto de una pelicula llamada daw1*/

SELECT r.representante
FROM representantes r
LEFT JOIN reparto re
ON r.idRepresentante = re.codRepresentante
LEFT JOIN repartoPelicula rp
ON rp.codReparto = re.idReparto
LEFT JOIN peliculas p
ON rp.codPelicula = p.idPelicula
WHERE p.titulo = 'DAW1'

/*Peliculas con director o productor Español, ordenado descendentemente*/

SELECT p.titulo
FROM peliculas pe
LEFT JOIN directores d
ON pe.codDirector = d.idDirector
LEFT JOIN productores pr
ON pe.codProductor = pr.idProductor
LEFT JOIN paises pa
ON pa.idPais = d.codPais
OR pa.idPais = pr.codPais
WHERE pa.pais = 'España'
ORDER BY 1 DESC /*tambien podriamos poner p.titulo*/
/*tambien podemos hacerlo de otra manera: */
SELECT p.titulo
FROM peliculas p
JOIN directores d
ON p.codDirector = d.idDirector
JOIN paises pa
ON pa.idPais = d.codPais
WHERE pa.pais = 'España'
UNION /*Si hay algun dato duplicado nos lo saca solo 1 vez, si quisiearmos que saliera tantas veces como esté duplicado tendriamos que poner UNION ALL*/
SELECT p.titulo
FROM peliculas p
JOIN productores pr
ON p.codProductor = d.idProductor
JOIN paises pa
ON pa.idPais = d.codPais
WHERE pa.pais = 'España'
ORDER BY 1 DESC

/*SUBCONSULTAS
- Se usa en los where parte derecha no izquierda
- Tambien se pueden usar en el select pero solo tiene que devolver un resultado*/
SELECT p.titulo
FROM peliculas p
WHERE p.codDirector IN (
    SELECT d.idDirector
    FROM directores d
    JOIN paises pa
    ON d.codPais = pa.idPais
    WHERE pa.pais = 'España'
)
UNION
SELECT p.titulo
FROM peliculas p
WHERE p.codProductor IN (
    SELECT pr.idProductor
    FROM productores pr
    JOIN paises pa
    ON d.codPais = pa.idPais
    WHERE pa.pais = 'España'
)

/*Listado de productores y directores cuyo pais sea España*/

SELECT d.nombre
FROM directores d
JOIN paises p
ON d.codPais = p.idPais
WHERE p.pais = 'España'
UNION
SELECT pr.nombre
FROM productores pr
JOIN paises p
ON pr.codPais = p.idPais
WHERE p.pais = 'España'
/*Si las columnas nombre no se llamasen igual necesitariamos poner el mismo alias a ambas*/
SELECT COALESCE (d.director, pr.productor, 'No hay') /*COALESCE: si alguno de ellos es null nos saca el siguiente*/ IFNULL (d.director, pr.productor) /*El IFNULL solo funciona en MariaDB*/
FROM paises p
LEFT JOIN directores d
ON p.idPais = d.codPais
LEFT JOIN productores pr
ON p.idPais = pr.codPais
WHERE p.pais = 'España'