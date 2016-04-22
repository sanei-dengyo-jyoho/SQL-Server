with

v2 as
(
SELECT TOP 1
	NULL AS 協力会社コード
,	N'（全て）' AS 協力会社名
,	sum(a0.人数) AS 人数
FROM
	協力会社_T AS a0

UNION ALL

SELECT
	a1.協力会社コード
,	a1.協力会社名
,	a1.人数
FROM
	協力会社_T AS a1
)

SELECT
	*
FROM
	v2 AS v200
