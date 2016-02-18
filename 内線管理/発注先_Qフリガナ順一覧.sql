WITH

V0 AS
(
SELECT
	システム名
,	工事種別
,   MAX(読み順) AS 読み順
,   読み順カナ
,   N'煕' AS カナ順
,   NULL AS 取引先コード
,   NULL AS 取引先名
,   N'... ' +
	読み順カナ +
	N' 行 (' +
	CONVERT(nvarchar(5),COUNT(取引先コード)) +
	N' 件)'
	AS 取引先名カナ
FROM
	発注先_Qフリガナ順 AS A0
GROUP BY
	システム名
,	工事種別
,   読み順カナ
)
,

V1 AS
(
SELECT
	システム名
,	工事種別
,   読み順
,   読み順カナ
,   取引先名カナ AS カナ順
,   取引先コード
,   取引先名
,   取引先名カナ
FROM
	発注先_Qフリガナ順 AS A1
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
