USE [BD_Tarea2]
GO
/****** Object:  StoredProcedure [dbo].[Validar_Usuario]    Script Date: 9/16/2023 1:09:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Erick Kauffmann
--				Samuel Valverde
-- Create date: 016/09/2023
-- Description:	validar el usuario y password
-- =============================================
ALTER PROCEDURE [dbo].[Validar_Usuario] 
	-- Add the parameters for the stored procedure here
	@inPostIP VARCHAR(100)
	, @inUsuarioActual VARCHAR(16)
	, @inPassword VARCHAR(16)
	, @outResultCode INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	DECLARE @inIdUsuarioActual INT;
	SET NOCOUNT ON;

	BEGIN TRY
		IF EXISTS (SELECT U.[id]
						, U.[UserName]
						, U.[Password]
					FROM dbo.Usuario U
					WHERE U.[UserName] = @inUsuarioActual 
					and U.[Password] = @inPassword)
		BEGIN
			SET @outResultCode = 0;  -- no error code, usuario y password correctos
			SELECT U.[id]
				, U.[UserName]
				, U.[Password]
			FROM dbo.Usuario U
			WHERE U.[UserName] = @inUsuarioActual 
			and U.[Password] = @inPassword

			SELECT @inIdUsuarioActual = U.[id] 
			FROM dbo.Usuario U 
			WHERE U.[UserName] = @inUsuarioActual 
			and U.[Password] = @inPassword;
			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			VALUES (@inIdUsuarioActual, @inPostIP, GETDATE(), '{"TipoAccion": "Login exitoso", "Descripcion": "'+ @inUsuarioActual+'"}');
		END
		ELSE
		BEGIN
		--PRINT 'login no exitoso'
			SET @outResultCode = 50007;  -- usuario o password incorrecto
			INSERT INTO dbo.EventLog (PostIdUser, PostIP, PostTime, LogDescription)
			VALUES (-1, @inPostIP, GETDATE(), '{"TipoAccion": "Login no exitoso", "Descripcion": "'+ @inUsuarioActual+'"}');
		END
		-- mostrar el usuario que corresponde al username y password ingresados
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
		SET @outResultCode = 50008;  -- código error en la búsqueda de usuario
	END CATCH
END
