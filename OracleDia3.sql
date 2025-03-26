-- Ejercicio 2 Encontrar el salario más alto, mas bajo y la diferencia entre ambos de todos los empleados con oficio EMPLEADO
select count(*) as empleados, max(salario) as maximosalario, min(salario) as minimosalario, max(salario) - min(salario) as diferencia
from emp
group by oficio
having oficio='EMPLEADO';

-- Ejercicio 4 Visualizar el número de personas que realizan cada oficio en cada departamento ordenado por departamento
select count(*) as personas, dept_no, oficio
from emp
group by dept_no, oficio
order by dept_no;

-- Ejercicio 5 Buscar aquellos departamentos con cuatro o más personas trabajando
select count(*) as personas, dept_no
from emp
group by dept_no
having count(*) >= 4;

-- Ejercicio 7 Visualizar el número de enfermeros, enfermeras e interinos que hay en la plantilla, ordenados por la función
 select count(*) as trabajadores, funcion
 from plantilla
 group by funcion
 having funcion in ('ENFERMERO', 'ENFERMERA', 'INTERINO')
 order by funcion;
 
 -- Ejercicio 8 Visualizar departamentos, oficios y número de personas, para aquellos departamentos que tengan dos o más personas trabajando en el mismo oficio
 select count(*) as personas, dept_no, oficio
 from emp
 group by dept_no, oficio
 having count(*) >= 2;
 
 -- Ejercicio 10 Calcular el valor medio de las camas que existen para cada nombre de sala. Indicar el nombre de cada sala y el número de cada una de ellas
select count(*) as camas, avg(num_cama) as media_camas, nombre
from sala
group by nombre;

-- Ejercicio 11 Calcular el salario medio de la plantilla de la sala 6, según la función que realizan. Indicar la función y el número de empleados
select avg(salario) as salario_medio, funcion, sala_cod, count(*) as personas
from plantilla
group by funcion, sala_cod
having sala_cod = 6;

-- Ejercicio 12 Averiguar los últimos empleados que se dieron de alta en la empresa en cada uno de los oficios, ordenados por la fecha
select max(fecha_alt) as fechamaxima,oficio
from emp
group by oficio
order by 1;

-- Ejercicio 13 Mostrar el número de hombres y el número de mujeres que hay entre los enfermos
select count(*) as enfermos, sexo
from enfermo
group by sexo;

-- Ejercicio 15 Calcular el número de salas que existen en cada hospital
select count(*) as numero_salas, hospital_cod
from sala
group by hospital_cod;

-- Ejercicio 16 Mostrar el número de enfermeras que existan por cada sala
select count(*) as enfermeras, sala_cod
from plantilla
group by sala_cod;


-- consultas de combinacion
-- nos permiten mostrar datos de varias tablas que deben estar relacionadas entre si mediante alguna clave
-- 1) necesitamos campo/s relacion entre las tablas
-- 2) debemos poner el nombre de cada tabla y cada campo en la consulta
-- sintaxis:
select tabla1.campo1, tabla1.campo2, tabla2.campo1, tabla2.campo2
from tabla1
inner join tabla2
on tabla1.campo_relacion = tabla2.campo_relacion;

-- mostrar el apellido, el oficio de empleados junto a su nombre de departamento y localidad
select emp.apellido, emp.oficio, dept.dnombre, dept.loc
from emp
inner join dept
on emp.dept_no = dept.dept_no;

-- tenemos otra sintaxis para realizar los join
select emp.apellido, emp.oficio, dept.dnombre, dept.loc
from emp, dept
where emp.dept_no = dept.dept_no;

-- podemos realizar, por supuesto nuestros where
-- queremos mostrar los dato solo de madrid
select emp.apellido, emp.oficio, dept.dnombre, dept.loc
from emp
inner join dept
on emp.dept_no = dept.dept_no
where dept.loc= 'MADRID';

-- podemos añadir alias a los nombres de las tablas 
-- para llamarlas asi a lo largo de la consulta
-- es util cuando tenemos tablas con nombre muy largos
-- cuando ponemos alias, la tabla se llamara asi para toda la consulta
select e.apellido, e.oficio, d.dnombre, d.loc
from emp e
inner join dept d
on e.dept_no = d.dept_no;

-- tenemos multiples tipos de join en las bases de datos
-- inner: combina los resultados de las dos tablas
-- left: combina las dos tablas y tambien la tabla izquierda
-- right: combina las dos tablas y fuerza la tabla derecha
-- full: combina las dos tablas y fuerza las dos tablas
-- cross: producto cartesiano, combinar cada dato de una tabla con los otros datos de la tabla

select distinct dept_no from emp;
select * from dept;

-- crear nuevo empleado que no tenga departamento (granada)
INSERT INTO emp VALUES('1203', 'sindept', 'ANALISTA', 7919, TO_DATE('20-10-1986', 'DD-MM-YYYY'), 258500, 50000, 50);

-- tenemos un empleado sin departamento en el 50
-- left: combina las dos tablas y tambien la tabla izquierda
-- la tabla de la izquierda es antes del join 
select emp.apellido, dept.dnombre, dept.loc
from emp 
left join dept
on emp.dept_no = dept.dept_no;

-- right: combina las dos tablas y fuerza la tabla derecha
-- la tabla dela derecha es despues del join 
select emp.apellido, dept.dnombre, dept.loc
from emp 
right join dept
on emp.dept_no = dept.dept_no;

-- full: combina las dos tablas y fuerza las dos tablas
select emp.apellido, dept.dnombre, dept.loc
from emp 
full join dept
on emp.dept_no = dept.dept_no;

-- cross: producto cartesiano, combinar cada dato de una tabla con los otros datos de la tabla
select emp.apellido, dept.dnombre, dept.loc
from emp 
cross join dept;

-- mostrar la media salarial de los doctores por hospital
-- mostrando el nombre del hospital
select avg(doctor.salario) as media, hospital.nombre 
from doctor
inner join hospital
on doctor.hospital_cod = hospital.hospital_cod
group by hospital.nombre;

-- mostrar el numero de empleados que existen por cada localidad
select count(emp.emp_no) as empleados, dept.loc
from emp
right join dept
on emp.dept_no = dept.dept_no
group by dept.loc;
