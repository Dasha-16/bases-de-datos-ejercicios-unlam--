-- ============================================================
-- Bases de Datos 1 — Guia de Ejercicios
-- 03_empresa_persona.sql
-- Modelo: Empresa, Persona, Trabaja, Vive
-- ============================================================

--GUIA EJERCICIOS- EJ4

CREATE TABLE Persona
(
	dni int,
	nomPersona varchar(50),
	telefono int,
	PRIMARY KEY (dni)
)
go
CREATE TABLE Empresa
(
	nomEmpresa varchar(50),
	telefono int,
	PRIMARY KEY (nomEmpresa)
)
go
CREATE TABLE Vive
(
	dni int,
	calle varchar(50),
	ciudad varchar(50),
	PRIMARY KEY (dni)
)
go
CREATE TABLE Trabaja
(
	dni int,
	nomEmpresa varchar(50),
	salario decimal(18,3),
	feIngreso date,
	feEgreso date,
	PRIMARY KEY (dni)
)
go
CREATE TABLE Situada_En
(
	nomEmpresa varchar(50),
	ciudad varchar(50),
	PRIMARY KEY (nomEmpresa)
)
go
CREATE TABLE Supervisada
(
	dniPer int,
	dniSup int,
	PRIMARY KEY (dniPer, dniSup)
)



INSERT INTO Persona VALUES
	(1, 'Dasha', 46614020),
	(2, 'Florencia', 46253891),
	(3, 'Sofia', 45879135),
	(4, 'Romina', 45785135),
	(5, 'Martina', 45963835),
	(6, 'Oriana', 47532135),
	(7, 'Pilar', 75899135)


INSERT INTO Empresa VALUES
	('Banelco', 46611111),
	('Telecom', 46252222),
	('Paulinas', 45873333),
	('Clarin', 45874444),
	('Sony', 45875555)

INSERT INTO Vive VALUES
	(1, 'Firpo 1523', 'Ituzaingo'),
	(2, 'Olivera 1060', 'Ituzaingo'),
	(3, 'Vucetich 2894', 'Castelar'),
	(4, 'Rivadavia 2784', 'Castelar'),
	(5, 'Firpo 1604', 'Ituzaingo'),
	(6, 'Casacuberta 2894', 'Moron'),
	(7, 'Belgrano 2894', 'Moron')

INSERT INTO Trabaja VALUES
	(1, 'Banelco', 1000, '2000-01-01', '2001-01-01'),
	(2, 'Banelco', 900, '2002-05-02', '2004-01-01'),
	(3, 'Telecom', 1500, '2003-08-03', '2006-01-01'),
	(4, 'Paulinas', 2000, '2010-02-04', '2011-01-01'),
	(5, 'Paulinas', 500, '2000-10-05', '2010-01-01'),
	(6, 'Clarin', 800, '2000-12-06', '2008-01-01'),
	(7, 'Sony', 1800, '2000-02-07', '2020-01-01')

INSERT INTO Situada_En VALUES
	('Banelco', 'Ituzaingo'),
	('Telecom', 'Castelar'),
	('Paulinas', 'Moron'),
	('Clarin', 'Padua'),
	('Sony', 'Moron')

INSERT INTO Supervisada VALUES
	(1,1),
	(2,1),
	(3,2),
	(4,2),
	(5,2),
	(6,3),
	(7,3)

/* a. Encontrar el nombre de todas las personas que trabajan en la empresa �Banelco� */
SELECT * FROM PERSONA
GO
SELECT * FROM	Situada_En

SELECT p.dni, P.nomPersona
FROM Persona p JOIN Trabaja t ON p.dni = t.dni
WHERE t.nomEmpresa = 'Banelco'

/* b. Localizar el nombre y la ciudad de todas las personas que trabajan para la empresa �Telecom�. */

--Personas que trabajn para Telecom */
CREATE view personasTelecom AS
SELECT p.dni, P.nomPersona
FROM Persona p JOIN Trabaja t ON p.dni = t.dni
WHERE t.nomEmpresa = 'Telecom'

SELECT p.nomPersona, v.ciudad
FROM personasTelecom p JOIN Vive v ON p.dni = V.dni

/*c. Buscar el nombre, calle y ciudad de todas las personas que trabajan para la empresa �Paulinas� y ganan m�s de $1500. */

--Personas que trabajan para la empresa Paulina y ganan m�s de 1500
CREATE view personasPaulina AS
SELECT p.dni, p.nomPersona
FROM Persona p JOIN Trabaja t ON p.dni = t.dni
WHERE t.nomEmpresa = 'Paulinas' AND t.salario >=1500 

SELECT p.nomPersona, v.calle, v.ciudad
FROM personasPaulina p JOIN Vive v ON p.dni = v.dni

/*d. Encontrar las personas que viven en la misma ciudad en la que se halla la empresa en donde trabajan. */SELECT t.dni, v.ciudad, t.nomEmpresaFROM Trabaja t JOIN Vive v ON t.dni = v.dniWHERE v.ciudad IN (SELECT s.ciudad, T.dni					FROM Situada_En s JOIN Trabaja t ON s.nomEmpresa = t.nomEmpresa					WHERE t.dni = v.dni				)-- Ciudad de la empresa en la que trabajan SELECT t.dni, t.nomEmpresa, s.ciudadFROM Situada_En s JOIN Trabaja t ON s.nomEmpresa = t.nomEmpresa