USE [BD_Tarea2]
GO
/****** Object:  StoredProcedure [dbo].[Modificar_Articulo]    Script Date: 9/22/2023 8:25:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Kauffmann
--				Samuel Valverde
-- Create date: 22/09/2023
-- Description:	modifica un articulo de la tabla Artículo
-- =============================================
ALTER PROCEDURE [dbo].[Modificar_Articulo] 
	-- Add the parameters for the stored procedure here
	@inIdUsuarioActual INT
	, @inPostIP VARCHAR(100)
	, @inIdArticuloBuscado INT
	, @inIdClaseArticulo INT
	, @inCodigo VARCHAR(32)
	, @inNombre VARCHAR(125)
	, @inPrecio MONEY
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
	BEGIN TRY
		SET @outResultCode = 0;  -- no error code
		IF EXISTS(SELECT A.[id]
						, A.[IdClaseArticulo]
						, A.[Codigo]
						, A.[Nombre]
						, A.[Precio]
					FROM dbo.Articulo A 
					WHERE ((Codigo = @inCodigo and id <> @inIdArticuloBuscado) or (Nombre = @inNombre and id <> @inIdArticuloBuscado)) and A.[EsActivo] = 1)
		BEGIN
			SELECT @idArticulo = A.[id]
				, @idCAAnterior = A.[IdClaseArticulo]
				, @codigoAnterior = A.[Codigo]
				, @nombreAnterior = A.[Nombre]
				, @precioAnterior = A.[Precio]
			FROM dbo.Articulo A 
			WHERE id = @inIdArticuloBuscado and A.[EsActivo] = 1;
			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			'{"TipoAccion": "Modificación de artículo no exitosa", 
			"Descripcion": "id: '+CONVERT(VARCHAR, @idArticulo)+'", "id clase artículo anterior: '+CONVERT(VARCHAR, @idCAAnterior)+'", "código anterior: '+@codigoAnterior+'", "nombre anterior: '+@nombreAnterior+'", "precio anterior: '+CONVERT(VARCHAR, @precioAnterior)
			+'", "id clase artículo nuevo: '+CONVERT(VARCHAR, @inIdClaseArticulo)+'", "código nuevo: '+@inCodigo+'", "nombre nuevo: '+@inNombre+'", "precio nuevo: '+CONVERT(VARCHAR, @inPrecio)
			+'", "descripción del error: '+ERROR_MESSAGE()+'"}');
		END
		ELSE
		BEGIN
			SELECT @idArticulo = A.[id]
					, @idCAAnterior = A.[IdClaseArticulo]
					, @codigoAnterior = A.[Codigo]
					, @nombreAnterior = A.[Nombre]
					, @precioAnterior = A.[Precio]
			FROM dbo.Articulo A 
			WHERE id = @inIdArticuloBuscado and A.[EsActivo] = 1;

			BEGIN TRANSACTION tUpdateArticulo 
				UPDATE dbo.Articulo
				SET    IdClaseArticulo = @inIdClaseArticulo
						, Codigo = @inCodigo
						, Nombre = @inNombre
						, Precio = @inPrecio
				WHERE id = @inIdArticuloBuscado and EsActivo = 1;
				INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
				VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
				'{"TipoAccion": "Modificación de artículo exitosa", 
				"Descripcion": "id: '+CONVERT(VARCHAR, @idArticulo)+'", "id clase artículo anterior: '+CONVERT(VARCHAR, @idCAAnterior)+'", "código anterior: '+@codigoAnterior+'", "nombre anterior: '+@nombreAnterior+'", "precio anterior: '+CONVERT(VARCHAR, @precioAnterior)
				+'", "id clase artículo nuevo: '+CONVERT(VARCHAR, @inIdClaseArticulo)+'", "código nuevo: '+@inCodigo+'", "nombre nuevo: '+@inNombre+'", "precio nuevo: '+CONVERT(VARCHAR, @inPrecio)+'"}');
			COMMIT TRANSACTION tUpdateArticulo 
		END
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0  -- error sucedio dentro de la transaccion
		BEGIN
			ROLLBACK TRANSACTION tUpdateArticulo; -- se deshacen los cambios realizados
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
		SET @outResultCode = 50011;  -- código error en la modificación de artículo
	END CATCH
	

	
END
