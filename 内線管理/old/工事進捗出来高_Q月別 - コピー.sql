with

q0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	日付
,	max(出来高) as 出来高
,	sum(稼働人員) as 稼働人員
from
	工事進捗管理_Tサブタスク_出来高 as qa0
group by
	工事年度
,	工事種別
,	工事項番
,	日付
)
,

t0 as
(
select top 100 percent
	工事年度
,	工事種別
,	工事項番
,	日付
,	出来高
,	稼働人員
from
	q0 as ta0
order by
	工事年度
,	工事種別
,	工事項番
,	日付 desc
)
,

z0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	min(日付) as 開始日付
,	max(日付) as 終了日付
from
	t0 as xa0
group by
	工事年度
,	工事種別
,	工事項番
)
,

cte0
(
	工事年度
,	工事種別
,	工事項番
,	日付
)
as
(
select
	ct0.工事年度
,	ct0.工事種別
,	ct0.工事項番
,	ct0.開始日付 as 日付
from
	z0 as ct0

union all

select
	bt1.工事年度
,	bt1.工事種別
,	bt1.工事項番
,	dateadd(day,1,bt1.日付) as 日付
from
	cte0 as bt1
inner join
	z0 as ct1
	on ct1.工事年度 = bt1.工事年度
	and ct1.工事種別 = bt1.工事種別
	and ct1.工事項番 = bt1.工事項番
where
	bt1.日付 < ct1.終了日付
)
,

v0 as
(
select
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.日付
,
	(
	select top 1
		max(t01.出来高) as 出来高
	from
		t0 as t01
	where
		( t01.工事年度 = a0.工事年度 )
		and ( t01.工事種別 = a0.工事種別 )
		and ( t01.工事項番 = a0.工事項番 )
		and ( t01.日付 <= a0.日付 )
	)
	as 出来高
,
	(
	select top 1
		e01.稼働人員
	from
		t0 as e01
	where
		( e01.工事年度 = a0.工事年度 )
		and ( e01.工事種別 = a0.工事種別 )
		and ( e01.工事項番 = a0.工事項番 )
		and ( e01.日付 = a0.日付 )
	)
	as 稼働人員
from
	cte0 as a0
)
,

v1 as
(
select distinct
	a1.工事年度
,	a1.工事種別
,	a1.工事項番
,	c1.年度 as 工期年度
,	c1.年 * 100 + c1.月 as 工期年月
,	max(a1.日付) as 工期日付
,	max(a1.出来高) as 出来高
,	sum(a1.稼働人員) as 稼働人員
from
	v0 as a1
left outer join
	カレンダ_T as c1
	on c1.日付 = a1.日付
group by
	a1.工事年度
,	a1.工事種別
,	a1.工事項番
,	c1.年度
,	c1.年
,	c1.月
)
,

v2 as
(
select
   	dbo.FuncMakeConstructNumber(工事年度,工事種別,工事項番) AS 工事番号
,	工事年度
,	工事種別
,	工事項番
,	工期年度
,	工期年月
,	工期日付
,	出来高
,	稼働人員
from
	v1 as a2
)

select
	*
from
	v2 as v200
