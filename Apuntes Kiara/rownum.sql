--1 Muestra los tres alumnos que mejor nota final han obtenido en “ABD” (Administración de Bases de Datos). 
select * from asignatura;  --para saber el id de la asignatura que nos ST_PointAtDistance
SELECT * FROM 
    (SELECT * FROM alumasig 
    WHERE idasignatura = 1 
    ORDER BY notafinal DESC) 
WHERE ROWNUM <= 3;

--solucion buena:
SELECT ROWNUM, nomAlumno, notaFinal FROM
    (SELECT a.nombre AS nomAlumno, aa.notafinal AS notaFinal
    FROM alumno a 
    JOIN alumasig aa ON (a.idalumno = aa.idalumno)
    JOIN asignatura b ON (aa.idasignatura = b.idasignatura) 
    WHERE b.nombreasig = 'Administración de Bases de Datos'
    ORDER BY aa.notafinal DESC)
WHERE ROWNUM <= 3;


--2 Muestra la nota media de todos los exámenes parciales de cada alumno. 
SELECT a.nombre, ROUND(AVG(aa.notaparcial),2) AS Media
FROM alumno a
JOIN alumexa aa ON (aa.idAlumno = a.idAlumno)
GROUP BY a.nombre;

--   2a A continuación, realiza otra consulta para mostrarlo por cada asignatura. 
SELECT asig.nombreasig, a.nombre, ROUND(AVG(aa.notaparcial),2) AS Media
FROM alumno a
JOIN alumexa aa ON (aa.idAlumno = a.idAlumno)
JOIN alumasig b ON (b.idAlumno = aa.idAlumno)
JOIN asignatura asig ON (asig.idAsignatura = b.idAsignatura)
GROUP BY asig.nombreasig, a.nombre;

--3 Muestra los seis alumnos que han obtenido mejor nota parcial en cualquier examen. 
SELECT * FROM 
    (SELECT a.nombre, aa.idalumno, AVG(aa.notaparcial) AS Media 
    FROM alumexa aa
    JOIN alumno a ON a.idAlumno = aa.idAlumno
    GROUP BY a.nombre, aa.idalumno
    ORDER BY Media DESC) 
WHERE ROWNUM <= 6;

--4 Muestra los dos alumnos que peor nota final han obtenido en “FH” (Fundamentos del Hardware). 
select * from 
    (select * from alumasig 
    where idasignatura = 2 
    order by notafinal) 
where rownum <= 2;

--solucion buena:
SELECT ROWNUM, nomAlumno, notaFinal FROM
    (SELECT a.nombre AS nomAlumno, aa.notafinal AS notaFinal
    FROM alumno a 
    JOIN alumasig aa ON (a.idalumno = aa.idalumno)
    JOIN asignatura b ON (aa.idasignatura = b.idasignatura) 
    WHERE b.nombreasig = 'Fundamentos del Hardware'
    ORDER BY aa.notafinal ASC)
WHERE ROWNUM <= 2;

--5 Muestra las dos asignaturas con mejor nota final de alumnos individuales.
select * from 
    (select a.nombreasig, avg(notafinal) as Media 
    from alumasig alas
    JOIN asignatura a ON alas.idasignatura = a.idasignatura
    group by a.nombreasig 
    order by Media desc) 
where rownum <= 2;

--5a A continuación, realiza otra consulta para mostrarlo de todo el grupo de alumnos. 
SELECT * FROM 
    (SELECT c.curso, asig.nombreasig, AVG(alasig.notafinal) as media
    FROM asignatura asig
    JOIN alumasig alasig ON asig.idasignatura = alasig.idasignatura
    JOIN curso c ON c.idcurso = asig.idcurso
    GROUP BY c.curso, asig.nombreasig
    ORDER BY AVG(alasig.notafinal) DESC)
WHERE ROWNUM <= 2;

--6 Muestra las tres asignaturas con peor nota final indicando el curso al que pertenecen. 
select * from 
    (select c.curso, a.nombreAsig, avg(al.notafinal) as Media 
    from curso c 
    join asignatura a on c.idCurso = a.idCurso 
    join alumasig al on a.idAsignatura = al.idAsignatura 
    group by c.curso, a.nombreAsig 
    order by Media) 
where rownum <= 3;

--6a A continuación, realiza otra consulta para mostrarlo de todo el grupo de la asignatura. 
SELECT *
FROM (SELECT c.curso, AVG(al.notafinal) AS media
    FROM curso c 
    JOIN asignatura a ON c.idcurso = a.idcurso
    JOIN alumasig al ON a.idasignatura = al.idasignatura
    GROUP BY c.curso
    ORDER BY 2 ASC)
WHERE ROWNUM <= 3;


--7 Muestra los cuatro mejores alumnos (los que mejores notas medias han obtenido en su nota final) indicando el curso al que pertenecen. 
SELECT *
FROM (SELECT a.nombre, c.curso, AVG(alas.notafinal) AS Media
    FROM curso c
    JOIN alumno a ON c.idcurso = a.idcurso
    JOIN asignatura asig ON c.idcurso = asig.idcurso
    JOIN alumasig alas ON a.idalumno = alas.idalumno
    GROUP BY a.nombre, c.curso
    ORDER BY 3 DESC)
WHERE ROWNUM <= 4;


--8 Muestra el mejor y el peor alumno del colegio (todo en una consulta). 
SELECT *
FROM (SELECT a.nombre, AVG(alas.notafinal) AS Media
    FROM alumasig alas
    JOIN alumno a ON alas.idalumno = a.idalumno
    GROUP BY a.nombre
    ORDER BY 2 DESC)
WHERE ROWNUM <= 1
UNION ALL
SELECT *
FROM (SELECT a.nombre, AVG(alas.notafinal) AS Media
    FROM alumasig alas
    JOIN alumno a ON alas.idalumno = a.idalumno
    GROUP BY a.nombre
    ORDER BY 2 ASC)
WHERE ROWNUM <= 1;



--9 Muestra los dos mejores y los dos peores alumnos del colegio (todo en una consulta)
SELECT *
FROM (SELECT a.nombre, AVG(alas.notafinal) AS Media
    FROM alumasig alas
    JOIN alumno a ON alas.idalumno = a.idalumno
    GROUP BY a.nombre
    ORDER BY 2 DESC)
WHERE ROWNUM <= 2
UNION ALL
SELECT *
FROM (SELECT a.nombre, AVG(alas.notafinal) AS Media
    FROM alumasig alas
    JOIN alumno a ON alas.idalumno = a.idalumno
    GROUP BY a.nombre
    ORDER BY 2 ASC)
WHERE ROWNUM <= 2;
