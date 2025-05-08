-- cascada dept
create or replace trigger tr_update_dept_cascade
before update
on dept
for each row
    when (new.dept_no <> old.dept_no)
declare
begin
    dbms_output.put_line ('Dept_no cambiando');
    -- modificamos los datos asociados (emp)
    update emp set dept_no=:new.dept_no where
    dept_no=: old.dept_no;
end;
update dept set dept_no=31 where DEPT_NO=30;

-- Impedir insertar un nuevo presidente si ya existe uno en la tabla EMP
drop TRIGGER tr_emp_control_presi_insert;
create or REPLACE TRIGGER tr_emp_control_presi_insert
BEFORE INSERT
on EMP
for each ROW
DECLARE
    v_presis NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Derrocando presidente !!!');
    select count(emp_no) into v_presis from emp
    where upper(OFICIO)='PRESIDENTE';
    if v_presis <> 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Solo un presidente activo');
    end if;
end;
INSERT INTO emp VALUES (2222,'USURPADOR', 'PRESIDENTE', 7566, sysdate, 120000, 2000, 20);

-- no quiero que exista mas de una localidad si hacemos un update
create or replace TRIGGER tr_dept_control_localidades
before update
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
update dept set loc='CADIZ' where DEPT_NO=10;

-- package para almacenar las variables entre triggers
create or replace PACKAGE pk_triggers
AS
    v_nueva_localidad dept.LOC%TYPE;
end pk_triggers;

create or replace TRIGGER tr_dept_control_localidades_row
BEFORE UPDATE
on dept
for each ROW
declare
BEGIN
    -- almacenamos el valor de la nueva localidad
    PK_TRIGGERS.v_nueva_localidad := :new.loc;
end;
-- creamos el trigger de update para after
create or replace trigger tr_dept_control_localidades_after
after UPDATE
on dept
DECLARE
v_numero NUMBER;
BEGIN
    select COUNT(dept_no) into v_numero from DEPT
    where upper(loc)=upper(PK_TRIGGERS.v_nueva_localidad);
    if (v_numero > 0) THEN
    RAISE_APPLICATION_ERROR(-20001, 'Solo un departameno por localidad');
    end if;
    dbms_output.PUT_LINE('Localidad nueva: ' || PK_TRIGGERS.v_nueva_localidad);
end;

-- trigger instead of
-- cramos una visa ccon todos los datos de los departamentos
create or replace view vista_departamentos
AS
    SELECT * from dept;
-- solo trabajamos con la vista
insert into vista_departamentos VALUES
(12, 'VISTA', 'SIN TRIGGER');
-- creamos un trigger sobre la vista
create or replace trigger tr_vista_dept
INSTEAD of INSERT
on vista_departamentos
DECLARE
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertando vista dept');
end;
select * from dept;
-- vamos a crear una vista con los datos de los empleados
-- pero sin sus datos sensibles (salario, comision, fecha_alt)
create or replace view vista_empleados
AS
    select emp_no, apellido, oficio, dir, dept_no from emp;
select * from VISTA_EMPLEADOS;
insert into VISTA_EMPLEADOS values (555, 'el nuevo', 'BECARIO', 7566, 31);
-- si miramos en la tabla... 
select * from emp order by emp_no;

-- creamos un trigger rellenando los huecos que queden de emp
create or REPLACE TRIGGER tr_vista_empleados
instead of INSERT
on vista_empleados
DECLARE
BEGIN
    -- con new capturamos los datos que vienen en la vista
    -- y rellenamos el resto
    insert into emp values (:new.emp_no, :new.apellido, :new.oficio,
    :new.dir, sysdate, 0, 0, :new.dept_no);
end;

-- vamos a crear una vista para mostrar doctores
create or replace view vista_doctores
AS
    SELECT doctor.doctor_no, doctor.apellido, doctor.especialidad,
    doctor.salario, hospital.nombre
    from doctor
    inner join hospital
    on doctor.hospital_cod = hospital.hospital_cod;
select * from VISTA_DOCTORES;
insert into VISTA_DOCTORES VALUES
(111,'HOUSE 2', 'Especialista', 450000, 'provincial');

-- meter info a dos tablas utilizando trigger y new
create or replace trigger tr_vista_doctor
instead of insert
on vista_doctores
declare
    v_codigo hospital.hospital_cod%TYPE;
begin
select hospital_cod into v_codigo from hospital
where upper(nombre)=upper(:new.nombre);
insert into doctor values
(v_codigo, :new.doctor_no, :new.apellido, :new.especialidad, :new.salario);
end;

-- sql dinamico
-- 1=1 inyeccion sql, devuelve todo
