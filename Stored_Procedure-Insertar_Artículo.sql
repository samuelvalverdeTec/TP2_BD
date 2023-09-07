USE [BD_Tarea2]
GO
/****** Object:  StoredProcedure [dbo].[Insertar_Articulo]    Script Date: 9/7/2023 11:58:26 AM ******/
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
	@inIdClaseArticulo INT
	, @inCodigo VARCHAR(32)
	, @inNombre VARCHAR(125)
	, @inPrecio MONEY
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	BEGIN TRY
		IF EXISTS(SELECT A.[id]
				 , A.[IdClaseArticulo]
				 , A.[Codigo]
				 , A.[Nombre]
				 , A.[Precio] 
				 FROM dbo.Articulo A 
				 WHERE Nombre = @inNombre)
		BEGIN
			SET @outResultCode = 50003;  -- ERROR: el articulo ya existia
		END
		ELSE
		BEGIN
			SET @outResultCode = 0;  -- no error code
			INSERT INTO dbo.Articulo (IdClaseArticulo, Codigo, Nombre, Precio) 
			VALUES (@inIdClaseArticulo, @inCodigo, @inNombre, @inPrecio); 
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
		SET @outResultCode = 50004;  -- código error en la inserción de artículos
	END CATCH
	

	
END
