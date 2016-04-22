
WITH

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
,	ggj0.支払先1
,	ggj0.支払先2
,	ggj0.契約金額
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
	(
	SELECT
		ggj00.工事年度
	,	ggj00.工事種別
	,	ggj00.工事項番
	,	ggj00.大分類
	,	ggj00.中分類
	,	ggj00.小分類
	,	ggj00.項目名
	,	ggj00.支払先1
	,	ggj00.支払先2
	,	ggj00.支払金額 AS 契約金額
	,	999 AS 実績
	FROM
		支払_Q項目名 AS ggj00
	)
	as ggj0
    ON ggj0.工事年度 = gga0.工事年度
    AND ggj0.工事種別 = gga0.工事種別
    AND ggj0.工事項番 = gga0.工事項番
    AND ggj0.大分類 = gga0.大分類
    AND ggj0.中分類 = gga0.中分類
    AND ggj0.小分類 = gga0.小分類
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
	(
	SELECT
		gxa0.*
	FROM
		gg AS gxa0

	UNION ALL

	SELECT
		gxb0.*
	FROM
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
			(
			SELECT
				gya00.工事年度
			,	gya00.工事種別
			,	gya00.工事項番
			,	gya00.大分類
			,	gya00.中分類
			,	gya00.小分類
			,	gya00.項目名
			,	gya00.支払先1
			,	gya00.支払先2
			,	gya00.支払金額 AS 契約金額
			,	999 AS 実績
			FROM
				支払_Q項目名 AS gya00
			)
			AS gya0
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
		AS gxb0
	)
	AS a0
INNER JOIN
	工事種別_T AS c0
	ON c0.工事種別 = a0.工事種別
)
,

-- 中分類ごとに小計と総合計を算出 --
v1 AS
(
SELECT TOP 100 PERCENT
	a1.システム名
,	a1.工事年度
,	a1.工事種別
,	a1.工事項番
,	ISNULL(a1.大分類,999999) AS 大分類
,	ISNULL(a1.中分類,999999) AS 中分類
,	999999 AS 小分類
,	COUNT(a1.項目名件数) AS 項目名件数
,	NULL AS 項目名
,	NULL AS 支払先1
,	NULL AS 支払先2
,	SUM(a1.契約金額) AS 契約金額
,	NULL AS 実績
FROM
	v0 AS a1
GROUP BY
	ROLLUP
	(
		a1.システム名
	,	a1.工事年度
	,	a1.工事種別
	,	a1.工事項番
	,	a1.大分類
	,	a1.中分類
	)
HAVING
	( a1.システム名 IS NOT NULL )
	AND ( a1.工事年度 IS NOT NULL )
	AND ( a1.工事種別 IS NOT NULL )
	AND ( a1.工事項番 IS NOT NULL )
ORDER BY
	a1.システム名
,	a1.工事年度
,	a1.工事種別
,	a1.工事項番
,	a1.大分類
,	a1.中分類
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
	as
	項目名
,
	case
		when ( isnull(j8.[JV],0) > 0 ) and ( isnull(a8.費目,N'') = N'G1' )
		then z8.項目名
		else
			case
				when ISNULL(a8.項目名登録,0) = 0
				then ISNULL(a8.項目名,b8.項目名)
				else z8.項目名
			end
	end
	as 項目名比較
,	b8.支払先1
,	z8.支払先1 AS 支払先1比較
,	b8.支払先2
,	z8.支払先2 AS 支払先2比較
,	b8.契約金額
,	z8.契約金額 AS 契約金額比較
,	b8.実績
,
	case
		when ( isnull(j8.[JV],0) > 0 ) and ( isnull(a8.費目,N'') = N'G1' )
		then 1
		else a8.項目名登録
	end
	as 項目名登録
,	a8.項目名表示
,	a8.原価率表示
,
	dbo.FuncMakePercentFormat(
		b8.契約金額,
		isnull(j8.請負受注金額,d8.受注金額)
	)
	AS 原価率
,
	dbo.FuncMakePercentFormat(
		z8.契約金額,
		isnull(j8.請負受注金額,d8.受注金額)
	)
	AS 原価率比較
,	a8.赤
,	a8.緑
,	a8.青
,	d8.受注金額
,	d8.消費税率
,	d8.消費税額
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
,	j8.請負受注金額
,	j8.請負消費税率
,	j8.請負消費税額
FROM
	工事原価_Q項目名一覧 AS a8
LEFT OUTER JOIN
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

	-- 大分類ごとに累計を算出 --
	SELECT
		c4.*
	FROM
		(
		SELECT TOP 100 PERCENT
			a2.システム名
		,	a2.工事年度
		,	a2.工事種別
		,	a2.工事項番
		,	a2.大分類
		,	a2.中分類
		,	a2.小分類
		,	1 AS 項目名件数
		,	a2.項目名
		,	a2.支払先1
		,	a2.支払先2
		,
			SUM(a2.契約金額)
			OVER(
				PARTITION BY
					a2.システム名
				,	a2.工事年度
				,	a2.工事種別
				,	a2.工事項番
				ORDER BY
					a2.システム名
				,	a2.工事年度
				,	a2.工事種別
				,	a2.工事項番
				,	a2.大分類
			)
			AS 契約金額
		,	NULL AS 実績
		FROM
			v1 AS a2
		WHERE
			( a2.大分類 <> 999999 )
			AND ( a2.中分類 = 999999 )
		ORDER BY
			a2.システム名
		,	a2.工事年度
		,	a2.工事種別
		,	a2.工事項番
		,	a2.大分類
		)
		AS c4
	)
	AS b8
	ON b8.システム名 = a8.システム名
	AND b8.工事年度 = a8.工事年度
	AND b8.工事種別 = a8.工事種別
	AND b8.工事項番 = a8.工事項番
	AND b8.大分類 = a8.大分類
	AND b8.中分類 = a8.中分類
	AND b8.小分類 = a8.小分類
INNER JOIN
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
	支払_T AS p8
	ON p8.工事年度 = a8.工事年度
	AND p8.工事種別 = a8.工事種別
	AND p8.工事項番 = a8.工事項番
LEFT OUTER JOIN
	(
	SELECT
		gj8.工事年度
	,	gj8.工事種別
	,	gj8.工事項番
	,	gj8.大分類
	,	gj8.中分類
	,	gj8.小分類
	,	gj8.項目名
	,	gj8.支払先1
	,	gj8.支払先2
	,	gj8.支払金額 AS 契約金額
	,	999 AS 実績
	FROM
		支払_Q項目名 AS gj8
	)
	AS z8
	ON z8.工事年度 = a8.工事年度
	AND z8.工事種別 = a8.工事種別
	AND z8.工事項番 = a8.工事項番
	AND z8.大分類 = a8.大分類
	AND z8.中分類 = a8.中分類
	AND z8.小分類 = a8.小分類
where
	( isnull(p8.確定日付,'') <> '' )
)

SELECT
	*
FROM
	v8 AS v800
where
	( 有効 = 1 )
	AND ( [JV表示] between [JV自] and [JV至] )
