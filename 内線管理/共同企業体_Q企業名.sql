with

v1 as
(
select
	a1.企業名
,	count(a1.企業名) as 件数
,
	RANK()
	OVER
	(
	ORDER BY
		count(a1.企業名) DESC
	)
	as 順位
from
	(
	select
		a0.企業名 as 企業名
	from
		当社_Q内線 as a0

	union all

	select
		b0.企業名
	from
		工事台帳_T共同企業体 as b0
	)
	as a1
group by
	a1.企業名
)

select
	*
from
	v1 as v100
