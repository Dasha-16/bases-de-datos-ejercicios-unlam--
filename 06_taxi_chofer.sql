-- ============================================================
-- Bases de Datos 1 — Guia de Ejercicios
-- 06_taxi_chofer.sql
-- Modelo: Auto, Chofer, Viaje, Cliente
-- Consultas con fechas, agregaciones y subconsultas
-- ============================================================

--GUIA DE EJERCICIOS (7)

--Resuelto ult clase 1-2 y mitad del 3 

USE EjGuia;

CREATE TABLE Auto (
	Matricula int primary key,
	modelo varchar(50),
	a�o int
)


CREATE TABLE Chofer(
	NroLic int primary key,
	Nombre varchar(50),
	Apeliido varchar(50),
	Fecha_Ing date,
	Telefono int
)

CREATE TABLE Viaje(
	FechaHora_Ini datetime,
	FechaHora_Fin datetime,
	NroLic int,
	cliente varchar(50),
	matricula int,
	kmTotales decimal(12,2),
	esperaTotal decimal(12,2),
	costoEspera decimal(12,2),
	costoKms decimal(12,2)
)

CREATE TABLE Cliente (
	NroCliente int primary key,
	Calle varchar(30),
	Nro int,
	Localidad varchar(30)
)

INSERT INTO Auto Values
	('1', 'Etios', '2020'),
	('2', 'Hilux', '2022'),
	('3', 'Kwid', '2020'),
	('4', 'Gol', '2000'),
	('5', 'Sandero', '2018'),
	('6','Corsa','1990'),
	('7','Onix','2000')

INSERT INTO Chofer VALUES
	('11','Dasha','Apollaro','1-25-2023','46232422'),
	('22','Agustin','Morales','5-2-2020','46789514'),
	('33','Florencia','Clerici','10-10-2018','46247877'),
	('44','Dina','Dadamo','8-28-2003','46614020')

INSERT INTO Viaje VALUES
	('2023-6-20 19:50', '2023-6-20 20:50', '11', '1', '1', '10','1', '10', '50'),
	('2023-6-20 15:50', '2023-6-20 16:30', '11', '2', '1', '100','1', '10', '50'),
	('2020-2-20 19:50', '2020-2-20 20:50', '11', '1', '2', '10','1', '10', '50'),
	('2023-2-20 19:50', '2023-2-20 20:50', '22', '3', '1', '10','1', '10', '50'),
	('2023-2-20 19:50', '2023-2-20 20:50', '33', '3', '1', '10','1', '10', '50'),
	('2023-5-20 19:50', '2023-5-20 22:50', '44', '3', '1', '10','1', '10', '50'),
	('2020-5-20 19:50', '2020-5-20 22:50', '44', '3', '2', '10','1', '10', '50'),
	('2023-3-20 19:50', '2023-5-20 20:50', '44', '3', '3', '10','1', '10', '50'),
	('2023-2-20 19:50', '2023-5-20 19:30', '44', '3', '4', '10','1', '10', '50'),
	('2023-1-20 19:50', '2023-5-20 22:30', '44', '3', '5', '10','1', '10', '50'),
	('2023-1-20 19:50', '2023-5-20 21:50', '44', '3', '6', '10','1', '10', '50'),
	('2022-5-20 19:50', '2023-5-20 20:50', '44', '3', '7', '10','1', '10', '50'),
	('2023-5-25 15:00', '2023-5-25 15:15', '44', '3', '7', '10','1', '10', '50')

INSERT INTO Cliente VALUES
	('1','Olivera','1060','Ituzaingo'),
	('2','Vucetich','2894','Castelar'),
	('3','Rivadavia','1100','Padua')

SELECT * FROM auto
DROP TABLE Viaje

/* 1. Indique cuales son los autos con mayor cantidad de kil�metros realizados en el �ltimo mes  */

--mayor cantidad de km realizados en el ultimo mes
SELECT MAX(v.kmTotales)
FROM Viaje v
WHERE v.FechaHora_Fin between DATEADD(mm, -1, GETDATE()) and getdate()

--los autos que hicieron esos km 
SELECT v.matricula
FROM viaje v
WHERE v.kmTotales = (SELECT MAX(v.kmTotales)
						FROM Viaje v
						WHERE v.FechaHora_Fin between DATEADD(mm, -1, GETDATE()) and getdate())
	AND
	v.FechaHora_Fin between DATEADD(mm, -1, GETDATE()) and getdate()

/* 2. Indique los clientes que m�s viajes hayan realizado con el mismo chofer */

--Cantidad de viajes por cliente y chofer
CREATE VIEW ViajesPorCliente as
SELECT v.cliente, v.NroLic, count (*) as Cantidad
FROM viaje v
GROUP BY v.cliente, v.NroLic

SELECT cliente
FROM ViajesPorCliente
WHERE Cantidad = (select MAX(cantidad) FROM ViajesPorCliente)

/* 3. Indique el o los clientes con mayor cantidad de viajes en este a�o. */
-- cantidad de viajes por clientes este a�o
CREATE VIEW CantViajesClientes as
SELECT v.cliente, count(*) as CantidadViajes
FROM Viaje v
WHERE v.fechahora_ini between DATEADD(yy,-1,getdate()) AND getdate()
GROUP BY v.cliente

-- FORMA A
SELECT *
FROM CantViajesClientes
WHERE CantidadViajes = (SELECT MAX(CantidadViajes) 
						FROM CantViajesClientes)

--FORMA B
--mayor cantidad de viajes
SELECT MAX (cant)
FROM (SELECT v.cliente, count(*) AS CANT
		FROM Viaje v
		WHERE v.fechahora_ini between DATEADD(yy,-1,getdate()) AND getdate()
		GROUP BY v.cliente
	) CantViajes

SELECT v.cliente, count(*) as CantidadViajes
FROM Viaje v
WHERE v.fechahora_ini between DATEADD(yy,-1,getdate()) AND getdate()
GROUP BY v.cliente
HAVING count(*) = (SELECT MAX (cant)
					FROM (SELECT v.cliente, count(*) AS CANT
							FROM Viaje v
							WHERE v.fechahora_ini between DATEADD(yy,-1,getdate()) AND getdate()
							GROUP BY v.cliente
						) CantViajes)

/* 4. Obtenga nombre y apellido de los choferes que no manejaron todos los veh�culos que disponemos. */

--total de vehiculos
SELECT count(*) FROM Auto  

-- chofereres que no manejaron todos los vehiculos
SELECT v.NroLic
FROM VIAJE v
GROUP BY v.NroLic
HAVING COUNT(Distinct(V.matricula)) < (SELECT count(*) FROM Auto )

SELECT *
FROM Chofer c 
WHERE c.NroLic IN (SELECT v.NroLic
					FROM VIAJE v
					GROUP BY v.NroLic
					HAVING COUNT(Distinct(V.matricula)) < (SELECT count(*) FROM Auto ))


/* 5. Obtenga el nombre y apellido de los clientes que hayan viajado en todos nuestros autos. */
--FORMA A
SELECT v.cliente
FROM VIAJE v JOIN Cliente c ON v.cliente = c.NroCliente
GROUP BY v.cliente
HAVING COUNT(Distinct(V.matricula)) = (SELECT count(*) FROM Auto )

--FORMA B
SELECT *
FROM Cliente c
WHERE NOT EXISTS (
					SELECT 1
					FROM Auto a
					WHERE NOT EXISTS (
										SELECT 1
										FROM Viaje V
										WHERE c.nroCliente = v.cliente AND a.matricula = v.matricula
									)
				)

/* 6. Queremos conocer el tiempo de espera promedio de los viajes de los �ltimos 2 meses */
SELECT AVG(esperaTotal)
FROM Viaje
WHERE fechaHora_Fin between DATEADD (MM,-2, GETDATE()) AND GETDATE()

/* 7. Indique los kil�metros realizados en viajes por cada auto. */
-- CASO A (Si un auto no realizo ningun viaje, no va a figurar)
--Los km que relizado cada auto
SELECT V.matricula, sum(kmTotales) kmRealizados
FROM VIAJE v
GROUP BY v.matricula

--CASO B
SELECT a.matricula, isnull(sum(kmTotales),0) kmRealizados
FROM auto a LEFT JOIN viaje v ON a.Matricula = v.matricula
GROUP BY a.matricula

/* 8. Indique el costo promedio de los viajes realizados por cada auto. */
SELECT v.matricula, AVG(esperaTotal + costoEspera) as CostoProm select *
FROM Viaje v
GROUP BY v.matricula 

/* 9. Indique el costo total de los viajes realizados por cada chofer en el �ltimo mes. */
SELECT V.NroLic, SUM(esperaTotal + costoEspera) as Costo
FROM VIAJE v
WHERE fechaHora_Fin between DATEADD (MM,-1, GETDATE()) AND GETDATE()
GROUP BY v.NroLic

/* 10. Indique la fecha inicial, el chofer y el cliente que hayan realizado el viaje m�s largo de este a�o. */
--viaje mas largo de este a�o
SELECT MAX(kmTotales)
FROM Viaje
WHERE YEAR(fechaHora_Fin) = YEAR(getdate())
--WHERE fechaHora_Fin between DATEADD (yy,-1, GETDATE()) AND GETDATE()

SELECT *
FROM Viaje
WHERE KmTotales IN (SELECT MAX(kmTotales)
					FROM Viaje
					WHERE YEAR(fechaHora_Fin) = YEAR(getdate())
					)
	AND YEAR(fechaHora_Fin) = YEAR(getdate())