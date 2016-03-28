with

x0 as
(
select top 100 percent
	工事年度
,	工事種別
,	工事項番
,	親タスク番号
,	親タスク名
,	タスク番号
,	タスク名
,	開始日付
,	終了日付 as 日付
,	進捗率
from
	工事管理_Qタスク as xa0
order by
	工事年度
,	工事種別
,	工事項番
,	親タスク番号
,	タスク番号
,	終了日付 desc
)
,

y0 as
(
select top 100 percent
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	日付
,	max(人数) as 人数
from
	工事管理_Tタスク人数 as ya0
group by
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	日付
order by
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	日付 desc
)
,

z0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	親タスク番号
,	親タスク名
,	タスク番号
,	タスク名
,	min(開始日付) as 開始日
,	max(日付) as 終了日
from
	x0 as za0
group by
	工事年度
,	工事種別
,	工事項番
,	親タスク番号
,	親タスク名
,	タスク番号
,	タスク名
)
,

cte0
(
	工事年度
,	工事種別
,	工事項番
,	親タスク番号
,	親タスク名
,	タスク番号
,	タスク名
,	日付
)
as
(
select
	ct0.工事年度
,	ct0.工事種別
,	ct0.工事項番
,	ct0.親タスク番号
,	ct0.親タスク名
,	ct0.タスク番号
,	ct0.タスク名
,	ct0.開始日 as 日付
from
	z0 as ct0

union all

select
	bt1.工事年度
,	bt1.工事種別
,	bt1.工事項番
,	bt1.親タスク番号
,	bt1.親タスク名
,	bt1.タスク番号
,	bt1.タスク名
,	dateadd(day,1,bt1.日付) as 日付
from
	cte0 as bt1
inner join
	z0 as ct1
	on ct1.工事年度 = bt1.工事年度
	and ct1.工事種別 = bt1.工事種別
	and ct1.工事項番 = bt1.工事項番
	and ct1.親タスク番号 = bt1.親タスク番号
	and ct1.親タスク名 = bt1.親タスク名
	and ct1.タスク番号 = bt1.タスク番号
	and ct1.タスク名 = bt1.タスク名
where
	bt1.日付 < ct1.終了日
)
,

v0 as
(
select
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.親タスク番号
,	a0.親タスク名
,	a0.タスク番号
,	a0.タスク名
,	a0.日付
,
	(
	select top 1
		max(x01.進捗率) as 進捗率
	from
		x0 as x01
	where
		( x01.工事年度 = a0.工事年度 )
		and ( x01.工事種別 = a0.工事種別 )
		and ( x01.工事項番 = a0.工事項番 )
		and ( x01.親タスク番号 = a0.親タスク番号 )
		and ( x01.親タスク名 = a0.親タスク名 )
		and ( x01.タスク番号 = a0.タスク番号 )
		and ( x01.タスク名 = a0.タスク名 )
		and ( x01.日付 <= a0.日付 )
	)
	as 進捗率
,
	(
	select top 1
		max(y01.人数) as 人数
	from
		y0 as y01
	where
		( y01.工事年度 = a0.工事年度 )
		and ( y01.工事種別 = a0.工事種別 )
		and ( y01.工事項番 = a0.工事項番 )
		and ( y01.タスク番号 = a0.タスク番号 )
		and ( y01.日付 <= a0.日付 )
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
,	a1.親タスク番号
,	a1.親タスク名
,	a1.タスク番号
,	a1.タスク名
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
,	a1.親タスク番号
,	a1.親タスク名
,	a1.タスク番号
,	a1.タスク名
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
,	親タスク番号
,	親タスク名
,	タスク番号
,	タスク名
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
