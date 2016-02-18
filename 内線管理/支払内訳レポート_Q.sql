with

r0 as
(
select
	年月
,	固定 as 消費税率
from
	数値条件_Q as ra0
where
	( 名前 = N'消費税率' )
)
,

v0 as
(
select
	c0.年度 as 支払年度
,	year(a0.支払日付)*100+month(a0.支払日付) as 支払年月
,	year(a0.支払日付) as 支払年
,	month(a0.支払日付) as 支払月
,	b0.支払先種別コード
,
	case
		when d0.支払先種別名 = N'資材'
		then N'資材'
		else N'一般'
	end
	as 支払種別
,	a0.支払先コード
,	b0.支払先名
,	b0.支払先名カナ
,	a0.支払金額
from
	支払_T支払先 as a0
left outer join
	支払先_T as b0
	on b0.支払先コード = a0.支払先コード
left outer join
	支払先種別_T as d0
	on d0.支払先種別コード = b0.支払先種別コード
left outer join
	カレンダ_T as c0
	on c0.日付 = a0.支払日付
)
,

v1 as
(
select
	a1.支払年度
,	a1.支払年月
,	a1.支払年
,	a1.支払月
,	a1.支払先種別コード
,	a1.支払種別
,	a1.支払先コード
,	a1.支払先名
,	a1.支払先名カナ
,	a1.支払金額
,
	(
	select top 1
		r1.消費税率
	from
		r0 as r1
	where
		( r1.年月 <= a1.支払年月 )
	order by
		r1.年月 desc
	)
	as 消費税率
from
	v0 as a1
)
,

v2 as
(
select
	支払年度
,	支払年月
,	支払年
,	支払月
,	支払先種別コード
,	支払種別
,	支払先コード
,	支払先名
,	支払先名カナ
,	支払金額
,	消費税率
,	convert(money,floor(支払金額*消費税率/100)) as 支払消費税額
,	支払金額+convert(money,floor(支払金額*消費税率/100)) as 税込支払金額
from
	v1 as a2
)

select
	*
from
	v2 as v200
