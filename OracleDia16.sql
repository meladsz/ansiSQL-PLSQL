-- exception
-- capturar una excepcion del sistema
DECLARE
v_numero1 NUMBER := &numero1;
v_numero2 NUMBER := &numero2;
v_division NUMBER;
BEGIN
v_division := v_numero1 / v_numero2;
DBMS_OUTPUT.PUT_LINE('El resultado de la division es: ' || v_division);
EXCEPTION
WHEN ZERO_DIVIDE THEN
DBMS_OUTPUT.PUT_LINE('Error: Division por cero no permitida.');
end;
UNDEFINE numero1;
UNDEFINE numero2;

-- cuando los empleados tengan una comision con valor 0,
-- lanzar una excepcion
-- tendremos una tabla donde almacenaremos los empleados
-- con comision mayor a 0
CREATE TABLE emp_comision (apellido VARCHAR2(50), comision NUMBER(9));

DECLARE
    CURSOR cursor_emp IS
        SELECT apellido, comision FROM emp order by comision desc;
        exception_comision EXCEPTION;
BEGIN
    for v_record in cursor_emp LOOP
    INSERT INTO emp_comision (apellido, comision) VALUES (v_record.apellido, v_record.comision);
    if (v_record.comision = 0) then
        RAISE exception_comision;
    end if;
    END LOOP;
EXCEPTION
    -- quiero detener el cursor cuando la comision es 0
    WHEN exception_comision THEN
        DBMS_OUTPUT.PUT_LINE('Comision a 0.');
END;

-- pragma exceptions
DECLARE
    exception_nulos EXCEPTION;
    PRAGMA EXCEPTION_INIT(exception_nulos, -1400);
BEGIN
INSERT into dept VALUES (null, 'DEPARTAMENTO', 'PRAGMA');
EXCEPTION
    WHEN exception_nulos THEN
        DBMS_OUTPUT.PUT_LINE('Error: No se puede insertar un valor nulo en la columna DEPTNO.');
END;

-- exception en un bloque de excepcion
DECLARE
    v_id NUMBER;
BEGIN
    SELECT dept_no INTO v_id FROM dept WHERE dnombre = 'VENTAS';
    DBMS_OUTPUT.PUT_LINE('El id del departamento de ventas es: ' || v_id);
EXCEPTION
    when too_many_rows then
        DBMS_OUTPUT.PUT_LINE(' Se encontraron demasiadas filas en cursor');
    when others then
        DBMS_OUTPUT.PUT_LINE(to_char (sqlcode) || ' '  || sqlerrm);
end;

-- raise_application_error
-- raise_application_error es una funcion que lanza un error de usuario
DECLARE
    v_id NUMBER;
BEGIN
    RAISE_APPLICATION_ERROR(-20401, 'puedo hacer esto con Exception???');
    SELECT dept_no INTO v_id FROM dept WHERE dnombre = 'VENTAS';
    DBMS_OUTPUT.PUT_LINE('El id del departamento de ventas es: ' || v_id);
end;

-- procedimientos almacenados
-- ejemplo procedimiento para mostrar un mensaje
create or REPLACE PROCEDURE sp_mensaje 
AS 
BEGIN
 -- mostrar un mensaje
    DBMS_OUTPUT.PUT_LINE('Hoy es juernes con musica!!!');
end;
-- llamada al procedimiento
BEGIN 
    sp_mensaje;
END;
exec sp_mensaje;

-- creamos un procedimiento
create or REPLACE PROCEDURE sp_ejemplo_plsql
AS
BEGIN
-- procedimiento con bloque psql
DECLARE
    v_numero NUMBER;
BEGIN
    v_numero := 14;
    if v_numero > 0 then
        DBMS_OUTPUT.PUT_LINE('Positivo');
    else
        DBMS_OUTPUT.PUT_LINE('Negativo');
    end if;
END;
end;
-- llamada al procedimiento
BEGIN
    sp_ejemplo_plsql;
END;
-- tenemos otra sintaxispara tener variables
-- dentro de un procedimiento
-- no se utiliza la palabra declare
CREATE OR REPLACE PROCEDURE sp_ejemplo_plsql2
AS
    v_numero NUMBER;
BEGIN
    if v_numero > 0 then
        DBMS_OUTPUT.PUT_LINE('Positivo');
    else
        DBMS_OUTPUT.PUT_LINE('Negativo');
    end if;
END;

BEGIN
    sp_ejemplo_plsql2;
END;

-- procedimiento para sumar dos numeros
create or replace PROCEDURE sp_suma (p_numero1 NUMBER, p_numero2 NUMBER)
as 
    v_suma NUMBER;
BEGIN
    v_suma := p_numero1 + p_numero2;
    DBMS_OUTPUT.PUT_LINE('La suma de ' || p_numero1 || ' + ' || p_numero2 || ' es: ' || v_suma);
END;
-- llamada al procedimiento
BEGIN
    sp_suma(10, 20);
END;

-- necesito un procedimiento para dividir dos numeros
-- se llamara sp_dividir_numeros
create or replace PROCEDURE sp_dividir_numeros (p_numero1 NUMBER, p_numero2 NUMBER)
AS
    v_division NUMBER;
BEGIN
    v_division := p_numero1 / p_numero2;
    DBMS_OUTPUT.PUT_LINE('La division de ' || p_numero1 || ' / ' || p_numero2 || ' es: ' || v_division);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Division entre cero PROCEDURE');
END;
-- llamada al procedimiento
BEGIN
    sp_dividir_numeros(10, 0);
EXCEPTION
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Division entre cero, PL/SQL outer');
END;



