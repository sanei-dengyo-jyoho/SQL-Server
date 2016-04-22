with

zv0 as
(
select
	zvc0.年度
,	zva0.協力会社コード
,	zva0.日付
,	zva0.過失比率当社
from
	(
	select
		zva00.日付
	,	zva00.協力会社コード
	,	zva00.過失比率当社
	from
		車両事故報告_T as zva00

	union all

	select
		zva01.日付
	,	zva01.協力会社コード
	,	zva01.過失比率当社
	from
		車両事故報告_T補正 as zva01
	)
	as zva0
inner join
	カレンダ_T as zvc0
	on zvc0.日付 = zva0.日付
inner join
	協力会社_Q全年度 as zvs0
	on zvs0.年度 = zvc0.年度
	and zvs0.協力会社コード = zva0.協力会社コード
where
	( isnull(zva0.過失比率当社,0) >= 50 )
)
,

t2 as
(
select
	a2.年度
,	a2.年
,	a2.月
,	a2.協力会社コード
	------------
	-- 車両事故 --
	------------
,
	dbo.FuncAccidentInitialDate(
		a2.車両事故発足日,
		a2.車両事故起算日
	)
	as 車両事故起算日
,	a2.車両事故報告日
,
	dbo.FuncAccidentMonthlyDays(
		a2.車両事故報告日,
		a2.年,
		a2.月
	)
	as 車両事故当月
,
	dbo.FuncAccidentTotalDays(
		a2.車両事故発足日,
		a2.車両事故起算日,
		a2.車両事故報告日,
		a2.年,
		a2.月
	)
	as 車両事故累計
from
	(
	select
		a0.年度
	,	a0.年
	,	a0.月
	,	a0.協力会社コード
		------------
		-- 車両事故 --
		------------
	,
		cast(
			isnull(w0.日付,'2002-05-01')
			as datetime
		)
		as 車両事故発足日
	,
		cast(
			case
				when isnull(w1.日付,'') = ''
				then '2002-05-01'
				else dateadd(day,1,w1.日付)
			end
			as datetime
		)
		as 車両事故起算日
	,	w2.日付 as 車両事故報告日
	from
		協力会社_Q一覧_年月 as a0
	------------
	-- 車両事故 --
	------------
	outer apply
		(
		select top 1
			max(v0d.日付) as 日付
		from
			協力会社_T発足日 as v0d
		where
			( v0d.日付
				<= eomonth(datefromparts(a0.年,a0.月,1))
			)
			and ( v0d.協力会社コード = a0.協力会社コード )
		)
		as w0 (日付)
	outer apply
		(
		select top 1
			max(v1d.日付) as 日付
		from
			zv0 as v1d
		where
			( v1d.日付
				<= eomonth(datefromparts(a0.年,a0.月,1))
			)
			and ( v1d.協力会社コード = a0.協力会社コード )
		)
		as w1 (日付)
	outer apply
		(
		select top 1
			max(v2d.日付) as 日付
		from
			zv0 as v2d
		where
			( v2d.日付
				between
				datefromparts(a0.年,a0.月,1)
				and
				eomonth(datefromparts(a0.年,a0.月,1))
			)
			and ( v2d.協力会社コード = a0.協力会社コード )
		)
		as w2 (日付)
	)
	as a2
)
,

t3 as
(
select
	z3.年度
,	z3.年
,	z3.月
,	z3.年月
,	z3.協力会社コード
,	z3.協力会社名
,	z3.人数
	------------
	-- 車両事故 --
	------------
,	a3.車両事故起算日
,	a3.車両事故報告日
,	a3.車両事故当月
,	a3.車両事故累計
,	null as 車両事故備考
from
	協力会社_Q一覧_年月 as z3
left outer join
	(
	select
		a30.年度
	,	a30.年
	,	a30.月
	,	a30.協力会社コード
	,	a30.車両事故起算日
	,	a30.車両事故報告日
	,	a30.車両事故当月
	,	a30.車両事故累計
	from
		t2 as a30
	)
	as a3
	on a3.年度 = z3.年度
	and a3.年 = z3.年
	and a3.月 = z3.月
	and a3.協力会社コード = z3.協力会社コード
)

select
	*
from
	t3 as t300
