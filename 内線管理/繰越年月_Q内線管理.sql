with

y0 as
(
select
	年度
,	年月
from
	繰越処理_Q as ya0
where
	(システム名 = N'内線管理')
	and (サイクル区分 = 2)
)
,

z0 as
(
select
	年度
from
	y0 as za0
group by
	年度
)
,

v0 as
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
	年月_Q as a0
inner join
	z0 as b0
	on b0.年度 = a0.年度
left outer join
	y0 as c0
	on c0.年度 = a0.年度
	and c0.年月 = a0.年月
)
,

v1 as
(
select
	a1.年度
,	w11.年号+convert(nvarchar(4),w11.年)+N'年度' as 和暦年度
,	a1.年度+isnull(b1.期別加算,0) as 期
,	convert(nvarchar(4),a1.年度+isnull(b1.期別加算,0)) + N'期' as 期別
,	w12.年号+convert(nvarchar(4),w12.年)+N'年' as 和暦年
,	SUBSTRING(CONVERT(varchar(10),a1.年月),1,4)+N'年'+SUBSTRING(CONVERT(varchar(10),a1.年月),5,2)+N'月' AS 年月表示
,	a1.年月
,	a1.年
,	a1.月
,	convert(nvarchar(4),a1.月) + N'月分' as 月分
,	a1.繰越有無
,	case
		when (a1.月 >= b1.上期首月) and (a1.月 <= b1.上期末月)
		then 1
		else 2
	end
	as 上下期
,	case
		when (a1.月 >= b1.上期首月) and (a1.月 <= b1.上期末月)
		then N'上期'
		else N'下期'
	end
	as 上下期名
from
	v0 as a1
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
