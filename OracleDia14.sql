-- bloque para consultas de accion
-- insertar 5 departamento en un bloque pl/sql dinamico3.
DECLARE
v_nombre dept.dnombre%type;
v_loc dept.loc%type; -- %type para que coja el tipo de tabla por ejemplo loc 
BEGIN
    -- vamos a realizar un bucle para insertar 5 departamentos
    for i in 1..5 loop
        v_nombre := ' Departamento ' || i;
        v_loc := 'Localidad ' || i;
        insert into dept values (i, v_nombre, v_loc);
    end loop;
    dbms_output.put_line( 'Fin del progama');
end;
select * from dept;

-- crear 5 departamentos sumandole uno al ultimo numero de departamento
DECLARE
v_nombre dept.dnombre%type;
v_loc dept.loc%type; 
BEGIN
    for i in 1..5 loop
        v_nombre := ' Departamento ' || i;
        v_loc := 'Localidad ' || i;
        insert into dept values ( (select max(dept_no) + 1 from dept)
            , v_nombre, v_loc);
    end loop;
    dbms_output.put_line( 'Fin del progama');
end;
select * from dept;
rollback;

-- realizar un bloque pl(sql) que pedira un numero al
-- usuario y mostrara el departamento con dicho numero
DECLARE
v_id int;
BEGIN
    v_id := &numero;
    select * from dept where dept_no = v_id;
END;
UNDEFINE numero;
-- esta no funcionaria porque solo se puede hacer select si hay antes un "insert into, update, delete"

-- CURSORES --
-- cursor implicito 
-- solo puede devolver una fila, sino da error
-- recuperar el oficio del empleado rey
DECLARE
    v_oficio emp.OFICIO%TYPE;
BEGIN
    select oficio into v_oficio from emp where upper (APELLIDO)='REY';
    DBMS_OUTPUT.PUT_LINE ('El oficio de REY es ...' || v_oficio);
end;

-- cursor explicito
-- pueden devolver mas de una fila
-- y se declara el cursor 
-- mostrar el apellido y salario de todos los empleados
DECLARE
    v_ape emp.APELLIDO%TYPE;
    v_sal emp.SALARIO%TYPE;
    -- declaramos nuestro cursor con una consulta
    -- la consulta debe tener los mismos datos para luego
    -- hacer el fetch
    CURSOR CURSOREMP IS
    select APELLIDO, SALARIO from emp;
BEGIN
    -- abrir el cursor
    OPEN CURSOREMP;
    -- bucle infinito
    LOOP
        -- extraemos los datos del cursor
        fetch CURSOREMP into v_ape, v_sal; -- mismo orden que el select
        exit when CURSOREMP%notfound;
        -- dibujamos los datos
        DBMS_OUTPUT.PUT_LINE('Apellido: '|| v_ape || ', Salario: ' || v_sal);
    end loop;  
    -- cerrar cursor
    close CURSOREMP;
end;

-- atributo rowcount para las consultas de accion
-- incrementar en 1 el salario de los empleados del departamento
-- 10.
-- mostrar el numero de los empleados modificados
begin 
    update emp set salario = salario + 1
    where dept_no = 10;
    DBMS_OUTPUT.PUT_LINE('Empleados modificados ' || SQL%rowcount);
end;

-- incrementar en 10000 al empleado que menos cobre en la plantilla
-- minimo salario implicito
declare 
v_sal emp.SALARIO%TYPE;
BEGIN
    select min(salario) into v_sal FROM emp;
    update emp set salario = salario + 10000
    where salario= v_sal;
    DBMS_OUTPUT.PUT_LINE(' Salario incrementado a ' || sql%rowcount || ' empleados ' );
end;

-- modificar un departameno su nombre y localidad
-- si el departamento no existe, lo insertamos
-- 90, I+D, GIJON
DECLARE
    v_id dept.dept_no%TYPE := 90;
    v_dnombre dept.dnombre%TYPE := 'I+D';
    v_loc dept.loc%TYPE := 'GIJON';
    v_existe dept.dept_no%TYPE := NULL;
    CURSOR CURSORDEPT IS 
        SELECT dept_no FROM dept;
BEGIN
    OPEN CURSORDEPT;
    LOOP
        FETCH CURSORDEPT INTO v_existe;
        EXIT WHEN CURSORDEPT%NOTFOUND;

        IF v_existe = v_id THEN
            -- Ya existe, hacemos el UPDATE
            UPDATE dept
            SET dnombre = v_dnombre,
                loc = v_loc
            WHERE dept_no = v_id;

            DBMS_OUTPUT.PUT_LINE('Departamento actualizado.');
            CLOSE CURSORDEPT;
            RETURN; -- Termina el bloque aquí porque ya actualizó
        END IF;
    END LOOP;
    CLOSE CURSORDEPT;

    -- Si llegó aquí es que no lo encontró → hacemos el INSERT
    INSERT INTO dept (dept_no, dnombre, loc)
    VALUES (v_id, v_dnombre, v_loc);
    DBMS_OUTPUT.PUT_LINE('Departamento insertado.');
END;
select * from dept;

-- modificar el salario del empleado ARROYO
-- si el empleado cobra mas de 250.000, le bajamos el sueldo en 10.000
-- sino, le subimos el sueldo en 10000
DECLARE
    v_sal emp.salario%TYPE;
    v_idemp emp.EMP_NO%TYPE;
BEGIN
    SELECT emp_no, salario INTO v_idemp, v_sal
    FROM emp
    WHERE UPPER(apellido) = 'arroyo';
IF
v_sal > 250000 then
v_sal := v_sal - 10000;
ELSE
v_sal := v_sal + 10000;
end if;
update emp 
set SALARIO = v_sal
where EMP_NO = v_idemp;
DBMS_OUTPUT.PUT_LINE ('Salario modificado ');
end;
