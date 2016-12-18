
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
