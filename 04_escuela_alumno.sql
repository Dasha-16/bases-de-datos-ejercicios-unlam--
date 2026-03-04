-- ============================================================
-- Bases de Datos 1 — Ejercicios Resueltos
-- 04_escuela_alumno.sql
-- Modelo: Escuela, Alumno, Hermano_De, Alimento
-- ============================================================

--EJERCICIOS RESUELTOS (2)

use EjResueltos

drop table Alumno
create table Alumno
(
	DNI int not null primary key, 
	Apellido varchar(50), 
	Nombre varchar(50), 
	CodEscuela int
);
create table Hermano_De
(
	DniAlumno int not null, 
	DniHermano int not null, 
	constraint PK_Hermano_De primary key(DniAlumno, DniHermano)
);
create table Escuela
(
	CodEscuela int not null primary key, 
	Nombre varchar(50), 
	Direccion varchar(255)
);
create table Alimento
(
	IdAlimento int not null primary key, 
	Descripcion varchar(50),
	Marca varchar(50)
);
create table Almuerza_En
(
	DniAlumno int not null, 
	IdAlimento int not null, 
	CodEscuela int, 
	constraint PK_Almuerza_En primary key(DniAlumno, IdAlimento)
);


INSERT INTO escuela (CodEscuela, Nombre, Direccion) VALUES 
	('1', 'Escuela 1', 'Famosos'),
	('2', 'Escuela 2', 'Oficialistas'),
	('3', 'Escuela 3', 'Opositores'),
	('4', 'Escuela 4', 'Hermanos');

INSERT INTO alumno(DNI, Apellido, Nombre, CodEscuela) VALUES 
	('1', 'Fort', 'Ricardo', '1'),
	('2', 'Marcelo', 'Tinelli', '1'),
	('3', 'Moria', 'Casan', '1'),
	('4', 'Cristina', 'Fernandez','2'),
	('5', 'Anibal', 'Fernandez','2'),
	('6', 'Amado', 'Boudou', '2'),
	('7', 'Ricardo', 'Alfonsin','3'),
	('8', 'Elisa', 'Carrio', '3'),
	('9', 'Hermes', 'Binner', '3'),
	('10', 'Guido', 'Tinelli', '4'),
	('11', 'Hugo', 'Tinelli', '4'),
	('12', 'Alberto', 'Fernandez','4'),
	('13', 'Silvia', 'Fernandez','4'),
	('14', 'Ricardo', 'Tinelli','4');

INSERT INTO hermano_de (DniAlumno, DniHermano) VALUES
	('2', '10'),
	('2', '11'),
	('2', '14'),
	('5', '12'),
	('4', '13'),
	('10', '2'),
	('10', '11'),
	('10', '14'),
	('11', '2'),
	('11', '10'),
	('11', '14'),
	('14', '2'),
	('14', '10'),
	('14', '11');

INSERT INTO Alimento (IdAlimento, Descripcion, Marca) VALUES
	('1', 'Hamburgesa','Patty'),
	('2', 'Milanesa', 'Granja del Sol'),
	('3', 'Salchicha', 'Vienisima');

INSERT INTO almuerza_en (DniAlumno, IdAlimento, CodEscuela) VALUES 
	('4', '1', '1'),
	('5', '1', '3'),
	('4', '2', '4'),
	('1', '3', '1'),
	('1', '1', '4'),
	('2', '1', '1'),
	('3', '1', '1'),
	('12', '2', '4'),
	('13', '2', '4'),
	('10', '1', '3'),
	('7', '1', '3'),
	('8', '2', '3'),
	('9', '3', '3');

-- a) Listar a todos los alumnos que asisten a escuelas donde no sirven alimentos y almuerzan en otro establecimiento
-- b) Mostrar todas las escuelas que sirven alimentos a todos sus alumnos que no tienen m�s de dos hermanos

SELECT * FROM Almuerza_En
SELECT * FROM Alimento
SELECT * FROM escuela
SELECT * FROM alumno
SELECT * FROM hermano_de

-- a) Listar a todos los alumnos que asisten a escuelas donde no sirven alimentos y almuerzan en otro establecimiento

/* Escuelas que sirven alimentos */ -- Las escuelas que figuran en la lista de Almuerza_en
SELECT Distinct(e.CodEscuela)
FROM Escuela e JOIN Almuerza_En a ON e.CodEscuela = a.CodEscuela

/* Escuelas que no sirven alimentos */
SELECT CodEscuela
FROM Escuela 
WHERE CodEscuela NOT IN ( SELECT CodEscuela FROM Almuerza_En)

/*Alumnos que asisten a la escuela que no sirve alimento*/
SELECT *
FROM Alumno
WHERE CodEscuela IN (SELECT CodEscuela
					FROM Escuela 
					WHERE CodEscuela NOT IN ( 
											SELECT CodEscuela 
											FROM Almuerza_En))

/*Alumnos  que almuerzan en otra escuela*/
SELECT *
FROM Alumno a JOIN Almuerza_En ae ON a.DNI = ae.DniAlumno
WHERE a.CodEscuela <> ae.CodEscuela

/*SOLUCION */
SELECT DISTINCT a.*
FROM Alumno a JOIN Almuerza_En ae ON a.DNI = ae.DniAlumno
WHERE a.CodEscuela <> ae.CodEscuela
	AND
		a.CodEscuela NOT IN ( SELECT CodEscuela FROM Almuerza_En)


-- b) Mostrar todas las escuelas que sirven alimentos a todos sus alumnos que no tienen m�s de dos hermanos - Ver si almuerza_en le da de comer a ese alumno (*)

/* Cuantos alumnos tiene cada escuela */ -- Agrupo los alumnos por escuela y los cuentos
SELECT a.CodEscuela, a.DNI --count (a.DNI) as TOTAL_ALUMNOS
FROM Alumno a
GROUP BY a.CodEscuela, a.DNI

/* Alumnos que tienen mas de 2 hermanos que tiene cada escuela */ --(*)
SELECT a.CodEscuela, a.DNI 
FROM Alumno a
GROUP BY a.CodEscuela, a.DNI
HAVING a.DNI IN (SELECT h.DniAlumno
FROM Hermano_De h
GROUP BY h.DniAlumno
HAVING COUNT (h.DniHermano) >= 2)


/* Escuelas que sirven alimento a todos sus alumnos */ -- Si todos los alumnos de esa escuela comen ah�, es decir, que en Almuerza_en aparezca tantas veces 
SELECT ae.CodEscuela, COUNT (ae.DniAlumno) AS CANT_DE_ALUMNOS_QUE_ALIMENTA
FROM Almuerza_en ae
GROUP BY ae.CodEscuela

/* Alumnos que tienen mas de 2 hermanos */
SELECT h.DniAlumno, COUNT (h.DniHermano) as TOTAL_HERMANOS
FROM Hermano_De h
GROUP BY h.DniAlumno
HAVING COUNT (h.DniHermano) >= 2

/* Alumnos con mas de 2 hermanos que tiene cada escuela 
SELECT a.CodEscuela, count (DISTINCT(a.DNI)) as TOTAL_ALUMNOS_CON_HERMANOS, COUNT (h.DniHermano)
FROM Alumno a JOIN Hermano_De h ON a.DNI = h.DniAlumno
GROUP BY a.CodEscuela
HAVING COUNT (h.DniHermano) >= 2*/

/* RESULTADO */
SELECT DistInct e.CodEscuela
FROM Escuela e JOIN Almuerza_En ae ON e.CodEscuela = ae.CodEscuela
--GROUP BY e.CodEscuela
WHERE e.CodEscuela not IN (SELECT a.CodEscuela
					FROM Alumno a
					GROUP BY a.CodEscuela, a.DNI
					HAVING a.DNI IN (SELECT h.DniAlumno
									FROM Hermano_De h
									GROUP BY h.DniAlumno
									HAVING COUNT (h.DniHermano) >= 2))



