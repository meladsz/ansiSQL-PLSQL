-- declaracion de variables como subtipo de la tabla
declare
v_numero dept.dept_no%type;
v_nombre dept.dnombre%type;
v_localidad dept.loc%type;
begin
v_numero := &numero;
v_nombre := '&nombre';
v_localidad := '&localidad';
insert into dept values (v_numero, v_nombre, v_localidad);
end;
undefine numero;
undefine nombre;
undefine localidad;
select * from dept;

-- 2. Insertar en la tabla EMP un empleado con código 9999 asignado directamente en la 
-- variable con %TYPE, apellido ‘PEREZ’, oficio ‘ANALISTA’ y código del departamento al que pertenece 10
DECLARE
V_EMP EMP.EMP_NO%TYPE := 9999;
BEGIN
INSERT INTO EMP(EMP_NO, APELLIDO,OFICIO, DEPT_NO)
VALUES(V_EMP,'PEREZ','ANALISTA',10);
COMMIT;
END;

-- 3. Incrementar el salario en la tabla EMP en 200 EUROS a todos los trabajadores que sean ‘ANALISTA’, 
-- mediante un bloque anónimo PL, asignando dicho valor a una variable declarada con %TYPE.
DECLARE
V_INCREMENTO EMP.SALARIO%TYPE := 200;
BEGIN
UPDATE EMP
SET SALARIO = SALARIO + V_INCREMENTO
WHERE OFICIO = 'ANALISTA';
COMMIT;
END;

-- 4. Realizar un programa que devuelva el número de cifras de un número entero, 
-- introducido por teclado, mediante una variable de sustitución.
DECLARE
V_NUM NUMBER := &NUM;
BEGIN
DBMS_OUTPUT.PUT_LINE('EL NUMERO '||V_NUM||' TIENE UNA LONGITUD DE '||LENGTH(V_NUM));
END;

-- 5. Crear un bloque PL para insertar una fila en la tabla DEPT. Todos los datos necesarios serán pedidos desde teclado.
DECLARE
V_DEPTNO NUMBER := &DEPTNO;
V_LOC VARCHAR2(30) := '&LOC';
V_DNAME VARCHAR2(30) := '&DNAME';
BEGIN
INSERT INTO DEPT
VALUES(V_DEPTNO, V_LOC, V_DNAME);
COMMIT;
END;

-- 6. Crear un bloque PL que actualice el salario de los empleados que no cobran comisión en un 5%.
DECLARE
V_INCREMENTO NUMBER := 0.05;
BEGIN
UPDATE EMP
SET SALARIO = SALARIO + (SALARIO * V_INCREMENTO)
WHERE COMISION IS NULL;
END;

-- 7. Crear un bloque PL que almacene la fecha del sistema en una variable. 
-- Solicitar un número de meses por teclado y mostrar la fecha del sistema incrementado en ese número de meses.
DECLARE
V_DATE DATE := SYSDATE;
V_MESES NUMBER := &MESES;
BEGIN
DBMS_OUTPUT.PUT_LINE(ADD_MONTHS(V_DATE, V_MESES));
END;

-- 8. Introducir dos números por teclado y devolver el resto de la división de los dos números.
DECLARE
numero1 int;
numero2 int;
resto int;
BEGIN
numero1 := &num1;
numero2 := &num2;
resto := MOD(numero1, numero2);
dbms_output.put_line ( 'el resto de la division de ' || numero1 || ' / ' || numero2 || ' es igual a ' || resto);
end;

-- 9. Solicitar un nombre por teclado y devolver ese nombre con la primera inicial en mayúscula.
DECLARE
apellido varchar2(15) := '&dato';
V_RESUL varchar2(15);
BEGIN
V_RESUL :=INITCAP(apellido);
DBMS_OUTPUT.PUT_LINE(V_RESUL);
END;

-- 10. Crear un bloque anónimo que permita borrar un registro de la tabla emp introduciendo por parámetro un número de empleado.
DECLARE
V_NUM NUMBER := &NUM;
BEGIN
DELETE FROM EMP WHERE EMP_NO=&NUM;
COMMIT;
END;


-- estructuras de control --
-- debemos comprobar si un numero es positivo o negativo
declare 
v_numero int;
BEGIN
v_numero := &numero;
-- preguntamos por el propio numero 
if (v_numero >=0) THEN
dbms_output.PUT_LINE('Positivo: ' || v_numero);
else
DBMS_OUTPUT.PUT_LINE('Negativo: ' || v_numero);
end if;
DBMS_OUTPUT.PUT_LINE('Fin de programa');
end;
undefine numero;

-- numero positivo, negativo o 0
DECLARE
v_numero int;
BEGIN
v_numero := &numero;
if (v_numero > 0) THEN
dbms_output.put_line('Es positivo...' || v_numero);
elsif (v_numero = 0) then 
DBMS_OUTPUT.PUT_LINE('Es cero!!! ' || v_numero);
elsif (v_numero < 0) then
DBMS_OUTPUT.PUT_LINE('Negativo:' || v_numero);
end if;
dbms_output.PUT_LINE('Fin del programa');
end;

-- Pedir un numero al usuario del 1 al 4, si nos da otr numero le indicamos que esta mal
-- 1 primavera, 2 verano, 3 otoño, 4 invierno
declare 
v_estacion int;
begin 
v_estacion := &estacion;
if (v_estacion = 1) THEN
DBMS_OUTPUT.PUT_LINE('Primavera');
elsif (v_estacion = 2) then
DBMS_OUTPUT.PUT_LINE('Verano');
elsif (v_estacion = 3) then
DBMS_OUTPUT.PUT_LINE('Otoño');
elsif (v_estacion = 4) then
DBMS_OUTPUT.PUT_LINE('Invierno');
else
dbms_output.PUT_LINE('Valor incorrecto' || v_estacion);
end if;
DBMS_OUTPUT.PUT_LINE('Fin de programa');
end;

-- pediremos dos numeros al usuario y debemos devolver que numero es mayor
DECLARE
numero1 int;
numero2 int;
BEGIN
numero1 := &num1;
numero2 := &num2;
if (numero1 > numero2) THEN
DBMS_OUTPUT.PUT_LINE('El numero mayor es ' || numero1);
ELSIF (numero1 < numero2) THEN
dbms_output.PUT_LINE('El numero mayor es ' || numero2);
end if;
end;

UNDEFINE numero1;
undefine numero2;

-- pedir un numero al usuario e indicar si es par o impar
declare
    v_numero int;
begin
    v_numero := &numero;
    if (MOD(v_numero, 2) = 0) THEN
        DBMS_OUTPUT.PUT_LINE(' Numero par '  || v_numero);
    ELSE
        DBMS_OUTPUT.PUT_LINE(' Numero impar' || v_numero);
    end if;
end;

-- por supuesto, podemos perfectamente utilizar cualquier
-- operador, tanto de comparacion, como relacional en nuestros
-- codigos.
-- pedir una letra al usuario. Si la letra es vocal (a,e,i,o,u)
-- pintamos vocal, sino, consonante

declare 
    v_letra varchar2(1);
BEGIN
    v_letra := lower('&letra');
    if (v_letra ='a' or v_letra = 'e' or v_letra ='i' 
    or v_letra = 'o' or v_letra ='u') then
        dbms_output.put_line('Vocal ' || v_letra);
    else
        dbms_output.put_line('Consonante ' || v_letra);
end if;
end;


-- pedir tres numeros al usuario
-- debemos mostrar el mayor de ellos y el menor de ellos
declare
v_numero1 int;
v_numero2 int;
v_numero3 int;
v_mayor int;
v_menor int;
v_intermedio int;
v_suma int;
begin
v_numero1 := &numero1;
v_numero2 := &numero2;
v_numero3 := &numero3;

if (v_numero1 >= v_numero2 and v_numero1 >= v_numero3) THEN v_mayor := v_numero1;
ELSIF (v_numero2 >= v_numero1 and v_numero2 >= v_numero3) THEN v_mayor := v_numero2;
ELSE v_mayor := v_numero3;
end if; 
if (v_numero1 <= v_numero2 and v_numero1 <= v_numero3) THEN v_menor := v_numero1;
ELSIF (v_numero2 <= v_numero1 and v_numero2 <= v_numero3) THEN v_menor := v_numero2;
else v_menor := v_numero3;
end if;
v_suma := v_numero1 + v_numero2 + v_numero3;
v_intermedio := v_suma - v_mayor - v_menor;
    dbms_output.put_line('Mayor: ' || v_mayor);
    dbms_output.put_line('Menor: ' || v_menor);
    dbms_output.put_line('Intermedio: ' || v_intermedio);
end;


undefine numero1;
undefine numero2;
undefine numero3;

-- conseguir dia del año de un nacimiento
DECLARE


BEGIN


end;