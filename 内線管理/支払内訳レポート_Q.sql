with

v2 as
(
select
	a2.*
,	convert(money,floor(a2.支払金額 * a2.消費税率 / 100)) as 支払消費税額
from
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
			(
			select
				ra0.年月
			,	ra0.固定 as 消費税率
			from
				数値条件_Q as ra0
			where
				( ra0.名前 = N'消費税率' )
			)
			as r1
		where
			( r1.年月 <= a1.支払年月 )
		order by
			r1.年月 desc
		)
		as 消費税率
	from
		(
		select
			c0.年度 as 支払年度
		,	year(a0.支払日付) * 100 + month(a0.支払日付) as 支払年月
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
			(
			SELECT
				pa0.支払先コード
			,	pa0.支払日付
			,	pa0.支払金額
			FROM
				支払_T支払先 as pa0

			UNION ALL

			SELECT
				pa1.支払先コード
			,	pa1.支払日付
			,	pa1.支払金額
			FROM
				定期支払_T支払先 as pa1
			)
			as a0
		inner join
			支払先_T as b0
			on b0.支払先コード = a0.支払先コード
		left outer join
			支払先種別_T as d0
			on d0.支払先種別コード = b0.支払先種別コード
		left outer join
			カレンダ_T as c0
			on c0.日付 = a0.支払日付
		)
		as a1
	)
	as a2
)

select
	*
from
	v2 as v200
