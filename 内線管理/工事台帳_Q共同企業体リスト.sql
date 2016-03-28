WITH

v0 AS
(
SELECT
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	999 AS 合計行
,	N'合計' AS 企業名
,	NULL AS 出資比率
,	ISNULL(SUM(b0.請負受注金額),MAX(a0.受注金額)) AS 請負受注金額
,	ISNULL(MAX(b0.請負消費税率),MAX(a0.消費税率)) AS 請負消費税率
,	ISNULL(SUM(b0.請負消費税額),MAX(a0.消費税額)) AS 請負消費税額
FROM
	工事台帳_T AS a0
LEFT OUTER JOIN
	工事台帳_T共同企業体 AS b0
	ON b0.工事年度 = a0.工事年度
	AND b0.工事種別 = a0.工事種別
	AND b0.工事項番 = a0.工事項番
GROUP BY
	a0.工事年度
,	a0.工事種別
,	a0.工事項番

UNION ALL

SELECT
	b1.工事年度
,	b1.工事種別
,	b1.工事項番
,	0 AS 合計行
,	b1.企業名
,	b1.出資比率
,	b1.請負受注金額
,	b1.請負消費税率
,	b1.請負消費税額
FROM
	工事台帳_T共同企業体 AS b1
)
,

v2 AS
(
SELECT
	b2.システム名
,	a2.工事年度
,	a2.工事種別
,	a2.工事項番
,	a2.合計行
,	a2.企業名
,	a2.出資比率
,	a2.請負受注金額
,	a2.請負消費税率
,	a2.請負消費税額
,
	RANK()
 	OVER(
		PARTITION BY
			a2.工事年度
		,	a2.工事種別
		,	a2.工事項番
		ORDER BY
			a2.合計行 DESC
		,	a2.出資比率 DESC
		,	a2.企業名
		)
	AS 順位
FROM
	v0 AS a2
LEFT OUTER JOIN
    工事種別_T AS b2
    ON b2.工事種別 = a2.工事種別
)

SELECT
	*
FROM
	v2 AS v200
