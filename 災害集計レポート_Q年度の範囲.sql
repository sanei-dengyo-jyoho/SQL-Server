with

v2 as
(
select
	convert(int, a2.年度) as 年度
,
	convert(nvarchar(100),
		convert(nvarchar(4),a2.年度) + N'年度'
	)
	as 年度表示
,
	convert(nvarchar(100),
		isnull(w2.年号,'') + format(isnull(w2.年,0),'D2') + N'年度'
	)
	as 和暦年度表示
from
	(
	select
		a1.年度
	from
		(
		select
			a0.年度
		from
			災害事故報告_T as a0
            where
                ( isnull(a0.労災認定,0) <> 0 )

		union all

		select
			b0.年度
		from
			車両事故報告_T as b0
            where
            	( isnull(b0.過失比率当社,0) >= 50 )
		)
		as a1
	group by
		a1.年度
	)
	as a2
LEFT OUTER JOIN
	和暦_T as w2
	on w2.西暦 = a2.年度
)

select
	*
from
	v2 as v200
