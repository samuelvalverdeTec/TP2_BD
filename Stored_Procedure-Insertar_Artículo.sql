USE [BD_Tarea2]
GO
/****** Object:  StoredProcedure [dbo].[Insertar_Articulo]    Script Date: 9/14/2023 10:21:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Kauffmann
--				Samuel Valverde
-- Create date: 07/09/2023
-- Description:	insertar un articulo nuevo en la tabla Artículo
-- =============================================
ALTER PROCEDURE [dbo].[Insertar_Articulo] 
	-- Add the parameters for the stored procedure here
	@inIdUsuarioActual INT
	, @inPostIP VARCHAR(100)
	, @inIdClaseArticulo INT
	, @inCodigo VARCHAR(32)
	, @inNombre VARCHAR(125)
	, @inPrecio MONEY
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	DECLARE @idArticulo INT;
	SET NOCOUNT ON;
	BEGIN TRY
		IF EXISTS(SELECT A.[id]
				 , A.[IdClaseArticulo]
				 , A.[Codigo]
				 , A.[Nombre]
				 , A.[Precio] 
				 FROM dbo.Articulo A 
				 WHERE Nombre = @inNombre or Codigo = @inCodigo and A.[EsActivo] = 1)
		BEGIN
			SET @outResultCode = 50003;  -- ERROR: el articulo ya existia

			SELECT @idArticulo = A.[id]
				 , @inIdClaseArticulo = A.[IdClaseArticulo]
				 , @inCodigo = A.[Codigo]
				 , @inNombre = A.[Nombre]
				 , @inPrecio = A.[Precio]
			FROM dbo.Articulo A 
			WHERE Nombre = @inNombre or Codigo = @inCodigo and A.[EsActivo] = 1;
			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			'{"TipoAccion": "Insertar articulo no exitoso", 
			"Descripcion": "'+CONVERT(VARCHAR, @idArticulo)+'", "'+CONVERT(VARCHAR, @inIdClaseArticulo)+'", "'+@inCodigo+'", "'+@inNombre+'", "'+CONVERT(VARCHAR, @inPrecio)+'"}');
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION tInsertArticulo
				SET @outResultCode = 0;  -- no error code
				INSERT INTO dbo.Articulo (IdClaseArticulo, Codigo, Nombre, Precio) 
				VALUES (@inIdClaseArticulo, @inCodigo, @inNombre, @inPrecio); 

				SELECT @idArticulo = @@IDENTITY;
				-- si el articulo no existe inserta uno nuevo con los parametros
				INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
				VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
				'{"TipoAccion": "Insertar articulo exitoso", 
				"Descripcion": "'+CONVERT(VARCHAR, @idArticulo)+'", "'+CONVERT(VARCHAR, @inIdClaseArticulo)+'", "'+@inCodigo+'", "'+@inNombre+'", "'+CONVERT(VARCHAR, @inPrecio)+'"}');
			COMMIT TRANSACTION tInsertArticulo
		END
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0  -- error sucedio dentro de la transaccion
		BEGIN
			ROLLBACK TRANSACTION tInsertArticulo; -- se deshacen los cambios realizados
		END;

		INSERT INTO dbo.DBErrors	VALUES (
				SUSER_SNAME(),
				ERROR_NUMBER(),
				ERROR_STATE(),
				ERROR_SEVERITY(),
				ERROR_LINE(),
				ERROR_PROCEDURE(),
				ERROR_MESSAGE(),
				GETDATE()
			);
		SET @outResultCode = 50004;  -- código error en la inserción de artículos
	END CATCH
	

	
END
