-- ============================================================
-- Bases de Datos 1 — Ejercicios Resueltos (Catedra)
-- 02_almacen_articulo_resueltos.sql
-- Modelo: Almacen, Articulo, Material, Proveedor
-- Resoluciones alternativas provistas por la catedra
-- ============================================================

--EJERCICIOS RESUELTOS (1)

CREATE DATABASE EjResueltos;

USE EjResueltos;

CREATE TABLE Almacen
(
	Nro int primary key,
	Responsable varchar(50)
)
CREATE TABLE Articulo
(
	CodArt int primary key,
	Descrip varchar(50),
	Precio decimal(12,3)
)
CREATE TABLE Material
(
	CodMat int primary key,
	Descrip varchar(50)
)
CREATE TABLE Proveedor
(
	CodProv int,
	Nombre varchar(50),
	Domicilio varchar(50),
	Ciudad varchar(50)
	PRIMARY KEY (CodProv)
)
CREATE TABLE Tiene
(
	Nro int, 
	CodArt int,	
	--FOREIGN KEY (Nro) references Almacen(Nro),
	--FOREIGN KEY (CodArt) references Articulo(CodArt)
)
CREATE TABLE Compuesto_Por
(
	CodArt int, 
	CodMat int,
	--FOREIGN KEY (CodMat) references Material(CodMat),
	--FOREIGN KEY (CodArt) references Articulo(CodArt)
)
CREATE TABLE Provisto_Por
(
	CodMat int, 
	CodProv int,
	--FOREIGN KEY (CodProv) references Proveedor(CodProv),
	--FOREIGN KEY (CodMat) references Material(CodMat)
)

/*DROP TABLE Almacen
DROP TABLE Articulo
DROP TABLE Material
DROP TABLE Proveedor
DROP TABLE Tiene
DROP TABLE Compuesto_Por
DROP TABLE Provisto_Por*/

INSERT INTO Almacen values
	(1, 'Juan Perez'),
	(2, 'Jose Basualdo'),
	(3, 'Rogelio Rodriguez')

INSERT INTO Articulo values
	(1, 'Sandwich JyQ', 5),
	(2, 'Pancho', 6),
	(3, 'Hamburguesa', 10),
	(4, 'Hamburguesa completa', 15)

INSERT INTO Material values
	(1, 'Pan'),
	(2, 'Jamon'),
	(3, 'Queso'),
	(4, 'Salchicha'),
	(5, 'Pan Pancho'),
	(6, 'Paty'),
	(7, 'Lechuga'),
	(8, 'Tomate')

INSERT INTO Proveedor values
	(1, 'Panader�a Carlitos', 'Carlos Calvo 1212', 'CABA'),
	(2, 'Fiambres Perez', 'San Martin 121', 'Pergamino'),
	(3, 'Almacen San Pedrito', 'San Pedrito 1244', 'CABA'),
	(4, 'Carnicer�a Boedo', 'Av. Boedo 3232', 'CABA'),
	(5, 'Verduler�a Platense', '5 3232', 'La Plata')

INSERT INTO Tiene values
--Juan Perez 
	(1, 1),
--Jose Basualdo
	(2, 1),
	(2, 2),
	(2, 3),
	(2, 4),
--Rogelio Rodriguez
	(3, 3),
	(3, 4)

INSERT INTO Compuesto_Por values
--Sandwich JyQ
	(1, 1), (1, 2), (1, 3),
--Pancho
	(2, 4), (2, 5),
--Hamburguesa
	(3, 1), (3, 6),
--Hamburguesa completa
	(4, 1), (4, 6), (4, 7), (4, 8)

INSERT INTO Provisto_Por values
--Pan
	(1, 1), (1, 3),
--Jamon
	(2, 2), (2, 3), (2, 4),
--Queso
	(3, 2), (3, 3),
--Salchicha
	(4, 3), (4, 4),
--Pan Pancho
	(5, 1), (5, 3),
--Paty
	(6, 3), (6, 4),
--Lechuga
	(7, 3), (7, 5),
--Tomate
	(8, 3), (8, 5)


SELECT * FROM Almacen
SELECT * FROM Material
SELECT * FROM Proveedor
SELECT * FROM Articulo
--SELECT * FROM Tiene
SELECT * FROM Compuesto_Por
SELECT * FROM Provisto_Por

-- 1) Listar los nombres de los proveedore de la ciudad de la PLata
SELECT Nombre
FROM Proveedor
WHERE Ciudad= 'La Plata'

-- 2) Listar los n�meros de art�culos cuyo precio sea inferior a $10.
SELECT CodArt
FROM Articulo
WHERE Precio<10

-- 3) Listar los responsables de los almacenes.
SELECT Responsable FROM Almacen

-- 4) Listar los c�digos de los materiales que provea el proveedor 3 y no los provea el proveedor 5.
SELECT CodMat
FROM Provisto_por
WHERE CodProv = 3 AND CodMat NOT IN (SELECT CodMat FROM Provisto_por WHERE CodProv=5)

-- 5) Listar los n�meros de almacenes que almacenan el art�culo 1.
SELECT Nro
FROM Tiene
WHERE CodArt = 1

-- 6) Listar los proveedores de Pergamino que se llamen P�rez
SELECT *
FROM Proveedor
WHERE Ciudad = 'Pergamino' AND Nombre LIKE '%Perez'

-- 7) Listar los almacenes que contienen los art�culos 1 y los art�culos 2 (ambos)
SELECT *
FROM Tiene
WHERE CodArt = 1 AND Nro IN (SELECT Nro FROM Tiene WHERE CodArt=2) 

-- 8) Listar los art�culos que cuesten m�s de $100 o que est�n compuestos por el material 1.
SELECT *
FROM Articulo
WHERE Precio > 100 OR CodArt IN (SELECT CodArt FROM Compuesto_por WHERE CodMat=1)

/*SELECT A.CodArt
FROM Articulo A JOIN Compuesto_por C ON A.CodArt = C.CodArt
WHERE A.Precio>100 AND C.CodMat = 1*/