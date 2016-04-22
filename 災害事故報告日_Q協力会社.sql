with

v0 as
(
select
	a0.協力会社コード
,	a0.部門コード
,	a0.日付
,	isnull(r0.災害コード,11) as 災害コード
from
	災害事故報告_T as a0
left outer join
	休業コード_Q as r0
	on r0.休業コード = a0.休業コード
where
	( isnull(a0.労災認定,0) <> 0 )
)
,

v1 as
(
select
	s1.協力会社コード
,	max(a1.部門コード) as 部門コード
,	a1.日付
,	a1.災害コード
from
	協力会社_T as s1
left outer join
	(
	select
		a10.協力会社コード
	,	null as 部門コード
	,	cast('2002-05-01' as datetime) as 日付
	,	1 as 災害コード
	from
		協力会社_T as a10

	union all

	select
		a11.協力会社コード
	,	null as 部門コード
	,	a11.日付
	,	1 as 災害コード
	from
		協力会社_T発足日 as a11

	union all

	select
		a12.協力会社コード
	,	a12.部門コード
	,	a12.日付
	,	a12.災害コード
	from
		v0 as a12

	union all

	select
		a13.協力会社コード
	,	a13.部門コード
	,	dateadd(day,1,a13.日付) as 日付
	,	2 as 災害コード
	from
		v0 as a13
	)
	as a1
	on a1.協力会社コード = s1.協力会社コード
group by
	s1.協力会社コード
,	a1.日付
,	a1.災害コード
)

select
	*
from
	v1 as v100
