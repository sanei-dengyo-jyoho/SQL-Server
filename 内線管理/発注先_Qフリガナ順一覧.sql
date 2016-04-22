WITH

V2 AS
(
SELECT
	A0.システム名
,	A0.工事種別
,	MAX(A0.読み順) AS 読み順
,	A0.読み順カナ
,	N'煕' AS カナ順
,	NULL AS 取引先コード
,	NULL AS 取引先名
,
	N'... ' +
	A0.読み順カナ +
	N' 行 (' +
	CONVERT(nvarchar(5),COUNT(A0.取引先コード)) +
	N' 件)'
	AS 取引先名カナ
FROM
	発注先_Qフリガナ順 AS A0
GROUP BY
	A0.システム名
,	A0.工事種別
,	A0.読み順カナ

UNION ALL

SELECT
	A1.システム名
,	A1.工事種別
,	A1.読み順
,	A1.読み順カナ
,	A1.取引先名カナ AS カナ順
,	A1.取引先コード
,	A1.取引先名
,	A1.取引先名カナ
FROM
	発注先_Qフリガナ順 AS A1
)

SELECT
	*
FROM
	V2 AS V200
