/*REALIZA LAS SIGUIENTES CONSULTAS UTILIZANDO ROWNUM:

1.1 MUESTRA EL NOMBRE DE LOS 2 TRABAJADORES MÁS MAYORES INDICANDO LA DESCRIPCIÓN DE LA PLANTA A LA QUE PERTENECEN*/


SELECT * FROM
    (
    SELECT t.nombre, t.priApe, t.fecha_nac, p.descrip
    FROM trabajador t
    JOIN planta p USING (idPlanta)
    ORDER BY t.fecha_nac ASC;
    )
WHERE ROWNUM <= 2;
/*
NOMBRE	PRIAPE	FECHA_NAC	DESCRIP
Mario	Sanchez	09-FEB-80	Accesorios
Jorge	Blazquez	02-MAR-81	Libros
*/

/*1.2 MUESTRA EL NOMBRE DE LOS 3 TRABAJADORES QUE HAYAN VENDIDO LOS PRODUCTOS MÁS CAROS, TAMBIÉN DEBES INDICAR LA DESCRIPCIÓN
Y EL PRECIO DEL PRODUCTO*/

SELECT * FROM
    (
    SELECT t.nombre, t.priApe, p.descripc, p.precio
    FROM trabajador t
    JOIN producto p USING (idTrab)
    ORDER BY p.precio DESC
    )
WHERE ROWNUM <= 3;

/*
NOMBRE	PRIAPE	DESCRIPC	PRECIO
Susana	Garcia	Port�til Toshiba	1000
Susana	Garcia	Tablet	300
Amparo	Arribas	Ipod	100
*/

/*1.3 MUESTRA EL NOMBRE DE LOS TRES TRABAJADORES QUE MÁS PRODUCTOS HAN VENDIDO. ADEMÁS, DEBES MOSTRAR EL NÚMERO DE PRODUCTOS
QUE HAN VENDIDO ESTOS TRABAJADORES*/
/*
    SELECT t.nombre, t.priApe, p.descripc, COUNT(idTrab)
    FROM trabajador t
    JOIN producto p USING (idTrab)
    GROUP BY COUNT(idTrab);*/


/*2. CREA LAS SIGUIENTES VISTAS


2.1 CREA LA VISTA vsTrabajador QUE MUESTRE EL NOMBRE Y LA FECHA DE NACIMIENTO DE LOS TRABAJADORES*/

CREATE OR REPLACE VIEW vsTrabajador(nombre, priApe, fecha_nac) AS
    (
    SELECT nombre, priApe, fecha_nac
    FROM trabajador
    );

SELECT * FROM vsTrabajador;

/*
NOMBRE	PRIAPE	FECHA_NAC
Carla	Rodriguez	25-APR-85
Mario	Sanchez	09-FEB-80
Susana	Garcia	10-SEP-83
Amparo	Arribas	30-JAN-88
Jorge	Blazquez	02-MAR-81
*/

/*2.1.1 ¿SE PUEDE DAR DE ALTA UN NUEVO TRABAJADOR? JUSTIFICA LA RESPUESTA CON UN EJEMPLO*/

--No se puede dar de alta un nuevo trabajador ya que no disponemos de la clave primaria 'idTrab' en la vista.
--Intentamos hacer el siguiente INSERT:
INSERT INTO vsTrabajador VALUES('Pepito', 'Perez', TO_DATE('17/05/2000','DD/MM/YYYY'));
--Y tenemos como error nos sale el siguiente, justificando nuestra respuesta anterior:
ORA-01400: cannot insert NULL into ("SQL_FALOHMPZHBQHUXTOKTLPNJYMK"."TRABAJADOR"."IDTRAB") ORA-06512: at "SYS.DBMS_SQL", line 1721

/*2.1.2 ¿SE PUEDE MODIFICAR UN TRABAJADOR? JUSTIFICA LA RESPUESTA CON UN EJEMPLO*/

--Si, si podemos actualizar los datos dado que la modificación de la vista solo afecta a una tabla
--Para comprobarlo utilizamos el siguiente UPDATE;:
UPDATE vsTrabajador SET nombre = 'Pepe' WHERE nombre = 'Mario';

SELECT * FROM vsTrabajador;

--Nos sale el siguiente resultado:
/*
NOMBRE	PRIAPE	FECHA_NAC
Carla	Rodriguez	25-APR-85
Pepe	Sanchez	09-FEB-80
Susana	Garcia	10-SEP-83
Amparo	Arribas	30-JAN-88
Jorge	Blazquez	02-MAR-81
*/

/*2.1.3 ¿SE PUEDE BORRAR UN TRABAJADOR? JUSTIFICA LA RESPUESTA CON UN EJEMPLO*/

--No podemos, ya que la vista no contiene ni la pk 'idTrab' ni las fk 'idJefe' e 'idPlanta'
--Tratamos de hacer un DELETE:
DELETE FROM vsTrabajador WHERE nombre = 'Pepe';
--Y obtenemos el siguiente error:
ORA-02292: integrity constraint (SQL_FALOHMPZHBQHUXTOKTLPNJYMK.TRA_IDJ_FK) violated - child record found ORA-06512: at "SYS.DBMS_SQL", line 1721

/*2.2 CREA LA VISTA vsTrabajadorPlanta QUE MUESTRE EL TRABAJADOR Y LA DESCRIPCIÓN DE LA PLANTA A LA QUE PERTENECE
CON LA OPCIÓN WITH READ ONLY*/

CREATE OR REPLACE VIEW vsTrabajadorPlanta(nombre, priApe, descrip) AS
    (
    SELECT t.nombre, t.priApe, p.descrip
    FROM trabajador t
    JOIN planta p USING (idPlanta)
    )
WITH READ ONLY;

SELECT * FROM vsTrabajadorPlanta;

/*
NOMBRE	PRIAPE	DESCRIP
Carla	Rodriguez	Inform�tica
Pepe	Sanchez	Accesorios
Susana	Garcia	Accesorios
Amparo	Arribas	M�sica
Jorge	Blazquez	Libros
*/

/*2.2.1 ¿SE PUEDE DAR DE ALTA UN NUEVO TRABAJADOR? JUSTIFICA LA RESPUESTA CON UN EJEMPLO*/

--No se puede dar de alta un nuevo trabajador ya que le hemos puesto la opcion de WITH READ ONLY
INSERT INTO vsTrabajadorPlanta VALUES('Pepa', 'Perez', 'Libros');
--Nos da el siguiente error:
ORA-42399: cannot perform a DML operation on a read-only view

/*2.2 CREA LA VISTA vsProductoTrabajador QUE MUESTRE EL idProducto, SU DESCRIPCIÓN, SU PRECIO Y EL NOMBRE DEL TRABAJADOR QUE LO HA VENDIDO.
SÓLO SE DEBERÁN INCLUIR EN LA VISTA LOS PRODUCTOS CUYOS PRECIOS SEAN MAYORES A 50€. CREA LA VISTA CON LA OPCIÓN WITH CHECK OPTION*/

CREATE OR REPLACE VIEW vsProductoTrabajador(idProducto, descripc, precio, nombre, priApe) AS
    (
    SELECT p.idProducto, p.descripc, p.precio, t.nombre, t.priApe
    FROM producto p
    JOIN trabajador t USING (idTrab)
    WHERE p.precio > 50
    )
WITH CHECK OPTION;

SELECT * FROM vsProductoTrabajador;

/*
IDPRODUCTO	DESCRIPC	        PRECIO	    NOMBRE	PRIAPE
4	        Malet�n	           90	        Carla	Rodriguez
1	        Port�til Toshiba   1000	        Susana	Garcia
6	        Tablet	            300	         Susana	Garcia
2	        Ipod	            100	        Amparo	Arribas
*/

/*2.3.1 ¿SE PUEDE MODIFICAR EL PRECIO DEL IPOD QUE VALE 100€ POR 40€? JUSTIFICA LA RESPUESTA CON UN EJEMPLO*/

--No nos va a dejar porque estamos intentando introducir un precio menor que el especificado en la vista de 50€
--Intentamos el siguiente UPDATE
UPDATE vsProductoTrabajador SET precio = 40 WHERE descripc = 'Ipod';
--Nos da el siguiente error:
ORA-01402: view WITH CHECK OPTION where-clause violation ORA-06512: at "SYS.DBMS_SQL", line 1721

/*3. CREA LOS SIGUIENTES BLOQUES PL/SQL:

3.1 UNO QUE MUESTRE POR PANTALLA A QUÉ PLANTA PERTENECE EL TRABAJADOR CON IDENTIFICADOR 2 DE LA SIGUIENTE MANERA:
    El trabajador Mario trabaja en la planta de Accesorios*/

DECLARE
    v_nombre trabajador.nombre%TYPE;
    v_planta planta.descrip%TYPE;
BEGIN
    SELECT t.nombre, p.descrip INTO v_nombre, v_planta
    FROM trabajador t
    JOIN planta p USING (idPlanta)
    WHERE idTrab = 2;

    DBMS_OUTPUT.PUT_LINE('El trabajador ' || v_nombre || ' trabaja en la planta de ' || v_planta);
END;

/*
El trabajador Pepe trabaja en la planta de Accesorios
*/
--Como aclaración, a mi me sale Pepe en lugar de Mario porque en uno de los ejercicios anteriores de Update a una vista he
--cambiado justo el trabajador Mario. Concretamente ha sido en el 2.1.2

--Cambiando la consulta para usar %ROWTYPE:

DECLARE
    CURSOR cTrabajador IS
        SELECT t.nombre, p.descrip
        FROM trabajador t
        JOIN planta p USING (idPlanta)
        WHERE idTrab = 2;
    registro trabajador%ROWTYPE;
BEGIN
    FOR registro IN cTrabajador LOOP
        DBMS_OUTPUT.PUT_LINE('El trabajador ' || registro.nombre || ' trabaja en la planta de ' || registro.descrip);
    END LOOP;
END;

/*
El trabajador Pepe trabaja en la planta de Accesorios
*/

/*3.2 OTRO QUE MUESTRE POR PANTALLA LOS TRABAJADORES QUE PERTENECEN A LA PLANTA DE ACCESORIOS DE LA SIGUIENTE MANERA:

    Mario trabaja en la planta de accesorios
    Susana trabaja en la planta de accesorios
    */

DECLARE
    CURSOR cTrabajador IS
        SELECT t.nombre, p.descrip
        FROM trabajador t
        JOIN planta p USING (idPlanta)
        WHERE p.descrip LIKE 'Accesorios';
BEGIN
    FOR rTrabajador IN cTrabajador LOOP
        DBMS_OUTPUT.PUT_LINE(rTrabajador.nombre || ' trabaja en la planta de ' || rTrabajador.descrip);
    END LOOP;
END;

/*
Pepe trabaja en la planta de Accesorios
Susana trabaja en la planta de Accesorios
*/

--Nos sale Pepe en lugar de Mario por la misma razon que antes

/*3.3 UTILIZANDO PARÁMETROS MUESTRA QUÉ TRABAJADOR HA VENDIDO EL PRODUCTO 'TABLET' DE LA SIGUIENTE MANERA:

    Susana ha vendido la Tablet*/

DECLARE
    CURSOR cTrabajador(p_nombre producto.descripc%TYPE) IS
        SELECT t.nombre, p.descripc
        FROM trabajador t
        JOIN producto p USING (idTrab)
        WHERE p.descripc LIKE p_nombre;
BEGIN
    FOR rTrabajador IN cTrabajador('Tablet') LOOP
        DBMS_OUTPUT.PUT_LINE(rTrabajador.nombre || ' ha vendido la ' || rTrabajador.descripc);
    END LOOP;
END;

/*
Susana ha vendido la Tablet
*/

/*3.4 UTILIZANDO ACTUALIZACIONES AL RECOGER REGISTROS SUBE EL PRECIO 10€ A LOS PRODUCTOS QUE VALGAN MÁS DE 100€.
ADEMÁS DE ACTUALIZAR EL PRECIO DEBERÁS SACAR UN MENSAJE POR PANTALLA COMO EL SIGUIENTE:

    Producto Portátil Toshiba. Pasa de costar 1000 a costar 1010
    Producto Tablet. Pasa de costar 300 a costar 310
    */

DECLARE
    CURSOR cProductos IS
        SELECT descripc, precio
        FROM producto
    	FOR UPDATE OF precio NOWAIT;
BEGIN
    FOR rProducto IN cProductos LOOP
        IF (rProducto.precio >= 100) THEN
            UPDATE producto SET precio = precio + 10
            WHERE CURRENT OF cProductos;
            DBMS_OUTPUT.PUT_LINE(rProducto.descripc || '. Pasa de costar ' || rProducto.precio || ' a costar ' || (rProducto.precio + 10));
        END IF;
    END LOOP;
END;