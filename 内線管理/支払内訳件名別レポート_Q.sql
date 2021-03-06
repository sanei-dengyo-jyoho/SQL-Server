with

v0 as
(
SELECT
   	dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	isnull(g0.取引先コード,999999) as 取引先コード
,	isnull(h0.取引先名,N'（定期支払）') as 取引先名
,	isnull(h0.取引先略称,N'（定期支払）') as 取引先略称
,	g0.取引先担当
,	isnull(a0.工事件名,g0.工事件名) as 工事件名
,	g0.受注日付
,	isnull(j0.請負受注金額,g0.受注金額) AS 受注金額
,	g0.消費税率
,	isnull(j0.請負消費税額,g0.消費税額) AS 消費税額
,	a0.支払日付
,	c0.年度 as 支払年度
,	year(a0.支払日付) as 支払年
,	month(a0.支払日付) as 支払月
,	year(a0.支払日付) * 100 + month(a0.支払日付) as 支払年月
,	b0.支払先種別コード
,
	case
		when d0.支払先種別名 = N'資材'
		then N'資材'
		else N'一般'
	end
    as 支払種別
,	a0.支払先コード
,	b0.支払先名
,	b0.支払先略称 as 支払先
,	a0.支払金額
,
	convert(money,
		floor(a0.支払金額 *
			(
			select top 1
				r1.消費税率
			from
				(
				select
					ra0.年月
				,	ra0.固定 as 消費税率
				from
					数値条件_Q as ra0
				where
					( ra0.名前 = N'消費税率' )
				)
				as r1
			where
				( r1.年月 <= (year(a0.支払日付) * 100 + month(a0.支払日付)) )
			order by
				r1.年月 desc
			)
			/ 100
		)
	) as 支払消費税額
from
    (
    SELECT distinct
		tc0.工事年度
	,	tc0.工事種別
	,	tc0.工事項番
	,	tc0.支払日付
	,	tc0.支払先コード
	,	tc0.支払金額
	,	null as 工事件名
    from
    	支払_T as ta0
    inner join
    	支払_T項目名 as tb0
        on tb0.工事年度 = ta0.工事年度
        and tb0.工事種別 = ta0.工事種別
        and tb0.工事項番 = ta0.工事項番
    inner join
    	支払_T支払先 as tc0
        on tc0.工事年度 = tb0.工事年度
        and tc0.工事種別 = tb0.工事種別
        and tc0.工事項番 = tb0.工事項番
        and tc0.大分類 = tb0.大分類
        and tc0.中分類 = tb0.中分類
        and tc0.小分類 = tb0.小分類

	UNION ALL

    SELECT distinct
		9999 as 工事年度
	,	format(pc0.支払先コード,'D6') as 工事種別
	,	pc0.支払先項番 as 工事項番
	,	pc0.支払日付
	,	pc0.支払先コード
	,	pc0.支払金額
	,	pa0.工事件名
    from
    	定期支払_T as pa0
    inner join
    	定期支払_T支払先 as pc0
        on pc0.支払先コード = pa0.支払先コード
        and pc0.支払先項番 = pa0.支払先項番
    )
	as a0
inner join
	支払先_T as b0
	on b0.支払先コード = a0.支払先コード
left outer join
	支払先種別_T as d0
	on d0.支払先種別コード = b0.支払先種別コード
left outer join
	カレンダ_T as c0
	on c0.日付 = a0.支払日付
left outer join
    工事台帳_T as g0
    on g0.工事年度 = a0.工事年度
    and g0.工事種別 = a0.工事種別
    and g0.工事項番 = a0.工事項番
left outer join
    発注先_Q AS h0
    on h0.工事種別 = g0.工事種別
    and h0.取引先コード = g0.取引先コード
left outer join
    (
    select
        ya0.工事年度
    ,	ya0.工事種別
    ,	ya0.工事項番
    ,	sum(ya0.請負受注金額) as 請負受注金額
    ,	sum(ya0.請負消費税額) as 請負消費税額
    from
        工事台帳_T共同企業体 as ya0
    group by
        ya0.工事年度
    ,	ya0.工事種別
    ,	ya0.工事項番
    )
	as j0
    on j0.工事年度 = a0.工事年度
    and j0.工事種別 = a0.工事種別
    and j0.工事項番 = a0.工事項番
)

SELECT
	*
FROM
	v0 as v000
