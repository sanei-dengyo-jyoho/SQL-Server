with

e0 as
(
select top 100 percent
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	サブタスク番号
,	日付
,	max(人数) as 人数
from
	工事進捗管理_Tサブタスク_人数 as ea0
group by
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	サブタスク番号
,	日付
order by
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	サブタスク番号
,	日付 desc
)
,

t0 as
(
select top 100 percent
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	サブタスク番号
,	日付
,	max(進捗率) as 進捗率
from
	工事進捗管理_Tサブタスク_出来高 as ta0
group by
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	サブタスク番号
,	日付
order by
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	サブタスク番号
,	日付 desc
)
,

z0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	サブタスク番号
,	min(日付) as 開始日付
,	max(日付) as 終了日付
from
	t0 as xa0
group by
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	サブタスク番号
)
,

cte0
(
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	サブタスク番号
,	日付
)
as
(
select
	ct0.工事年度
,	ct0.工事種別
,	ct0.工事項番
,	ct0.タスク番号
,	ct0.サブタスク番号
,	ct0.開始日付 as 日付
from
	z0 as ct0

union all

select
	bt1.工事年度
,	bt1.工事種別
,	bt1.工事項番
,	bt1.タスク番号
,	bt1.サブタスク番号
,	dateadd(day,1,bt1.日付) as 日付
from
	cte0 as bt1
inner join
	z0 as ct1
	on ct1.工事年度 = bt1.工事年度
	and ct1.工事種別 = bt1.工事種別
	and ct1.工事項番 = bt1.工事項番
	and ct1.タスク番号 = bt1.タスク番号
	and ct1.サブタスク番号 = bt1.サブタスク番号
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
,	a0.タスク番号
,	a0.サブタスク番号
,	a0.日付
,
	(
	select top 1
		max(t01.進捗率) as 進捗率
	from
		t0 as t01
	where
		( t01.工事年度 = a0.工事年度 )
		and ( t01.工事種別 = a0.工事種別 )
		and ( t01.工事項番 = a0.工事項番 )
		and ( t01.タスク番号 = a0.タスク番号 )
		and ( t01.サブタスク番号 = a0.サブタスク番号 )
		and ( t01.日付 <= a0.日付 )
	)
	as 進捗率
,
	(
	select top 1
		max(e01.人数) as 人数
	from
		e0 as e01
	where
		( e01.工事年度 = a0.工事年度 )
		and ( e01.工事種別 = a0.工事種別 )
		and ( e01.工事項番 = a0.工事項番 )
		and ( e01.タスク番号 = a0.タスク番号 )
		and ( e01.サブタスク番号 = a0.サブタスク番号 )
		and ( e01.日付 <= a0.日付 )
	)
	as 人数
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
,	a1.タスク番号
,	a1.サブタスク番号
,	c1.年度 as 工期年度
,	c1.年 * 100 + c1.月 as 工期年月
,	max(a1.日付) as 工期日付
,	max(a1.進捗率) as 進捗率
,	max(a1.人数) as 人数
from
	v0 as a1
left outer join
	カレンダ_T as c1
	on c1.日付 = a1.日付
group by
	a1.工事年度
,	a1.工事種別
,	a1.工事項番
,	a1.タスク番号
,	a1.サブタスク番号
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
,	タスク番号
,	サブタスク番号
,	工期年度
,	工期年月
,	工期日付
,	進捗率
,	人数
from
	v1 as a1
)

select
	*
from
	v2 as v200
