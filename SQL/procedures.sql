--1. Calle donde se cometen la mayor cantidad de infracciones (Multas Agente solamente)
CREATE PROCEDURE c1
AS
BEGIN
select calle from (
	select calle, count(numexpediente) noinfracciones 
	from MultaAgente
	group by calle) a
where noinfracciones = (
	select max(nos) 
	from (
		select calle, count(numexpediente) nos 
		from MultaAgente
		group by calle) b);
END;
GO

--2. Cantidad de cada tipo de vehículo registrado 
CREATE PROCEDURE c2
AS
BEGIN
select m.tipo, count(noSerieMotor) cantidad from 
Auto a join Modelo m on a.modelo = m.modelo
group by m.tipo;
END;
GO

--3. Información sobre las licencias suspendidas de alguna colonia que empiece con A
CREATE PROCEDURE c3
AS
BEGIN
select l.* 
from Licencia l join Persona p 
on l.RFC = p.RFC
where fechaSusp is not null
and p.colonia like 'a%';
END;
GO

--4. Agente que más multas ha dado 
CREATE PROCEDURE c4
AS
BEGIN	
select at.*
from (
	select numRegistroPersonal, count(numexpediente) noinfracciones 
	from MultaAgente
	group by numRegistroPersonal) a
	join AgenteTransito at on a.numRegistroPersonal = at.numRegistroPersonal
where noinfracciones = (
	select max(nos) 
	from (
		select numRegistroPersonal, count(numexpediente) nos 
		from MultaAgente
		group by numRegistroPersonal) b);
END;
GO

--5.Los 3 modelos más populares de auto registrados
CREATE PROCEDURE c5
AS
BEGIN
select top 3 marca, modelo, count(noSerieMotor) cantidad
from Auto
group by marca, modelo
order by cantidad desc;
END;
GO

--6. Información de los autos que sean propiedad de gente que se apellide López o Lopez (los he visto sin acento)
CREATE PROCEDURE c6
AS
BEGIN
select (p.nombres + ' ' + p.apaterno + ' ' + p.amaterno) as [Propietario],
	(a.marca + ' ' + a.modelo) as [Auto],
	a.noseriemotor as [Número de serie],
	m.tipo as [Tipo de auto],
	m.capTanque as [Capacidad de tanque (Lt)],
	m.espEquipaje as [Espacio de equipaje (m^3)],
	m.pasajeros as [Pasajeros],
	m.cilindros as [No. de Cilindros],
	m.litros as [Litros de motor],
	a.transmision as [Transmisión],
	a.color as [Color],
	a.lugarFabricacion as [Lugar de fabricación]
from ((propiedadde pd join persona p
	on pd.actual = 1 and pd.rfc = p.rfc
	and p.apaterno like 'L_pez') join auto a
	on pd.noseriemotor = a.noseriemotor) join modelo m
	on a.modelo = m.modelo;
END;
GO

--7. Cantidad de autos en cada estado del domicilio del propietario con placas de otro estado
CREATE PROCEDURE c7
AS
BEGIN
select p.estado as [Estado del propietario],
	count(*) as [No. de Autos]
from (persona p join propiedadde pd
	on p.rfc = pd.rfc
	and pd.actual = 1) join placa pl
	on pd.noseriemotor = pl.noseriemotor
	and pl.actual = 1
where pl.estado <> p.estado
group by p.estado;
END;
GO

--8. Todos los agentes de tránsito que hayan recibido una multa de un agente que siga trabajando
CREATE PROCEDURE c8
AS
BEGIN
declare @s table(
	rfc varchar(255)
);
insert into @s (rfc)
select distinct l.rfc
from licencia l join multaagente ma
	on ma.numlicencia = l.numlicencia
where ma.numregistropersonal is not null;

select ag.numregistropersonal as [No. de registro personal],
	(p.nombres + ' ' + p.apaterno + ' ' + p.amaterno) as [Nombre Agente]
from agentetransito ag join persona p
	on p.rfc = ag.rfc
where p.rfc in (select * from @s);
END;
GO

--9. Cada auto con placas de Nuevo León, con su historial de placas
CREATE PROCEDURE c9
AS
BEGIN
select au.noseriemotor as [No. de serie],
	p.numeroplaca as [Placa],
	p.fechaotorgacion as [Fecha de otorgación],
	p.estado as [Estado]
from Placa p join Auto au
	on p.noseriemotor = au.noseriemotor
	and p.estado like 'nuevo le_n'
	and p.actual = 1
group by au.noseriemotor, p.numeroplaca, p.fechaotorgacion,p.estado
order by au.noseriemotor, p.numeroplaca, p.fechaotorgacion;
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
select idcamara,
	count(*)
from fotomulta
where idcamara is not null
group by idcamara;

declare @r int;
select @r = max(fotomultas)
from @s2;

select *
from camara
where idcamara in (
	select idcamara
	from @s2
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

--12. Cantidad de propietarios de autos por estado
CREATE PROCEDURE c12
AS
BEGIN
SELECT Estado, COUNT(Estado) Proprietarios
FROM Persona
GROUP BY Estado;
END;
GO

--13. Información de las multas de todas las licencias suspendidas
CREATE PROCEDURE c13
AS
BEGIN
SELECT Importe, colonia, CP, calle, numero, articuloInfringido, fecha, hora
FROM MultaAgente JOIN Licencia ON MultaAgente.numLicencia = Licencia.numLicencia
WHERE fechaSusp IS NOT NULL
END;
GO

--14. Color del auto con la placa mas fotografiada
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

--15. Cantidad de infracciones cometidas, agrupada por mes
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
