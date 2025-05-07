-- TIPOS DE DATOS
-- Registros
-- es solo una variable de utilidad, para guardar tipos de datos del usuario 
-- record = %rowtype
-- Explicita 
-- TYPE nombre_tipo is record ( 
--   campo1 int, campo2 varchar2
--);

-- bloque anonimo para recuperar el apellido, oficio y salario de empleados
declare
    -- primero declaramos el tipo.
    type type_empleado is record(
        v_apellido varchar2(50),
        v_oficio varchar2(50),
        v_salario number
    );
    -- uso del tipo en una variable
    v_tipo_empleado type_empleado;
begin
    select apellido, oficio, salario into v_tipo_empleado
    from emp where EMP_NO=7839;
    DBMS_OUTPUT.PUT_LINE('apellido: ' || v_tipo_empleado.v_apellido || ', oficio:'
    || v_tipo_empleado.v_oficio || ', salario:' || v_tipo_empleado.v_salario);
end;

-- por un lado tenemos la declaracion del tipo
-- por otro lado tenemos la variable de dicho tipo
DECLARE
-- un tipo array para numeros
    type table_numeros is table of NUMBER
    INDEX by BINARY_INTEGER;
    -- objeto para almacenar varios numeros
    lista_numeros table_numeros;
BEGIN
    -- almacenamos datos en su interior
    lista_numeros(1) := 88;
    lista_numeros(2) := 99;
    lista_numeros(3) := 222;
    DBMS_OUTPUT.PUT_LINE('Numero 2 ' || lista_numeros.count);
    -- podemos recorrer todos los registros (numeros) que tengamos
    for i in 1..lista_numeros.count LOOP
    --for i in 1..3 loop
    DBMS_OUTPUT.PUT_LINE('Numero: ' || lista_numeros(i));
    END LOOP;
end;

-- almacenamos a la vez
-- guardamos un tipo fila de departamento 
declare
    type table_dept is table of dept%rowtype INDEX BY
    BINARY_INTEGER;
    --declaramos  el objeto para almacenar filas
    lista_dept table_dept;
BEGIN
    select * into lista_dept(1) from dept where dept_no=10;
    select * into lista_dept(2) from dept where dept_no=30;
    for i in 1..lista_dept.COUNT
    loop 
    DBMS_OUTPUT.PUT_LINE( lista_dept(i).dnombre || ',' || lista_dept(i).loc);
    end loop;
end;

DECLARE
  CURSOR cursorEmpleados IS
    SELECT apellido
    FROM EMP;
  TYPE c_lista IS VARRAY(20) OF EMP.apellido%TYPE;
  lista_empleados c_lista := c_lista();
  contador INTEGER := 0;
BEGIN
  FOR n IN cursorEmpleados LOOP
    contador := contador + 1;
    lista_empleados.EXTEND;
    lista_empleados(contador) := n.apellido;
    DBMS_OUTPUT.PUT_LINE('Empleado(' || contador || '): ' || lista_empleados(contador));
  END LOOP;
END;

-- trigger
-- comprobar las caracterisiticas de las consultas de accion
-- no sirven ni commit ni rollback
-- ejemplo de trigger capturando informacion 
create or replace trigger tr_dept_before_insert
before INSERT
on dept
for each ROW
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger dept before insert row');
    DBMS_OUTPUT.PUT_LINE(:new.dept_no || ',' || :new.dnombre ||
    ',' || :new.loc);
end;
insert into dept values (111, 'NUEVO', 'TOLEDO');
select * from dept;
-- delete
create or replace trigger tr_dept_before_delete
before delete
on dept
for each ROW
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger dept before delete row');
    DBMS_OUTPUT.PUT_LINE(:old.dept_no || ',' || :old.dnombre ||
    ',' || :old.loc);
end;
delete from dept where dept_no=478;
select * from dept;
-- update
create or replace trigger tr_dept_before_update
before update
on dept
for each ROW
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger dept before update row');
    DBMS_OUTPUT.PUT_LINE(:old.dept_no || ', Antigua LOC:' || :old.loc ||
    ', Nueva LOC:' || :new.loc);
end;
update dept set loc='VICTORIA' where dept_no= 111;
select * from dept;

-- trigger control doctor
create or replace trigger tr_doctor_control_salario_update
before UPDATE
on doctor
for each ROW
    when (new.salario > 250000)
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Trigger doctor before update row');
    DBMS_OUTPUT.PUT_LINE('Dr/Dra '|| :old.apellido || 'cobra mucho dinero' || :new.salario ||
    '. Antes:' || :OLD.salario);
end;
update doctor set salario = 150000 where doctor_no = 386;

-- no podemos tener dos triggers del mismo tipo de una tabla
drop trigger tr_dept_before_insert;
create or replace TRIGGER tr_dept_control_barcelona
before INSERT
on dept
for each row
    when (upper(new.loc) =  'BARCELONA')
DECLARE
begin
    DBMS_OUTPUT.PUT_LINE('Trigger Control Barcelona');
    if (upper(:new.loc) = 'BARCELONA') then 
    DBMS_OUTPUT.PUT_LINE('No se admiten departamentos en Barcelona');
    RAISE_APPLICATION_ERROR(-20001, 'Error');
    end if;
end;
drop trigger tr_dept_control_barcelona;
insert into dept values (66, 'MILAN', 'BARCELONA');
-- localidades
create or replace TRIGGER tr_dept_control_localidades
before INSERT
on dept
for each row
DECLARE
    v_num NUMBER;
begin
    DBMS_OUTPUT.PUT_LINE('Trigger Control Localidades');
    select count(dept_no) into v_num from DEPT
    where upper(loc)=upper(:new.loc);
    if (v_num > 0) then
    RAISE_APPLICATION_ERROR(-20001, 'Solo un depatamento por ciudad ' || :new.loc);
    end if;
end;
insert into dept values (6, 'MILAN', 'TERUEL');
