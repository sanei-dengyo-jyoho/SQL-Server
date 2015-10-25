with

v0 as
(
SELECT TOP 1
	NULL AS 協力会社コード
,	N'（全て）' AS 協力会社名
,	sum(人数) AS 人数
FROM
	協力会社_T AS a0
)
,

v1 as
(
SELECT
	協力会社コード
,	協力会社名
,	人数
FROM
	協力会社_T AS a1
)
,

v2 as
(
SELECT
	*
FROM
	v0 AS a2

UNION ALL

SELECT
	*
FROM
	v1 AS b2
)

SELECT
	*
FROM
	v2 AS a3
