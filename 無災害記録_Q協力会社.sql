with

zw0 as
(
select
	zwc0.年度
,	zwa0.協力会社コード
,	zwa0.日付
,	zwa0.労災認定
from
	(
	select
		zwa00.日付
	,	zwa00.協力会社コード
	,	zwa00.労災認定
	from
		災害事故報告_T as zwa00

	union all

	select
		zwa01.日付
	,	zwa01.協力会社コード
	,	zwa01.労災認定
	from
		災害事故報告_T補正 as zwa01
	)
	as zwa0
inner join
	カレンダ_T as zwc0
	on zwc0.日付 = zwa0.日付
inner join
	協力会社_Q全年度 as zws0
	on zws0.年度 = zwc0.年度
	and zws0.協力会社コード = zwa0.協力会社コード
where
	( isnull(zwa0.労災認定,0) <> 0 )
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
	-- 労働災害 --
	------------
,
	dbo.FuncAccidentInitialDate(
		a2.労働災害発足日,
		a2.労働災害起算日
	)
	as 労働災害起算日
,	a2.労働災害報告日
,
	dbo.FuncAccidentMonthlyDays(
		a2.労働災害報告日,
		a2.年,
		a2.月
	)
	as 労働災害当月
,
	dbo.FuncAccidentTotalDays(
		a2.労働災害発足日,
		a2.労働災害起算日,
		a2.労働災害報告日,
		a2.年,
		a2.月
	)
	as 労働災害累計
from
	(
	select
		a0.年度
	,	a0.年
	,	a0.月
	,	a0.協力会社コード
		------------
		-- 労働災害 --
		------------
	,
		cast(
			isnull(w0.日付,'2002-05-01')
			as datetime
		)
		as 労働災害発足日
	,
		cast(
			case
				when isnull(w1.日付,'') = ''
				then '2002-05-01'
				else dateadd(day,1,w1.日付)
			end
			as datetime
		)
		as 労働災害起算日
	,	w2.日付 as 労働災害報告日
	from
		協力会社_Q一覧_年月 as a0
	------------
	-- 労働災害 --
	------------
	outer apply
		(
		select top 1
			max(w0d.日付) as 日付
		from
			協力会社_T発足日 as w0d
		where
			( w0d.日付
				<= eomonth(datefromparts(a0.年,a0.月,1))
			)
			and ( w0d.協力会社コード = a0.協力会社コード )
		)
		as w0 (日付)
	outer apply
		(
		select top 1
			max(w1d.日付) as 日付
		from
			zw0 as w1d
		where
			( w1d.日付
				<= eomonth(datefromparts(a0.年,a0.月,1))
			)
			and ( w1d.協力会社コード = a0.協力会社コード )
		)
		as w1 (日付)
	outer apply
		(
		select top 1
			max(w2d.日付) as 日付
		from
			zw0 as w2d
		where
			( w2d.日付
				between
				datefromparts(a0.年,a0.月,1)
				and
				eomonth(datefromparts(a0.年,a0.月,1))
			)
			and ( w2d.協力会社コード = a0.協力会社コード )
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
	-- 労働災害 --
	------------
,	a3.労働災害起算日
,	a3.労働災害報告日
,	a3.労働災害当月
,	a3.労働災害累計
,	null as 労働災害備考
from
	協力会社_Q一覧_年月 as z3
left outer join
	(
	select
		a30.年度
	,	a30.年
	,	a30.月
	,	a30.協力会社コード
	,	a30.労働災害起算日
	,	a30.労働災害報告日
	,	a30.労働災害当月
	,	a30.労働災害累計
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
