USE [BD_Tarea2]
GO
/****** Object:  StoredProcedure [dbo].[Obtener_Clases_Articulos]    Script Date: 9/12/2023 1:04:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Kauffmann
--				Samuel Valverde
-- Create date: 06/09/2023
-- Description:	obtener la lista de todas las clases de artículos de la BD en orden de id.
-- =============================================
ALTER PROCEDURE [dbo].[Obtener_Clases_Articulos]  
	@outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		SET @outResultCode = 0;  -- no error code
		SELECT CA.[id]
			 , CA.[Nombre]
		FROM dbo.ClaseArticulo CA
		ORDER BY Nombre ASC;
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
		SET @outResultCode = 50002;  -- código error en la búsqueda de clases de artículos
	END CATCH
END
