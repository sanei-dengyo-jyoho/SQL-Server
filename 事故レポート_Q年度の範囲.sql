with

v0 as
(
select
	a0.年度

from
	災害事故報告_T as a0

union all

select
	b0.年度

from
	車両事故報告_T as b0
)
,

v1 as
(
select
	年度

from
	v0 as a1

group by
	年度
)
,

v2 as
(
select
	convert(int, a2.年度) as 年度
,	convert(varchar(4), a2.年度) + '年度' as 年度表示
,	isnull(w2.年号,'') + dbo.FuncGetNumberFixed(isnull(w2.年,0), default) + '年度' as 和暦年度表示

from
	v1 as a2
left outer join
	和暦_T as w2
	on w2.西暦 = a2.年度
)

select
	*

from
	v2 as a3




