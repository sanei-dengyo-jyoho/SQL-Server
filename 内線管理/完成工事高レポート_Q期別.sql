with

v0 as
(
SELECT
	a0.年度
,	a0.和暦年度
,	a0.期
,	a0.期別
,	a0.和暦年
,	a0.年月
,	a0.年
,	a0.月
,	a0.月分
,	a0.上下期
,	a0.上下期名
,	b0.税別受注金額
,	b0.消費税率
,	b0.消費税額
,	b0.税込受注金額
from
	繰越年月 as a0
left outer join
	完成工事高 as b0
	on b0.完工年 = a0.年
	and b0.完工月 = a0.月
)

select
	*
from
	v0 as v000
