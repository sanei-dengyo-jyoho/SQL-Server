with

q0 as
(
select
	q000.*
from
	協力会社_Q年度 as q000
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
,	isnull(p.人数,0) as 人数
from
	(
	select
		c00.年度
	,	c00.年
	,	c00.月
	,	c00.年 * 100 + c00.月 as 年月
	from
		カレンダ_T as c00
	inner join
		(
		select top 1
			min(p000.年度) as 最小年度
		,	max(p000.年度) as 最大年度
		from
			q0 as p000
		)
		as p00
		on c00.年度 >= p00.最小年度
		and c00.年度 <= p00.最大年度
	group by
		c00.年度
	,	c00.年
	,	c00.月
	)
	as c
LEFT OUTER JOIN
	q0 as p
	on p.年度 = c.年度
)

select
	*
from
	s0 as s00
