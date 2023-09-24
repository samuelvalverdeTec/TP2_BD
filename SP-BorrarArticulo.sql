USE [BD_Tarea2]
GO
/****** Object:  StoredProcedure [dbo].[Insertar_Clase_Articulo]    Script Date: 9/7/2023 12:04:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Kauffmann
--				Samuel Valverde
-- Create date: 23/09/2023
-- Description:	Borrar un articulo de la tabla Articulo
-- =============================================
CREATE PROCEDURE [dbo].[BorrarArticulo] 
	-- Add the parameters for the stored procedure here
	@inNombre VARCHAR(125)
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		IF EXISTS(SELECT A.[id]
				 , A.[Nombre]
				 FROM dbo.Articulo A)
			
		BEGIN
			UPDATE dbo.Articulo
				SET Articulo.[EsActivo] = 0	-- Queda el articulo inactivo
				WHERE Articulo.[Nombre] = @inNombre
			SET @outResultCode = 0;  -- No hay error
		END
		ELSE
		BEGIN
			SET @outResultCode = 50007;  -- ERROR: no existía el articulo
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
		SET @outResultCode = 500077;  -- código error en el borrado de artículo
	END CATCH
	
END
