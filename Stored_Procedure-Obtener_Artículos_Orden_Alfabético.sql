USE [BD_Tarea2]
GO
/****** Object:  StoredProcedure [dbo].[Obtener_Articulos_Orden_Alfabetico]    Script Date: 9/9/2023 11:29:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Kauffmann
--				Samuel Valverde
-- Create date: 03/09/2023
-- Description:	obtener la lista de todos los articulos de la BD en orden alfabético.
--				si se recibe por parámetro algún filtro se hace la búsqueda de los artículos que contengan ese filtro
--				(se hace el filtro)
-- =============================================
ALTER PROCEDURE [dbo].[Obtener_Articulos_Orden_Alfabetico] 
	-- Add the parameters for the stored procedure here
	@inFiltroNombre VARCHAR(128)
	, @inFiltroCantidad INT
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	BEGIN TRY
		SET @outResultCode = 0;  -- no error code
		IF(@inFiltroNombre is NULL) or (@inFiltroNombre = '')
		BEGIN
			IF(@inFiltroCantidad is NULL)
			BEGIN
				SELECT A.[id]
					 , A.[IdClaseArticulo]
					 , A.[Codigo]
					 , A.[Nombre]
					 , A.[Precio]
					 , CA.[Nombre] NombreClase
				FROM dbo.Articulo A 
				INNER JOIN dbo.ClaseArticulo CA 
				ON A.[IdClaseArticulo] = CA.[id]
				ORDER BY Nombre ASC; -- mostrar la tabla completa con todos los articulos en orden alfabético
			END
			ELSE
			BEGIN
				SELECT TOP (@inFiltroCantidad)
					   A.[id]
					 , A.[IdClaseArticulo]
					 , A.[Codigo]
					 , A.[Nombre]
					 , A.[Precio]
					 , CA.[Nombre] NombreClase
				FROM dbo.Articulo A 
				INNER JOIN dbo.ClaseArticulo CA 
				ON A.[IdClaseArticulo] = CA.[id]
				ORDER BY Nombre ASC; -- mostrar la tabla completa con todos los articulos en orden alfabético
			END
		END
		ELSE
		BEGIN
			SELECT A.[id]
				 , A.[IdClaseArticulo]
				 , A.[Codigo]
				 , A.[Nombre]
				 , A.[Precio]
				 , CA.[Nombre] NombreClase
			FROM dbo.Articulo A 
			INNER JOIN dbo.ClaseArticulo CA 
			ON A.[IdClaseArticulo] = CA.[id]
			WHERE A.[Nombre] like '%'+@inFiltroNombre+'%'
			ORDER BY Nombre ASC; -- mostrar la tabla completa con todos los articulos en orden alfabético
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
		SET @outResultCode = 50001;  -- código error en la búsqueda de artículos
	END CATCH
END
