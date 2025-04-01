-- select to select
-- es una consulta sobre un cursor (select) 
-- cuando hacemos un select, en realidad estamos recuperando datos de una tabla
-- este tipo de consultas nos permiten recuperar daos de un select ya 
-- realizado, los where y demas se hacen sobre el cursor
-- sintaxis:
select * from 
(select tabla1.campo1 as alias, tabla2.campo2 from tabla1
union select tabla2.campo1, tabla2.campo2 from tabla2) consulta
where consulta.alias = 'valor';

-- queremos mostrar los datos de todas las personas de mi bbdd (emp, doctor, plantilla)
-- solamente queremos los que cobren menos de 300.000
select * from
(select apellido, oficio, salario as sueldo from emp
union 
select apellido, funcion, salario from plantilla
union
select apellido, especialidad, salario from doctor) consulta
where consulta.sueldo < 300000;

-- consultas a nivel de fila
-- son consultas creadas para dar formato a la salida de datos
-- no modifican los datos de la tabla, los muestran de otra forma
-- segun yo lo necesite
-- van con preguntas en la consulta
-- sintaxis: 
select campo1, campo2, case campo3
when 'dato1'  then 'valor1'
when 'dato2' then 'valor2'
else 'valor3'
end as alias from tabla;

-- mostramos los apellidos de la plantilla, pero con su turno que se vea bien
-- (mañana, tarde, noche)
select apellido, funcion, case turno
when 'T' then 'tarde'
when 'M' then 'mañana'
when 'N' then 'noche'
end as turno from plantilla;

-- evaluar por un operador (rango, mayor o menor, distinto)
select campo1, campo2, case 
when campo3 <= 800 then 'resultado1'
when campo3 >= 800 then 'resultado2'
else 'resultado3'
end as formato
from tabla;

-- salarios de la plantilla
select apellido, funcion, salario, 
case
when salario >= 250000 then 'salario correcto'
when salario >= 150000 and salario < 250000 then 'media salarial'
end as rango_salarial
from plantilla;

-- 1)mostrar la suma salarial de los empleados por su nombre de departamento
select sum(emp.salario) , dept.dnombre
from emp
inner join dept
on emp.dept_no = dept.dept_no
group by dept.dnombre;

-- 2)mostrar la suma salarial de los doctores por su hospital
select sum(doctor.salario), hospital.nombre
from doctor
inner join hospital
on doctor.hospital_cod = hospital.hospital_cod
group by hospital.nombre;

-- 3)me gustaria poder ver todo junto en una misma consulta
select sum(emp.salario) as salario, dept.dnombre as ocupacion from emp inner join dept on emp.dept_no = dept.dept_no group by dept.dnombre
union
select sum(doctor.salario), hospital.nombre from doctor inner join hospital on doctor.hospital_cod = hospital.hospital_cod group by hospital.nombre;

-- consultas de accion
-- son consultas para modificar los registros de la base de datos
-- se almacenan de forma temporal por sesion
-- commit: hace los cambios permanentes
-- rollback: deshacer los cambios realizados
-- tenemos 3 tipos de consulas de accion
-- insert: inserta un nuevo registro en la tabla
-- update: modifica uno o varios registros de una tabla
-- delete: elimina uno o varios registros de una tabla
---------------------------------------------------
-- insert
-- cada registro a insertar es una instruccion insert, es decir
-- si queremos insertar 5 registos, son  insert
-- tenemos dos tipos de sintaxis:
-- 1) insertar todos los datos de la tabla: debemos identificar todas las columnas/campos
-- de la tabla y en el mismo orden que esten en la propia tabla
-- insert into tabla values (valor1, valor2, ...); 
insert into dept values (50, 'ORACLE', 'BERNABEU');
commit;
insert into dept values (51, 'BORRAR', 'BORRAR');
select * from dept;
rollback;

-- 2) insertar solamente algunos datos de la tabla: debemos indicar el nombre de las columnas
-- que deseamos insertar y los valores iran en dicho orden, la tabla no tiene nada que ver
-- insert into tabla (campo3, campo7) values (valor3, valor7);
insert into dept (dept_no, loc) values (55, 'ALMERIA');

-- las subconsultas son super utiles si estamos en consultas de accion
-- necesito un departamento de sidra en Gijon
-- generar el siguiente numero disponible en la consulta de accion
select max(dept_no) + 1 from dept;
insert into dept values ((select max(dept_no) + 1 from dept), 'SIDRA', 'GIJON');

-- delete
-- elimina una o varias filas de una tabla. si no existe nada para eliminar, no hace nada
-- sintaxis:
-- delete from tabla
-- la sintaxis anterior elimina todos los registros de la tabla
-- opcional, incluir where
-- eliminar el departamento de oracle
delete from dept where dnombre='ORACLE';
select * from dept;
rollback;

-- muy util utilizar subconsultas para delete
-- eliminar todos los empleados de granada
delete from emp where dept_no = 
(select dept_no from dept where loc='GRANADA');

-- update
-- modifica una o varias filas de una tabla, puede modificar varias columnas a la vez
-- update tabla set campo1=valor1, campo2=valor2
-- esta consulta modifica todas las filas de la tabla
-- es conveniente utilizar un where
-- modificar el salario de la plantilla del turno de noche, todos cobraran 315000
update plantilla set salario=315000 
where turno='N';

select * from plantilla where turno='N';

-- modificar la ciudad y el nombre del departamento 10
-- se llamara cuenas y nos vamos a toledo
update dept set loc='TOLEDO', dnombre='CUENTAS'
where dept_no=10;

select * from dept;

-- podemos mantener el valor de una columna y asignar "algo" con operaciones matematicas
-- incrementar en 1 el salario de todos los empleados
update emp set salario=salario + 1;

select * from emp;

-- podemos utilizar subconsultas  en update
-- 1) si las subconsultas estan en el set, solamente deben devolver un dato
-- arroyo esta envidioso de sala, poner el mismo salario a arroyo que sala
update emp set salario=(select salario from emp where apellido='sala')
where apellido='arroyo';

select * from emp where apellido='arroyo'
union
select * from emp where apellido='sala';

-- los catalanes estan subidos y les bajamos el sueldo a la mitad 
-- poner a la mitad el salario de los empleados de Barcelona
update emp set salario=salario / 2
where dept_no=( select dept_no from dept where loc='BARCELONA');

select * from emp inner join dept
on emp.dept_no= dept.dept_no 
where loc='BARCELONA';
rollback;

-- 1. Dar de alta con fecha actual al empleado José Escriche Barrera como programador perteneciente al departamento de
-- producción. Tendrá un salario base de 70000pts/mes y no cobrará comisión.
insert into emp ( apellido, oficio, fecha_alt, salario, comision, dept_no) values (7924, 'escriche', 'PROGRAMADOR', '31/03/25', 70000, 0, 
(select dept_no from dept where dnombre='PRODUCCION'));

--2. Se quiere dar de alta un departamento de informática situado en Fuenlabrada (Madrid).
insert into dept values (60, 'INFORMATICA', 'FUENLABRADA');

--3. El departamento de ventas, por motivos peseteros, se traslada a Teruel, realizar dicha modificación
update dept set loc='TERUEL' where dnombre='VENTAS';

--4. En el departamento anterior (ventas), se dan de alta dos empleados: Julián Romeral y Luis Alonso. Su salario base es el menor que cobre un empleado,
-- y cobrarán una comisión del 15% de dicho salario
insert into emp (apellido, salario, comision, dept_no) 
values ('romeral', (select min(salario) from emp where oficio='EMPLEADO'),  
(select min(salario)*15/100 from emp where oficio='EMPLEADO') 
, (select dept_no from dept where dnombre='VENTAS'));

insert into emp (apellido, salario, comision, dept_no) 
values ('alonso', (select min(salario) from emp where oficio='EMPLEADO'),  
(select min(salario)*15/100 from emp where oficio='EMPLEADO') 
, (select dept_no from dept where dnombre='VENTAS')); 

--5. Modificar la comisión de los empleados de la empresa, de forma que todos tengan un incremento del 10% del salario
update emp set comision= salario*10/100; 

--6. Incrementar un 5% el salario de los interinos de la plantilla que trabajen en el turno de noche
update plantilla set salario = salario*5/100 where funcion = 'INTERINO' and turno ='N'; 

--7. Incrementar en 5000 Pts. el salario de los empleados del departamento de ventas y del presidente, tomando en cuenta los que se dieron de alta antes que el presidente de la empresa.
update emp set salario=salario+5000 
where oficio='PRESIDENTE' or dept_no=(select dept_no from dept where dnombre='VENTAS') 
and fecha_alt<(select fecha_alt from emp where oficio='PRESIDENTE'); 

--8. El empleado Sanchez ha pasado por la derecha a un compañero. Debe cobrar de comisión 12.000 ptas más que el empleado Arroyo y su sueldo se ha incrementado un 10% respecto a su compañero.
update emp set comision = (select comision + 12000 from emp 
where upper(apellido) = 'ARROYO'), salario = (select salario * 1.10 from emp  
where upper(apellido) = 'ARROYO') 
where upper(apellido) = 'SANCHA'; 

--9. Se tienen que desplazar cien camas del Hospital SAN CARLOS para un Hospital de Venezuela. Actualizar el número de camas del Hospital SAN CARLOS.
update hospital set num_cama=num_cama-100 where nombre='san carlos'; 

--10. Subir el salario y la comisión en 100000 pesetas y veinticinco mil pesetas respectivamente a los empleados que se dieron de alta en este año.
update emp 
set salario= salario+100000, comision=comision+25000 
where fecha_alt>='01/01/2011'; 

--11. Ha llegado un nuevo doctor a la Paz. Su apellido es House y su especialidad es Diagnostico. Introducir el siguiente número de doctor disponible
insert into doctor values ((select hospital_cod from hospital where nombre='la paz'), 
(select max(doctor_no) + 1 from doctor), 'House', 'Diagnostico') ;

--12. Borrar todos los empleados dados de alta entre las fechas 01/01/80 y 31/12/82
delete from emp where fecha_alt between "01/01/80" and "31/12/82";

--13. Modificar el salario de los empleados trabajen en la paz y estén destinados a Psiquiatría. Subirles el sueldo 20000 Ptas. más que al señor Amigo R
update doctor set salario = (select salario+20000 from plantilla where apellido='amigo r.') 
where hospital_cod = (select hospital_cod from hospital where nombre='la paz') and especialidad='Psiquiatria' ;

--14. Insertar un empleado con valores null (por ejemplo la comisión o el oficio), y después borrarlo buscando como valor dicho valor null creado.
insert into emp (apellido, salario, comision, dept_no) 
values ('gutierrez', 225000, null, 10); 

delete from emp 
where oficio is null and comision is null and apellido='gutierrez'; 

--15. Borrar los empleados cuyo nombre de departamento sea producción.
delete from emp where dept_no =(select dept_no from dept where dnombre='PRODUCCION';

--16. Borrar todos los registros de la tabla Emp sin delete
truncate table emp; 

--17. Volver a ejecutar los SCRIPTS de BBDD para dejar la base de datos intacta para el siguiente módulo.
rollback;




