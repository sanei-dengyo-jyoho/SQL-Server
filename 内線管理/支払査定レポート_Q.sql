with

cte as
(
select
	ct0.工事年度
,	ct0.工事種別
,	ct0.工事項番
,	ct1.年度
,	ct1.年
,	ct1.月
,	ct1.日
,	ct1.日付 as 支払日付
from
	(
	select
		pa0.工事年度
	,	pa0.工事種別
	,	pa0.工事項番
	,	min(pa0.支払日付) as 開始日付
	,	max(pa0.支払日付) as 終了日付
	from
		(
		select
			qa0.工事年度
		,	qa0.工事種別
		,	qa0.工事項番
		,	qa0.支払日付
		from
			支払_T支払先 as qa0
		)
		as pa0
	group by
		pa0.工事年度
	,	pa0.工事種別
	,	pa0.工事項番
	)
	as ct0
-- 開始日から終了日までのレコードを生成 --
cross apply
	(
	select
		ct2.年度
	,	ct2.年
	,	ct2.月
	,	ct2.日
	,	ct2.日付
	from
		(
		select top 100 percent
			cal0.年度
		,	cal0.年
		,	cal0.月
		,	cal0.日
		,	cal0.日付
		from
			カレンダ_T as cal0
		order by
			cal0.日付
		)
		as ct2
	where
		( ct2.日付 between ct0.開始日付 and ct0.終了日付 )
	)
	as ct1
)
,

e0 AS
(
SELECT TOP 100 PERCENT
	ea1.工事年度
,	ea1.工事種別
,	ea1.工事項番
,	ea1.大分類
,	ea1.中分類
,	ea1.小分類
,	ea1.確定日付
,	ea1.支払年月
,	ea1.支払先
,	ea1.支払金額
,
	SUM(ea1.支払金額)
	OVER(
		PARTITION BY
			ea1.工事年度
		,	ea1.工事種別
		,	ea1.工事項番
		,	ea1.大分類
		,	ea1.中分類
		,	ea1.小分類
		ORDER BY
			ea1.工事年度
		,	ea1.工事種別
		,	ea1.工事項番
		,	ea1.大分類
		,	ea1.中分類
		,	ea1.小分類
		,	ea1.支払年月
	)
	AS 支払金額累計
,
	SUM(ea1.支払金額)
	OVER(
		PARTITION BY
			ea1.工事年度
		,	ea1.工事種別
		,	ea1.工事項番
	)
	AS 支払総額
,
	COUNT(ea1.小分類)
	OVER(
		PARTITION BY
			ea1.工事年度
		,	ea1.工事種別
		,	ea1.工事項番
		,	ea1.大分類
		,	ea1.中分類
	) * 2
	AS 支払回数
FROM
	(
	select
		ea0.工事年度
	,	ea0.工事種別
	,	ea0.工事項番
	,	eb0.大分類
	,	eb0.中分類
	,	eb0.小分類
	,	max(ep0.確定日付) as 確定日付
	,	ea0.年 * 100 + ea0.月 as 支払年月
	,	isnull(min(ep0.支払先1),min(ep0.支払先2)) as 支払先
	,	sum(isnull(ep0.支払金額,0)) as 支払金額
	from
		cte as ea0
	left outer join
		支払査定_Q全項目名 as eb0
		on eb0.工事年度 = ea0.工事年度
		and eb0.工事種別 = ea0.工事種別
		and eb0.工事項番 = ea0.工事項番
	left outer join
		支払査定_Q支払日付 as ep0
		on ep0.工事年度 = ea0.工事年度
		and ep0.工事種別 = ea0.工事種別
		and ep0.工事項番 = ea0.工事項番
		and ep0.大分類 = eb0.大分類
		and ep0.中分類 = eb0.中分類
		and ep0.小分類 = eb0.小分類
		and ep0.支払日付 = ea0.支払日付
	where
		( isnull(eb0.項目名,N'') <> N'' )
		and ( isnull(eb0.小分類,0) <> 999999 )
	group by
		ea0.工事年度
	,	ea0.工事種別
	,	ea0.工事項番
	,	eb0.大分類
	,	eb0.中分類
	,	eb0.小分類
	,	ea0.年
	,	ea0.月
	)
	AS ea1
ORDER BY
	ea1.工事年度
,	ea1.工事種別
,	ea1.工事項番
,	ea1.大分類
,	ea1.中分類
,	ea1.小分類
,	ea1.支払年月
)
,

v0 as
(
select
	xa0.工事年度
,	xa0.工事種別
,	xa0.工事項番
,	xb0.大分類
,	xb0.中分類
,	xb0.小分類
,	xb0.費目
,	xb0.項目名
,	isnull(xb0.契約先1,xb0.契約先2) as 契約先
,	xb0.契約金額
,	xb0.原価率
,	xd0.確定日付
,	xa0.支払年月
,	xa0.和暦支払年月
,	xd0.支払先
,	xd0.支払金額
,	xd0.支払金額累計
,	xd0.支払総額
,	xd0.支払総額 / xd0.支払回数 as 支払総額累計
,	xz0.請負総額
,	xz0.請負総額 / xd0.支払回数 as 請負総額累計
,
	case
		when isnull(xg0.工事項番,0) = 0
		then 0
		else 1
	end
	as 原価有無
from
	(
	select
		da0.工事年度
	,	da0.工事種別
	,	da0.工事項番
	,	da0.年 * 100 + da0.月 as 支払年月
	,
		concat(
			convert(nvarchar(4),dw0.年号略称),
			convert(nvarchar(4),da0.年),
			N'年',
			convert(nvarchar(2),da0.月),
			N'月'
		)
		as 和暦支払年月
	from
		cte as da0
	left outer join
		和暦_T as dw0
		ON dw0.西暦 = da0.年
	group by
		da0.工事年度
	,	da0.工事種別
	,	da0.工事項番
	,	dw0.年号略称
	,	da0.年
	,	da0.月
	)
	as xa0
left outer join
	支払査定_Q全項目名 as xb0
	on xb0.工事年度 = xa0.工事年度
	and xb0.工事種別 = xa0.工事種別
	and xb0.工事項番 = xa0.工事項番
left outer join
	工事原価_T as xg0
	on xg0.工事年度 = xa0.工事年度
	and xg0.工事種別 = xa0.工事種別
	and xg0.工事項番 = xa0.工事項番
left outer join
	e0 as xd0
	on xd0.工事年度 = xa0.工事年度
	and xd0.工事種別 = xa0.工事種別
	and xd0.工事項番 = xa0.工事項番
	and xd0.大分類 = xb0.大分類
	and xd0.中分類 = xb0.中分類
	and xd0.小分類 = xb0.小分類
	and xd0.支払年月 = xa0.支払年月
left outer join
	(
	SELECT
	   	za0.工事年度
	,	za0.工事種別
	,	za0.工事項番
	,	isnull(zb0.請負受注金額,za0.受注金額) AS 請負総額
	from
	    工事台帳_T as za0
	left outer join
		(
		select
		    ya0.工事年度
		,	ya0.工事種別
		,	ya0.工事項番
		,	sum(ya0.請負受注金額) as 請負受注金額
		from
		    工事台帳_T共同企業体 as ya0
		group by
		    ya0.工事年度
		,	ya0.工事種別
		,	ya0.工事項番
		)
		as zb0
		on zb0.工事年度 = za0.工事年度
		and zb0.工事種別 = za0.工事種別
		and zb0.工事項番 = za0.工事項番
	)
	as xz0
	on xz0.工事年度 = xa0.工事年度
	and xz0.工事種別 = xa0.工事種別
	and xz0.工事項番 = xa0.工事項番
where
	( isnull(xb0.項目名,N'') <> N'' )
)

select
	*
from
	v0 as v000
