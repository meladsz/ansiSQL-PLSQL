-- Paquetes
-- Contiene objetos lógicos en su interio
-- cramos nuestro primer paquete
-- header
create or replace package pk_ejemplo
AS
-- en el header solamente se incluyen declaraciones
procedure mostrarmensaje;
end pk_ejemplo;
-- body
create or replace package body pk_ejemplo
AS
procedure mostrarmensaje
as
begin
    dbms_output.put_line('Soy un paquete');
    end;
end pk_ejemplo;

-- vamos a realizar un paquetee que contenga acciones de eliminar
-- sobre EMP, DEPT, DOCTOR, ENFERMO
create or replace package paquetedelete
as
procedure eliminaremp(p_empno emp.emp_no%type);
procedure eliminardept(p_deptno dept.dept_no%type);
procedure eliminardoctor(
p_doctorno doctor.doctor_no%type);
procedure eliminarenfermo(p_inscripcion enfermo.inscripcion%type);
end paquetedelete;

-- Cuerpo del paquete
create or replace package body paquetedelete
as
procedure eliminaremp(p_empno emp.emp_no%type)
as
begin
delete from
emp where emp_no = p_empno;
end;
procedure eliminardept(p_deptno dept.dept_no%type)
as
begin
delete from dept where dept_no = p_deptno;
end;
procedure eliminardoctor(p_doctorno doctor.doctor_no%type)
as
begin
delete from
doctor where doctor_no = p_doctorno;
end;
procedure eliminarenfermo(p_inscripcion enfermo.inscripcion%type)
as
begin
delete from enfermo where inscripcion = p_inscripcion;
end;
end paquetedelete;
-- llamada
begin
paquetedelete.eliminardept(11);
end;
rollback;
select * from dept;

-- creamos un paquete para devolver maximo, minimo y diferencia
-- todos los empleados (salario)
create or replace package pk_empleados_salarios
AS
function minimo return number;
function maximo return number;
function diferencia return number;
end pk_empleados_salarios;
-- cuerpo del paquete
create or replace package body pk_empleados_salarios
AS
    function minimo return number
as
    v_minimo emp.SALARIO%TYPE;
begin
    select min(salario) into v_minimo from emp;
return v_minimo;
end;
    function maximo return number
as
    v_maximo emp.SALARIO%TYPE;
begin
    select max(salario) into v_maximo from emp;
return v_maximo;
end;
    function diferencia return number
as
    v_diferencia emp.SALARIO%TYPE;
begin
    v_diferencia := maximo - minimo;
return v_diferencia;
end;
end pk_empleados_salarios;
-- llamada
select pk_empleados_salarios.minimo as minimo,
pk_empleados_salarios.maximo as maximo,
pk_empleados_salarios.diferencia as diferencia
from dual;

-- necesito un paquete para realizar
-- update, insert y delete sobre departamentos
-- llamamos al paquete pk_departamentos
create or replace package pk_departamentos
as
procedure insertardept(p_deptno dept.dept_no%type,
p_dnombre dept.dnombre%type,
p_loc dept.loc%type);
procedure updatedept(p_deptno dept.dept_no%type,
p_dnombre dept.dnombre%type,
p_loc dept.loc%type);
procedure deletedept(p_deptno dept.dept_no%type);
end pk_departamentos;
-- cuerpo del paquete
create or replace package body pk_departamentos
as
procedure insertardept(p_deptno dept.dept_no%type,
p_dnombre dept.dnombre%type,
p_loc dept.loc%type)
as
begin
insert into dept(dept_no,dnombre,loc)
values(p_deptno,p_dnombre,p_loc);
end;
procedure updatedept(p_deptno dept.dept_no%type,
p_dnombre dept.dnombre%type,
p_loc dept.loc%type)
as
begin
update dept set dnombre = p_dnombre,
loc = p_loc
where dept_no = p_deptno;
end;
procedure deletedept(p_deptno dept.dept_no%type)
as
begin
delete from dept where dept_no = p_deptno;
end;
end pk_departamentos;

-- necesito una funcionalidad que nos devuelva el apellido
-- el trabajo, el salario y lugar de trabajo
-- de todas las personas de nuestra bbdd

-- 1) consulta gorda
select EMP.APELLIDO, EMP.OFICIO, EMP.SALARIO
, DEPT.DNOMBRE
from EMP
inner join DEPT
on EMP.DEPT_NO=DEPT.DEPT_NO
UNION
select DOCTOR.APELLIDO, DOCTOR.ESPECIALIDAD, DOCTOR.SALARIO
, HOSPITAL.NOMBRE
from DOCTOR
inner join HOSPITAL
on DOCTOR.HOSPITAL_COD=HOSPITAL.HOSPITAL_COD
UNION
select PLANTILLA.APELLIDO, PLANTILLA.FUNCION, PLANTILLA.SALARIO
, HOSPITAL.NOMBRE
from PLANTILLA
inner join HOSPITAL
on PLANTILLA.HOSPITAL_COD=HOSPITAL.HOSPITAL_COD;
-- 2) consulta dentro de vista
create or replace view V_TODOS_EMPLEADOS as
    select EMP.APELLIDO, EMP.OFICIO, EMP.SALARIO
    , DEPT.DNOMBRE
    from EMP
    inner join DEPT
    on EMP.DEPT_NO=DEPT.DEPT_NO
    UNION
    select DOCTOR.APELLIDO, DOCTOR.ESPECIALIDAD, DOCTOR.SALARIO
    , HOSPITAL.NOMBRE
    from DOCTOR
    inner join HOSPITAL
    on DOCTOR.HOSPITAL_COD=HOSPITAL.HOSPITAL_COD
    UNION
    select PLANTILLA.APELLIDO, PLANTILLA.FUNCION, PLANTILLA.SALARIO
    , HOSPITAL.NOMBRE
    from PLANTILLA
    inner join HOSPITAL
    on PLANTILLA.HOSPITAL_COD=HOSPITAL.HOSPITAL_COD;
-- 3) paquete con dos procedimientos
create or replace package pk_empleados
as
procedure mostrar_empleados;
procedure mostrar_empleados_salario(p_salario emp.salario%type);
end pk_empleados;
-- 3A) procedimiento para devolver todos los datos de un cursor
create or replace package body pk_empleados
as
    procedure mostrar_empleados
    is
    begin
        for emp in (select * from V_TODOS_EMPLEADOS) loop
            dbms_output.put_line('Apellido: ' || emp.apellido || ', Oficio: ' || emp.oficio ||
         ', Salario: ' || emp.salario || ', Lugar: ' || emp.dnombre);
        end loop;
    end mostrar_empleados;
-- 3B) procedimiento para devolver todos los datos de un cursor por salario
    procedure mostrar_empleados_salario(p_salario emp.salario%type)
    is
    begin
        for emp in (select * from V_TODOS_EMPLEADOS where salario >= p_salario) loop
            dbms_output.put_line('Apellido: ' || emp.apellido || ', Oficio: ' || emp.oficio ||
         ', Salario: ' || emp.salario || ', Lugar: ' || emp.dnombre);
        end loop;
    end mostrar_empleados_salario;
end pk_empleados;
-- 4) llamada a los procedimientos del paquete
/
begin
  pk_empleados.mostrar_empleados;
end;
/

begin
  pk_empleados.mostrar_empleados_salario(2000);
end;
/

--Necesitamos un paquete con procedimiento para modificar el salario de cada 
--Doctor de forma individual.
--La modificación de los datos de cada doctor será de forma aleatoria.
--Debemos comprobar el Salario de cada Doctor para ajustar el número aleatorio 
--del incremento.
--1) Doctor con menos de 200.000: Incremento aleatorio de 500
--2) Doctor entre de 200.000 y 300.000: Incremento aleatorio de 300
--3) Doctor mayor a 300.000: Incremento aleatorio de 50
--El incremento Random lo haremos con una función dentro del paquete.
create or replace package pk_doctores
as
    procedure incremento_random_doctores;
    function function_random_doctores(p_iddoctor doctor.doctor_no%type)
    return number;
end pk_doctores;
-- body
create or replace package body pk_doctores
as
    procedure incremento_random_doctores
    AS
    cursor c_doctores is
    select doctor_no, apellido, salario from doctor;
    v_random number;
    begin
    for v_doc in c_doctores
    LOOP
        select trunc(dbms_random.value(1,50)) into v_random from dual;
        update doctor set salario = salario + v_random
        where doctor_no=v_doc.doctor_no;
       end loop;
    end;
    function function_random_doctores(p_iddoctor doctor.doctor_no%type)
    return number;
end pk_doctores;

DECLARE
cursor c_doctores is
select doctor_no, apellido, salario from doctor;
v_random number;
begin
    for v_doc in c_doctores
    LOOP
        select trunc(dbms_random.value(1,50)) into v_random from dual;
        update doctor set salario = salario + v_random
        where doctor_no=v_doc.doctor_no;
        end loop;
end;

create or replace function random_doctor
(p_iddoctor doctor.doctor_no%type)
return number
as 
    v_salario doctor.SALARIO%TYPE;
    v_random number;
begin
    select salario into v_salario from doctor
    where doctor_no=p_iddoctor;
    if (v_salario < 200000) then
        v_random := trunc(dbms_random.value (1,500));
    elsif (v_salario > 300000) then
        v_random := trunc(dbms_random.value (1,50));
    else
        v_random := trunc(dbms_random.value (1,300));
    end if;
    return v_random;
end;
-- 386 -> 500
-- 522 -> 50
select random_doctor(386) as incremento from dual;
select random_doctor(522) as incremento from dual;
update doctor set salario = salario + dbms_random.value(1,50);
select dbms_random.value(1,50) as aleatorio from DUAL;
select * from DOCTOR;
