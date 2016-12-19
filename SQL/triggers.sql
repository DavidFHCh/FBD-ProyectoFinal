/* Triggers para la base de datos. */

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
--Evita levantar otra multa sobre una licencia que ya tenía doce puntos,
--es decir, que ya fue cancelada.
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
	--última multa agregada
	SET @mul = IDENT_CURRENT('MultaAgente');
	SELECT @lic = numLicencia
	FROM MultaAgente
	WHERE numExpediente = @mul;
	IF dbo.puntos(@lic) >= 12
	BEGIN
		RAISERROR ('La licencia fue cancelada con anterioridad',16,1);
		ROLLBACK TRANSACTION;
	END;
END;
GO
