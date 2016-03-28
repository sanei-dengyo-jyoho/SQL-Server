WITH

v003 AS
(
SELECT
	a002.工事年度
,	a002.工事種別
,	a002.工事項番
,	a002.大分類
,	a002.中分類
,	a002.小分類
,	1 as 項目名件数
,	a002.項目名
,	NULL AS 契約先1
,	NULL AS 契約先2
,	NULL AS 契約金額
,	a002.支払先1 AS 支払先1
,	a002.支払先2 AS 支払先2
,	a002.支払金額
,	a002.支払自日付
,	a002.支払至日付
,	a002.確定日付
FROM
	支払_Q項目名 AS a002
LEFT OUTER JOIN
	工事原価_T AS g002
    ON g002.工事年度 = a002.工事年度
    AND g002.工事種別 = a002.工事種別
    AND g002.工事項番 = a002.工事項番
WHERE
	( g002.工事年度 IS NULL )
	AND ( g002.工事種別 IS NULL )
	AND ( g002.工事項番 IS NULL )
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
,	a0.項目名件数
,	a0.項目名
,	a0.契約先1
,	a0.契約先2
,	a0.契約金額
,	a0.支払先1
,	a0.支払先2
,	a0.支払金額
,	a0.支払自日付
,	a0.支払至日付
,	a0.確定日付
FROM
	v003 AS a0
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
,	COUNT(項目名件数) AS 項目名件数
,	NULL AS 項目名
,	NULL AS 契約先1
,	NULL AS 契約先2
,	SUM(isnull(契約金額,0)) AS 契約金額
,	NULL AS 支払先1
,	NULL AS 支払先2
,	SUM(支払金額) AS 支払金額
,	NULL AS 支払自日付
,	NULL AS 支払至日付
,	NULL AS 確定日付
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
,	1 AS 項目名件数
,	項目名
,	契約先1
,	契約先2
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
		)
	AS 契約金額
,	支払先1
,	支払先2
,	SUM(支払金額)
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
		)
	AS 支払金額
,	NULL AS 支払自日付
,	NULL AS 支払至日付
,	NULL AS 確定日付
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
,	a8.費目
,	b8.項目名件数
,
	case
		when ( isnull(j8.[JV],0) > 0 ) and ( isnull(a8.費目,N'') = N'G1' )
        then b8.項目名
        else ISNULL(a8.項目名,b8.項目名)
    end
	as 項目名
,	b8.契約先1
,	b8.契約先2
,	b8.契約金額
,	b8.支払先1
,	b8.支払先2
,	b8.支払金額
,	b8.支払自日付
,	b8.支払至日付
,   dbo.FuncMakeConstructPeriod(b8.支払自日付,b8.支払至日付,DEFAULT) AS 支払期間
,	b8.確定日付
,
	case
		when ( isnull(j8.[JV],0) > 0 ) and ( isnull(a8.費目,N'') = N'G1' )
        then 1
        else a8.項目名登録
    end
	as 項目名登録
,	a8.項目名表示
,	a8.原価率表示
,	dbo.FuncMakePercentFormat(b8.契約金額,isnull(j8.請負受注金額,d8.受注金額)) AS 原価率
,	a8.赤
,	a8.緑
,	a8.青
,   d8.受注金額
,   d8.消費税率
,   d8.消費税額
,
	case
		when ( isnull(j8.[JV],0) > 0 ) and ( isnull(a8.費目,N'') = N'備考' )
        then 0
        else 1
    end
	as 有効
,	a8.[JV表示]
,
	case
		when isnull(j8.[JV],0) = 0
		then 0
		else 0
	end
	as [JV自]
,
	case
		when isnull(j8.[JV],0) = 0
		then 0
		else 999
	end
	as [JV至]
,	j8.[JV]
,   j8.請負受注金額
,   j8.請負消費税率
,   j8.請負消費税額
FROM
	支払_Q項目名一覧 AS a8
INNER JOIN
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
)
,

v9 AS
(
SELECT
	*
FROM
	v8 AS a9
where
	( 有効 = 1 )
    AND ( [JV表示] between [JV自] and [JV至] )
)

SELECT
	*
FROM
	v9 AS v900
