with

v0 as
(
select top 1
	min(年度) as 最小年度
,	max(年度) as 最大年度
from
	協力会社_Q年度 as a0
)
,

v1 as
(
select
	a1.年度
,	a1.年
,	a1.月
,	a1.年 * 100 + a1.月 as 年月
from
	カレンダ_T as a1
inner join
	v0 as b1
	on a1.年度 >= b1.最小年度
	and a1.年度 <= b1.最大年度
group by
	a1.年度
,	a1.年
,	a1.月
)
,

s0 as
(
select
	a2.年度
,	a2.年
,	a2.月
,	a2.年月
,	b2.協力会社コード
,	b2.協力会社名
,	isnull(c2.登録人員,isnull(b2.人数,0)) as 人数
from
	v1 as a2
left outer join
	協力会社_Q年度 as b2
	on b2.年度 = a2.年度
left outer join
	無災害記録_T協力会社 as c2
	on c2.年度 = a2.年度
	and c2.年 = a2.年
	and c2.月 = a2.月
	and c2.協力会社コード = b2.協力会社コード
)

select
	*
from
	v2 as a3

