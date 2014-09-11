with

v0 as
(
select
	d1.digit * 100 + d2.digit * 10 + d3.digit as seq

from
	digits_T as d1
cross join
	digits_T as d2
cross join
	digits_T as d3
)

select
	seq as IP4

from
	v0 as a1

where
	( seq between 1 and 255 )

