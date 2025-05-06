-- Funciones
-- Realizar una funcion para sumar dos numeros 
create or replace function f_sumar_numeros
(p_numero1 number, p_numero2 number)
return number
as 
v_suma number;
begin
    v_suma := p_numero1 + p_numero2; -- nvl(p_numero1,0) + nvl(p_numero2,0); -- si no se pasa un valor a la funcion se le asigna 0
    -- siempre un return
    return v_suma;
end;
-- llamada con codigo PL/SQL
declare
    v_resultado number;
BEGIN
    v_resultado := f_sumar_numeros(22, 55);
    dbms_output.put_line('La suma es: ' || v_resultado);
end;
-- llamada con select
SELECT f_sumar_numeros(22, 55) as suma FROM dual;
select apellido, F_SUMAR_NUMEROS(salario, comision) as total from emp;

-- funcion para saber el numero de personas de un oficio
create or replace FUNCTION num_personas_oficio
(p_oficio emp.oficio%type)
return number
AS
v_personas int;
BEGIN
    select count(emp_no) into v_personas from emp 
    where lower(oficio) = lower(p_oficio);
    return v_personas;
END;
select num_personas_oficio('analista') as personas from dual;

-- realizar una funcion para devolver el mayor de dos numeros
create or replace function f_mayor_numero
(p_numero1 number, p_numero2 number)
return number
as
v_mayor number;
begin 
if p_numero1 > p_numero2 then
    v_mayor := p_numero1;
else
    v_mayor := p_numero2;
end if;
return v_mayor;
end;
select f_mayor_numero(22, 55) as mayor from dual;

-- realizar una funcion para devolver el mayor de tres numeros
-- no quiero utilizar el if
create or replace function mayor_tres_numeros
(p_numero1 number, p_numero2 number, p_numero3 number)
return number
as
v_mayor number;
begin
    v_mayor := greatest(p_numero1, p_numero2, p_numero3);
    return v_mayor;
end;
select mayor_tres_numeros(22, 55, 33) as mayor from dual;

-- tenemos los parametros por defecto dentro de las funciones
select 100 * 1.21 as iva from dual;
select 100 * 1.28 as iva from dual;
select importe, iva(importe) as total from productos;
select importe, iva(importe, 21) as total from productos;
create or replace function calcular_iva
(p_precio number, p_iva number := 1.18)
return number
AS
BEGIN
    return p_precio * p_iva;
END;
select calcular_iva(100, 1.21) as iva from dual;

-- vamos a crear una vista para tener todos
-- los datos de los empleados sin el salario ni comision, ni direccion
create or replace view v_empleados as
select emp_no, apellido, oficio, fecha_alt, dept_no from emp;
select * from v_empleados;

-- una vista simplifica las consultas
-- mostrar el apellido, oficio, salario
-- , nombre del departamento y localidad de todos los empleados
create or replace view v_empleados_dept as
select e.apellido, e.oficio, e.salario, d.dnombre as departamento, d.loc as localidad
from emp e, dept d
where e.dept_no = d.dept_no;
select * from v_empleados_dept where localidad = 'MADRID';
select * from user_views where view_name = 'V_EMPLEADOS_DEPT';

-- podemos tener campos virtuales en las vistas
create or replace view v_empleados_virtual 
AS
select emp_no, apellido, oficio, salario + comision as total, dept_no
from emp;
select * from v_empleados_virtual;

-- modificar el salario de los empleados ANALISTA
-- tabla
update V_EMPLEADOS set salario = salario + 1 where oficio = 'ANALISTA';
create or replace view v_empleados as
select emp_no, apellido, oficio, salario, fecha_alt, dept_no from emp;
select * from v_empleados WHERE oficio = 'ANALISTA';

-- eliminamos el empleado con id 7917
delete from V_EMPLEADOS where emp_no = 7917;

-- inseramos en la vista
insert into V_EMPLEADOS values 
(1111, 'lunes', 'LUNES',0 , sysdate, 40);
select * from emp where emp_no = 1111;

-- ¿que sucede si las columnas no admiten null?
-- proporcionara error, habra que dar un valor vaido o usar valores predeterminados
-- modificar el saalrio de los empleados de MADRID
update V_EMPLEADOS_DEPT set salario = salario + 1 where localidad = 'MADRID';
--eliminar a los empleados de Barcelona
delete from V_EMPLEADOS_DEPT where localidad = 'BARCELONA';
ROLLBACK;
insert into V_EMPLEADOS_DEPT VALUES
(3333, 'lunes 3', 'LUNES 3', 250000, 'CONTABILIDAD', 'SEVILLA');
update V_EMPLEADOS_DEPT set salario = salario + 1, departamento= 'CONTABLES' where localidad = 'MADRID';
select * from v_empleados_dept;

create or replace view v_vendedores as
select emp_no, apellido, oficio, salario, dept_no from emp
where oficio = 'VENDEDOR';
-- modificamos el salario de los vendedores
update V_VENDEDORES set salario = salario + 1;
update V_VENDEDORES set oficio = 'VENDIDOS';
select * from v_vendedores;
ROLLBACK;

-- Debemos pedir un texto numérico al usuario
-- Un número narcisista es aquel que, sumando la potencia de la longitud del
-- número de cada uno de los números, devuelve el mismo número
declare
v_textonumero varchar2(10);
v_numero int;
v_longitud int;
v_suma int;
v_potencia int;
begin
-- PEDIMOS EL NUMERO AL PROGRAMA
v_textonumero := '&textonumero';
v_longitud := length(v_textonumero);
v_suma := 0;
for i in 1..v_longitud
loop
-- EXTRAEMOS CADA NUMERO INDIVIDUAL DEL TEXTO
v_numero := substr(v_textonumero, i, 1);
-- ELEVAMOS CADA NUMERO A LA POTENCIA DE LA LONGITUD
v_potencia := power(v_numero, v_longitud);
v_suma := v_suma + v_potencia;
end loop;
if (v_suma = v_textonumero) then
dbms_output.put_line('El numero ' || v_textonumero || ' es narcisista.');
else
dbms_output.put_line('El numero ' || v_textonumero || ' NO es narcisista.');
end if;
end;



