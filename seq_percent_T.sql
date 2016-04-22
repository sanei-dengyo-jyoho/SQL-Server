with

v3 as
(
select
	convert(decimal(4,1), a2.seq / 10.0) as seq
from
	(
	select top 1
		0 as seq

	union all

	select
		a1.seq
	from
		digits_Q_9999 as a1
	where
		( a1.seq between 1 and 1000 )
	)
	as a2
where
	( a2.seq % 5 = 0 )

)
,

v4 as
(
select
	seq
,	convert(varchar(20), seq) as seq_p1
,	convert(varchar(20), seq) + '0' as seq_p2
from
	v3 as a4
)

select
	*
from
	v4 as v400
