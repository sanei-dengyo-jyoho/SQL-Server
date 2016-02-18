WITH

V0 AS
(
SELECT
	MAX(読み順) AS 読み順
,	読み順カナ
,	N'煕' AS カナ順
,	NULL AS 支払先コード
,	NULL AS 支払先名
,	N'... ' +
	読み順カナ +
	N' 行 (' +
	CONVERT(nvarchar(5),COUNT(支払先コード)) +
	N' 件)'
	AS 支払先名カナ
FROM
	支払先_Qフリガナ順 AS A0
GROUP BY
	読み順カナ
)
,

V1 AS
(
SELECT
	読み順
,	読み順カナ
,	支払先名カナ AS カナ順
,	支払先コード
,	支払先名
,	支払先名カナ
FROM
	支払先_Qフリガナ順 AS A1
)
,

V2 AS
(
SELECT
	A2.*
FROM
	V0 AS A2

UNION ALL

SELECT
	B2.*
FROM
	V1 AS B2
)

SELECT
	*
FROM
	V2 AS V200
