with

t1 as
(
select distinct
	t00.年度
,	t00.年
,	t00.月
,	t00.年月
,	t00.部所グループコード
,	t00.部所コード
from
	(
	select
		a0.年度
	,	a0.年
	,	a0.月
	,	a0.年月
	,	a0.部所グループコード
	,	a0.部所コード
	from
		部所_Q全社一覧_最新_年月 as a0
	inner join
		(
		select
			max(r00.年月) as 年月
		,	r00.部所グループコード
		,	r00.部所コード
		from
			無災害記録_T as r00
		group by
			r00.部所グループコード
		,	r00.部所コード
		)
		as b0
		on b0.年月 > a0.年月

	union all

	select
		q1.年度
	,	q1.年
	,	q1.月
	,	q1.年月
	,	q1.部所グループコード
	,	q1.部所コード
	from
		無災害記録_T as q1

	union all

	select
		a1.年度
	,	a1.年
	,	a1.月
	,	a1.年月
	,	a1.部所グループコード
	,	a1.部所コード
	from
		部所_Q全社一覧_最新_年月 as a1
	inner join
		(
		select
			max(r00.年月) as 年月
		,	r00.部所グループコード
		,	r00.部所コード
		from
			無災害記録_T as r00
		group by
			r00.部所グループコード
		,	r00.部所コード
		)
		as b1
		on b1.年月 < a1.年月
	)
	as t00
)
,

v0 as
(
select
	a.年度
,	a.年
,	a.月
,	a.年月
,	a.部所グループコード
,	a.部所コード
,	isnull(b.部所グループ名,isnull(c.部所グループ名,N'')) as 部所グループ名
,	isnull(b.部所名,isnull(c.部所名,N'')) as 部所名
,	isnull(b.赤,isnull(c.赤,255)) as 赤
,	isnull(b.緑,isnull(c.緑,255)) as 緑
,	isnull(b.青,isnull(c.青,255)) as 青
,	isnull(b.人数,isnull(c.人員,0)) as 人数
from
	t1 as a
left join
	部所_Q全社一覧_最新_年月 as b
	on b.年度 = a.年度
	and b.年 = a.年
	and b.月 = a.月
	and b.部所グループコード = a.部所グループコード
	and b.部所コード = a.部所コード
left join
	無災害記録_T as c
	on c.年度 = a.年度
	and c.年 = a.年
	and c.月 = a.月
	and c.部所グループコード = a.部所グループコード
	and c.部所コード = a.部所コード
)

select
	*
from
	v0 as v00
