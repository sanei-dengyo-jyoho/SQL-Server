with

v2 as
(
select
	a2.システム名
,	a2.年度
,	a2.顧客金額 + a2.一般金額 as 金額
,	a2.顧客金額
,	a2.一般金額
,	a2.備考
from
	(
	select
		a1.システム名
	,	a1.年度
	,
		isnull(
			b1.顧客金額,
			(
			select top 1
				lb000.顧客金額
			from
		    	売上目標_T as lb000
			where
		    	( lb000.システム名 = a1.システム名 )
		    	and ( lb000.年度 < a1.年度 )
			order by
				lb000.年度 desc
			)
		)
		as 顧客金額
	,
		isnull(
			b1.一般金額,
			(
			select top 1
				lb001.一般金額
			from
		    	売上目標_T as lb001
			where
		    	( lb001.システム名 = a1.システム名 )
		    	and ( lb001.年度 < a1.年度 )
			order by
				lb001.年度 desc
			)
		)
		as 一般金額
	,	b1.備考
	from
		(
		select
			a0.システム名
		,	b0.年度
		from
			(
			select
			    xa0.システム名
			from
			    工事種別_T as xa0
			group by
			    xa0.システム名
			)
		    as a0
		cross join
			(
			select
				xb0.seq as 年度
			from
				digits_Q_9999 as xb0
			where
				(
				xb0.seq
				between
					2001
				and
					(
					select top 1
						max(xb000.年度) as 年度
					from
						繰越年月_Q内線管理 as xb000
					)
				)
			)
		    as b0
		)
		as a1
	left outer join
	    売上目標_T as b1
	    on b1.システム名 = a1.システム名
	    and b1.年度 = a1.年度
	)
    as a2
)

select
    *
from
    v2 as v200
