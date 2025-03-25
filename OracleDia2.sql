select * from EMP; 
-- utilizar nombre de los campos.
-- control + enter, ejecuta la linea en la que estamos posicionados
select apellido, oficio, salario from emp;

-- la ordenacion siempre al final y afecta al select
-- ordenacion de datos  siempre es ascendente
select * from emp order by apellido asc;

-- ordenacion de datos descendente
select * from emp order by apellido desc;

-- ordenar por mas de un campo 
select * from emp order by dept_no, oficio;

-- filtrado de registros 
-- operadores de comparacion 
/*
= igual
>= mayor o igual
<= menor o igual 
> mayor
< menor
<> distinto 
*/ 
-- oracle, por defecto, diferencia entre mayusculas y minisculas en sus textos (string/varchar)
-- todo lo que no sea un numero se escribe entre comillas simples '...'
-- para filtrar se utiliza la palabra 'where' y se escribe solo una vez en toda la consulta
-- despues del from 
-- mostrar todos los empleados del departamento 10 
select * from emp where dept_no=10;

-- mostrar todos los empleados cuyo oficio sea director
select * from emp where oficio='DIRECTOR';

-- mostar todos los empleados cuyo oficio sea diferente al director
select * from emp where oficio <> 'DIRECTOR'; 

-- operadores relacionales
-- nos permiten realizar mas de una pregunta dentro de una consulta
/*
or --> muestra los datos de cada filtro
and --> todos los filtros deben cumplirse
not --> negacion de una condicion (evitarlo siempre)
*/
-- mostrar los empleados del departamento 10 y/o que sean directores
select * from emp where dept_no=10 and oficio='DIRECTOR';
select * from emp where dept_no=10 or oficio='DIRECTOR';

--mostrar los empleados del departamento 10 y 20
select * from emp where dept_no=10 or dept_no=20;

-- operadores opcionales ademas de los standard
-- between muestra los datos entre un rango inclusivo 
-- mostrar los empleados cuyo salario este entre 251000 y 390000
select * from emp where salario between 251000 and 390000;

-- podemos hacer la misma consulta con operadores y es eficiente
select * from emp where salario >=251000 and salario <=390000;

-- mostrar los empleados que no sean directores
select * from emp where not oficio='DIRECTOR';
select * from emp where oficio <> 'DIRECTOR';

-- existe un operador para buscar coincidencias en textos
-- nos permite mediante caracteres especiales hacer filtros en textos
/*
% busca cualquier caracter y longitud
_ un caracter cualquiera
? un caracter numerico
*/
-- mostrar los empleados cuyo apellido comienza en s
select * from emp where apellido like 's%';

-- mostrar los empleados cuyo apellido comienza en s y finaliza en a
select * from emp where apellido like 's%a';

-- mostrar los empleados cuyo apellido tenga 4 letras
select * from emp where apellido like '____';

-- existe otro operador para buscar coincidencias de igualdad al mismo
-- campo: in (valor1,valor2)
-- mostrar los empleados del departamente 10, 20, 30, 55, 65, ,77
select * from emp where dept_no in (10,20,30,55,65,77);

-- tenemos el operador 'not in', recupera los quee no coincidan
-- mostrar todos los empleados que no esten en el departamento 10,20
select * from emp where dept_no not in (10,20);
select * from emp where not dept_no in (10,20);

-- campos calculados
-- un campo calculado es una herramienta en una consulta 
-- siempre debe tener un alias 
-- sirve para generar campos que no existan en una tabla y los podemos calcular
-- mostrar el apellido, el salario, comision y el salario total (salario + comision)
-- un campo calculado solo es para el cursor
select apellido, salario, comision, (salario + comision) as total from emp;

-- de todos los empleados cuyo salario mas comision sea mayor 344500
select apellido, (salario + comision) as total from emp where (salario + comision) >=344500;

--queremos la consulta original y ordenar por ella
select apellido, salario, comision, (salario + comision) as total from emp
order by total;

-- clausula distinct: se utiliza para el select y lo qu realiza es
-- elimnar repetidos de la consulta
-- mostrar el oficio de los empleados
select oficio from emp;

-- mostrar los diferentes oficios de los empleados
select distinct oficio from emp;

-- mostrar los diferentes oficios, apellidos de los empleados
select distinct oficio, apellido from emp;

-- ejercicio 6 Mostrar todos los enfermos nacidos antes del 11/01/1970
select * from enfermo where fecha_nac <= '11/01/1970';

-- ejercicio 7 Igual que el anterior, para los nacidos antes del 01/01/1970 ordenados por número de inscripción
select * from enfermo where fecha_nac <= '01/01/1970' order by inscripcion;

-- ejercicio 8 Listar todos los datos de la plantilla del hospital del turno de mañana
select * from plantilla where turno='M';

-- ejercicio 9 Y del turno de noche.
select * from plantilla where turno='N';

-- ejercicio 10 Listar los doctores que su salario anual supere 3.000.000
select * from doctor where (salario*12)>3000000;

-- ejercicio 11 Visualizar los empleados de la plantilla del turno de mañana que tengan un salario entre 2mil y 250mil
select * from plantilla where turno='M' and salario >=200000 and salario <=250000;

-- ejercicio 12 Visualizar los empleados de la tabla emp que no se dieron de alta entre esos años
select * from emp where fecha_alt not between '01/01/1986' and '12/12/1994'; 

-- ejercicio 13 Mostrar los nombres de los departamentos situados en Madrid o en Barcelona
select dnombre from dept where loc in ('MADRID','BARCELONA');


-- consultas de agrupacion
-- nos permite mostrar algun resumen sobre un grupo determinado  de los datos
-- utilizan funciones de agrupacion para conseguir el resumen
-- las funciones deben tener alias
--count(*): cuenta el numero de registros incluyendo nulos 
--count(campo): cuenta el numero de registro sin nulos
--sum(numero): suma el total d un campo numero
--avg(numero): recupera la media de un campo numerico
--max(campo): devuelve el maximo valor de un campo
--min(campo) devuelve el minimo valor de un campo
-- mostrar el numero de registros de la tabla doctor
select count(*) as numero_doctores from doctor;
select count(apellido) as numero_doctores from doctor;

-- podemos combinar sin problma varias funciones
-- queremos el numero de doctores y el maximo salario
select count(*) as doctores, max(salario) as maximo from doctor;

-- los datos resultantes de las funciones podemos agruparlos por algun campo de la tabla
-- cuando queremos agrupar utilizamos 'group by' despues del from
-- truco: debemos agrupar por cada campo que no sea una funcion
-- queremos mostrar cuantos doctores existen por cada especialidad
select count(*) as doctores, especialidad 
from doctor group by especialidad;

-- mostrar numero de personas y maximo salario de los empleados por cada departamento y oficio
select count(*) as personas, max(salario) as maximo_salario, dept_no, oficio 
from EMP
group by dept_no, oficio;

-- mostrar el numero de personas de la plantilla
select count(*) as bananasaurios from plantilla;

-- mostrar el numero de personas por cada turno de la plantilla
select count(*) as personas, turno from plantilla
group by turno;

-- filtrando en consultas de agrupacion
-- tenemos dos posibilidades:
-- where: antes del group by y para filtrar sobre la tabla
-- having: despues del group by y para filtrar sobre el conjunto
-- mostrar cuantos empleados tenemos por cada oficio que cobren mas de 200000
select count(*) as empleados, oficio
from emp
where salario > 200000
group by oficio;

-- mostrar cuantos empleados tenemos por cada oficio que cobren mas de 200000
-- y que sean analistas o vendedores
-- podemos decidir con having o where
select count(*) as empleados, oficio
from emp
group by oficio
having oficio in('ANALISTA', 'VENDEDOR');

select count(*) as empleados, oficio
from emp
where oficio in('ANALISTA', 'VENDEDOR')
group by oficio;

-- cuando no podemos decidir y estamos obligado a utilizar having:
-- si queremos filtrar por una funcion de agrupacion
-- mostrar cuantos empleados tenemos por cad oficio
-- solamente donde tengamos 2 o mas empleados del mismo oficio
select count(*) as empleados, oficio
from emp
group by oficio
having count(*) >= 2;


