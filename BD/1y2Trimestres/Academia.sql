create database Academia;
use Academia;

/*Creamos primero la tabla paises, que no tiene claves FK */

create table paises(
	idPais int(2) primary key,
	nombre varchar(56) unique not null
);

/* HAGO UN  --> SHOW TABLES;  para comprobar que se ha creado
+--------------------+
| Tables_in_academia |
+--------------------+
| paises             |
+--------------------+

SHOW CREATE TABLE paises;   nos muestra como ha sido creada la tabla paises

DESC paises;  nos describe la info de la tabla:
+--------+-------------+------+-----+---------+-------+
| Field  | Type        | Null | Key | Default | Extra |
+--------+-------------+------+-----+---------+-------+
| idPais | int(2)      | NO   | PRI | NULL    |       |
| nombre | varchar(56) | NO   | UNI | NULL    |       |
+--------+-------------+------+-----+---------+-------+
*/


/*creamos ahora la tabla profesores, la cual tiene como FK
el idPais y esa tabla ya la hemos creado*/

create table profesores(
	idProfesor int(2) primary key,
	nombre varchar(50) not null,
    tlfMovil int(9) unique not null,
    fijo int(9),
    idPais int(2) not null,
    FOREIGN KEY (idPais) references Paises(idPais)
);

/*creamos el resto de tablas*/

create table grupo(
	idGrupo int(2) primary key,
	nivel varchar(2) unique not null,
    idProfesor int(2) not null,
    FOREIGN KEY (idProfesor) references profesores(idProfesor)
);

create table alumnos(
    idAlumno int(2) primary key,
    nombre varchar(50) not null,
    telefono int(9),
    direccion varchar(90),
    idGrupo int(2) not null,
    FOREIGN KEY (idGrupo) references grupo(idGrupo)
);
insert into paises (idPais, pais)
values (1, 'España');

COMMIT; /*Para guardar los cambios*/

insert into paises (idPais, pais)
values (3, 'Alemania');
null /*Cuando tenemos alguna columna que queremos que este vacio o que no tenemos los datos de algun caso de esa columnas*/
select [columna] /*Para consultas query*/
from [tabla] /*Para elegir la tabal sobre la que queremos hacer la consulta*/
where [condición] /*Condiciones*/
order by [columna] /*Para ordenar*/
select * /*El asterisco indica que queremos que nos muestre todo*/
alter table drop /*Para eliminar una columna*/
alter table add /*Para añadir una columna*/
update [tabla] set [columna = valor] where [columna = valor] /*Para añadir datos en columnas que esten vacias*/
drop database [base de datos] /*Para borrar una base de datos*/
cd ..
cd ..
cd xampp\mysql\bin
mysql -u root /*pata entrar desde la consola*/
select * from [tabla] where [columna] <> [elemento de la columna que queremos obviar]

MariaDB [matricula]> SELECT *
    -> FROM alumnos
    -> JOIN alumnosasignaturas
    -> ON idAlumno = codAlumno
    -> JOIN asignaturas
    -> ON idAsignatura = codAsignatura;
+----------+----------------+----------------------+----------------------+-----------+---------------+--------------+------------------------+ /*Para consultar varias tablas a la vez*/
| idAlumno | nombre         | email                | idAlumnosAsignaturas | codAlumno | codAsignatura | idAsignatura | asignatura             |
+----------+----------------+----------------------+----------------------+-----------+---------------+--------------+------------------------+
|        1 | Maria Garcia   | margar@educa.jcyl.es |                    1 |         1 |             1 |            1 | Bases de datos         |
|        1 | Maria Garcia   | margar@educa.jcyl.es |                    2 |         1 |             2 |            2 | Programación           |
|        1 | Maria Garcia   | margar@educa.jcyl.es |                    3 |         1 |             3 |            3 | Lenguaje de marcas     |
|        1 | Maria Garcia   | margar@educa.jcyl.es |                    4 |         1 |             4 |            4 | Sistemas informáticos  |
|        1 | Maria Garcia   | margar@educa.jcyl.es |                    5 |         1 |             5 |            5 | FOL                    |
|        1 | Maria Garcia   | margar@educa.jcyl.es |                    6 |         1 |             6 |            6 | Entornos de desarrollo |
|        2 | Juan Perez     | juaper@educa.jcyl.es |                    7 |         2 |             1 |            1 | Bases de datos         |
|        3 | Ana Sanchez    | anasan@educa.jcyl.es |                    8 |         3 |             1 |            1 | Bases de datos         |
|        4 | Jose Rodriguez | josrod@educa.jcyl.es |                    9 |         4 |             1 |            1 | Bases de datos         |
+----------+----------------+----------------------+----------------------+-----------+---------------+--------------+------------------------+


MariaDB [matricula]> SELECT nombre, email       /*Para hacer una consulta sobre los alumnos que estan matriculados en una asignatura concreta*/
    -> FROM alumnos
    -> JOIN alumnosasignaturas
    -> ON idAlumno = codAlumno
    -> JOIN asignaturas
    -> ON idAsignatura = codAsignatura
    -> WHERE asignatura = 'Programación';
+--------------+----------------------+
| nombre       | email                |
+--------------+----------------------+
| Maria Garcia | margar@educa.jcyl.es |
+--------------+----------------------+

MariaDB [matricula]> SELECT al.nombre, al.email     /*La misma mierdad de antes pero usando alias*/
    -> FROM alumnos al
    -> JOIN alumnosasignaturas aa
    -> ON al.idAlumno = aa.codAlumno
    -> JOIN asignaturas asi
    -> ON asi.idAsignatura = aa.codAsignatura
    -> WHERE asi.asignatura = 'Programación';
+--------------+----------------------+
| nombre       | email                |
+--------------+----------------------+
| Maria Garcia | margar@educa.jcyl.es |
+--------------+----------------------+