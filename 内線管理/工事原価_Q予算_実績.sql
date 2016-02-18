WITH

gj as
(
SELECT
	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	小分類
,	項目名
,	支払先1
,	支払先2
,	支払金額 AS 契約金額
,	999 AS 実績
FROM
	支払_Q項目名 AS gja0
)
,

gg as
(
SELECT
	gga0.工事年度
,	gga0.工事種別
,	gga0.工事項番
,	gga0.大分類
,	gga0.中分類
,	gga0.小分類
,	isnull(ggj0.項目名,gga0.項目名) as 項目名
,	isnull(ggj0.支払先1,ggb0.支払先略称) as 支払先1
,	isnull(ggj0.支払先2,ggc0.支払先略称) as 支払先2
,	isnull(ggj0.契約金額,gga0.契約金額) as 契約金額
,
	case
		when isnull(ggj0.契約金額,0) = isnull(gga0.契約金額,0)
		then 0
		else 1
	end
	as 実績
FROM
	工事原価_T予算 AS gga0
LEFT OUTER JOIN
	支払先_T as ggb0
	on ggb0.支払先コード = gga0.支払先コード1
LEFT OUTER JOIN
	支払先_T as ggc0
	on ggc0.支払先コード = gga0.支払先コード2
LEFT OUTER JOIN
	gj as ggj0
    ON ggj0.工事年度 = gga0.工事年度
    AND ggj0.工事種別 = gga0.工事種別
    AND ggj0.工事項番 = gga0.工事項番
    AND ggj0.大分類 = gga0.大分類
    AND ggj0.中分類 = gga0.中分類
    AND ggj0.小分類 = gga0.小分類
)
,

gy as
(
SELECT
	gya0.工事年度
,	gya0.工事種別
,	gya0.工事項番
,	gya0.大分類
,	gya0.中分類
,	gya0.小分類
,	gya0.項目名
,	gya0.支払先1
,	gya0.支払先2
,	gya0.契約金額
,	gya0.実績
FROM
	gj AS gya0
LEFT OUTER JOIN
	gg as gyb0
    ON gyb0.工事年度 = gya0.工事年度
    AND gyb0.工事種別 = gya0.工事種別
    AND gyb0.工事項番 = gya0.工事項番
    AND gyb0.大分類 = gya0.大分類
    AND gyb0.中分類 = gya0.中分類
    AND gyb0.小分類 = gya0.小分類
WHERE
	( gyb0.大分類 IS NULL )
	AND ( gyb0.中分類 IS NULL )
	AND ( gyb0.小分類 IS NULL )
)
,

gx as
(
SELECT
	gxa0.工事年度
,	gxa0.工事種別
,	gxa0.工事項番
,	gxa0.大分類
,	gxa0.中分類
,	gxa0.小分類
,	gxa0.項目名
,	gxa0.支払先1
,	gxa0.支払先2
,	gxa0.契約金額
,	gxa0.実績
FROM
	gg AS gxa0

UNION ALL

SELECT
	gxb0.工事年度
,	gxb0.工事種別
,	gxb0.工事項番
,	gxb0.大分類
,	gxb0.中分類
,	gxb0.小分類
,	gxb0.項目名
,	gxb0.支払先1
,	gxb0.支払先2
,	gxb0.契約金額
,	gxb0.実績
FROM
	gy AS gxb0
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
,	1 as 項目名件数
,	a0.項目名
,	a0.支払先1
,	a0.支払先2
,	a0.契約金額
,	a0.実績
FROM
	gx AS a0
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
,	NULL AS 支払先1
,	NULL AS 支払先2
,	SUM(契約金額) AS 契約金額
,	NULL AS 実績
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
,	支払先1
,	支払先2
,
	SUM(契約金額)
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
		) AS 契約金額
,	NULL AS 実績
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
	CASE
		when ( isnull(j8.[JV],0) > 0 ) and ( isnull(a8.費目,N'') = N'G1' )
        then b8.項目名
        else ISNULL(a8.項目名,b8.項目名)
    end as 項目名
,
	CASE
		when ( isnull(j8.[JV],0) > 0 ) and ( isnull(a8.費目,N'') = N'G1' )
        then b8.項目名
        else ISNULL(a8.項目名,b8.項目名)
    end as 項目名比較
,	b8.支払先1
,	b8.支払先1 AS 支払先1比較
,	b8.支払先2
,	b8.支払先2 AS 支払先2比較
,	b8.契約金額
,	b8.契約金額 AS 契約金額比較
,	b8.実績
,
	CASE
		when ( isnull(j8.[JV],0) > 0 ) and ( isnull(a8.費目,N'') = N'G1' )
        then 1
        else a8.項目名登録
    end as 項目名登録
,	a8.項目名表示
,	a8.原価率表示
,	dbo.FuncMakePercentFormat(b8.契約金額,isnull(j8.請負受注金額,d8.受注金額)) AS 原価率
,	dbo.FuncMakePercentFormat(b8.契約金額,isnull(j8.請負受注金額,d8.受注金額)) AS 原価率比較
,	a8.赤
,	a8.緑
,	a8.青
,   d8.受注金額
,   d8.消費税率
,   d8.消費税額
,
	CASE
		when ( isnull(j8.[JV],0) > 0 ) and ( isnull(a8.費目,N'') = N'備考' )
        then 0
        else 1
    end as 有効
,	a8.[JV表示]
,
	CASE
		when isnull(j8.[JV],0) = 0
		then 0
		else 0
	end as [JV自]
,
	CASE
		when isnull(j8.[JV],0) = 0
		then 0
		else 999
	end as [JV至]
,	j8.[JV]
,   j8.請負受注金額
,   j8.請負消費税率
,   j8.請負消費税額
FROM
	工事原価_Q項目名一覧 AS a8
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
)

SELECT
	*
FROM
	v8 AS v800
where
	( 有効 = 1 )
    AND ( [JV表示] between [JV自] and [JV至] )
