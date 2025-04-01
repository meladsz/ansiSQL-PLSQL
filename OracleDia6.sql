-- insert ansi sql (menos rapido)
-- autoincremento
insert into dept values ( (select max(dept_no) + 1 from dept), 'INTO', 'INTO' );
insert into dept values ( (select max(dept_no) + 1 from dept),'INTO2', 'INTO2' );
insert into dept values ( (select max(dept_no) + 1 from dept), 'INTO3', 'INTO3' );

insert all 
into dept values (50, 'ORACLE', 'BERNABEU')
into dept values (60, 'I+D', 'OVIEDO')
select * from dual;

insert all 
into dept values ((select max(dept_no) + 1 from dept), 'ALL', 'ALL')
into dept values ((select max(dept_no) + 1 from dept), 'ALL2', 'ALL2')
into dept values ((select max(dept_no) + 1 from dept), 'ALL3', 'ALL3')
select * from dual; -- siempre dual para que no salga repetido por la cantidad de lineas que hay en tabla

select * from dept;

rollback;

-- creacion de tablas para insercciones
describe dept;

create table departamentos 
as select * from dept; -- duplicaria la tabla dept dento de departamentos

select * from departamentos;

create table doctoreshospital
as 
select doctor.doctor_no as iddoctor, doctor.apellido, hospital.nombre, hospital.telefono
from doctor
inner join hospital
on doctor.hospital_cod = hospital.hospital_cod;

select * from doctoreshospital;

-- instruccion insert into select 
insert into destino
select * from origen;

insert into departamentos
select * from dept;
select * from departamentos;

-- variables de sustitucion
select &&campo1, apellido, salario, dept_no from emp where emp_no=&numero;

select apellido , salario from emp where &condicion;
select * from emp;

-- define y undefine variable
undefine dato='VENDEDOR'
select apellido, oficio, salario, comision, dept_no
  2  from emp
  3  where oficio='&dato';
  
-- acciones con join
-- natural join 
select apellido, loc, dnombre, oficio, dept_no from emp natural join dept;

select * from emp natural join dept;

-- using
select apellido, loc, dnombre from emp inner join dept using (dept_no);


-- recuperacion jerarquica
-- tenemos un presidente que es el jefe de la empresa: rey 7839
-- mostrar todos los empleados que trabajan para rey
select * from emp where dir=7839;

-- necesito saber los empleados que trabajan para negro 7698
select * from emp where dir=7698;

-- sintaxis
select level as nivel, apellido, dir, oficio
from emp
connect by prior emp_no = dir -- decendente
start with apellido='jimenez' order by 1;

select level as nivel, apellido, dir, oficio
from emp
connect by emp_no = prior dir -- ascendente
start with apellido='jimenez' order by 1;

-- arroyo ha metido la pata, quiero ver a todos sus jefes en mi despacho.
-- manda el listado
select level, apellido, oficio from emp
connect by emp_no= prior DIR
start with apellido='arroyo';

select level as nivel, apellido, dir, oficio, sys_connect_by_path(apellido, '/') as relacion
from emp
connect by prior emp_no = dir
start with apellido='jimenez' order by 1;

-- operadores de conjuntos
-- intersect
select * from plantilla where turno='T'
intersect
select * from plantilla where funcion='ENFERMERA';

-- operador minus
-- pillar todo menos una cierta caracteristicas
select * from plantilla where turno='T'
minus
select * from plantilla where funcion='ENFERMERA';

-- creacion y gestion de tablas
create table dept
(dept_no number(9)
,dnombre varchar2(50)
,loc varchar2(50));







