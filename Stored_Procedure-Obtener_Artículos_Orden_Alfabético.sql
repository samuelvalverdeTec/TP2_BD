USE [BD_Tarea2]
GO
/****** Object:  StoredProcedure [dbo].[Obtener_Articulos_Orden_Alfabetico]    Script Date: 9/16/2023 12:48:38 PM ******/
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
	@inIdUsuarioActual INT
	, @inAccion INT
	, @inPostIP VARCHAR(100)
	, @inFiltroIdClase INT
	, @inFiltroNombre VARCHAR(128)
	, @inFiltroCantidad INT
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;

	BEGIN TRY
		
		SET @outResultCode = 0;  -- no error code
		IF(@inFiltroIdClase is NULL) or (@inFiltroIdClase = -1)
		BEGIN
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
					WHERE A.[EsActivo] = 1
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
					WHERE A.[EsActivo] = 1
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
				and A.[EsActivo] = 1
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
			WHERE A.[IdClaseArticulo] = @inFiltroIdClase
			and A.[EsActivo] = 1
			ORDER BY Nombre ASC;
		END
		
		IF(@inAccion = 1)
		BEGIN
			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), '{"TipoAccion": "Consulta por nombre", "Descripcion": "'+ ISNULL(@inFiltroNombre,'nulo')+'"}');
		END
		ELSE IF(@inAccion = 2)
		BEGIN
			IF(@inFiltroCantidad is NULL)
			BEGIN
				INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
				VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), '{"TipoAccion": "Consulta por cantidad", "Descripcion": "nulo"}');
			END
			ELSE
			BEGIN
				
				INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
				VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), '{"TipoAccion": "Consulta por cantidad", "Descripcion": "'+ CONVERT(VARCHAR, @inFiltroCantidad)+'"}');
			END
		END
		ELSE IF(@inAccion = 3)
		BEGIN
			IF(@inFiltroIdClase is NULL)
			BEGIN
				INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
				VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), '{"TipoAccion": "Consulta por clase de articulo", "Descripcion": "nulo"}');
			END
			ELSE
			BEGIN
				
				INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
				VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), '{"TipoAccion": "Consulta por clase de artículo", "Descripcion": '+ CONVERT(VARCHAR, @inFiltroIdClase)+'"}');
			END
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
