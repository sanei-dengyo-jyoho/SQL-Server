with

q0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	小分類
,	支払日付
,	支払先
,	支払金額
from
	支払_T支払先 as qa0
)
,

p0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	min(支払日付) as 開始日付
,	max(支払日付) as 終了日付
from
	q0 as pa0
group by
	工事年度
,	工事種別
,	工事項番
)
,

cte
(
	工事年度
,	工事種別
,	工事項番
,	支払日付
)
as
(
select
	ct0.工事年度
,	ct0.工事種別
,	ct0.工事項番
,	ct0.開始日付 as 支払日付
from
	p0 as ct0

union all

select
	bt1.工事年度
,	bt1.工事種別
,	bt1.工事項番
,	dateadd(day,1,bt1.支払日付) as 支払日付
from
	cte as bt1
inner join
	p0 as ct1
	on ct1.工事年度 = bt1.工事年度
	and ct1.工事種別 = bt1.工事種別
	and ct1.工事項番 = bt1.工事項番
where
	bt1.支払日付 < ct1.終了日付
)
,

d0 as
(
select
	da0.工事年度
,	da0.工事種別
,	da0.工事項番
,	dc0.年*100+dc0.月 as 支払年月
,	convert(nvarchar(10),dc0.和暦年表示略称)+N'年'+convert(nvarchar(2),dc0.月)+N'月' as 和暦支払年月
from
	cte as da0
left outer join
	カレンダ_Q as dc0
	on dc0.日付 = da0.支払日付
group by
	da0.工事年度
,	da0.工事種別
,	da0.工事項番
,	dc0.和暦年表示略称
,	dc0.年
,	dc0.月
)
,

e0 as
(
select
	ea0.工事年度
,	ea0.工事種別
,	ea0.工事項番
,	eb0.大分類
,	eb0.中分類
,	eb0.小分類
,	max(ep0.確定日付) as 確定日付
,	ec0.年*100+ec0.月 as 支払年月
,	isnull(min(ep0.支払先1),min(ep0.支払先2)) as 支払先
,	sum(ep0.支払金額) as 支払金額
from
	cte as ea0
left outer join
	支払査定_Q項目名 as eb0
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
left outer join
	カレンダ_T as ec0
	on ec0.日付 = ea0.支払日付
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
,	ec0.年
,	ec0.月
)
,

e1 AS
(
SELECT TOP 100 PERCENT
	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	小分類
,	確定日付
,	支払年月
,	支払先
,	支払金額
,	SUM(支払金額)
	OVER(
		PARTITION BY
			工事年度
		,	工事種別
		,	工事項番
		,	大分類
		,	中分類
		,	小分類
		ORDER BY
			工事年度
		,	工事種別
		,	工事項番
		,	大分類
		,	中分類
		,	小分類
		,	支払年月
	) AS 支払金額累計
,	SUM(支払金額)
	OVER(
		PARTITION BY
			工事年度
		,	工事種別
		,	工事項番
	) AS 支払総額
,	COUNT(小分類)
	OVER(
		PARTITION BY
			工事年度
		,	工事種別
		,	工事項番
		,	大分類
		,	中分類
	) * 2 AS 支払回数
FROM
	e0 AS ea1
ORDER BY
	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	小分類
,	支払年月
)
,

y0 as
(
select
    工事年度
,   工事種別
,   工事項番
,   sum(請負受注金額) as 請負受注金額
,   sum(請負消費税額) as 請負消費税額
from
    工事台帳_T共同企業体 as ya0
group by
    工事年度
,   工事種別
,   工事項番
)
,

z0 AS
(
SELECT
   	za0.工事年度
,	za0.工事種別
,	za0.工事項番
,	isnull(zb0.請負受注金額,za0.受注金額) + isnull(zb0.請負消費税額,za0.消費税額) AS 請負総額
from
    工事台帳_T as za0
left outer join
	y0 as zb0
	on zb0.工事年度 = za0.工事年度
	and zb0.工事種別 = za0.工事種別
	and zb0.工事項番 = za0.工事項番
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
from
	d0 as xa0
left outer join
	支払査定_Q項目名 as xb0
	on xb0.工事年度 = xa0.工事年度
	and xb0.工事種別 = xa0.工事種別
	and xb0.工事項番 = xa0.工事項番
left outer join
	e1 as xd0
	on xd0.工事年度 = xa0.工事年度
	and xd0.工事種別 = xa0.工事種別
	and xd0.工事項番 = xa0.工事項番
	and xd0.大分類 = xb0.大分類
	and xd0.中分類 = xb0.中分類
	and xd0.小分類 = xb0.小分類
	and xd0.支払年月 = xa0.支払年月
left outer join
	z0 as xz0
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
