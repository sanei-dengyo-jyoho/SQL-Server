with

v0 as
(
select
	convert(
		numeric(10,2),
		d4.digit * 1000 +
		d3.digit * 100 +
		d2.digit * 10 +
		d1.digit
	)
	as seq
from
	digits_T as d1
cross join
	digits_T as d2
cross join
	digits_T as d3
cross join
	digits_T as d4
)
,

v1 as
(
select top 1
	0 as seq

union all

select
	a1.seq
from
	v0 as a1
where
	( a1.seq between 1 and 1000 )
)
,

v2 as
(
select
	seq
from
	v1 as a2
where
	( seq % 5 = 0 )

)
,

v3 as
(
select
	convert(decimal(4,1), seq / 10.0) as seq
from
	v2 as a3
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
