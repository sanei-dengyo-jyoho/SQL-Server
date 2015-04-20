with

q0 as
(
select
	*
from
	協力会社_Q年度 as q000
)
,

p0 as
(
select top 1
	min(年度) as 最小年度
,	max(年度) as 最大年度
from
	q0 as p000
)
,

c0 as
(
select
	c00.年度
,	c00.年
,	c00.月
,	c00.年 * 100 + c00.月 as 年月
from
	カレンダ_T as c00
inner join
	p0 as p00
	on c00.年度 >= p00.最小年度
	and c00.年度 <= p00.最大年度
group by
	年度
,	年
,	月
)
,

s0 as
(
select
	c.年度
,	c.年
,	c.月
,	c.年月
,	p.協力会社コード
,	p.協力会社名
,	isnull(r.登録人員,isnull(p.人数,0)) as 人数
from
	c0 as c
LEFT OUTER JOIN
	q0 as p
	on p.年度 = c.年度
LEFT OUTER JOIN
	無災害記録_T協力会社 as r
	on r.年度 = c.年度
	and r.年 = c.年
	and r.月 = c.月
	and r.協力会社コード = p.協力会社コード
)

select
	*
from
	s0 as s00

