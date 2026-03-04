-- ============================================================
-- Bases de Datos 1 — Guia de Ejercicios
-- 01_almacen_articulo.sql
-- Modelo: Almacen, Articulo, Material, Proveedor
-- 25 ejercicios de consultas SELECT
-- ============================================================

--GUIA DE EJERCICIOS (1)

CREATE DATABASE EjGuia;

USE EjGuia;

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
SELECT * FROM Tiene
SELECT * FROM Compuesto_Por
SELECT * FROM Provisto_Por

/* 1. Listar los nombres de los proveedores de la ciudad de La Plata. */
SELECT Nombre
FROM Proveedor
WHERE Ciudad = 'La Plata'

/* 2. Listar los n�meros de art�culos cuyo precio sea inferior a $10 */
SELECT a.CodArt
FROM Articulo a
WHERE Precio <10

/* 3. Listar los responsables de los almacenes. */
SELECT a.Responsable
FROM Almacen a

/* 4. Listar los c�digos de los materiales que provea el proveedor 2 y no los provea el proveedor 4. */
SELECT pr.*
FROM Provisto_Por pr
WHERE pr.CodProv = 2 AND pr.CodMat NOT IN
										(SELECT pr.CodMat
										FROM Provisto_Por pr
										WHERE pr.CodProv = 4)

/* 5. Listar los n�meros de almacenes que almacenan el art�culo 3. */
SELECT t.Nro
FROM Tiene t
WHERE T.CodArt = 3

/* 6. Listar los proveedores de Pergamino que se llamen P�rez. */
SELECT P.*
FROM Proveedor P
WHERE p.Ciudad = 'Pergamino' AND p.Nombre LIKE '% Perez'

/* 7. Listar los almacenes que contienen los art�culos 3 y los art�culos 2 (ambos). */
SELECT t.*
FROM Tiene t
WHERE T.CodArt = 3 AND t.Nro IN (
								SELECT t.Nro
								FROM Tiene t
								WHERE t.CodArt = 2)

/* 8. Listar los art�culos que cuesten m�s o igual a $10 o que est�n compuestos por el material 4 */
SELECT Distinct a.CodArt
FROM Articulo a JOIN Compuesto_Por c ON a.CodArt = c.CodArt
WHERE A.Precio >=10 OR c.CodMat = 4

/* 9. Listar los materiales, c�digo y descripci�n, provistos por proveedores de la ciudad de Pergamino. */SELECT DistInct(p.CodMat) , m.Descrip FROM Provisto_Por p JOIN Material m ON p.CodMat = m.CodMatWHERE P.CodProv IN (					SELECT pr.CodProv					FROM Proveedor PR					WHERE pr.Ciudad = 'Pergamino')/* 10. Listar el c�digo, descripci�n y precio de los art�culos que se almacenan en 3. */SELECT Distinct (ar.CodArt), ar.Descrip, ar.PrecioFROM Articulo ar JOIN Tiene T on AR.CodArt = T.CodArtWHERE t.Nro = 3 /* 11. Listar la descripci�n de los materiales que componen el art�culo 1. */SELECT m.CodMat , m.DescripFROM Material M JOIN Compuesto_Por c ON m.CodMat = c.CodMatWHERE c.CodArt = 1/* 12. Listar los nombres de los proveedores que proveen los materiales al almac�n que Juan Perez tiene a su cargo. */-- Almacen que Juan Perez tiene a su cargaSELECT a.NroFROM Almacen aWHERE a.Responsable = 'Juan Perez'SELECT p.NombreFROM Proveedor p /* 13. Listar c�digos y descripciones de los art�culos compuestos por al menos un material provisto por el proveedor Fiambres Perez. */SELECT*FROM Articulo arWHERE ar.CodArt IN (SELECT Distinct c.CodArt					FROM Compuesto_Por c					WHERE c.CodMat IN (SELECT CodMat										FROM Provisto_Por										WHERE CodProv IN (SELECT p.CodProv														FROM Proveedor p														WHERE p.Nombre = 'Fiambres Perez')))-- articulos compuestos por al menos uno de esos materialesSELECT Distinct c.CodArtFROM Compuesto_Por cWHERE c.CodMat IN (SELECT CodMatFROM Provisto_PorWHERE CodProv IN (SELECT p.CodProv				FROM Proveedor p				WHERE p.Nombre = 'Fiambres Perez'))-- materiales provistos por el proveedor Fiambres PerezSELECT CodMatFROM Provisto_PorWHERE CodProv IN (SELECT p.CodProv				FROM Proveedor p				WHERE p.Nombre = 'Fiambres Perez')--codprov de Fiambres PerezSELECT p.CodProvFROM Proveedor pWHERE p.Nombre = 'Fiambres Perez'/* 14. Hallar los c�digos y nombres de los proveedores que proveen al menos un material que se usa en alg�n art�culo cuyo precio es mayor a $15. */SELECT DistInct p.CodProv, prov.NombreFROM Provisto_Por p JOIN Proveedor prov ON p.CodProv = prov.CodProvWHERE p.CodMat IN (SELECT DistInct c.CodMat					FROM Compuesto_Por c					WHERE c.CodArt IN (SELECT a.CodArt									FROM Articulo A									WHERE a.Precio<15))-- materiales que se usa en alg�n art�culo cuyo precio es mayor a $15SELECT DistInct c.CodMatFROM Compuesto_Por cWHERE c.CodArt IN (SELECT a.CodArt				FROM Articulo A				WHERE a.Precio<15)-- articulos cuyo precio es menor a $15SELECT a.CodArtFROM Articulo AWHERE a.Precio<15--SELECT * FROM Almacen
SELECT * FROM Material
SELECT * FROM Proveedor
SELECT * FROM Articulo
SELECT * FROM Tiene
SELECT * FROM Compuesto_Por
SELECT * FROM Provisto_Por order by CodProvINSERT INTO Provisto_Por values ('7','3')UPDATE Provisto_Por SET codProv=5 WHERE CodMat = 7INSERT INTO Compuesto_Por VALUES ('4','2')DELETE FROM Compuesto_Por WHERE CodArt = 4 AND CodMat = 2--/* 15. Listar los n�meros de almacenes que tienen todos los art�culos que incluyen el material 1. */CREATE VIEW NroAlmacenesMaterial ASSELECT * FROM Tiene tWHERE t.CodArt IN (SELECT c.CodArt					FROM Compuesto_Por c					WHERE c.CodMat =  1)SELECT n.Nro, COUNT(n.codart) as cantidadFROM NroAlmacenesMaterial nGROUP BY n.NroHAVING Count(n.CodArt) IN ( SELECT Count(c.CodArt)								FROM Compuesto_Por c								WHERE c.CodMat =  1 )--articulos que incluyen el material 1SELECT c.CodArtFROM Compuesto_Por cWHERE c.CodMat =  1/* 16. Listar los proveedores de Capital Federal que sean �nicos proveedores de alg�n material. */SELECT *FROM Proveedor pWHERE p.Ciudad = 'CABA' AND p.CodProv IN (SELECT p.CodProv											FROM Proveedor prov JOIN Provisto_Por p ON prov.CodProv = p.CodProv											WHERE p.CodMat IN (SELECT p.CodMat																FROM Provisto_Por p																GROUP BY p.CodMat																HAVING count (p.codProv) = 1))--unicos proveedoresSELECT p.CodProvFROM Proveedor prov JOIN Provisto_Por p ON prov.CodProv = p.CodProvWHERE p.CodMat IN (SELECT p.CodMat					FROM Provisto_Por p					GROUP BY p.CodMat					HAVING count (p.codProv) = 1)--materiales con unico proveedorSELECT p.CodMat, count (p.codProv)FROM Provisto_Por pGROUP BY p.CodMatHAVING count (p.codProv) = 1/* 17. Listar el/los art�culo/s de mayor precio. */SELECT *FROM Articulo aWHERE a.Precio IN (SELECT MAX(a.precio)					FROM Articulo a)/* 18. Listar el/los art�culo/s de menor precio. */SELECT *FROM Articulo aWHERE a.Precio IN (SELECT Min(a.precio)					FROM Articulo a)/* 19. Listar el promedio de precios de los art�culos en cada almac�n. */SELECT AVG(a.precio)FROM ARTICULO aSELECT t.Nro, AVG(a.precio) as PromedioFROM Tiene t JOIN Articulo a ON t.CodArt = a.CodArtGROUP BY t.Nro /* 20. Listar los almacenes que almacenan la mayor cantidad de art�culos. */CREATE VIEW AlmacenArticulo ASSELECT t.Nro, count (t.codart) as cantidadFROM Tiene TGROUP BY T.NroSELECT *FROM AlmacenArticulo AWHERE A.cantidad in (SELECT MAX(cantidad) 				FROM AlmacenArticulo )/* 21. Listar los art�culos compuestos mas de 2 materiales. */SELECT c.CodArt, count (c.CodMat) as materialesFROM Compuesto_Por cGROUP BY c.CodArtHAVING count (c.CodMat) > 2/* 22. Listar los art�culos compuestos por exactamente 2 materiales. */ SELECT c.CodArt, count (c.CodMat) as materialesFROM Compuesto_Por cGROUP BY c.CodArtHAVING count (c.CodMat) = 2/* 23. Listar los art�culos que est�n compuestos con hasta 3 materiales. */SELECT c.CodArt, count (c.CodMat) as materialesFROM Compuesto_Por cGROUP BY c.CodArtHAVING count (c.CodMat) <= 3/* 24. Listar los art�culos compuestos por todos los materiales. */SELECT c.CodArtFROM Compuesto_Por c GROUP BY c.CodArtHAVING count (c.CodMat) IN (SELECT COUNT(CodMat)							FROM Material)/* 25. Listar las ciudades donde existan proveedores que provean todos los materiales. */-- proveedores que provean todos los materialesSELECT p.CodProv, count(p.codmat) as MaterialesFROM Provisto_Por pGROUP BY p.CodProvHAVING count(p.codmat) IN (SELECT COUNT(CodMat)							FROM Material)-- ciudades de esos proveedoresSELECT P.CiudadFROM Proveedor Pwhere P.CodProv in (SELECT p.CodProv					FROM Provisto_Por p					GROUP BY p.CodProv					HAVING count(p.codmat) IN (SELECT COUNT(CodMat)												FROM Material)) 