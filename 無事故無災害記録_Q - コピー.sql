with

t0 as
(
select
	a0.年度
,	a0.年
,	a0.月
,	a0.部所グループコード
,	a0.部所コード
	------------
	-- 労働災害 --
	------------
,
	cast(isnull(w0.日付,'2002-05-01') as datetime)
	as 労働災害報告起算日
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
,
	w2.日付
	as 労働災害報告日
	------------
	-- 車両事故 --
	------------
,
	cast(isnull(v0.日付,'2002-05-01') as datetime)
	as 車両事故報告起算日
,
	cast(
		case
			when isnull(v1.日付,'') = ''
			then '2002-05-01'
			else dateadd(day,1,v1.日付)
		end
		as datetime
	)
	as 車両事故起算日
,
	v2.日付
	as 車両事故報告日
from
	部所_Q全社一覧_最新_年月 as a0
------------
-- 労働災害 --
------------
outer apply
	(
	select top 1
		max(w0d.日付) as 日付
	from
		災害報告_T as w0d
	where
		( w0d.災害コード between 1 and 2 )
		and ( w0d.部所グループコード = a0.部所グループコード )
		and ( w0d.部所コード = a0.部所コード )
		and ( w0d.日付 <= eomonth(datefromparts(a0.年,a0.月,1)) )
	)
	as w0 (日付)
outer apply
	(
	select top 1
		max(w1d.日付) as 日付
	from
		災害事故報告_T as w1d
	inner join
		部所部門_T as w1s
		on w1s.部門コード = w1d.部門コード
	where
		( isnull(w1d.労災認定,0) <> 0 )
		and ( w1s.部所グループコード = a0.部所グループコード )
		and ( w1s.部所コード = a0.部所コード )
		and ( w1d.日付 <= eomonth(datefromparts(a0.年,a0.月,1)) )
	)
	as w1 (日付)
outer apply
	(
	select top 1
		max(w2d.日付) as 日付
	from
		災害事故報告_T as w2d
	inner join
		部所部門_T as w2s
		on w2s.部門コード = w2d.部門コード
	where
		( isnull(w2d.労災認定,0) <> 0 )
		and ( w2s.部所グループコード = a0.部所グループコード )
		and ( w2s.部所コード = a0.部所コード )
		and ( w2d.日付
				between
				datefromparts(a0.年,a0.月,1)
				and
				eomonth(datefromparts(a0.年,a0.月,1))
			)
	)
	as w2 (日付)
------------
-- 車両事故 --
------------
outer apply
	(
	select top 1
		max(v0d.日付) as 日付
	from
		事故報告_T as v0d
	where
		( v0d.災害コード between 1 and 2 )
		and ( v0d.部所グループコード = a0.部所グループコード )
		and ( v0d.部所コード = a0.部所コード )
		and ( v0d.日付 <= eomonth(datefromparts(a0.年,a0.月,1)) )
	)
	as v0 (日付)
outer apply
	(
	select top 1
		max(v1d.日付) as 日付
	from
		車両事故報告_T as v1d
	inner join
		部所部門_T as v1s
		on v1s.部門コード = v1d.部門コード
	where
		( isnull(v1d.過失比率当社,0) >= 50 )
		and ( v1s.部所グループコード = a0.部所グループコード )
		and ( v1s.部所コード = a0.部所コード )
		and ( v1d.日付 <= eomonth(datefromparts(a0.年,a0.月,1)) )
	)
	as v1 (日付)
outer apply
	(
	select top 1
		max(v2d.日付) as 日付
	from
		車両事故報告_T as v2d
	inner join
		部所部門_T as v2s
		on v2s.部門コード = v2d.部門コード
	where
		( isnull(v2d.過失比率当社,0) >= 50 )
		and ( v2s.部所グループコード = a0.部所グループコード )
		and ( v2s.部所コード = a0.部所コード )
		and ( v2d.日付
				between
				datefromparts(a0.年,a0.月,1)
				and
				eomonth(datefromparts(a0.年,a0.月,1))
			)
	)
	as v2 (日付)
where
	( a0.部所グループコード <> 0 )
	and ( a0.部所コード <> 0 )
)
,

t2 as
(
select
	a2.年度
,	a2.年
,	a2.月
,	a2.部所グループコード
,	a2.部所コード
	------------
	-- 労働災害 --
	------------
,	a2.労働災害起算日
,	a2.労働災害報告日
/*,
	case
		when isnull(a2.労働災害報告日,'') = ''
		then datefromparts(a2.年,a2.月,1)
		else a2.労働災害報告日
	end
	as 労働災害当月初日
,
	case
		when isnull(a2.労働災害報告日,'') = ''
		then a2.労働災害起算日
		else a2.労働災害報告日
	end
	as 労働災害累計初日*/
,
	datediff(
		day,
		case
			when isnull(a2.労働災害報告日,'') = ''
			then datefromparts(a2.年,a2.月,1)
			else a2.労働災害報告日
		end,
		eomonth(datefromparts(a2.年,a2.月,1))
	) + 1
	as 労働災害当月
,
	datediff(
		day,
		case
			when isnull(a2.労働災害報告日,'') = ''
			then a2.労働災害起算日
			else a2.労働災害報告日
		end,
		eomonth(datefromparts(a2.年,a2.月,1))
	) + 1
	as 労働災害累計
	------------
	-- 車両事故 --
	------------
,	a2.車両事故起算日
,	a2.車両事故報告日
/*,
	case
		when isnull(a2.車両事故報告日,'') = ''
		then datefromparts(a2.年,a2.月,1)
		else a2.車両事故報告日
	end
	as 車両事故当月初日
,
	case
		when isnull(a2.車両事故報告日,'') = ''
		then a2.車両事故起算日
		else a2.車両事故報告日
	end
	as 車両事故累計初日*/
,
	datediff(
		day,
		case
			when isnull(a2.車両事故報告日,'') = ''
			then datefromparts(a2.年,a2.月,1)
			else a2.車両事故報告日
		end,
		eomonth(datefromparts(a2.年,a2.月,1))
	) + 1
	as 車両事故当月
,
	datediff(
		day,
		case
			when isnull(a2.車両事故報告日,'') = ''
			then a2.車両事故起算日
			else a2.車両事故報告日
		end,
		eomonth(datefromparts(a2.年,a2.月,1))
	) + 1
	as 車両事故累計
from
	(
	select
		a1.年度
	,	a1.年
	,	a1.月
	,	a1.部所グループコード
	,	a1.部所コード
	,
		case
			when a1.労働災害起算日 > a1.労働災害報告起算日
			then a1.労働災害起算日
			else a1.労働災害報告起算日
		end
		as 労働災害起算日
	,	a1.労働災害報告日
	,
		case
			when a1.車両事故起算日 > a1.車両事故報告起算日
			then a1.車両事故起算日
			else a1.車両事故報告起算日
		end
		as 車両事故起算日
	,	a1.車両事故報告日
	from
		t0 as a1
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
,	e3.会社コード
,	z3.部所グループコード
,	z3.部所コード
,	z3.部所グループ名
,	z3.部所名
,	z3.赤
,	z3.緑
,	z3.青
,	z3.人数
,
	case
		z3.部所コード
		when 0
		then isnull(a3.部所件数,0)
		else 0
	end
	as 部所件数
,	a3.労働災害起算日
,	a3.労働災害報告日
,	a3.労働災害当月
,	a3.労働災害累計
,	null as 労働災害備考
,	a3.車両事故起算日
,	a3.車両事故報告日
,	a3.車両事故当月
,	a3.車両事故累計
,	null as 車両事故備考
from
	部所_Q全社一覧_最新_年月 as z3
left outer join
	当社_Q as e3
	on e3.年度 = z3.年度
left outer join
	(
	-- 部所グループコードごとに合計と総合計を算出 --
	select top 100 percent
		a30.年度
	,	a30.年
	,	a30.月
	,	isnull(a30.部所グループコード,0) as 部所グループコード
	,	isnull(a30.部所コード,0) as 部所コード
	,	count(a30.部所コード) as 部所件数
	,	max(a30.労働災害起算日) as 労働災害起算日
	,	max(a30.労働災害報告日) as 労働災害報告日
	,	min(a30.労働災害当月) as 労働災害当月
	,	min(a30.労働災害累計) as 労働災害累計
	,	max(a30.車両事故起算日) as 車両事故起算日
	,	max(a30.車両事故報告日) as 車両事故報告日
	,	min(a30.車両事故当月) as 車両事故当月
	,	min(a30.車両事故累計) as 車両事故累計
	from
		t2 as a30
	GROUP BY
		ROLLUP
		(
			a30.年度
		,	a30.年
		,	a30.月
		,	a30.部所グループコード
		,	a30.部所コード
		)
	HAVING
		( a30.年度 IS NOT NULL )
		AND ( a30.年 IS NOT NULL )
		AND ( a30.月 IS NOT NULL )
	ORDER BY
		a30.年度
	,	a30.年
	,	a30.月
	,	a30.部所グループコード
	,	a30.部所コード
	)
	as a3
	on a3.年度 = z3.年度
	and a3.年 = z3.年
	and a3.月 = z3.月
	and a3.部所グループコード = z3.部所グループコード
	and a3.部所コード = z3.部所コード
)

select
	*
from
	t3 as a400
