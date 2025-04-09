select * from emp where lower(oficio)='analista';
update emp set oficio ='analisTA' where emp_no=7902;
-- estamos poniendo valores estaticos: 'analista'
-- tambien podriamos incluir valores dinamicos, por lo que tendriamos que
-- convertir las dos comparaciones
select * from emp where upper(OFICIO)=upper('&dato');

-- en oracle tenemos la posibilidad de concatenar textos de una
-- sola columna (campo calculado)
-- se utiliza el simbolo || para concatenar
-- queremos mostrar, en una sola columna el apellido y oficio de los empleados
select apellido ||' '|| oficio as descripcion from emp;

-- la funcion initcap muestra cada palabra de una frase con la primera letra
-- en mayusculas
select initcap (oficio) as initc from emp;
select initcap(apellido ||' '|| oficio) as descripcion from emp;
select concat('Nuestro empleado ES...',apellido) as resultado from emp;

-- substr recupera una subcadena de un texto
select substr('FLORERO', 1, 4) as dato from dual;

-- mostrar los empleados cuyo apellido empiezan con s
select * from emp where apellido like 's%';
select substr(apellido, 1, 1) as letra from emp;
select * from emp where substr(apellido, 1, 1)='s';
select length('LIBRO') as longitud from dual;

-- mostrar los empleados cuyo apellido sea 4 letras
select * from emp where apellido like '____';
select * from emp where length(apellido)=4;

-- instr busca un texto y devuelve su posicion
select instr('BENITO', 'NIP') as posicion from dual;
select instr('ORACLE MOLA', 'M') as posicion from dual;

-- si deseamos validar un mail
select * from dual where instr('m@ail', '@') > 0;
select lpad(dept_no, 5, '$') from emp;
select rpad(dept_no, 5, '$') from emp;

-- funciones matematicas
select round(45.923) as redondeo from dual;
select round(45.923, 2) as redondeo from dual;
select round(45.929, 2) as redondeo from dual;

select trunc(45.923) as redondeo from dual;
select trunc(45.923, 2) as redondeo from dual;
select trunc(45.929, 2) as redondeo from dual;

-- resto
-- everiguar si numero es par
select mod(99, 2) as resto from dual; -- si no da exacto no es par y dara <>0
select mod(998, 2) as resto from dual; -- si es exacto aparecerá 0

-- mostrar los empleados cuyo salario sea par
update emp set salario = salario + 1 where dept_no=20;
select * from emp where mod(salario, 2)= 0;

-- funciones de fechas
-- tenemos una funcion para averiguar la fecha actual de hoy
-- en el servidor: sysdate
select sysdate as fecha_actual from dual;
select sysdate + 10 as fecha from dual;
-- months_between cuantos meses hay de por medio entre dos fechas
-- mostrar cuantos meses llevan los empeados dados de alta en la empresa
select apellido, months_between(sysdate, fecha_alt) as meses from emp;

-- agregamos a la fecha actual 5 meses
select add_months(sysdate, 5) as dentro5 from dual;

--mostrar cuando es el proximo lunes
select next_day(sysdate, 1) as proximolunes from dual;
select next_day(sysdate, 'martes') as proximomartes from dual;
select next_day(sysdate, 'miércoles') as proximachampions from dual;

--last_day
select last_day(sysdate) as finmes from dual;

-- empleados redondeados la fecha al mes
select apellido, fecha_alt, round (fecha_alt, 'MM') as roundmes from emp;
select apellido, fecha_alt, round (fecha_alt, 'YY') as roundyear from emp;

-- trunc fecha
select apellido, fecha_alt, trunc (fecha_alt, 'MM') as truncmes from emp;
select apellido, fecha_alt, trunc (fecha_alt, 'YY') as truncyear from emp;

select apellido, fecha_alt, to_char (fecha_alt, 'MM-DD-YYYY') as formato from emp;
select to_char(sysdate, 'day month') as nombremes from dual;
select to_char(sysdate, 'day month rm ww ') as nombremes from dual;
select to_char(7458, '0000L') as ZERO from dual;
select to_char(7458, '0000.00$') as ZERO from dual;

-- hora del sistema
select to_char(sysdate, 'HH24:MI:SS') as hora_sistema from dual;

-- si deseamos incluir texto entre to_char y los formatos
-- se realiza con " " entro de las simples
select to_char(sysdate, '"Hoy es " DD " de " month') as formato from dual;

-- funciones de conversion
select '08/04/2025' + 2 as fecha from dual;
select to_date('08/04/2025') + 2 as fecha from dual;
select '12' + 2 as resultado from dual;
select to_number('12') + 2 as resultado from dual;

-- NVL sirve para evitar los nulos y sustituir
-- si encuentra un nulo, lo sustituye, sino, muestra el valor
-- mostrar apellido, salario y comision de todos los empleados
select apellido, salario, comision from emp;
-- podemos indicarqueen lugar de poner null, escriba otro valor
-- el valor debe ser correspondinte al tipo de dato de la columna
select apellido, salario, nvl(comision, -1) as comision from emp;

-- mostrar apellido, salario + comision de todos los empleados
select apellido, salario + nvl(comision, 0) as total from emp;

-- mostrar el turno en palabra ('mañana', 'tarde' o 'noche') de la plantilla
select apellido, turno from plantilla;
select apellido, decode(turno, 'M', 'MAÑANA', 'N', 'NOCHE', 'TARDE') as turno from plantilla;

-- quiero saber la fecha del proximo miercoles que juega el madrid
-- quiero ver la fecha completa, que no me entero
-- quiero ver: El Miercoles 11 de abril juega el Madrid
select to_char(next_day(sysdate + 2, 'miércoles'), '"El día " day dd" juega el Madrid "') as champions from dual; 




