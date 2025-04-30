--REALIZAR UN PROCEDIMIENTO PARA INSERTAR UN NUEVO DEPARTAMENTO
 create or replace procedure sp_insertardepartamento
 (p_id DEPT.DEPT_NO%TYPE
 , p_nombre DEPT.DNOMBRE%TYPE
 , p_localidad DEPT.LOC%TYPE)
 as
 begin
     insert into DEPT values (p_id, p_nombre, p_localidad);
     --normalmente, dentro de los procedimientos de acción se incluye
     --commit o rollback si diera una excepción
     commit;
 end;
 --llamada al procedimiento
 begin
     sp_insertardepartamento(11, '11', '11');
 end;
 select * from DEPT;
 rollback;
 --VERSION 2
 --REALIZAR UN PROCEDIMIENTO PARA INSERTAR UN NUEVO DEPARTAMENTO
 --GENERAMOS EL ID CON EL MAX AUTOMATICO DENTRO DEL PROCEDURE
 create or replace procedure sp_insertardepartamento
 (p_id DEPT.DEPT_NO%TYPE
 , p_nombre DEPT.DNOMBRE%TYPE
 , p_localidad DEPT.LOC%TYPE)
 as
 begin
     select max(dept_no) + 1 into v_max_id from DEPT;
     insert into DEPT values (v_max_id, p_nombre, p_localidad);
     --normalmente, dentro de los procedimientos de acción se incluye
     --commit o rollback si diera una excepción
     commit;
    EXCEPTION
        when no_data_found then
            dbms_output.put_line('No existen datos');
            ROLLBACK;
 end;
 --llamada al procedimiento
 begin
     sp_insertardepartamento(11, '11', '11');
 end;
 select * from dept;

-- realizar un procedimiento para incrementar el salario de 
-- los empleados por un oficio
-- debemos enviar el oficio y el incremento
create or replace procedure sp_incrementosalario
    (p_oficio EMP.OFICIO%TYPE, p_incremento NUMBER)
    as
    BEGIN
        update EMP set SALARIO = SALARIO + p_incremento where upper(OFICIO) = upper(p_oficio);
        commit;
end;
BEGIN
    sp_incrementosalario('ANALISTA', 1);
END;
SELECT * FROM EMP WHERE OFICIO = 'ANALISTA';

-- necesito un procedimiento para insertar un doctor
-- enviar los datos del doctor, excepto el id
-- debemos recuperar el maximo id de doctor dentro del procedimiento
create or replace procedure sp_insertar_doctor
(p_hospital_cod doctor.hospital_cod%TYPE,
    p_apellido doctor.apellido%TYPE,
    p_especialidad doctor.especialidad%TYPE,
    p_salario doctor.salario%TYPE)
as
    v_max_doctor_no doctor.doctor_no%TYPE;
begin
    select max(doctor_no) + 1 into v_max_doctor_no from doctor;
    insert into doctor values (v_max_doctor_no, p_hospital_cod, p_apellido, p_especialidad, p_salario);
    commit;
end;
BEGIN
    sp_insertar_doctor(19, 'Willson', 'cirujano', 1000);
END;
select * from doctor;
ROLLBACK;

-- VERSION 2
-- enviamos el nombre del hospital en lugar del id del hospital
-- controlar si no existe el hospital enviado
create or replace procedure sp_insertar_doctor
(p_hospital_nombre hospital.nombre%TYPE,
    p_apellido doctor.apellido%TYPE,
    p_especialidad doctor.especialidad%TYPE,
    p_salario doctor.salario%TYPE)
as
    v_max_doctor_no doctor.doctor_no%TYPE;
    v_hospital_cod hospital.hospital_cod%TYPE;

BEGIN
    select hospital_cod into v_hospital_cod 
    from hospital where upper(nombre) = upper(p_hospital_nombre);
    select max(doctor_no) + 1 into v_max_doctor_no from doctor;
insert into doctor values (v_max_doctor_no, v_hospital_cod, p_apellido, p_especialidad, p_salario);
end;
BEGIN
    sp_insertar_doctor('la paz', 'House', 'diagnostico', 123000);
END;

-- podemos utilizar cursores explicitos dentro de un procedimiento
-- reaalizar un procedimiento para mostrar los empleados
-- de un deterrminado numero de departamento
create or replace PROCEDURE sp_empleados_dept
(p_deptno emp.dept_no%TYPE)
AS
    cursor cursor_emp is
    select * from emp where dept_no = p_deptno;
BEGIN
    for v_reg_emp in cursor_emp
    loop
        dbms_output.put_line(' apellido: ' || v_reg_emp.apellido || ', oficio: ' || v_reg_emp.oficio);
    end loop;
    end;
BEGIN
    sp_empleados_dept(10);
END;


create or replace procedure ejemploOpcionales
(p_uno int, p_dos int := 0, p_tres int := 0)
AS

begin 
ejemploOpcionales(8); -- error
ejemploOpcionales(8, p_tres =>9);
ejemploOpcionales(8, 9, 10);
end;

-- Procedimientos almacenados con parámetros de salida
-- vamos a realizar un procedimiento para enviar el
-- nombre del departamento y devolver el numero de dicho departamento
create or replace procedure sp_numerodepartamento
    (p_nombre dept.dnombre%TYPE)
AS
    v_iddept dept.dept_no%TYPE;
BEGIN
    select dept_no into v_iddept from dept 
    where upper(dnombre) = upper(p_nombre);
    dbms_output.put_line('El id del departamento es: ' || v_iddept);
end;
BEGIN
    sp_numerodepartamento('VENTAS');
END;

-- necesito un procedimiento para incrementar en 1
-- el salario de los empleados de un departamento
-- enviaremos al procedimiento el nombre del departamento
create or replace procedure sp_incrementar_sal_dept
(p_nombre dept.dnombre%TYPE)
as
    v_num dept.DEPT_NO%TYPE;
begin
    -- recuperamos el id del departamento a partir del nombre
    -- llamamo al procedimiento de numero para recuperar el numero
    -- a partir del nombre
    -- (p_nombre dept.dnombre%TYPE,
    -- p_iddept out dept.dept_no%TYPE)
    select dept_no into v_num 
    from dept where upper(dnombre) = upper(p_nombre);
    update emp set salario = salario + 1 where dept_no = v_num;
    dbms_output.PUT_LINE ('salarios modificados: ' ||  sql%rowcount);
end;
begin
    sp_incrementar_sal_dept('VENTAS');
end;
