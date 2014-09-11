with

v0 as
(
select
	年度

from
	車両事故報告_T as a0

group by
	年度
)
,

v1 as
(
select
	isnull(w1.年号,'') + dbo.FuncGetNumberFixed(isnull(w1.年,0), default) + '年度' as 年度集計
,	convert(int, a1.年度) as 年度

from
	v0 as a1
left outer join
	和暦_T as w1
	on w1.西暦 = a1.年度
)

select
	*

from
	v1 as a2
