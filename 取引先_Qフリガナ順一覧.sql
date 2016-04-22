WITH

V2 AS
(
SELECT
	A0.種別コード
,   MAX(A0.読み順) AS 読み順
,   A0.読み順カナ
,   N'煕' AS カナ順
,   NULL AS 取引先コード
,
	N'... ' +
	A0.読み順カナ +
	N' 行 (' +
	CONVERT(nvarchar(5),COUNT(A0.取引先コード)) +
	N' 件)'
	AS 取引先名
FROM
	取引先_Qフリガナ順 AS A0
WHERE
	( ISNULL(A0.登録区分,-1) <= 0 )
GROUP BY
	A0.種別コード
,   A0.読み順カナ

UNION ALL

SELECT
	A1.種別コード
,   A1.読み順
,   A1.読み順カナ
,   A1.取引先名カナ AS カナ順
,   A1.取引先コード
,   A1.取引先名
FROM
	取引先_Qフリガナ順 AS A1
WHERE
	( ISNULL(A1.登録区分,-1) <= 0 )
)

SELECT
	*
FROM
	V2 AS V200
