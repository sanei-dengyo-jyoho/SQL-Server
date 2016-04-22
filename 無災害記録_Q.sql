with

zw0 as
(
select
	zwc0.年度
,	zws0.部所グループコード
,	zws0.部所コード
,	zwa0.部門コード
,	zwa0.日付
,	zwa0.労災認定
,	zwa0.種別
from
	(
	select
		zwa00.日付
	,	zwa00.部門コード
	,	zwa00.労災認定
	,	zwa00.種別
	from
		災害事故報告_T as zwa00

	union all

	select
		zwa01.日付
	,	zwa01.部門コード
	,	zwa01.労災認定
	,	zwa01.種別
	from
		災害事故報告_T補正 as zwa01
	)
	as zwa0
inner join
	カレンダ_T as zwc0
	on zwc0.日付 = zwa0.日付
inner join
	部所部門_Q全年度 as zws0
	on zws0.年度 = zwc0.年度
	and zws0.部門コード = zwa0.部門コード
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
,	a2.部所グループコード
,	a2.部所コード
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
,
	-- カンマ区切りの文字に改行コード（CR+LF）を追加する --
	replace(
		dbo.FuncDeleteCharPrefix(a2.リスト,default)
		, N'、', concat(N'、',CHAR(13),CHAR(10))
	)
	as 労働災害部門名リスト
from
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
	,	w3.リスト
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
			部所_T発足日 as w0d
		where
			( w0d.日付
				<= eomonth(datefromparts(a0.年,a0.月,1))
			)
			and ( w0d.部所グループコード = a0.部所グループコード )
			and ( w0d.部所コード = a0.部所コード )
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
			and ( w1d.部所グループコード = a0.部所グループコード )
			and ( w1d.部所コード = a0.部所コード )
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
			and ( w2d.部所グループコード = a0.部所グループコード )
			and ( w2d.部所コード = a0.部所コード )
		)
		as w2 (日付)
	outer apply
		(
		select top 100 percent
			concat(N'、',
				dbo.FuncAccidentSectionDetail(
					w3d.日付,
					w3s.部門名,
					w3d.種別,
					N'種別'
				)
			)
		from
			zw0 as w3d
		inner join
			部門_T as w3s
			on w3s.部門コード = w3d.部門コード
		where
			( w3d.日付
				between
				datefromparts(a0.年,a0.月,1)
				and
				eomonth(datefromparts(a0.年,a0.月,1))
			)
			and ( w3d.部所グループコード = a0.部所グループコード )
			and ( w3d.部所コード = a0.部所コード )
		order by
			w3d.日付 desc
		,	w3d.部門コード
		)
		as w3 (リスト)
	where
		( a0.部所グループコード <> 0 )
		and ( a0.部所コード <> 0 )
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
,	isnull(g3.色定数,isnull(h3.色定数,'#FFFFFF')) as 色定数
,	z3.人数
,
	case
		z3.部所コード
		when 0
		then isnull(a3.部所件数,0)
		else 0
	end
	as 部所件数
	------------
	-- 労働災害 --
	------------
,	a3.労働災害起算日
,	a3.労働災害報告日
,	a3.労働災害当月
,	a3.労働災害累計
,
	case
		when z3.部所コード <> 0
		then
			dbo.FuncAccidentAchievement(
				a3.労働災害累計,
				a3.労働災害起算日,
				a3.年,
				a3.月,
				default
			)
		else N''
	end
	as 労働災害備考
,
	case
		when z3.部所コード <> 0
		then a3.労働災害部門名リスト
	end
	as 労働災害部門名リスト
from
	部所_Q全社一覧_最新_年月 as z3
LEFT OUTER JOIN
	部所グループ_T年度 as g3
	on g3.年度 = z3.年度
	and g3.部所グループコード = z3.部所グループコード
LEFT OUTER JOIN
	(
	select distinct
		t11.部所グループコード
	,	t11.赤
	,	t11.緑
	,	t11.青
	,	t11.色定数
	from
		(
		select
			max(t00.年度) as 年度
		,	t00.部所グループコード
		from
			部所グループ_T年度 as t00
		group by
			t00.部所グループコード
		)
		as t10
	LEFT OUTER JOIN
		部所グループ_T年度 as t11
		on t11.年度 = t10.年度
		and t11.部所グループコード = t10.部所グループコード
	)
	as h3
	on h3.部所グループコード = z3.部所グループコード
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
	,	max(a30.労働災害部門名リスト) as 労働災害部門名リスト
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
	t3 as t300
