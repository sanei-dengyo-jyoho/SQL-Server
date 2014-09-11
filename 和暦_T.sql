with

v0 as
(
select
	d1.digit * 1000 + d2.digit * 100 + d3.digit * 10 + d4.digit as seq

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
select
	a1.seq as 西暦

from
	v0 as a1

where
	/* ～　現在+5年 */
	( a1.seq
		between (
				select
					min(x1.西暦) as 西暦
				from
					和暦_T基準 as x1
				)
		and (year(GETDATE()) + 5)
	)
)
,

v2 as
(
select
	a2.西暦
,	b2.年号
,	b2.年号カナ
,	b2.年号略称
,	a2.西暦 - (b2.西暦 - 1) as 年

from
	v1 as a2
inner join
	和暦_T基準 as b2
	on ( a2.西暦 >= b2.西暦 )
)
,

v3 as
(
select
	西暦
,	min(年) as 年

from
	v2 as a3

group by
	西暦
)

select
	a4.西暦
,	a4.年号
,	a4.年号カナ
,	a4.年号略称
,	a4.年

from
	v2 as a4
inner join
	v3 as b4
	on ( b4.西暦 = a4.西暦 )
	and ( b4.年 = a4.年 )

