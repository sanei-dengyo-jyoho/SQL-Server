WITH

v0 AS
(
SELECT
	a0.年度
,	a0.部門コード
,	a0.社員コード
,	a0.摘要
,	COUNT(a0.[伝票№]) AS 件数
FROM
	(
	SELECT
		a.年度
	,	a.[伝票№]
	,
		dbo.FuncGetStringBeforeSeparator(
			ISNULL(a.摘要,N''),
			CHAR(13)+CHAR(10)
		)
		AS 摘要
	,	b.部門コード
	,	b.社員コード
	FROM
	    経費明細_T AS a
	LEFT OUTER JOIN
		経費_T AS b
		ON a.年度 = b.年度
		AND a.[伝票№] = b.[伝票№]
	WHERE
	    ( ISNULL(a.摘要,N'') <> N'' )
	)
    AS a0
GROUP BY
	a0.年度
,	a0.部門コード
,	a0.社員コード
,	a0.摘要
)

SELECT
	*
FROM
	v0 As V000
