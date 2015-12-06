WITH

v0 as
(
SELECT
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	小分類
,	記号
,	項目名
,	支払先1
,	支払先2
,	支払金額
FROM
	工事原価_T予算_登録用 AS a0
)
,

v1 AS
(
SELECT
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	999999 AS 小分類
,	NULL AS 記号
,	NULL AS 項目名
,	NULL AS 支払先1
,	NULL AS 支払先2
,	SUM(支払金額) AS 支払金額
FROM
	v0 AS a1
GROUP BY
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
)
,

v02 AS
(
SELECT
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	大分類
,	999999 AS 中分類
,	999999 AS 小分類
,	NULL AS 記号
,	NULL AS 項目名
,	NULL AS 支払先1
,	NULL AS 支払先2
,	SUM(支払金額) AS 支払金額
FROM
	v0 AS a02
GROUP BY
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	大分類
)
,

v2 AS
(
SELECT TOP 100 PERCENT
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	小分類
,	記号
,	項目名
,	支払先1
,	支払先2
,	SUM(支払金額) OVER(
				PARTITION BY
				    利用者名
				,	オブジェクト名
				,	工事年度
				,	工事種別
				,	工事項番
				ORDER BY
				    利用者名
				,	オブジェクト名
				,	工事年度
				,	工事種別
				,	工事項番
				,	大分類
	) AS 支払金額
FROM
	v02 AS a2
ORDER BY
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	大分類
)
,

z0 AS
(
SELECT
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	999999 AS 大分類
,	999999 AS 中分類
,	999999 AS 小分類
,	NULL AS 記号
,	NULL AS 項目名
,	NULL AS 支払先1
,	NULL AS 支払先2
,	SUM(支払金額) AS 支払金額
FROM
	v0 AS a3
GROUP BY
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
)
,

v4 AS
(
SELECT
    a4.*
FROM
	v0 AS a4

UNION ALL

SELECT
	b4.*
FROM
	v1 AS b4

UNION ALL

SELECT
	c4.*
FROM
	v2 AS c4

UNION ALL

SELECT
	d4.*
FROM
	z0 AS d4
)
,

v5 as
(
SELECT
	a5.利用者名
,	a5.オブジェクト名
,	a5.工事年度
,	a5.工事種別
,	a5.工事項番
,	a5.大分類
,	a5.中分類
,	a5.小分類
,	a5.記号
,	a5.項目名
,	a5.支払先1
,	a5.支払先2
,	a5.支払金額
,   dbo.FuncMakeMoneyFormat(ISNULL(a5.支払金額,0)) AS 支払額
,   b5.受注金額
,   b5.消費税率
,   b5.消費税額
,	dbo.FuncMakePercentFormat(a5.支払金額,b5.受注金額) AS 工事原価率
FROM
	v4 as a5
LEFT OUTER JOIN
	工事台帳_T AS b5
	ON b5.工事年度 = a5.工事年度
	AND b5.工事種別 = a5.工事種別
	AND b5.工事項番 = a5.工事項番
)

SELECT
	*
FROM
	v5 as v500
