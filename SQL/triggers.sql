--Evita eliminar multas de la base de datos.
CREATE TRIGGER eliminarMultas
ON MultaAgente
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
END;
GO

--Evita eliminar fotomultas de la base de datos.
CREATE TRIGGER eliminarFotoMultas
ON FotoMulta
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON;
END;
GO

--Evita levantar otra multa sobre una licencia que ya tenía doce puntos,
--es decir, que ya fue cancelada
CREATE TRIGGER suspendida
ON Licencia
AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;
	declare @lic int;
	declare @mul int;
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
