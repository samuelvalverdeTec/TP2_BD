USE [BD_Tarea2]
GO
/****** Object:  StoredProcedure [dbo].[Borrar_Articulo]    Script Date: 9/22/2023 8:25:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Kauffmann
--				Samuel Valverde
-- Create date: 22/09/2023
-- Description:	borra un articulo de la tabla Artículo
-- =============================================
ALTER PROCEDURE [dbo].[Borrar_Articulo] 
	-- Add the parameters for the stored procedure here
	@inIdUsuarioActual INT
	, @inPostIP VARCHAR(100)
	, @inCodigo VARCHAR(32)
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @idArticulo INT;
	DECLARE @idCAAnterior INT;
	DECLARE @codigoAnterior VARCHAR(32);
	DECLARE @nombreAnterior VARCHAR(125);
	DECLARE @precioAnterior MONEY;
	SET NOCOUNT ON;
	SELECT @idArticulo = A.[id]
		, @idCAAnterior = A.[IdClaseArticulo]
		, @codigoAnterior = A.[Codigo]
		, @nombreAnterior = A.[Nombre]
		, @precioAnterior = A.[Precio]
	FROM dbo.Articulo A 
	WHERE Codigo = @inCodigo and A.[EsActivo] = 1;
	BEGIN TRY
		SET @outResultCode = 0;  -- no error code
		IF EXISTS(SELECT A.[id]
						, A.[IdClaseArticulo]
						, A.[Codigo]
						, A.[Nombre]
						, A.[Precio]
					FROM dbo.Articulo A 
					WHERE Codigo = @inCodigo and A.[EsActivo] = 1)
		BEGIN
			SELECT @idArticulo = A.[id]
					, @idCAAnterior = A.[IdClaseArticulo]
					, @codigoAnterior = A.[Codigo]
					, @nombreAnterior = A.[Nombre]
					, @precioAnterior = A.[Precio]
			FROM dbo.Articulo A 
			WHERE Codigo = @inCodigo and A.[EsActivo] = 1;

			BEGIN TRANSACTION tDeleteArticulo
			UPDATE dbo.Articulo
			SET    EsActivo = 0
			WHERE Codigo = @inCodigo;
			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			'{"TipoAccion": "Borrado de artículo exitosa", 
			"Descripcion": "id: '+CONVERT(VARCHAR, @idArticulo)+'", "id clase artículo: '+CONVERT(VARCHAR, @idCAAnterior)+'", "código: '+@codigoAnterior+'", "nombre: '+@nombreAnterior+'", "precio: '+CONVERT(VARCHAR, @precioAnterior)+'"}');
			COMMIT TRANSACTION tDeleteArticulo
		END
		ELSE
		BEGIN
			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			'{"TipoAccion": "Borrado de artículo no exitosa", 
			"Descripcion": "id: '+CONVERT(VARCHAR, @idArticulo)+'", "id clase artículo: '+CONVERT(VARCHAR, @idCAAnterior)+'", "código: '+@codigoAnterior+'", "nombre: '+@nombreAnterior+'", "precio: '+CONVERT(VARCHAR, @precioAnterior)
			+'", "descripción del error: '+ERROR_MESSAGE()+'"}');
		END
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0  -- error sucedio dentro de la transaccion
		BEGIN
			ROLLBACK TRANSACTION tDeleteArticulo; -- se deshacen los cambios realizados
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
		SET @outResultCode = 50014;  -- código error en la modificación de artículo
	END CATCH
	

	
END
