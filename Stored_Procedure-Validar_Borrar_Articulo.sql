USE [BD_Tarea2]
GO
/****** Object:  StoredProcedure [dbo].[Validar_Borrar_Articulo]    Script Date: 9/22/2023 8:25:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Kauffmann
--				Samuel Valverde
-- Create date: 22/09/2023
-- Description:	valida que un articulo de la tabla Artículo exista para poder borrarlo
-- =============================================
ALTER PROCEDURE [dbo].[Validar_Borrar_Articulo] 
	-- Add the parameters for the stored procedure here
	@inIdUsuarioActual INT
	, @inPostIP VARCHAR(100)
	, @inCodigo VARCHAR(32)
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	BEGIN TRY
		IF EXISTS(SELECT A.[id]
					, A.[IdClaseArticulo]
					, A.[Codigo]
					, A.[Nombre]
					, A.[Precio] 
					FROM dbo.Articulo A 
					WHERE Codigo = @inCodigo and A.[EsActivo] = 1)
		BEGIN
			SET @outResultCode = 0;  -- no error code

			SELECT A.[id]
					, A.[IdClaseArticulo]
					, A.[Codigo]
					, A.[Nombre]
					, A.[Precio] 
					, CA.[Nombre] NombreClase
			FROM dbo.Articulo A 
			INNER JOIN dbo.ClaseArticulo CA 
			ON A.[IdClaseArticulo] = CA.[id]
			WHERE Codigo = @inCodigo and A.[EsActivo] = 1
			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			'{"TipoAccion": "Intento de borrar artículo", 
			"Descripcion": "'+@inCodigo+'", "artículo existe"}');
		END
		ELSE
		BEGIN
			SET @outResultCode = 50012;  -- ERROR articulo no existe
			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), 
			'{"TipoAccion": "Intento de borrar artículo", 
			"Descripcion": "'+@inCodigo+'", "artículo no existe"}');
		END
	END TRY
	BEGIN CATCH
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
		SET @outResultCode = 50013;  -- código error en la validacion de modificar artículo
	END CATCH
	

	
END
