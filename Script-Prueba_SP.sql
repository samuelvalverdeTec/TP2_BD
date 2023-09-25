INSERT INTO dbo.ClaseArticulo (Nombre)
VALUES ('Materiales');

--SELECT * FROM dbo.ClaseArticulo;

DECLARE @IdCA INT;
SELECT @IdCA = id FROM dbo.ClaseArticulo WHERE Nombre = 'Materiales';
INSERT INTO dbo.Articulo (IdClaseArticulo,Codigo,Nombre,Precio)
VALUES (@IdCA,'123','Madera','3000');

--SELECT * FROM dbo.Articulo;

DECLARE @codigoError1 INT
EXECUTE Obtener_Articulos_Orden_Alfabetico NULL,'',NULL,@codigoError1 OUTPUT;

DECLARE @codigoError2 INT
EXECUTE Obtener_Clases_Articulos @codigoError2 OUTPUT;

DECLARE @codigoError3 INT
EXECUTE Insertar_Clase_Articulo 'Herramientas', @codigoError3 OUTPUT;

DECLARE @IdCA2 INT;
SELECT @IdCA2 = id FROM dbo.ClaseArticulo WHERE Nombre = 'Herramientas';
DECLARE @codigoError4 INT
EXECUTE Insertar_Articulo @IdCA2,'223','Martillo','5000', @codigoError4 OUTPUT;

DECLARE @codigoError5 INT
EXECUTE Obtener_Articulos_Orden_Alfabetico NULL,'de',NULL,@codigoError5 OUTPUT;