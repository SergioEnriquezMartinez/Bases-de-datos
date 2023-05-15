
create table curso(
    codCurso number(3) constraint cur_pk primary key,
    nombre varchar2(30) constraint cur_nom_nn not null
);

create table alumno(
    codAlumno number(5) constraint alu_cod_pk primary key,
    nombre varchar2(30) constraint alu_nom_nn null,
    priApe varchar2(30) constraint alu_pri_nn not null,
    segApe varchar2(30),
    codCurso number(3) constraint alu_cur_fk references curso(codCurso)
);

insert into curso values (1, '1ESO');
insert into curso values (2, '2ESO');
insert into curso values (3, '3ESO');

insert into alumno values (1, 'Juan', 'Lopez', 'Lopez', 1);
insert into alumno values (2, 'Maria', 'Jimenez', 'Sanchez', 1);
insert into alumno values (3, 'Jose', 'Gutierrez', 'Gonzalez', 2);
insert into alumno values (4, 'Luisa', 'Garcia', 'Lopez', null);

create or replace view alumnosCursos(nombreAlum, priApe, segApe, nombreCurso)
as (
    select a.nombre, priApe, segApe, c.nombre
    from curso c join alumno a using (codCurso)
);

update alumnosCursos set priApe = 'Martin' where nombreCurso = '2ESO';
select * from alumnosCursos;


--la vista de antes pero modificada
create or replace view alumnosCursos(codAlumno, nombreAlum, priApe, segApe, 
codCurso, nombreCurso)
as (
    select a.codAlumno, a.nombre, priApe, segApe, c.codCurso, c.nombre
    from curso c join alumno a on (c.codCurso = a.codCurso)
);


--
insert into alumnosCursos(codAlumno, nombreAlum, priApe, segApe) 
values (4, 'Santiago', 'Sanchez', 'Garcia');

select * from alumnosCursos;
select * from alumno;

