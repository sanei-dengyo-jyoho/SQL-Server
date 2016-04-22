with

v0 as
(
select
	a0.西暦
,	b0.年号
,	b0.年号カナ
,	b0.年号略称
,	a0.西暦 - (b0.西暦 - 1) as 年
from
	(
	select top 100 percent
		aa0.seq as 西暦
	from
		digits_Q_9999 as aa0
	where
		-- ～　現在+10年 --
		(
		aa0.seq
		between
			(
			select
				min(ab0.西暦) as 西暦
			from
				和暦_T基準 as ab0
			)
		and
			(year(GETDATE()) + 10)
		)
	order by
		aa0.seq desc
	)
	as a0
inner join
	和暦_T基準 as b0
	on b0.西暦 < a0.西暦
)
,

v1 as
(
select
	a1.西暦
,	a1.年号
,	a1.年号カナ
,	a1.年号略称
,	a1.年
from
	v0 as a1
inner join
	(
	select
		aa1.西暦
	,	min(aa1.年) as 年
	from
		v0 as aa1
	group by
		aa1.西暦
	)
	as b1
	on b1.西暦 = a1.西暦
	and b1.年 = a1.年
)

select
	*
from
	v1 as v100
