USE [UserDB]
GO

CREATE Function [dbo].[FuncGetAgeString]
(
	@iDate	nvarchar(40),
	@iNow	nvarchar(40),
	@iYYSuf	nvarchar(10) = '年',
	@iMMSuf	nvarchar(10) = 'ヶ月'
)
RETURNS nvarchar(40)
AS

BEGIN
	DECLARE @wYY	int
	DECLARE @wMM	int
	DECLARE @Ret	nvarchar(40)

	SET @Ret = ''

	IF (@iDate <> '') AND (@iNow <> '')
	BEGIN
		SET @wYY = DATEDIFF(month,@iDate,@iNow) / 12
		SET @wMM = DATEDIFF(month,@iDate,@iNow) % 12

		SET @Ret =
		(
		CASE
		WHEN
			DATEADD(month,@wMM,DATEADD(year,@wYY,@iDate)) <= @iNow
		THEN
			(
			CASE WHEN @iMMSuf <> 'N'
			THEN CONVERT(nvarchar,@wYY) + @iYYSuf + CONVERT(nvarchar,@wMM)
			ELSE CONVERT(nvarchar,@wYY) + @iYYSuf
			END
			)
		ELSE
			(
			CASE
			WHEN
				@wMM > 0
			THEN
				(
				CASE WHEN @iMMSuf <> 'N'
				THEN CONVERT(nvarchar,@wYY) + @iYYSuf + CONVERT(nvarchar,@wMM - 1)
				ELSE CONVERT(nvarchar,@wYY) + @iYYSuf
				END
				)
			ELSE
				(
				CASE WHEN @iMMSuf <> 'N'
				THEN CONVERT(nvarchar,@wYY - 1) + @iYYSuf + '11'
				ELSE CONVERT(nvarchar,@wYY - 1)
				END
				)
			END
			)
		END
		)
		IF (@iMMSuf <> 'N')
		BEGIN
			SET @Ret = @Ret + @iMMSuf
		END
	END

	RETURN(@Ret)
END

GO
