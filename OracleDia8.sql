-- campos de autoincremento (secuencias)
-- nextval: incrementa en uno la secuencia por cada peticion
-- currval: devuelve el valor actual sin incrementar
create sequence seq_dept
increment by 10 
start with 40;

-- una secuencia no se puede modificar, solo eliminar y crear de nuevo
select seq_dept.nextval as siguiente from dual;

-- no podemos acceder a currval hasta que no hemos ejecutado nextval
select seq_dept.currval as actual from dual;

-- si lo queremos para insert debemos llamarlo de forma explicita
insert into dept values (seq_dept.nextval, 'NUEVO', 'NUEVO');

-- secuencia para departamentos
select * from dept;
create sequence seq_test
increment by 1
start with 1;

select seq_test.nextval from dual;
select seq_test.currval from dual;

-- una secuencia no esta asociada a una tabla
insert into hospital values (seq_dept.nextval, 'El Carmen', 'Calle Pex', '12345', 125);
select * from hospital;

-- practica --
-- necesito las siguientes caracteristicas dentro de nuestra base de datos hospital
-- 1) pk en hospital
alter table pk_hospital
add constraint 
primary key (hospital_cod);

-- 2) pk en doctor
alter table pk_doctor
add constraint
primary key (doctor_no);

-- 3) necesito relacional doctores con hospitales
select * from hospital;

alter table doctor
add constraint fk_doctor_hospital
foreign key (hospital_cod)
references hospital (hospital_cod);
-- 4) las personas de la plantilla solamente puede tabajar en 
-- turnos de mañana, tarfde o noche (T, N, M)
alter table plantilla
add constraint chk_plantilla_turno
check (turno in ('T', 'M', 'N'));

--Crear la tabla COLEGIOS con los siguientes campos --
create table colegios 
(cod_colegio int not null 
, nombre varchar2(20) not null 
, localidad varchar2(15) 
, provincia varchar2(15) 
, anyo_construccion date 
, coste_construccion int 
, cod_region int 
, unico int); 

-- restricciones de colegios (pk)
alter table colegios 
add constraint PK_COLEGIOS 
primary key (cod_colegio); 

-- unique
alter table colegios 
add constraint U_COLEGIOS_UNICO 
unique (unico); 

-- secuencia para manejar insercion de colegios
create sequence seq_colegios 
increment by 1 
start with 1; 

-- Crear la tabla PROFESORES con los siguientes campos --
create table profesores
(cod_profe varchar2 (3) not null,
nombre varchar2 (60) not null,
apellido1 varchar2 (50) not null,
apellido2 varchar2 (50),
dni varchar2 (9) not null, 
edad integer,
localidad varchar2 (50),
provincia varchar2 (50),
salario integer,
cod_colegio integer);

-- restricciones tabla profesores (pk)
alter table profesores 
add constraint PK_PROFESORES 
primary key (cod_profe); 

-- unique
alter table profesores 
add constraint U_PROFESORES_DNI 
unique (dni); 

-- check formato dni (longitud)
alter table profesores 
add constraint CK_PROFESORES_DNI 
check (length(dni) = 9); 

-- foreing key profesores colegios
alter table profesores 
add constraint FK_COLEGIOS_PROFESORES 
foreign key (cod_colegio) 
references colegios (cod_colegio); 

-- Crear la tabla REGIONES con los siguientes campos --
create table regiones
(cod_region integer not null,
regiones varchar2 (20) not null);

-- restricciones de regiones
alter table regiones 
add constraint PK_REGIONES   
primary key (cod_region);

-- secuencias para regiones
create sequence seq_regiones 
increment by 1 
start with 1; 

-- Crear la tabla ALUMNOS con los siguientes campos --
create table alumnos
(dni varchar2 (9) not null,
nombre varchar2 (20) not null,
apellidos varchar2 (50),
fecha_ingreso date,
fecha_nac date,
localidad varchar2 (15),
provincia varchar2 (30),
cod_colegio integer);

-- restricciones alumnos (pk)
alter table alumnos
add constraint PK_ALUMNOS
primary key (dni);

-- foreing key alumnos
alter table alumnos
add constraint FK_COLEGIOS_ALUMNOS
foreing key (cod_colegio)
references colegios (cod_colegio);

-- Crear una nueva relación entre el campo Cod_Region de la tabla REGIONES y Cod_Region de la tabla colegios. --
alter table regiones
add constraint FK_REGIONES_COLEGIOS
foreign key (cod_region)
references colegios (cod_region);

-- Añadir el campo Sexo, Fecha de nacimiento y Estado Civil a la tabla Profesores --
alter table profesores
add (sexo varchar2 (1),
fecha_nac date,
estado_civil varchar2 (12));

-- Eliminar el campo Edad de la tabla Profesores --
alter table profesores 
drop column edad;

-- Añadir el campo Sexo, Dirección y Estado Civil a la tabla Alumnos --
alter table alumnos
add (sexo varchar2 (1),
direccion varchar2 (100),
estado_civil varchar2 (12));

-- Borrar la relación existente entre la tabla profesores y Colegios --
alter table profesores
drop constraint FK_COLEGIOS_PROFESORES;

-- Crear de nuevo la relación borrada en el ejercicio anterior que tenga eliminación en cascada --
alter table profesores
add constraint FK_COLEGIOS_PROFESORES
foreign key (cod_colegio)
references colegios (cod_colegio)
on delete cascade;

-- Agregar un valor por defecto con la fecha actual al campo Fecha_Ingreso de la tabla alumnos
alter table alumnos
modify (fecha_ingreso date default sysdate);

-- Queremos rellenar los datos de las tablas creadas, para ello vamos a introducir a tres alumnos en los colegios. Los datos son los siguientes
-- primero deben existir las regiones
insert into regiones  
values (seq_regiones.nextval, 'MADRID'); 
insert into regiones 
values (seq_regiones.nextval, 'Comunidad Valenciana'); 
insert into regiones 
values (seq_regiones.nextval, 'Cataluña'); 

-- crear los colegios
insert into colegios 
values (seq_colegios.nextval, 'Buen consejo', 'Madrid', 'Madrid' 
, '01/01/1956', 150000, 1, 1); 

insert into colegios 
values (seq_colegios.nextval, 'Carmelitas', 'Alicante', 'Alicante' 
, '01/01/1901', 250000, 2, 2); 

insert into colegios 
values (seq_colegios.nextval, 'CP Cataluña', 'Llobregat', 'Barcelona' 
, '01/01/1915', 250000, 3, 3); 

-- ya se podrian insertar los alumnos
-- Ana Ortiz Ortega Provincia: Madrid Localidad: Madrid
-- Javier Chuko Palomo Provincia: Alicante Localidad: Arenales del sol
-- Miguel Torres Tormo Provincia: Barcelona Localidad: Llobregat
insert into alumnos 
values ('12345678X', 'Ana', 'Ortiz Ortega', sysdate, '01/01/1995' 
, 'MADRID', 'MADRID',2, 'F', 'SOLTERA', 'Calle Pez'); 

insert into alumnos 
values ('12345677Z', 'Javier', 'Chuko Palomo', sysdate, '01/01/1988' 
, 'ARENALES DEL SOL', 'ALICANTE',3, 'M', 'DIVORCIADO', 'Calle Salmon'); 

insert into alumnos 
values ('2345677Z', 'Miguel', 'Torres Tormo', sysdate, '01/01/2001' 
, 'Llobregat', 'BARCELONA',4, 'M', 'SOLTERO', 'Calle Delfin'); 

-- Borrar la tabla Regiones --
-- primero hay que borrar la foreing key con la que esta asociada
alter table colegios 
drop constraint FK_REGIONES_COLEGIOS; 
drop table regiones;

-- Borrar todas las tablas --
drop table alumnos;
drop table profesores;
drop table colegios;

-- insertar profesores a nuestra base de datos
insert into profesores 
values (1, 'Alejandro', 'Ramiro', 'Gutierrez', '12345678W', 'Parla', 'Madrid' 
, 45000, 2, 'M', 'CASADO', sysdate); 

insert into profesores
values (2, 'Alejandra', 'Marian', 'Lopez', '97845678W', 'Parla', 'Madrid' 
, 45000, 2, 'F', 'CASADA', sysdate); 

insert into profesores
values (3, 'Julia', 'Arroyo', 'Garrigos', '37845678W', 'Calpe', 'Alicante' 
, 65000, 3, 'F', 'SOLTERO', sysdate); 