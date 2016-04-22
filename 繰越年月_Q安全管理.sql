with

y0 as
(
select
	gya0.年度
,	gya0.年月
from
	繰越処理_Q as gya0
where
	( gya0.システム名 = N'安全管理' )
	and ( gya0.サイクル区分 = 2 )
)
,

v1 as
(
select
	a1.年度
,
	convert(nvarchar(100),
		w11.年号 +
		convert(nvarchar(4),w11.年) +
		N'年度'
	)
	as 和暦年度
,
	a1.年度 +
	isnull(b1.期別加算,0)
	as 期
,
	convert(nvarchar(100),
		convert(nvarchar(4),a1.年度 + isnull(b1.期別加算,0)) +
		N'期'
	)
	as 期別
,
	convert(nvarchar(100),
		w12.年号 +
		convert(nvarchar(4),w12.年) +
		N'年'
	)
	as 和暦年
,
	convert(nvarchar(100),
		w12.年号 +
		convert(nvarchar(4),w12.年) +
		N'年' +
		format(a1.月,'D2') +
		N'月'
	)
	as 和暦年月
,
	convert(nvarchar(100),
		format(a1.年,'D4') +
		N'年' +
		format(a1.月,'D2') +
		N'月'
	)
	as 年月表示
,	a1.年月
,	a1.年
,	a1.月
,
	convert(nvarchar(100),
		convert(nvarchar(4),a1.月) +
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
