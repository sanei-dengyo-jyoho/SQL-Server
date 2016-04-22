WITH

V2 AS
(
SELECT
	MAX(A0.読み順) AS 読み順
,	A0.読み順カナ
,	N'煕' AS カナ順
,	NULL AS 支払先コード
,	NULL AS 支払先名
,
	N'... ' +
	A0.読み順カナ +
	N' 行 (' +
	CONVERT(nvarchar(5),COUNT(A0.支払先コード)) +
	N' 件)'
	AS 支払先名カナ
FROM
	支払先_Qフリガナ順 AS A0
GROUP BY
	A0.読み順カナ

UNION ALL

SELECT
	A1.読み順
,	A1.読み順カナ
,	A1.支払先名カナ AS カナ順
,	A1.支払先コード
,	A1.支払先名
,	A1.支払先名カナ
FROM
	支払先_Qフリガナ順 AS A1
)

SELECT
	*
FROM
	V2 AS V200
