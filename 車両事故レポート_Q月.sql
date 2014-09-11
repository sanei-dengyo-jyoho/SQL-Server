with

v0 as
(
select
	年度

from
	車両事故報告_T as y

group by
	年度
)
,

v1 as
(
select
	c.年度
,	c.年
,	c.月
,	c.年 * 100 + c.月 as 年月

from
	v0 as v
left outer join
	カレンダ_T as c
	on c.年度 = v.年度

group by
	c.年度
,	c.年
,	c.月
)
,

v2 as
(
select
	isnull(w.年号,'') + dbo.FuncGetNumberFixed(isnull(w.年,0),	default) + '年度' as 年集計
,	convert(int,b.年度) as 年
,	convert(varchar(4),b.月)+'月' as 月集計
,	convert(int,b.月) as 月
,	convert(int,b.年月) as 年月
,	a.[管理№] as 番号
,	case isnull(a.[管理№],'') when '' then 0 else 1 end as 値

from v1 as b
left outer join
	車両事故報告_T as a
	on a.年度 = b.年度
	and a.年月 = b.年月
left outer join
	和暦_T as w
	on w.西暦 = b.年度
)

select
	*

from
	v2 as t2


