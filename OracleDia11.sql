-- Practica
-- 1. Mostrar todos los apellidos de los empleados en Mayúsculas
select upper (apellido) as apellidos from emp;

-- 2. Construir una consulta para que salga la fecha de hoy con el siguiente formato
select initcap (to_char(sysdate, 'day DD "de" month"de" YYYY')) as fecha_actual from dual;
-- Ahora en Italiano
select upper (to_char(sysdate, 'day DD "de" month"de" YYYY', 'nls_date_language = ITALIAN')) as fecha_actual from dual;

-- 3. Queremos cambiar el departamento de Barcelona y llevarlo a Tabarnia. 
-- Para ello tenemos que saber qué empleados cambiarían de localidad y cuáles no.
-- Combinar tablas y mostrar el nombre del departamento junto a los datos del empleado
SELECT DEPT.DNOMBRE AS DEPARTAMENTO
, EMP.APELLIDO, DEPT.LOC
, DECODE(DEPT.LOC, 'BARCELONA', 'A TABARNIA', 'NO CAMBIA DE LOCALIDAD') AS TRASLADO
FROM EMP
INNER JOIN DEPT
ON EMP.DEPT_NO = DEPT.DEPT_NO;

-- 4. Mirar la fecha de alta del presidente. Visualizar todos los empleados dados de alta 330 días antes que el presidente
SELECT APELLIDO, SALARIO, OFICIO, COMISION, DEPT_NO 
, DECODE(DEPT_NO, 10, 0, 20, 25000, 30, 15000, 40, 50000) AS PRODUCTIVIDAD 
, DECODE(UPPER(OFICIO), 'DIRECTOR', 5000, 'PRESIDENTE', 25000, 0) AS RETRIBUCION 
, TRUNC(((SYSDATE - FECHA_ALT)/100) * 1000) AS ANTIGUEDAD 
, SALARIO + NVL(COMISION, 0) 
+ DECODE(DEPT_NO, 10, 0, 20, 25000, 30, 15000, 40, 50000) 
+ DECODE(UPPER(OFICIO), 'DIRECTOR', 5000, 'PRESIDENTE', 25000, 0) 
+ TRUNC(((SYSDATE-FECHA_ALT)/100)*1000) AS NUEVO 
FROM EMP 
ORDER BY NUEVO; 

-- 5. Nos piden un informe como este:
SELECT FECHA_ALT FROM EMP WHERE UPPER(OFICIO) = 'PRESIDENTE'; 

--TODOS LOS QUE SE DIERON DE ALTA 330 DIAS ANTES 
SELECT SYSDATE - 330 FROM DUAL; 

--ESTA INTENTANDO RESTAR UN NUMERO DE OTRO, NO SABE QUE ES UNA FECHA 
--CONVERTIR EL TEXTO '17/11/1995' DE FORMA EXPLICITA A FECHA 
--COMO LO CONVERTIMOS???  TO_DATE 
SELECT TO_DATE('17/11/1995') - 330 FROM DUAL; 
SELECT * FROM EMP WHERE 
FECHA_ALT > (TO_DATE('17/11/1995') - 330); 

--SOLUCION CON SUBCONSULTA 
SELECT * FROM EMP WHERE 
FECHA_ALT >  
(SELECT FECHA_ALT - 330 FROM EMP 
WHERE UPPER(OFICIO) = 'PRESIDENTE'); 

-- 6. Nos piden otro, en el que se muestren todos los empleados de la siguiente manera:
SELECT RPAD(INITCAP(APELLIDO), 12, '.') AS INFORME
, RPAD(INITCAP(OFICIO), 12, '.') AS " "
, RPAD(SALARIO, 12, '.') AS " "
, RPAD(DEPT_NO, 5, '.') AS " "
FROM EMP;

-- PL/SQL --
declare 
-- declaramos una variable
numero int;
texto varchar2 (50);
begin 
texto := 'mi primer PL/SQL';
dbms_output.PUT_LINE('Mensaje: ' || texto);
dbms_output.PUT_LINE('Mi primer bloque anonimo');
numero := 44;
DBMS_OUTPUT.PUT_LINE('Valor numero: ' || numero);
numero := 22;
DBMS_OUTPUT.PUT_LINE('Valor numero nuevo: ' || numero);
end;

declare 
nombre VARCHAR2 (30);
begin
nombre := '&dato';
dbms_output.put_line( 'Su nombre es ' || nombre) ;
end;

DECLARE 
fecha date;
texto VARCHAR2(50);
longitud int;
BEGIN
fecha := sysdate;
texto := '&data';
dbms_output.PUT_LINE (texto);
-- almacenar la longitud del texto
longitud := length(texto);
-- la longitud de su texto es 41
DBMS_OUTPUT.PUT_LINE ('La longitud del texto es ' || longitud);
-- Hoy es ...Miercoles
dbms_output.put_line ('Hoy es ' || to_char(fecha, 'day'));
end;

-- realizar un programa donde pediremos dos numeros al usuario.
-- mostraremos por pantalla la suma
declare 
numero1 int;
numero2 int;
suma int;
begin
numero1 := &num1;
numero2 := &num2;
suma := numero1 + numero2;
dbms_output.put_line (' La suma de ' || numero1 ||  '+' || numero2 || '=' || suma);
end;

-- combinar sentencias PL/SQL con sentencias SQL
-- no podemos hacer un select para mostrar datos
DECLARE
-- declaramos una variable para almacenar el numero de departamento
v_departamento int;
BEGIN
-- pedimos un numero al usuario
v_departamento := &dept;
update emp set salario = salario + 1 WHERE DEPT_NO = v_departamento;
end;
undefine dept;
select * from emp;

