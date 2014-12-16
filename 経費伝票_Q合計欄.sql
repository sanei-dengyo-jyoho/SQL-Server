WITH

V0 AS
(
SELECT
	A.年度
,	A.[伝票№]
,	-1 AS [行№]
,	A.起票日付
,	A.部門コード
,	A.社員コード
,	SUM(B.金額) AS 金額
FROM
	経費_T AS A
LEFT OUTER JOIN
	経費明細_T AS B
	ON B.年度 = A.年度
	AND B.[伝票№] = A.[伝票№]
GROUP BY
	A.年度
,	A.[伝票№]
,	A.起票日付
,	A.部門コード
,	A.社員コード
)

SELECT
	*
FROM
	V0 AS V000
