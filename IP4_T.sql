with

v1 as
(
select
	seq as IP4
from
	digits_Q_999 as a1
where
	( seq between 1 and 255 )
)

select
	*
from
	v1 as v100
