-- realizar el siguiente codigo pl/sql
-- necesitamos modificar el salario de los doctores de LA PAZ
-- si la suma salarial supera 1.000.000 bajamos salarios en 10.000 a todos
-- si la suma salarial no supera 1.000.000 subimos salarios en 10.000
-- mostar el numero de filas que hemos modificado (subir o bajar)
-- doctores con suerte: 6, doctores mas pobres: 6.

DECLARE
    v_suma_salarial NUMBER;
BEGIN
    select sum (doctor.SALARIO) into v_suma_salarial
    from DOCTOR
    inner join hospital
    on DOCTOR.HOSPITAL_COD = hospital.HOSPITAL_COD
    where LOWER(hospital.NOMBRE) = 'la paz';
    DBMS_OUTPUT.PUT_LINE ('suma salarial La paz ' || v_suma_salarial);
if 
v_suma_salarial > 1000000 then
update doctor set SALARIO = salario - 10000
where HOSPITAL_COD = (SELECT HOSPITAL_COD from HOSPITAL where UPPER(nombre)='LA PAZ');
DBMS_OUTPUT.PUT_LINE ('Doctores con suerte ' || sql%rowcount);
ELSE
update doctor set SALARIO = salario + 10000
where HOSPITAL_COD = (SELECT HOSPITAL_COD from HOSPITAL where UPPER(nombre)='LA PAZ');
    DBMS_OUTPUT.PUT_LINE (' Doctores mas pobres ' || sql%rowcount);
end if;
end;

-- realizamos la declaracion con departamentos
-- no tiene nada que ver con la tabla DEPT toda cifra que se le asigne a una declaracion
describe dept;
DECLARE
v_id dept.DEPT_NO%TYPE;
BEGIN
    v_id := 10;
    DBMS_OUTPUT.PUT_LINE('El valor de v_id es ' || v_id);
end;

-- podemos almacenar todos los departamento (uno a uno) en un rowtype
DECLARE
    v_fila dept%rowtype;
    cursor cursor_dept IS
    select * from dept;
BEGIN
    open cursor_dept;
loop
    fetch cursor_dept into v_fila;
exit when cursor_dept%notfound;
    DBMS_OUTPUT.PUT_LINE(' id: ' || v_fila.dept_no || ' ,  nombre: ' || v_fila.dnombre || ', localidad: ' || v_fila.loc);
end loop;
close cursor_dept;
end;

-- realizar un curso para mostrar el apellido, salario y oficio
-- de empleados

DECLARE
    cursor cursor_emp IS 
    select apellido, salario, oficio,
    SALARIO + COMISION as total
    from EMP;
BEGIN
    for v_registro IN cursor_emp
    LOOP
        DBMS_OUTPUT.PUT_LINE('Apellido ' || v_registro.apellido || ', salario: ' || v_registro.salario
        || ', oficio: ' || v_registro.oficio || ', total: ' || v_registro.total);
    end loop;    
end;

