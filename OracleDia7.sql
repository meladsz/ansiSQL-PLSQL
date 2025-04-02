-- CONCEPTO Y CREACIÓN DE TABLAS
create table prueba (
identificador integer,
texto10 varchar2 (10),
textochar char(5) 
);

describe prueba; 

insert into prueba values (1, 'absdbasjdb', 'aeiou');
insert into prueba values (1, 'A', 'A');
rollback;
select * from prueba;
delete from prueba;

drop table prueba; -- eliminar base de datos

-- la tabla prueba contiene un registro
-- agregamos una nueva columna de tipo texto llamada nueva
alter table prueba
add (nueva varchar2(3));

-- agregamops otra columna de tipo texto llamada sinnulos
-- y va a ser not null
alter table prueba
add (sinnulos varchar2(7) not null);

alter table prueba 
modify (nueva float); -- decimales

rename prueba to examen; -- renombrar tabla
describe examen;

truncate table examen; -- los datos se piran 

comment on table prueba is 'Hoy es miercoles y mañana jueves'; -- hacer comentario

select * from all_tab_comments where table_name='PRUEBA'; -- ver comentarios
select * from user_tab_comments where table_name='PRUEBA'; -- ver comentarios

select * from user_tables; -- de mi usuario
select * from all_tables; -- de todos los usuarios

select distinct object_type from user_objects; -- tipos de objetos creados por el usuario
select * from cat; -- objetos creados por el usuario

-- añadimos una columna llamada test
alter table prueba
add (test int);

-- añadimos otra columna pero que contendra valore por defecto
alter table prueba
add (defecto int default -1);

insert into prueba values (1, 'absdbasjdb', 'aeiou');
insert into prueba
(identificador, texto10, textochar)
values
(2, 'AA', 'AA');

insert into prueba (identificador, texto10, textochar, DEFECTO, TEST)
values (2, 'CC', 'CC', -1, NULL);
select * from prueba;

---------------------------------------------------------------------
-- incluimos una restriccion primary key en el campo
-- dept_no de departamentos para que no puda admitir nulos
alter table dept
add constraint pk_dept
primary key (dept_no);

-- todas las restricciones del usuario se encuentran en el diccionario
-- user_contraints 
select * from user_constraints;

-- intentamos insertar un departamento repetido
insert into dept values (10, 'REPE', 'REPE');
select * from dept;

-- eliminamo la restriccion de primary key de departamentos
alter table dept
drop constraint pk_dept;

delete from dept where dept_no=10;
commit;
----------empleados------------
-- creamos una primary key para el campo emp_no 
alter table emp
add constraint pk_emp
primary key (emp_no);

select * from emp; 

-- creamos una restriccion para comprobar que el salario siempre sea positivo
alter table emp
add constraint ch_emp_salario
check (salario >= 0); 

-- ponemos un valor negativo a un empleado
update emp set salario= -1 where emp_no= 7782; -- se viola la restriccion al ser negativo

alter table emp
drop constraint ch_emp_salario;

---------enfermos------------
alter table enfermo 
add constraint pk_inscripcion
primary key (inscripcion);

-- unique para el dato de nss, seguridad social
alter table enfermo
add constraint u_enfermo_nss
unique (nss);

-- no podemos repetir PK
insert into enfermo values
(10995, 'Nuevo', 'Calle Nueva', '01/01/2000', 'F', '123');

-- no podemos repetir unique
insert into enfermo values
(10999, 'Nuevo', 'Calle Nueva', '01/01/2000', 'F', '12737783');

-- nulos n pk? NO
insert into enfermo values
(null, 'Nuevo', 'Calle Nueva', '01/01/2000', 'F', '123');

-- nulos en unique, SI
insert into enfermo values
(12346, ' Nuevo', 'Calle Nueva', '01/01/2000', 'F', null);
select * from enfermo;

-- quitamos los null para realizar la inscripcion
delete from enfermo where nss = null;
commit;

-- eliminamos las dos restricciones anteriores
alter table enfermo
drop constraint pk_inscripcion;

alter table enfermo
drop constraint u_enfermo_nss;

-- intentamos crear un registro con dos datos iguales de inscripcion y nss
insert into enfermo values
(88898, ' Languia M.', 'Goya 20', '01/01/2000', 'F', 180862482);

-- foreing key 
-- crear relacion entre empleados y departamentos
-- el campo de relacion es dept_no
alter table emp
add constraint fk_emp_dept
foreign key (dept_no)
references dept (dept_no)
on delete set null; -- pone a null el registro, campo de relacion
 -- on delete cascade; jamas utilizar

insert into dept values (10, 'CONTABILIDAD', 'ELCHE'); -- crear el dept 10 para relaizar el anterior

-- vamos a probar la eliminacion en cascada y set null en cascada
delete from dept where dept_no = 10;
alter table emp 
drop constraint fk_emp_dept;

-- insertamos un empleado en un departamento que no existe
insert into emp values (1111, 'nulo', 'EMPLEADO', 7902, '02/04/2025', 1, 1, null);
select * from emp; 
describe emp;
rollback;