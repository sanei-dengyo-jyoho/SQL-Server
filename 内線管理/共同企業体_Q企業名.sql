with

v0 as
(
select
	b0.企業名 as 企業名
from
	当社_Q as b0

union all

select
	b0.企業名
from
	工事台帳_T共同企業体 as b0
)
,

v1 as
(
select
	企業名
,	count(企業名) as 件数
,	RANK()
	OVER(
		ORDER BY
			count(企業名) DESC
		) as 順位
from
	v0 as a1
group by
	企業名
)

select
	*
from
	v1 as v100
