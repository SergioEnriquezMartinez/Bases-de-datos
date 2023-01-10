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