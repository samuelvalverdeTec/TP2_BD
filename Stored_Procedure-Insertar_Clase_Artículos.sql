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
-- Create date: 07/09/2023
-- Description:	insertar una clase de articulos nueva en la tabla ClaseArtículo
-- =============================================
ALTER PROCEDURE [dbo].[Insertar_Clase_Articulo] 
	-- Add the parameters for the stored procedure here
	@inNombre VARCHAR(125)
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		IF EXISTS(SELECT CA.[id]
				 , CA.[Nombre]
				 FROM dbo.ClaseArticulo CA 
				 WHERE Nombre = @inNombre)
		BEGIN
			SET @outResultCode = 50005;  -- ERROR: la clase de articulo ya existía
		END
		ELSE
		BEGIN
			SET @outResultCode = 0;  -- no error code
			INSERT INTO dbo.ClaseArticulo (Nombre) 
			VALUES (@inNombre); 
			-- si el articulo no existe inserta uno nuevo con los parametros
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
		SET @outResultCode = 50006;  -- código error en la inserción de clase de artículos
	END CATCH
	

	
END
