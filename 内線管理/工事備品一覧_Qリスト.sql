with

p0 as
(
select distinct
	pa0.工事年度
,	pa0.工事種別
,	pa0.工事項番
,	pa0.分類コード
,	pa0.商品名
,
	convert(nvarchar(100),
		CASE
			WHEN isnull(max(pa0.日付),'') = ''
			THEN N''
			ELSE format(max(pa0.日付),'d')
		END
	) as 日付
,
	convert(nvarchar(100),
		CASE
			WHEN isnull(sum(pa0.数量),'') = ''
			THEN N''
			ELSE cast(sum(pa0.数量) as nvarchar)
		END +
		space(1) +
		CASE
			WHEN isnull(max(pa0.単位),N'') = N''
			THEN N'　'
			ELSE max(pa0.単位)
		END
	)
	as 数量
,
	convert(nvarchar(100),
		CASE
			WHEN isnull(sum(pa0.金額),'') = ''
			THEN N''
			ELSE format(sum(pa0.金額),'c')
		END
	)
	as 金額
,
	convert(nvarchar(100),
		CASE
			WHEN isnull(max(pa0.支払先),N'') = N''
			THEN N''
			ELSE max(pa0.支払先)
		END
	) as 支払先
from
 	備品購入_Q明細リスト as pa0
where
	( isnull(pa0.工事年度,'') <> '' )
	and ( isnull(pa0.工事種別,'') <> '' )
	and ( isnull(pa0.工事項番,'') <> '' )
group by
	pa0.工事年度
,	pa0.工事種別
,	pa0.工事項番
,	pa0.分類コード
,	pa0.商品名
)
,

v0 as
(
select distinct
	a0.*
,
    replace(
        dbo.FuncDeleteCharPrefix(l0.リスト,default)
        , N'、', CHAR(13)
    )
    as 商品名
,
    replace(
        dbo.FuncDeleteCharPrefix(l0.リスト,default)
        , N'、', CHAR(13)+CHAR(10)
    )
    as 商品名出力
,
    replace(
        dbo.FuncDeleteCharPrefix(l1.リスト,default)
        , N'、', CHAR(13)
    )
    as 発注日付
,
    replace(
        dbo.FuncDeleteCharPrefix(l1.リスト,default)
        , N'、', CHAR(13)+CHAR(10)
    )
    as 発注日付出力
,
    replace(
        dbo.FuncDeleteCharPrefix(l2.リスト,default)
        , N'、', CHAR(13)
    )
    as 発注数量
,
    replace(
        dbo.FuncDeleteCharPrefix(l2.リスト,default)
        , N'、', CHAR(13)+CHAR(10)
    )
    as 発注数量出力
,
    replace(
        dbo.FuncDeleteCharPrefix(l3.リスト,default)
        , N'、', CHAR(13)
    )
    as 発注金額
,
    replace(
        dbo.FuncDeleteCharPrefix(l3.リスト,default)
        , N'、', CHAR(13)+CHAR(10)
    )
    as 発注金額出力
,
    replace(
        dbo.FuncDeleteCharPrefix(l4.リスト,default)
        , N'、', CHAR(13)
    )
    as 購入先
,
    replace(
        dbo.FuncDeleteCharPrefix(l4.リスト,default)
        , N'、', CHAR(13)+CHAR(10)
    )
    as 購入先出力
,	g0.支払完了日付
,	g0.支払日付
,	g0.支払金額
from
	工事台帳_Qリスト as a0
inner JOIN
	p0 as b0
    on b0.工事年度 = a0.工事年度
    and b0.工事種別 = a0.工事種別
    and b0.工事項番 = a0.工事項番
cross apply
    (
    select top 100 percent
        concat(N'、',p000.商品名)
    from
		p0 as p000
    where
        ( p000.工事年度 = a0.工事年度 )
        and ( p000.工事種別 = a0.工事種別 )
        and ( p000.工事項番 = a0.工事項番 )
    order by
        p000.工事年度
    ,	p000.工事種別
    ,	p000.工事項番
    ,	p000.分類コード
    for XML PATH ('')
    )
    as l0 (リスト)
cross apply
    (
    select top 100 percent
        concat(N'、',p001.日付)
    from
		p0 as p001
    where
        ( p001.工事年度 = a0.工事年度 )
        and ( p001.工事種別 = a0.工事種別 )
        and ( p001.工事項番 = a0.工事項番 )
    order by
        p001.工事年度
    ,	p001.工事種別
    ,	p001.工事項番
    ,	p001.分類コード
    for XML PATH ('')
    )
    as l1 (リスト)
cross apply
    (
    select top 100 percent
        concat(N'、',p002.数量)
    from
		p0 as p002
    where
        ( p002.工事年度 = a0.工事年度 )
        and ( p002.工事種別 = a0.工事種別 )
        and ( p002.工事項番 = a0.工事項番 )
    order by
        p002.工事年度
    ,	p002.工事種別
    ,	p002.工事項番
    ,	p002.分類コード
    for XML PATH ('')
    )
    as l2 (リスト)
cross apply
    (
    select top 100 percent
        concat(N'、',p003.金額)
    from
		p0 as p003
    where
        ( p003.工事年度 = a0.工事年度 )
        and ( p003.工事種別 = a0.工事種別 )
        and ( p003.工事項番 = a0.工事項番 )
    order by
        p003.工事年度
    ,	p003.工事種別
    ,	p003.工事項番
    ,	p003.分類コード
    for XML PATH ('')
    )
    as l3 (リスト)
cross apply
    (
    select top 100 percent
        concat(N'、',p004.支払先)
    from
		p0 as p004
    where
        ( p004.工事年度 = a0.工事年度 )
        and ( p004.工事種別 = a0.工事種別 )
        and ( p004.工事項番 = a0.工事項番 )
    order by
        p004.工事年度
    ,	p004.工事種別
    ,	p004.工事項番
    ,	p004.分類コード
    for XML PATH ('')
    )
    as l4 (リスト)
left outer join
	(
	SELECT
		zga0.工事年度
	,	zga0.工事種別
	,	zga0.工事項番
	,	MAX(zga0.確定日付) AS 支払完了日付
	,	MAX(zgc0.支払日付) AS 支払日付
	,	SUM(zgc0.支払金額) AS 支払金額
	FROM
		支払_T AS zga0
	LEFT OUTER JOIN
		支払_T支払先 AS zgc0
	    ON zgc0.工事年度 = zga0.工事年度
	    AND zgc0.工事種別 = zga0.工事種別
	    AND zgc0.工事項番 = zga0.工事項番
	GROUP BY
		zga0.工事年度
	,	zga0.工事種別
	,	zga0.工事項番
	)
    AS g0
    ON g0.工事年度 = a0.工事年度
    AND g0.工事種別 = a0.工事種別
    AND g0.工事項番 = a0.工事項番
)

select
	*
,
	concat(
		case
			when isnull(支払金額,'') <> ''
			then dbo.FuncMakeMoneyFormat(isnull(支払金額,0))
			else N''
		end,
		case
			when isnull(支払完了日付,'') <> ''
			then
				concat(
					case
						when isnull(支払金額,'') <> ''
						then char(13)
						else N''
					end,
					N'【完了】',
					format(支払完了日付,'d')
				)
			when isnull(支払日付,'') <> ''
			then
				concat(
					case
						when isnull(支払金額,'') <> ''
						then char(13)
						else N''
					end,
					N'【支払】',
					format(支払日付,'d')
				)
			else N''
		end
	)
	as 支払金額表示
,
	dbo.FuncMakeConstructSubject(
		CONCAT(N'工事件名','#'),
		工事番号,
		工事件名,
		ISNULL(受注金額,0),
		DEFAULT)
	as 工事件名グループ
,
	CONCAT(
		取引先略称,
		CASE
			WHEN ISNULL([JV出資比率],N'') <> N''
			THEN CONCAT(CHAR(13),[JV出資比率])
			ELSE N''
		END
	)
	as [発注先JV]
,
	dbo.FuncMakeMoneyFormat(ISNULL(受注金額,0))
	as 税別受注金額文字列
,
	dbo.FuncMakeMoneyFormat(ISNULL(受注金額,0)+ISNULL(消費税額,0))
	as 税込受注金額文字列
from
	v0 as v000
