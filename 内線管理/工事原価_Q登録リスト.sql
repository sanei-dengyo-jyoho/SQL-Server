WITH

v0 as
(
SELECT
	利用者名
,	オブジェクト名
,	CONVERT(int,キー1) AS 工事年度
,	CONVERT(varchar(20),コントロール名) AS 工事種別
,	CONVERT(int,キー2) AS 工事項番
,	CONVERT(int,キー3) AS 大分類
,	CONVERT(int,キー4) AS 中分類
,	CONVERT(int,キー5) AS 小分類
,	列0 AS 分類
,	列1 AS 項目名
,	列2 AS 支払先1
,	列3 AS 支払先2
,	数1 AS 契約金額
FROM
	汎用登録_T AS a0
WHERE
	( オブジェクト名 = N'実行予算_F' )
	OR ( オブジェクト名 = N'決算報告_F' )
)
,

v1 AS
(
SELECT TOP 100 PERCENT
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	ISNULL(大分類,999999) AS 大分類
,	ISNULL(中分類,999999) AS 中分類
,	999999 AS 小分類
,	NULL AS 分類
,	NULL AS 項目名
,	NULL AS 支払先1
,	NULL AS 支払先2
,	SUM(契約金額) AS 契約金額
FROM
	v0 AS a1
GROUP BY
ROLLUP
	(
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
	)
HAVING
	( 利用者名 IS NOT NULL )
	AND ( オブジェクト名 IS NOT NULL )
	AND ( 工事年度 IS NOT NULL )
	AND ( 工事種別 IS NOT NULL )
	AND ( 工事項番 IS NOT NULL )
ORDER BY
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
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
,	分類
,	項目名
,	支払先1
,	支払先2
,	SUM(契約金額)
	OVER(
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
		) AS 契約金額
FROM
	v1 AS a2
WHERE
	( 大分類 <> 999999 )
	AND ( 中分類 = 999999 )
ORDER BY
	利用者名
,	オブジェクト名
,	工事年度
,	工事種別
,	工事項番
,	大分類
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
WHERE
	( b4.大分類 = 999999 )
	OR (( b4.大分類 <> 999999 )
	AND ( b4.中分類 <> 999999 ))

UNION ALL

SELECT
	c4.*
FROM
	v2 AS c4
)
,

v8 as
(
SELECT
	a8.利用者名
,	a8.オブジェクト名
,	a8.工事年度
,	a8.工事種別
,	a8.工事項番
,	a8.大分類
,	a8.中分類
,	a8.小分類
,	a8.分類
,	a8.項目名
,	a8.支払先1
,	a8.支払先2
,	a8.契約金額
,   dbo.FuncMakeMoneyFormat(ISNULL(a8.契約金額,0)) AS 契約額
,	dbo.FuncMakePercentFormat(a8.契約金額,isnull(j8.請負受注金額,b8.受注金額)) AS 原価率
,   b8.受注金額
,   b8.消費税率
,   b8.消費税額
,	j8.[JV]
,   j8.請負受注金額
,   j8.請負消費税率
,   j8.請負消費税額
FROM
	v4 as a8
LEFT OUTER JOIN
	工事台帳_T AS b8
	ON b8.工事年度 = a8.工事年度
	AND b8.工事種別 = a8.工事種別
	AND b8.工事項番 = a8.工事項番
LEFT OUTER JOIN
    工事台帳_Q共同企業体出資比率 AS j8
    ON j8.工事年度 = b8.工事年度
    AND j8.工事種別 = b8.工事種別
    AND j8.工事項番 = b8.工事項番
)

SELECT
	*
FROM
	v8 as v800
