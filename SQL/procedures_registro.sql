
CREATE PROCEDURE expPlaca (
	@numeroPlaca varchar(16),
	@estado varchar(32),
	@actual bit,
	@fechaOtorgacion date,
	@rfc char(13),
	@noseriemotor char(17)
)
AS
BEGIN
	
END;
GO


CREATE PROCEDURE expLicencia(
	@tipo char(1),
	@vigencia tinyint,
	@vencimiento date,
	@rfc char(13)
)
AS
BEGIN
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


CREATE PROCEDURE expTarjeta (
	@vigencia tinyint,
	@fechaVencimiento date,
	@numeroPlaca varchar(16),
	@rfc char(13)
)
AS
BEGIN
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

CREATE PROCEDURE expTarjeta (
	@vigencia tinyint,
	@fechaVencimiento date,
	@numeroPlaca varchar(16),
	@rfc char(13)
)
AS
BEGIN
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
