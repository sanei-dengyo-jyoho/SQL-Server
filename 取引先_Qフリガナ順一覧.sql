WITH

V0 AS
(
SELECT
	種別コード
,   MAX(読み順) AS 読み順
,   読み順カナ
,   N'煕' AS カナ順
,   NULL AS 取引先コード
,
	N'... ' +
	読み順カナ +
	N' 行 (' +
	CONVERT(nvarchar(5),COUNT(取引先コード)) +
	N' 件)'
	AS 取引先名
FROM
	取引先_Qフリガナ順 AS A0
WHERE
	( ISNULL(登録区分,-1) <= 0 )
GROUP BY
	種別コード
,   読み順カナ
)
,

V1 AS
(
SELECT
	種別コード
,   読み順
,   読み順カナ
,   取引先名カナ AS カナ順
,   取引先コード
,   取引先名
FROM
	取引先_Qフリガナ順 AS A1
WHERE
	( ISNULL(登録区分,-1) <= 0 )
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
