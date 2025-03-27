-- 1.Seleccionar el apellido, oficio, salario, numero de departamento y su nombre de todos los empleados cuyo salario sea mayor de 300000
select emp.apellido, emp.oficio, emp.salario, emp.dept_no, dept.dnombre
from emp
inner join dept
on emp.dept_no = dept.dept_no
group by emp.apellido, emp.oficio, emp.salario, emp.dept_no, dept.dnombre
having emp.salario > 300000;

-- 2.Mostrar todos los nombres de Hospital con sus nombres de salas correspondientes
select hospital.nombre as nombre_hospital, sala.nombre as nombre_sala
from hospital
inner join sala
on hospital.hospital_cod = sala.hospital_cod
group by hospital.nombre, sala.nombre;

-- 3.Calcular cuántos trabajadores de la empresa hay en cada ciudad
select count (emp.emp_no) as empleados, dept.loc
from emp
right join dept
on emp.dept_no = dept.dept_no 
group by dept.loc;

-- 4.Visualizar cuantas personas realizan cada oficio en cada departamento mostrando el nombre del departamento.
select count (emp.emp_no) as empleados, emp.oficio, dept.dnombre
from emp
right join dept
on emp.dept_no = dept.dept_no
group by emp.oficio, dept.dnombre;

-- 5.Contar cuantas salas hay en cada hospital, mostrando el nombre de las salas y el nombre del hospital
select count (sala.sala_cod) as salas, sala.nombre as nombresala, hospital.nombre as nombrehospi
from sala
inner join hospital
on sala.hospital_cod = hospital.hospital_cod
group by sala.nombre, hospital.nombre;

-- 6. Queremos saber cuántos trabajadores se dieron de alta entre el año 1997 y 1998 y en qué departamento
select count (emp.emp_no) as altas, dept.dnombre
from emp
inner join dept 
on emp.dept_no = dept.dept_no
where emp.fecha_alt between '01/01/1997' and '01/01/1998'
group by dept.dnombre;

-- 7. Buscar aquellas ciudades con cuatro o más personas trabajando.
select count (emp.emp_no) as personas, dept.loc
from emp
inner join dept
on emp.dept_no = dept.dept_no
group by dept.loc
having count(emp.emp_no) > 4;

-- 8. Calcular la media salarial por ciudad. Mostrar solamente la media para Madrid y Sevilla.
select avg(emp.salario) as mediasalarios, dept.loc as ciudad
from emp
inner join dept
on emp.dept_no = dept.dept_no
group by dept.loc
having dept.loc in ('MADRID', 'SEVILLA');

-- 9. Mostrar los doctores junto con el nombre de hospital en el que ejercen, la dirección y el teléfono del mismo
select doctor.apellido as doctores, hospital.nombre, hospital.direccion, hospital.telefono
from doctor
inner join hospital 
on doctor.hospital_cod = hospital.hospital_cod
group by doctor.apellido, hospital.nombre, hospital.direccion, hospital.telefono;

-- 10. Mostrar los nombres de los hospitales junto con el mejor salario de los empleados de la plantilla de cada hospital
select hospital.nombre, max(plantilla.salario) as salariomaximo
from hospital
inner join plantilla
on hospital.hospital_cod = plantilla.hospital_cod
group by hospital.nombre;

-- 11. Visualizar el Apellido, función y turno de los empleados de la plantilla junto con el nombre de la sala y el nombre del hospital con el teléfono
-- por cada tabla un join y un on
select plantilla.apellido, plantilla.funcion, plantilla.turno, sala.nombre as nombresala, hospital.nombre as nombrehospital, hospital.telefono
from plantilla
inner join hospital
on plantilla.hospital_cod = hospital.hospital_cod
inner join sala
on hospital.hospital_cod = sala.hospital_cod
and plantilla.sala_cod = sala.sala_cod;

-- 12. Visualizar el máximo salario, mínimo salario de los Directores dependiendo de la ciudad en la que trabajen. Indicar el número total de directores por ciudad.
select count(emp.emp_no) as directores, dept.loc as ciudad, max(emp.salario) as salariomaximo, min(emp.salario) as salariominimo
from emp
inner join dept
on emp.dept_no = dept.dept_no
where oficio = 'DIRECTOR'
group by dept.loc;

-- 13. Averiguar la combinación de que salas podría haber por cada uno de los hospitales.
select sala.nombre as nombresala, hospital.nombre as nombrehospital
from sala
cross join hospital;

-- subconsultas
-- son consultas que necesitan del resultado de otra consulta para poder ser ejecutadas.
-- no son autonomas, necesitan de algun valor. 
-- no importa el nivel de anidaminto de subconsultas aunque pueden ralentizar la respuesta.
-- generan bloqueos en consultas select, lo que tambien ralentizan las respuestas
-- quiero visualizar los datos del empleado que mas cobra de la empresa (emp)
select max(salario) from emp ;
-- 650000
select * from emp where salario = 650000;

-- se ejecuan las dos consultas a la vez, se anida el resultado de una consulta
-- con la igualdad de la respuesta de otra consulta
-- las subconsultas van entre parentesis
select * from emp where salario= (select max(salario) from emp);

-- mostrar los empleados que tienen el mismo oficio que el empleado gil
-- y que cobren menos que jiminez
select * from emp where oficio= (select oficio from emp where apellido = 'gil') 
and salario < (select salario from emp where apellido= 'jimenez');

-- mostrar los empleados que tienen el mismo oficio que el empleado gil
-- y el mismo oficio que jiminez
-- si una subconsulta devuelve mas de un valor se utiliza in
select * from emp where oficio in
(select oficio from emp where apellido = 'gil' or apellido= 'jimenez');

-- mostrar el apellido y el oficio de los empleados del departamento de madrid
select emp.apellido, emp.oficio from emp 
inner join dept 
on emp.dept_no =dept.dept_no
where dept.loc ='MADRID';

-- consultas union 
-- muestran en un mismo cursor, un mismo conjunto de resultados
-- estas consultas se utilizan como concepto, no como relacion
-- debemos seguir 3 normas:
-- 1) la primera consulta es la jefa
-- 2) todas las consultas deben tener el mismo numero de columnas
-- 3) todas las columnas deben tener el mismo tipo de dato entre si
-- en nuestra base de datos, tenemos datos de personas en diferentes tablas
-- emp, plantila y doctor
select apellido, oficio, salario from emp
union
select apellido, funcion, salario from plantilla
union
select apellido, especialidad, salario from doctor;

-- podemos ordenar sin problemas
-- en las consultas union deberiamos utilizar siempre numerando
-- si ponemos un alias no funciona
select apellido, oficio, salario from emp
union
select apellido, funcion, salario from plantilla
union
select apellido, especialidad, salario from doctor
order by apellido;
-- order by 3;

-- por supuesto, podemos perfectamente filtrar los datos de la consulta
-- por ejemplo mostrar los dato de las personas que cobren menos 300000
-- cada where es independiente al union
select apellido, oficio, salario from emp
where salario < 300000
union
select apellido, funcion, salario from plantilla
where salario < 300000
union
select apellido, especialidad, salario from doctor
where salario < 300000
order by 1;

-- union limina los resultados repetidos
-- si queremos repetidos debemo utilizar 'union all'
select apellido, oficio from emp
union all
select apellido, oficio from emp;


