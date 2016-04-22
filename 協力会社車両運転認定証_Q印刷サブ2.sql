WITH

t0 AS
(
SELECT
	利用者名
,	オブジェクト名
,	コントロール名
,	CONVERT(int, ISNULL(キー1, 0)) AS 動作コード
,	CONVERT(int, ISNULL(キー2, 0)) AS 運転許可コード
,	CONVERT(int, ISNULL(キー4, 0)) AS 頁
,	CONVERT(int, ISNULL(キー5, 0)) AS 行
,	CONVERT(int, ISNULL(列5, 0)) AS 社員コード
,	ISNULL(列9, '') AS 会社コード
,	ISNULL(列10, '') AS 会社名
,	ISNULL(列1,  '') AS 列1
,	ISNULL(列2,  '') AS 列2
,	ISNULL(列3,  '') AS 列3
,	ISNULL(列4,  '') AS 列4
,	ISNULL(列5,  '') AS 列5
,	ISNULL(列6,  '') AS 列6
,	ISNULL(列7,  '') AS 列7
,	ISNULL(列8,  '') AS 列8
,	ISNULL(列9,  '') AS 列9
,	ISNULL(列10, '') AS 列10
,	ISNULL(列11, '') AS 列11
,	ISNULL(列12, '') AS 列12
,	ISNULL(列13, '') AS 列13
,	ISNULL(列14, '') AS 列14
,	ISNULL(列15, '') AS 列15
,	ISNULL(列16, '') AS 列16
,	ISNULL(列17, '') AS 列17
,	ISNULL(列18, '') AS 列18
,	ISNULL(列19, '') AS 列19
,	ISNULL(列20, '') AS 列20
,	ISNULL(列21, '') AS 列21
,	ISNULL(列22, '') AS 列22
,	ISNULL(列23, '') AS 列23
,	ISNULL(列24, '') AS 列24
,	ISNULL(列25, '') AS 列25
,	ISNULL(列26, '') AS 列26
,	ISNULL(列27, '') AS 列27
,	ISNULL(列28, '') AS 列28
,	ISNULL(列29, '') AS 列29
,	ISNULL(列30, '') AS 列30
FROM
	汎用登録_T AS v0
WHERE
	( オブジェクト名 = N'協力会社車両運転認定証_F' )
	AND ( コントロール名 = N'協力会社車両運転認定証_F' )
	AND ( CONVERT(int, ISNULL(キー1, 0)) BETWEEN 500 AND 520 )
	AND ( CONVERT(int, ISNULL(キー2, 0)) = 2 )
)

SELECT
	*
FROM
	t0 AS t000
