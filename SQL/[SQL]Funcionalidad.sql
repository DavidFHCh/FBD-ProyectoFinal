/* Funciones para la base de datos. */

/*
 * Función puntos.
 * Calcula los puntos de una licencia en base a las multas que ha recibido.
 * Recibe el número de la licencia (int) y devuelve el número de puntos (int).
 */
CREATE FUNCTION dbo.puntos (@licencia int)
RETURNS int AS
BEGIN
	declare @pts int;
	SELECT @pts = sum(i.puntos)
	FROM (Licencia l JOIN MultaAgente ma
		ON ma.numLicencia = l.numLicencia
		AND l.numLicencia = @licencia) JOIN infp i
		ON ma.articuloInfringido = i.articulo;
	IF (@pts IS NULL)
		SET @pts = -1;
	RETURN @pts;
END;
GO

/* Disparadores para la base de datos. */

--Trigger eliminarMultas.
--Evita la eliminación de multas de la base de datos.
CREATE TRIGGER eliminarMultas
ON MultaAgente
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
END;
GO

--Trigger eliminarFotoMultas.
--Evita la eliminación de fotomultas de la base de datos.
CREATE TRIGGER eliminarFotoMultas
ON FotoMulta
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
END;
GO

--Trigger suspendida.
--Cancela las licencias que suman 12 puntos y evita levantar otra multa
--sobre una licencia que ya tenía doce puntos, es decir, que ya fue cancelada.
--Si se trata de levantar una multa a una licencia cancelada, lanza un
--error y revierte la operación de inserción.
CREATE TRIGGER suspendida
ON MultaAgente
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	declare @lic int;
	declare @mul int;
	declare @fecha date;
	declare @pts int;
	--Última multa agregada
	SET @mul = IDENT_CURRENT('MultaAgente');
	SELECT @lic = numLicencia
	FROM MultaAgente
	WHERE numExpediente = @mul;
	SELECT @fecha = fechaSusp
	FROM Licencia
	WHERE numLicencia = @lic;
	SET @pts = dbo.puntos(@lic);
	--Cancelamos la licencia
	IF @fecha IS NULL AND @pts >= 12
	BEGIN
		UPDATE Licencia SET fechaSusp = GETDATE() WHERE numLicencia = @lic;
	END;
	--Si la licencia ya había sido cancelada
	ELSE IF @pts >= 12
	BEGIN
		RAISERROR ('La licencia fue cancelada con anterioridad',16,1);
		ROLLBACK TRANSACTION;
	END;
END;
GO

/* Procedimientos almacenados para la base de datos. */

/*
 * Procedimiento expPlaca para expedir placas de la CDMX.
 * Registra una nueva placa en la base de datos.
 * Se debe proporcionar el número de la nueva placa, la fecha de otorgación,
 * el RFC de la persona que
 * solicita las placas y el número de serie del auto.
 * La persona y auto deben estar registrados en la base de datos.
 */
CREATE PROCEDURE expPlaca (
	@numeroPlaca varchar(16),
	@fechaOtorgacion date,
	@rfc char(13),
	@noseriemotor char(17)
)
AS
BEGIN
	SET NOCOUNT ON;
	IF @numeroPlaca  IS NULL OR @fechaOtorgacion IS NULL OR @rfc IS NULL OR @noseriemotor IS NULL
	BEGIN
		RAISERROR('Datos insuficientes.',16,1);
	END;
	ELSE
	BEGIN
		IF EXISTS (SELECT * FROM Placa WHERE noseriemotor = @noseriemotor)
		BEGIN
			UPDATE Placa set fechaFin = @fechaOtorgacion, actual = 0
			WHERE noseriemotor = @noseriemotor AND actual = 1;
		END;
		INSERT INTO Placa (numeroPlaca, estado, actual, fechaOtorgacion, rfc, noseriemotor)
		VALUES (@numeroPlaca, 'CDMX', 1, @fechaOtorgacion, @rfc, @noseriemotor);
	END;
END;
GO

/*
 * Procedimiento expLicencia para expedir licencias de conducir.
 * Registra una nueva licencia en la base de datos.
 * Se debe proporcionar el tipo de licencia, la vigencia, la fecha de
 * vencimiento de la licencia y el RFC de la persona que la solicita.
 * La persona debe estar registrada en la base de datos.
 */
CREATE PROCEDURE expLicencia(
	@tipo char(1),
	@vigencia tinyint,
	@vencimiento date,
	@rfc char(13)
)
AS
BEGIN
	SET NOCOUNT ON;
	IF @tipo IS NULL OR @vigencia IS NULL OR @vencimiento IS NULL OR @rfc IS NULL
	BEGIN
		RAISERROR('Datos insuficientes.',16,1);
	END;
	ELSE
	BEGIN
		INSERT INTO Licencia (tipo,vigencia,vencimiento,rfc)
		VALUES (@tipo, @vigencia, @vencimiento, @rfc);
	END;
END;
GO

/*
 * Procedimiento expTarjeta para expedir tarjetas de circulación.
 * Registra una nueva tarjeta en la base de datos.
 * Se debe proporcionar  la vigencia, la fecha de vencimiento de
 * la tarjeta, el RFC de la persona que la solicita y el número de
 * placa del auto.
 * La persona y la placa deben estar registradas en la base de datos.
 */
CREATE PROCEDURE expTarjeta (
	@vigencia tinyint,
	@fechaVencimiento date,
	@numeroPlaca varchar(16),
	@rfc char(13)
)
AS
BEGIN
	SET NOCOUNT ON;
	IF @vigencia IS NULL OR @fechaVencimiento IS NULL OR @numeroPlaca IS NULL OR @rfc IS NULL
	BEGIN
		RAISERROR('Datos insuficientes.',16,1);
	END;
	ELSE
	BEGIN
		INSERT INTO TarjetaCirculacion (vigencia, fechaVencimiento, numeroPlaca, rfc)
		VALUES (@vigencia, @fechaVencimiento, @numeroPlaca, @rfc);
	END;
END;
GO

/*
 * Procedimiento regMultaAgente para registrar multas de agentes de tránsito.
 * Registra una nueva multa de agente en la base de datos.
 * Se debe proporcionar la fecha y hora, el artículo infringido, el importe,
 * dirección (calle, número, colonia, cp), el número de registro personal
 * del agente que levantó la multa, la licencia y tarjeta de circulación del auto
 * y conductor.
 * El agente, licencia y tarjeta deben estar registrados en la base de datos.
 */
CREATE PROCEDURE regMultaAgente (
	@fecha date,
	@hora time,
	@articuloInfringido tinyint,
	@importe money,
	@calle varchar(32),
	@numero varchar(8) = NULL,
	@colonia varchar(64),
	@cp char(5),
	@numRegistroPersonal varchar(64),
	@numLicencia int,
	@numTarjeta int
)
AS
BEGIN
	SET NOCOUNT ON;
	IF
	@fecha IS NULL OR
	@hora IS NULL OR
	@articuloInfringido IS NULL OR
	@importe IS NULL OR
	@calle IS NULL OR
	@numero IS NULL OR
	@colonia IS NULL OR
	@cp IS NULL OR
	@numRegistroPersonal IS NULL OR
	@numLicencia IS NULL OR
	@numTarjeta IS NULL
	BEGIN
		RAISERROR('Datos insuficientes.',16,1);
	END;
	ELSE
	BEGIN
		INSERT INTO MultaAgente (fecha, hora, articuloInfringido,
			importe, calle, numero, colonia, cp, numRegistroPersonal,
			numLicencia, numTarjeta)
		VALUES (@fecha, @hora, @articuloInfringido,
			@importe, @calle, @numero, @colonia, @cp, @numRegistroPersonal,
			@numLicencia, @numTarjeta);
	END;
END;
GO

/*
 * Procedimiento Multas para consultar multas de agentes de tránsito y fotomultas.
 * Se debe proporcionar el rfc que aparece en la licencia o las placas del auto.
 */
CREATE PROCEDURE Multas (
	@rfc char(13),
	@placa varchar(16)
)
AS
BEGIN
	IF @rfc IS NOT NULL
	BEGIN
		SELECT * FROM
		(SELECT a.numExpediente AS [Expediente],
			a.fecha AS [Fecha],
			a.hora AS [Hora],
			NULL AS [Artículo],
			NULL AS [Importe],
			NULL AS [Calle],
			NULL AS [No.],
			NULL AS [Colonia],
			NULL AS [CP],
			NULL AS [Agente],
			NULL AS [Licencia],
			NULL AS [Tarejta circulación],
			a.velocidad AS [Velocidad],
			a.color AS [Color],
			b.coordenadas AS [Coordenadas]
		FROM (FotoMulta a JOIN Placa p ON a.numeroPlaca = p.numeroPlaca AND p.rfc = @rfc AND p.actual = 1)
			JOIN Camara b ON a.idcamara = b.idcamara) FM
		
		UNION
		
		(SELECT a.numExpediente AS [Expediente],
			a.fecha AS [Fecha],
			a.hora AS [Hora],
			a.articuloInfringido AS [Artículo],
			a.importe AS [Importe],
			a.calle AS [Calle],
			a.numero AS [No.],
			a.colonia AS [Colonia],
			a.cp AS [CP],
			a.numRegistroPersonal AS [Agente],
			a.numLicencia AS [Licencia],
			a.numTarjeta AS [Tarejta circulación],
			NULL AS [Velocidad],
			NULL AS [Color],
			NULL AS [Coordenadas]
		FROM (MultaAgente a JOIN Licencia b ON a.numLicencia = b.numLicencia)
		WHERE b.rfc = @rfc) MA;
	END;
	ELSE IF @placa IS NOT NULL
	BEGIN
		(SELECT a.numExpediente AS [Expediente],
			a.fecha AS [Fecha],
			a.hora AS [Hora],
			NULL AS [Artículo],
			NULL AS [Importe],
			NULL AS [Calle],
			NULL AS [No.],
			NULL AS [Colonia],
			NULL AS [CP],
			NULL AS [Agente],
			NULL AS [Licencia],
			NULL AS [Tarejta circulación],
			a.velocidad AS [Velocidad],
			a.color AS [Color],
			b.coordenadas AS [Coordenadas]
		FROM FotoMulta a JOIN Camara b ON a.idcamara = b.idcamara
		WHERE numeroPlaca = @placa) FM
		
		UNION
		
		(SELECT a.numExpediente AS [Expediente],
			a.fecha AS [Fecha],
			a.hora AS [Hora],
			a.articuloInfringido AS [Artículo],
			a.importe AS [Importe],
			a.calle AS [Calle],
			a.numero AS [No.],
			a.colonia AS [Colonia],
			a.cp AS [CP],
			a.numRegistroPersonal AS [Agente],
			a.numLicencia AS [Licencia],
			a.numTarjeta AS [Tarejta circulación],
			NULL AS [Velocidad],
			NULL AS [Color],
			NULL AS [Coordenadas]
		FROM MultaAgente a JOIN TarjetaCirculacion b ON a.numTarjeta = b.numTarjeta
		WHERE b.numeroPlaca = @placa) MA
	END;
	ELSE
	BEGIN
		RAISERROR('Datos insuficientes.',16,1);
	END;
END;
GO
