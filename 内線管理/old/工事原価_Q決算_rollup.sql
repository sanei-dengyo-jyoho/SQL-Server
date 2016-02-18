WITH

x0 AS
(
SELECT
	xb0.システム名
,	xa0.工事年度
,	xa0.工事種別
,	xa0.工事項番
,	xb0.ページ
,	xb0.頁
,	xb0.行
,	xb0.大分類
,	xb0.中分類
,	xb0.小分類
,	xb0.分類
,	xb0.項目名
,	xb0.項目名登録
,	xb0.項目名表示
,	xb0.原価率表示
,	xb0.赤
,	xb0.青
,	xb0.緑
FROM
	工事原価_T AS xa0
CROSS JOIN
	工事原価項目_Q AS xb0
)
,

v0 AS
(
SELECT
    c0.システム名
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.大分類
,	a0.中分類
,	a0.小分類
,	a0.項目名
,	a0.支払先1
,	a0.支払先2
,	a0.契約金額
FROM
	工事原価_T決算 AS a0
LEFT OUTER JOIN
    工事種別_T AS c0
    ON c0.工事種別 = a0.工事種別
)
,

v1 AS
(
SELECT TOP 100 PERCENT
    システム名
,	工事年度
,	工事種別
,	工事項番
,	ISNULL(大分類,999999) AS 大分類
,	ISNULL(中分類,999999) AS 中分類
,	999999 AS 小分類
,	NULL AS 項目名
,	NULL AS 支払先1
,	NULL AS 支払先2
,	SUM(契約金額) AS 契約金額
FROM
	v0 AS a1
GROUP BY
	ROLLUP
	(
	    システム名
	,	工事年度
	,	工事種別
	,	工事項番
	,	大分類
	,	中分類
	)
HAVING
	( システム名 IS NOT NULL )
	AND ( 工事年度 IS NOT NULL )
	AND ( 工事種別 IS NOT NULL )
	AND ( 工事項番 IS NOT NULL )
ORDER BY
    システム名
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
    システム名
,	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	小分類
,	項目名
,	支払先1
,	支払先2
,	SUM(契約金額)
	OVER(
		PARTITION BY
		    システム名
		,	工事年度
		,	工事種別
		,	工事項番
		ORDER BY
		    システム名
		,	工事年度
		,	工事種別
		,	工事項番
		,	大分類
		) AS 原価
FROM
	v1 AS a2
WHERE
	( 大分類 <> 999999 )
	AND ( 中分類 = 999999 )
ORDER BY
    システム名
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

v8 AS
(
SELECT
    a8.システム名
,	dbo.FuncMakeConstructNumber(a8.工事年度,a8.工事種別,a8.工事項番) AS 工事番号
,	a8.工事年度
,	a8.工事種別
,	a8.工事項番
,	a8.ページ
,	a8.頁
,	a8.行
,	a8.大分類
,	a8.中分類
,	a8.小分類
,	a8.分類
,	ISNULL(a8.項目名,b8.項目名) AS 項目名
,	CASE
		WHEN ISNULL(a8.項目名登録,0) = 0
		THEN ISNULL(a8.項目名,b8.項目名)
		ELSE z8.項目名
	END AS 項目名比較
,	b8.支払先1
,	z8.支払先1 AS 支払先1比較
,	b8.支払先2
,	z8.支払先2 AS 支払先2比較
,	b8.契約金額
,	z8.契約金額 AS 契約金額比較
,	a8.項目名登録
,	a8.項目名表示
,	a8.原価率表示
,	dbo.FuncMakePercentFormat(b8.契約金額,isnull(j8.請負受注金額,d8.受注金額)) AS 原価率
,	dbo.FuncMakePercentFormat(z8.契約金額,isnull(j8.請負受注金額,d8.受注金額)) AS 原価率比較
,	a8.赤
,	a8.緑
,	a8.青
,   d8.受注金額
,   d8.消費税率
,   d8.消費税額
,	j8.[JV]
,   j8.請負受注金額
,   j8.請負消費税率
,   j8.請負消費税額
FROM
	x0 AS a8
LEFT OUTER JOIN
    v4 AS b8
    ON b8.システム名 = a8.システム名
    AND b8.工事年度 = a8.工事年度
    AND b8.工事種別 = a8.工事種別
    AND b8.工事項番 = a8.工事項番
    AND b8.大分類 = a8.大分類
    AND b8.中分類 = a8.中分類
    AND b8.小分類 = a8.小分類
LEFT OUTER JOIN
    工事台帳_T AS d8
    ON d8.工事年度 = a8.工事年度
    AND d8.工事種別 = a8.工事種別
    AND d8.工事項番 = a8.工事項番
LEFT OUTER JOIN
    工事台帳_Q共同企業体出資比率 AS j8
    ON j8.工事年度 = d8.工事年度
    AND j8.工事種別 = d8.工事種別
    AND j8.工事項番 = d8.工事項番
LEFT OUTER JOIN
    工事原価_T予算 AS z8
    ON z8.工事年度 = a8.工事年度
    AND z8.工事種別 = a8.工事種別
    AND z8.工事項番 = a8.工事項番
    AND z8.大分類 = a8.大分類
    AND z8.中分類 = a8.中分類
    AND z8.小分類 = a8.小分類
)

SELECT
	*
FROM
	v8 AS v800
