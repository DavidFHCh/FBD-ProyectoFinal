/* Consultas para la base de datos y reportes. */

--1. Calle donde se cometen la mayor cantidad de infracciones
--(Multas levantadas por Agentes solamente).
CREATE PROCEDURE c1
AS
BEGIN
	SELECT calle FROM (
		SELECT calle, count(numexpediente) noinfracciones 
		FROM MultaAgente
		GROUP BY calle) a
	where noinfracciones = (
		SELECT max(nos) 
		FROM (
			SELECT calle, count(numexpediente) nos 
			FROM MultaAgente
			GROUP BY calle) b);
END;
GO

--2. Cantidad de cada tipo de vehículo registrados.
CREATE PROCEDURE c2
AS
BEGIN
	SELECT m.tipo, count(noSerieMotor) cantidad FROM 
	Auto a JOIN Modelo m ON a.modelo = m.modelo
	GROUP BY m.tipo;
END;
GO

--3. Información sobre las licencias suspendidas de alguna colonia
--cuyo nombre empiece con A.
CREATE PROCEDURE c3
AS
BEGIN
	SELECT l.* 
	FROM Licencia l JOIN Persona p 
	ON l.RFC = p.RFC
	where fechaSusp is not null
	AND p.colonia like 'a%';
END;
GO

--4. Agente que más multas ha levantado.
CREATE PROCEDURE c4
AS
BEGIN	
	SELECT at.*
	FROM (
		SELECT numRegistroPersonal, count(numexpediente) noinfracciones 
		FROM MultaAgente
		GROUP BY numRegistroPersonal) a
		JOIN AgenteTransito at ON a.numRegistroPersonal = at.numRegistroPersonal
	where noinfracciones = (
		SELECT max(nos) 
		FROM (
			SELECT numRegistroPersonal, count(numexpediente) nos 
			FROM MultaAgente
			GROUP BY numRegistroPersonal) b);
END;
GO

--5. Los 3 modelos más populares de auto registrados
CREATE PROCEDURE c5
AS
BEGIN
	SELECT top 3 marca, modelo, count(noSerieMotor) cantidad
	FROM Auto
	GROUP BY marca, modelo
	ORDER BY cantidad desc;
END;
GO

--6. Información de los autos que sean propiedad de gente cuyo apellido
--paterno sea López (o Lopez) (los he visto sin acento).
CREATE PROCEDURE c6
AS
BEGIN
	SELECT (p.nombres + ' ' + p.apaterno + ' ' + p.amaterno) as [Propietario],
		(a.marca + ' ' + a.modelo) as [Auto],
		a.noseriemotor as [Número de serie],
		m.tipo as [Tipo de auto],
		m.capTanque as [Capacidad de tanque (Lt)],
		m.espEquipaje as [Espacio de equipaje (m^3)],
		m.pasajeros as [Pasajeros],
		m.cilindros as [No. de Cilindros],
		m.litros as [Litros de motor],
		a.transmisiON as [Transmisión],
		a.color as [Color],
		a.lugarFabricaciON as [Lugar de fabricación]
	FROM ((propiedadde pd JOIN persona p
		ON pd.actual = 1 AND pd.rfc = p.rfc
		AND p.apaterno like 'L_pez') JOIN auto a
		ON pd.noseriemotor = a.noseriemotor) JOIN modelo m
		ON a.modelo = m.modelo;
END;
GO

--7. Cantidad de autos en cada estado del domicilio del propietario con placas de otro estado.
CREATE PROCEDURE c7
AS
BEGIN
	SELECT p.estado as [Estado del propietario],
		count(*) as [No. de Autos]
	FROM (persona p JOIN propiedadde pd
		ON p.rfc = pd.rfc
		AND pd.actual = 1) JOIN placa pl
		ON pd.noseriemotor = pl.noseriemotor
		AND pl.actual = 1
	where pl.estado <> p.estado
	GROUP BY p.estado;
END;
GO

--8. Todos los agentes de tránsito que hayan recibido una multa de un agente que siga trabajando.
CREATE PROCEDURE c8
AS
BEGIN
	declare @s table(
		rfc varchar(255)
	);
	insert into @s (rfc)
	SELECT distinct l.rfc
	FROM licencia l JOIN multaagente ma
		ON ma.numlicencia = l.numlicencia
	where ma.numregistropersonal is not null;

	SELECT ag.numregistropersonal as [No. de registro personal],
		(p.nombres + ' ' + p.apaterno + ' ' + p.amaterno) as [Nombre Agente]
	FROM agentetransito ag JOIN persona p
		ON p.rfc = ag.rfc
	where p.rfc IN (SELECT * FROM @s);
END;
GO

--9. Cada auto con placas de Nuevo León, con su historial de placas
CREATE PROCEDURE c9
AS
BEGIN
	SELECT au.noseriemotor as [No. de serie],
		p.numeroplaca as [Placa],
		p.fechaotorgaciON as [Fecha de otorgación],
		p.estado as [Estado]
	FROM Placa p JOIN Auto au
		ON p.noseriemotor = au.noseriemotor
		AND p.estado like 'nuevo le_n'
		AND p.actual = 1
	GROUP BY au.noseriemotor, p.numeroplaca, p.fechaotorgacion,p.estado
	ORDER BY au.noseriemotor, p.numeroplaca, p.fechaotorgacion;
END;
GO

--10. Cámaras con la mayor cantidad de fotomutlas
CREATE PROCEDURE c10
AS
BEGIN
	declare @s2 table (
		idcamara int,
		fotomultas int
	);
	insert into @s2 (idcamara, fotomultas)
	SELECT idcamara,
		count(*)
	FROM fotomulta
	where idcamara is not null
	GROUP BY idcamara;

	declare @r int;
	SELECT @r = max(fotomultas)
	FROM @s2;

	SELECT *
	FROM camara
	where idcamara IN (
		SELECT idcamara
		FROM @s2
		where fotomultas = @r
	);
END;
GO

--11. Cantidad de infracciones al articulo 17 en el CP 58096
CREATE PROCEDURE c11
AS
BEGIN
	SELECT articuloInfringido, COUNT(articuloInfringido) Infracciones, CP
	FROM MultaAgente
	WHERE articuloInfringido = 17 AND CP = 58096
	GROUP BY articuloInfringido, CP;
END;
GO

--12. Cantidad de propietarios de autos por estado.
CREATE PROCEDURE c12
AS
BEGIN
	SELECT Estado, COUNT(Estado) Proprietarios
	FROM Persona
	GROUP BY Estado;
END;
GO

--13. Información de las multas de todas las licencias suspendidas.
CREATE PROCEDURE c13
AS
BEGIN
	SELECT Importe, colonia, CP, calle, numero, articuloInfringido, fecha, hora
	FROM MultaAgente JOIN Licencia ON MultaAgente.numLicencia = Licencia.numLicencia
	WHERE fechaSusp IS NOT NULL;
END;
GO

--14. Color de auto más común en fotomultas.
CREATE PROCEDURE c14
AS
BEGIN
	SELECT TOP 1 Placa.numeroPlaca, COUNT(Placa.numeroPlaca) Fotografias, Auto.color
	FROM (FotoMulta JOIN Placa ON FotoMulta.numeroPlaca = Placa.numeroPlaca) JOIN 
			Auto ON Placa.noSerieMotor = Auto.noSerieMotor
	GROUP BY Auto.color, Placa.numeroPlaca
	ORDER BY Fotografias DESC;
END;
GO

--15. Cantidad de infracciones cometidas, agrupadas por mes, de toda la historia.
CREATE PROCEDURE c15
AS
BEGIN
	SELECT DATEPART(month, fecha) Mes, COUNT(numExpediente) Multas
	FROM
		((SELECT fecha, numExpediente FROM MultaAgente) UNION
		(SELECT fecha, numExpediente FROM FotoMulta)) AS s
	GROUP BY DATEPART(month, fecha);
END;
GO
