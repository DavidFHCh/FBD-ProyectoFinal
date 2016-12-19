/*
 * Procedimiento expPlaca para expedir placas de la CDMX.
 * Registra una nueva placa en la base de datos.
 * Se debe proporcionar el número de la nueva placa, la fecha de otorgación
 * (de no ser proporcionada será el día actual), el RFC de la persona que
 * solicita las placas y el número de serie del auto.
 * La persona y auto deben estar registrados en la base de datos.
 */
CREATE PROCEDURE expPlaca (
	@numeroPlaca varchar(16),
	@fechaOtorgacion date = GETDATE(),
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
		IF EXISTS IN (SELECT * FROM Placa WHERE noseriemotor = @noseriemotor)
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
	fecha date = GETDATE(),
	hora time,
	articuloInfringido tinyint,
	importe money,
	calle varchar(32),
	numero varchar(8) = NULL,
	colonia varchar(64),
	cp char(5),
	numRegistroPersonal varchar(64),
	numLicencia int,
	numTarjeta int,
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
