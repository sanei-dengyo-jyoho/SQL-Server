with

z0 as
(
select
	*
from
	災害事故報告_T as z000

where
	( isnull(労災認定,0) <> 0 )
)
,

z1 as
(
select
	*
from
	車両事故報告_T as z100
)
,

v00 as
(
select
	年度
from
	z0 as y00

union all

select
	年度
from
	z1 as y01
)
,

v0 as
(
select
	年度
from
	v00 as a1
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
LEFT OUTER JOIN
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
	convert(int,a2.年度) as 年度
,	convert(varchar(4),a2.年度) + '年度' as 年度表示
,	isnull(w2.年号,'') + dbo.FuncGetNumberFixed(isnull(w2.年,0),	default) + '年度' as 和暦年度表示
,	convert(varchar(2),a2.月) + '月' as 月表示
,	convert(int,a2.年) as 年
,	convert(int,a2.月) as 月
,	convert(int,a2.年月) as 年月
from
	v1 as a2
LEFT OUTER JOIN
	和暦_T as w2
	on w2.西暦 = a2.年度
)
,

v3 as
(
select
	v21.年度
,	v21.年度表示
,	v21.和暦年度表示
,	v21.月表示
,	v21.年
,	v21.月
,	v21.年月
,	convert(int,1) as 事故種別コード
,	convert(int,isnull(v31.[管理№],0)) as 番号
,	case isnull(v31.[管理№],	0) when 0 then 0 else 1 end as 値
from
	v2 as v21
LEFT OUTER JOIN
	z0 as v31
	on v31.年度 = v21.年度
	and v31.年月 = v21.年月

union all

select
	v22.年度
,	v22.年度表示
,	v22.和暦年度表示
,	v22.月表示
,	v22.年
,	v22.月
,	v22.年月
,	convert(int,2) as 事故種別コード
,	convert(int,isnull(v32.[管理№],0)) as 番号
,	case isnull(v32.[管理№],	0) when 0 then 0 else 1 end as 値
from
	v2 as v22
LEFT OUTER JOIN
	z1 as v32
	on v32.年度 = v22.年度
	and v32.年月 = v22.年月
)
,

v4 as
(
select
	年度
,	年度表示
,	和暦年度表示
,	月表示
,	年
,	月
,	年月
,	convert(int,0) as 事故種別コード
,	max(番号) as 番号
,	sum(値) as 値
from
	v3 as v33
group by
	年度
,	年度表示
,	和暦年度表示
,	月表示
,	年
,	月
,	年月
)
,

v5 AS
(
select
	v53.年度
,	v53.年度表示
,	v53.和暦年度表示
,	v53.月表示
,	v53.年
,	v53.月
,	v53.年月
,	v53.事故種別コード
,	v53.番号
,	v53.値
from
	v3 as v53

union all

select
	v54.年度
,	v54.年度表示
,	v54.和暦年度表示
,	v54.月表示
,	v54.年
,	v54.月
,	v54.年月
,	v54.事故種別コード
,	v54.番号
,	v54.値
from
	v4 as v54
)
,

v6 as
(
select
	a.年度
,	a.年度表示
,	a.和暦年度表示
,	a.月表示
,	a.年
,	a.月
,	a.年月
,	a.事故種別コード
,	b.事故種別
,	a.番号
,	a.値
from
	v5 as a
LEFT OUTER JOIN
	事故種別_Q as b
	on b.事故種別コード = a.事故種別コード
)

select
	*
from
	v6 as t6
