with

g0 as
(
select
	ga0.工事年度
,	ga0.工事種別
,	ga0.工事項番
,	ga0.タスク番号
,	ga0.タスク名
,	gb0.サブタスク番号
,	gb0.サブタスク名
,	min(gc0.日付) as 開始日付
,	max(gc0.日付) as 終了日付
from
	工事進捗管理_Tタスク as ga0
inner join
	工事進捗管理_Tサブタスク as gb0
	on gb0.工事年度 = ga0.工事年度
	and gb0.工事種別 = ga0.工事種別
	and gb0.工事項番 = ga0.工事項番
	and gb0.タスク番号 = ga0.タスク番号
inner join
	工事進捗管理_Tサブタスク_出来高 as gc0
	on gc0.工事年度 = gb0.工事年度
	and gc0.工事種別 = gb0.工事種別
	and gc0.工事項番 = gb0.工事項番
	and gc0.タスク番号 = gb0.タスク番号
	and gc0.サブタスク番号 = gb0.サブタスク番号
group by
	ga0.工事年度
,	ga0.工事種別
,	ga0.工事項番
,	ga0.タスク番号
,	ga0.タスク名
,	gb0.サブタスク番号
,	gb0.サブタスク名
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
,	出来高
,	稼働人員
from
	工事進捗管理_Tサブタスク_出来高 as ta0
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
		max(t01.出来高) as 出来高
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
		and ( e01.タスク番号 = a0.タスク番号 )
		and ( e01.サブタスク番号 = a0.サブタスク番号 )
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
,	a1.タスク番号
,	a1.サブタスク番号
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
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	サブタスク番号
,	工期年度
,	工期年月
,	工期日付
,	出来高
,	稼働人員
from
	v1 as a1
)
,

v3 as
(
select
	dbo.FuncMakeConstructNumber(a3.工事年度,a3.工事種別,a3.工事項番) AS 工事番号
,	a3.工事年度
,	a3.工事種別
,	a3.工事項番
,	a3.タスク番号
,	a3.タスク名
,	a3.サブタスク番号
,	a3.サブタスク名
,	b3.工期年度
,	b3.工期年月
,	b3.工期日付
,
	case
		when b3.工期日付 > a3.開始日付
		then
			case
				when
					year(b3.工期日付) * 100 + month(b3.工期日付)
					<>
					year(a3.開始日付) * 100 + month(a3.開始日付)
				then datefromparts(year(b3.工期日付),month(b3.工期日付),1)
				else a3.開始日付
			end
		else datefromparts(year(a3.開始日付),month(a3.開始日付),1)
	end
	as 開始日付
,
	case
		when a3.終了日付 > b3.工期日付
		then eomonth(b3.工期日付)
		else a3.終了日付
	end
	as 終了日付
,	b3.出来高
,	b3.稼働人員
from
    g0 as a3
left outer join
	v2 as b3
	on b3.工事年度 = a3.工事年度
	and b3.工事種別 = a3.工事種別
	and b3.工事項番 = a3.工事項番
	and b3.タスク番号 = a3.タスク番号
	and b3.サブタスク番号 = a3.サブタスク番号
)

select
	*
from
	v3 as v300
