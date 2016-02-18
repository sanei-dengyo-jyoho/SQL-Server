with

p0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	min(支払日付) as 支払自日付
,	max(支払日付) as 支払至日付
from
	支払_T支払先 as pa0
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
,	ct0.支払自日付 as 支払日付
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
	bt1.支払日付 < ct1.支払至日付
)
,

v0 as
(
select
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	c0.年*100+c0.月 as 支払年月
,	sum(b0.支払金額) as 支払金額
from
	cte as a0
left outer join
	支払_T支払先 as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
	and b0.支払日付 = a0.支払日付
left outer join
	カレンダ_T as c0
	on c0.日付 = a0.支払日付
group by
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	c0.年
,	c0.月
)
,

v1 AS
(
SELECT TOP 100 PERCENT
	工事年度
,	工事種別
,	工事項番
,	支払年月
,	支払金額
,	SUM(支払金額)
	OVER(
		PARTITION BY
			工事年度
		,	工事種別
		,	工事項番
		ORDER BY
			工事年度
		,	工事種別
		,	工事項番
		,	支払年月
	) AS 支払金額累計
FROM
	v0 AS a1
ORDER BY
	工事年度
,	工事種別
,	工事項番
,	支払年月
)

select
	*
from
	v1 as v100
