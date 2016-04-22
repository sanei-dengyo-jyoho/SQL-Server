with

v0 as
(
select
	s0.部所グループコード
,	s0.部所コード
,	a0.部門コード
,	a0.日付
,	isnull(r0.災害コード,11) as 災害コード
from
	車両事故報告_T as a0
inner join
	部所部門_T as s0
	on s0.部門コード = a0.部門コード
left outer join
	休業コード_Q as r0
	on r0.休業コード = 0
where
	( isnull(a0.過失比率当社,0) >= 50 )
)
,

v1 as
(
select
	s1.部所グループコード
,	s1.部所コード
,	min(a1.部門コード) as 部門コード
,	a1.日付
,	a1.災害コード
from
	部所_T as s1
left outer join
	(
	select
		a10.部所グループコード
	,	a10.部所コード
	,	null as 部門コード
	,	cast('2002-05-01' as datetime) as 日付
	,	1 as 災害コード
	from
		部所_T as a10

	union all

	select
		a11.部所グループコード
	,	a11.部所コード
	,	null as 部門コード
	,	a11.日付
	,	1 as 災害コード
	from
		部所_T発足日 as a11

	union all

	select
		a12.部所グループコード
	,	a12.部所コード
	,	a12.部門コード
	,	a12.日付
	,	a12.災害コード
	from
		v0 as a12

	union all

	select
		a13.部所グループコード
	,	a13.部所コード
	,	a13.部門コード
	,	dateadd(day,1,a13.日付) as 日付
	,	2 as 災害コード
	from
		v0 as a13
	)
	as a1
	on a1.部所グループコード = s1.部所グループコード
	and a1.部所コード = s1.部所コード
group by
	s1.部所グループコード
,	s1.部所コード
,	a1.日付
,	a1.災害コード
)

select
	*
from
	v1 as v100
