with

y0 as
(
select
	gya0.年度
,	gya0.年月
from
	繰越処理_Q as gya0
where
	( gya0.システム名 = N'内線管理' )
	and ( gya0.サイクル区分 = 2 )

union all

select
	l0.年度
,	l1.年月
from
	(
	select
		gya1.年度
	,	max(gya1.年月) as 年月
	from
		(
		select
			gya0.年度
		,	gya0.年月
		from
			繰越処理_Q as gya0
		where
			( gya0.システム名 = N'内線管理' )
			and ( gya0.サイクル区分 = 2 )
		)
		as gya1
	group by
		gya1.年度
	)
	as gya2
cross apply
	(
	select top 1
		gyy2.年度
	from
		(
		select top 100 percent
			mgyy2.年度
		,	mgyy2.年月
		from
			年月_Q as mgyy2
		order by
			mgyy2.年月
		)
		as gyy2
	where
		( gyy2.年月 > gya2.年月 )
	)
	as l0 (年度)
cross apply
	(
	select top 1
		gym2.年月
	from
		(
		select top 100 percent
			mgym2.年度
		,	mgym2.年月
		from
			年月_Q as mgym2
		order by
			mgym2.年月
		)
		as gym2
	where
		( gym2.年月 > gya2.年月 )
	)
	as l1 (年月)
)
,

v1 as
(
select
	a1.年度
,
	concat(
		w11.年号,
		convert(nvarchar(4),w11.年),
		N'年度'
	)
	as 和暦年度
,
	a1.年度 +
	isnull(b1.期別加算,0)
	as 期
,
	concat(
		convert(nvarchar(4),a1.年度 + isnull(b1.期別加算,0)),
		N'期'
	)
	as 期別
,
	concat(
		w12.年号,
		convert(nvarchar(4),w12.年),
		N'年'
	)
	as 和暦年
,
	concat(
		SUBSTRING(CONVERT(nvarchar(10),a1.年月),1,4),
		N'年',
		SUBSTRING(CONVERT(nvarchar(10),a1.年月),5,2),
		N'月'
	)
	as 年月表示
,	a1.年月
,	a1.年
,	a1.月
,
	concat(
		convert(nvarchar(4),a1.月),
		N'月分'
	)
	as 月分
,	a1.繰越有無
,
	case
		when (a1.月 >= b1.上期首月) and (a1.月 <= b1.上期末月)
		then 1
		else 2
	end
	as 上下期
,
	case
		when (a1.月 >= b1.上期首月) and (a1.月 <= b1.上期末月)
		then N'上期'
		else N'下期'
	end
	as 上下期名
from
	(
	select
		a0.年度
	,	a0.年月
	,	a0.年
	,	a0.月
	,
		case
			when c0.年月 is null
			then 0
			else 1
		end
		as 繰越有無
	from
		(
		select top 100 percent
			mm0.年度
		,	mm0.年月
		,	mm0.年
		,	mm0.月
		from
			年月_Q as mm0
		order by
			mm0.年月
		)
		as a0
	inner join
		(
		select
			za0.年度
		from
			y0 as za0
		group by
			za0.年度
		)
		as b0
		on b0.年度 = a0.年度
	left outer join
		y0 as c0
		on c0.年度 = a0.年度
		and c0.年月 = a0.年月
	)
	as a1
inner join
	当社_Q as b1
	on b1.年度 = a1.年度
inner join
	和暦_T as w11
	on w11.西暦 = a1.年度
inner join
	和暦_T as w12
	on w12.西暦 = a1.年
)

select
	*
from
	v1 as v100
