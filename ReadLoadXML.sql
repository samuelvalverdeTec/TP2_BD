USE [BD_TP2]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Samuel Valverde A.
-- Create date: 06/09/2023
-- Description:	Read and Load XML Data in SQL Tables
-- =============================================

CREATE PROCEDURE [dbo].[ReadAndLoadXML]
	-- Add the parameters for the stored procedure here
	@inRutaXML NVARCHAR(500)
	, @outResultCode INT OUTPUT
AS

BEGIN
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

		SET @outResultCode = 0;  -- no error code

		DECLARE @Datos XML	-- Variable de tipo XML

		-- DECLARE @Comando NVARCHAR(500) = 'SELECT @Datos = D FROM OPENROWSET (BULK ' + CHAR(39) + @inRutaXML')'

		DECLARE @Parametros NVARCHAR(500)
		SET @Parametros = N'@Datos xml OUTPUT'

		EXECUTE sp_executesql @Comando, @Parametros, @Datos OUTPUT

		DECLARE @hdoc INT -- identificador



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

		Set @outResultCode=50005;	-- Error
	
	END CATCH

END
GO
