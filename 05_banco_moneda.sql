-- ============================================================
-- Bases de Datos 1 — Ejercicios Resueltos
-- 05_banco_moneda.sql
-- Modelo: Banco, Moneda, Persona, Cuenta, Opera
-- ============================================================

-- EJ 4 - Ej resuletos

create table Pais(
	pais char(50) primary key);

create table Banco(
	id int primary key, 
	nombre varchar(50), 
	pais char(50));

create table Moneda(
	id char(2) primary key, 
	descripcion varchar(50), 
	valorOro decimal(18,3), 
	valorPetroleo decimal(18,3));

create table Persona(
	pasaporte char(15) primary key, 
	codigoFiscal int, 
	nombre varchar(50));

create table Cuenta(
	monto decimal(18,3), 
	idBanco int not null, 
	idMoneda char(2) not null, 
	idPersona char(15) not null, 
	constraint PK_Persona primary key(idBanco, idMoneda,idPersona));

create table Opera(
	idBanco int not null, 
	idMoneda char(2) not null, 
	cambioCompra decimal(18,3), 
	cambioVenta decimal(18,3), 
	constraint PK_Opera primary key(idBanco,idMoneda));

INSERT INTO pais (pais) VALUES 
	('Argentina'),
	('USA'),
	('Uruguay'),
	('Espa�a'),
	('Alemania'),
	('Suiza');

INSERT INTO banco (id, nombre, pais) VALUES 
	('1', 'Banco Nacion', 'Argentina'),
	('2', 'Banco Montevideo', 'Uruguay'),
	('3', 'Banco Ciudad', 'Argentina'),
	('4', 'City Bank', 'USA'),
	('5', 'Switzerland Bank', 'Suiza'),
	('6', 'BBVA', 'Espa�a');

INSERT INTO moneda (id, descripcion, valorOro, valorPetroleo) VALUES 
	('AR', 'Peso Argentino','2', '1'),
	('UY', 'Peso Uruguayo','5', '2.5'),
	('US', 'Dolar', '1','.5'),
	('EU', 'Euro', '2', '1');

INSERT INTO persona (pasaporte, codigoFiscal, nombre) VALUES 
	('1', '1234', 'Bill Gates'),
	('2', '12112', 'Carlos Slim'),
	('3', '2325', 'Lionel Messi'),
	('4', '01243', 'Diego Maradona');

INSERT INTO cuenta (monto, idBanco, idMoneda, idPersona) VALUES 
	('100000', '4', 'US', '1'),
	('20000', '5', 'EU', '1'),
	('15000', '2', 'US', '1'),
	('50000', '4', 'US', '2'),
	('35000', '5', 'US', '2'),
	('2000', '1', 'AR', '3'),
	('10000', '4', 'US', '3'),
	('15000', '5', 'US', '3'),
	('15000', '5', 'US', '4');

INSERT INTO opera (idBanco, idMoneda, cambioCompra, cambioVenta) VALUES 
	('1', 'US', '1', '1'),
	('2', 'US', '1', '1'),
	('3', 'US', '1', '1'),
	('4', 'US', '1', '1'),
	('5', 'US', '1', '1'),
	('6', 'US', '1', '1'),
	('1', 'EU', '2', '2'),
	('2', 'EU', '2', '2'),
	('3', 'EU', '3', '3'),
	('4', 'EU', '2', '2'),
	('5', 'EU', '2.2','2.2'),
	('6', 'EU', '2.2','2.5'),
	('1', 'AR', '5', '5'),
	('3', 'AR', '5.5','5.5'),
	('2', 'AR', '7', '7'),
	('1', 'UY', '3', '3'),
	('2', 'UY', '2', '2');


-- A. Listar a las personas que no tienen ninguna cuenta en "pesos argentinos" en Ning�n banco. Que adem�s tengan al menos dos cuentas en "d�lares".
-- B. Listar de las monedas que son operadas en todos los bancos, aquellas con el valor oro m�s alto.

/* Personas que no tienen cuenta en pesos argentinos 
SELECT *
FROM Persona
WHERE pasaporte NOT IN (
	SELECT idPersona 
	FROM Cuenta 
	WHERE idMoneda = 'AR')*/

/* Persona que tienen cuenta en pesos argentinos
SELECT DistInct(nombre)
FROM Persona p JOIN Cuenta c ON p.pasaporte = c.idPersona
WHERE c.idMoneda = 'AR' */

/*Persona que tiene cuenta en pesos argentinos*/
SELECT idPersona 
FROM Cuenta c JOIN Moneda m ON m.id =c.idMoneda 
WHERE m.descripcion = 'Peso Argentino'

/*Persona que tienen mas de 2 cuentas en dolares*/
SELECT idPersona
FROM Cuenta c JOIN Moneda m On m.id=c.idMoneda
WHERE m.descripcion = 'Dolar'
GROUP BY idPersona
HAVING COUNT(distinct idBanco)>=2

/*Solucion*/
SELECT *
FROM Persona p1
WHERE p1.pasaporte NOT IN 
(
	SELECT idPersona 
	FROM Cuenta 
	WHERE idMoneda = 'AR'
)
AND EXISTS
(
	SELECT idPersona
	FROM Cuenta c JOIN Moneda m On m.id=c.idMoneda
	WHERE c.idpersona=p1.pasaporte AND m.descripcion = 'Dolar'
	GROUP BY idPersona
	HAVING COUNT(distinct idBanco)>=2
)

-- B. Listar de las monedas que son operadas en todos los bancos, aquellas con el valor oro m�s alto.

/*Lista las monedas operadas en todos los bancos*/

/*Cuantos bancos hay?*/
SELECT COUNT(Distinct id)  
FROM Banco

/*Cuantos bancos opera cada moneda?*/
SELECT idMoneda--, COUNT(Distinct idbanco)
FROM opera
GROUP BY idMoneda

/*Monedas que operan en todos los bancos */
SELECT idMoneda
FROM opera 
GROUP BY idMoneda
HAVING 
	COUNT(DistInct(idBanco)) = (
									SELECT COUNT(Distinct id)  
									FROM Banco)

--DROP VIEW monedas_en_todos_los_bancos 

/*Monedas que operan en todos los bancos con una vista*/
CREATE VIEW monedas_en_todos_los_bancos AS
SELECT o.idMoneda, COUNT(DistInct o.idBanco) as TotalDeBancos, m.valorOro
FROM opera o JOIN Moneda m ON o.idMoneda = m.id
GROUP BY o.idMoneda, m.valorOro
HAVING COUNT(DistInct(idBanco)) = (
									SELECT COUNT(Distinct id)  
									FROM Banco)

/*Moneda con mayor valor de oro que opera en todos los bancos*/

SELECT *
FROM Moneda m JOIN monedas_en_todos_los_bancos Mon ON m.id = Mon.idMoneda
WHERE valorOro >= (
					SELECT MAX(valorOro)
					FROM Moneda m JOIN monedas_en_todos_los_bancos Mon ON m.id = Mon.idMoneda
					)

SELECT *
FROM monedas_en_todos_los_bancos 
WHERE valorOro >= (
					SELECT MAX(valorOro)
					FROM monedas_en_todos_los_bancos
					)



