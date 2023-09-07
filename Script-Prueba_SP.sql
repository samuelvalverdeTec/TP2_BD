INSERT INTO dbo.ClaseArticulo (Nombre)
VALUES ('Materiales');

--SELECT * FROM dbo.ClaseArticulo;

DECLARE @IdCA INT;
SELECT @IdCA = id FROM dbo.ClaseArticulo WHERE Nombre = 'Materiales';
INSERT INTO dbo.Articulo (IdClaseArticulo,Codigo,Nombre,Precio)
VALUES (@IdCA,'123','Madera','3000');

--SELECT * FROM dbo.Articulo;

DECLARE @codigoError1 INT
EXECUTE Obtener_Articulos_Orden_Alfabetico '',@codigoError1 OUTPUT;

DECLARE @codigoError2 INT
EXECUTE Obtener_Clases_Articulos @codigoError2 OUTPUT;