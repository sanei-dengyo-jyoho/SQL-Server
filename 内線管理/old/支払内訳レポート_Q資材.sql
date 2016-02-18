with

v0 as
(
select
	c0.年度 as 支払年度
,	c0.年 as 支払年
,	c0.月 as 支払月
,	b0.支払先コード
,	b0.支払先名
,	a0.支払金額
,	null as 合計金額
from
	支払_T支払先 as a0
left outer join
	支払先_T as b0
	on b0.支払先略称 = a0.支払先
left outer join
	支払先種別_T as d0
	on d0.支払先種別コード = b0.支払先種別コード
left outer join
	カレンダ_T as c0
	on c0.日付 = a0.支払日付
where
	( d0.支払先種別名 = N'資材' )
)
,

v1 AS
(
SELECT TOP 100 PERCENT
	支払年度
,	支払年
,	支払月
,	9999 as 支払先コード
,	null as 支払先名
,	null as 支払金額
,	SUM(支払金額)
	OVER(
		PARTITION BY
			支払年度
		,	支払年
		,	支払月
	) AS 合計金額
FROM
	v0 AS a1
ORDER BY
	支払年度
,	支払年
,	支払月
)
,

v2 AS
(
SELECT
	a2.*
FROM
	v0 AS a2

UNION ALL

SELECT distinct
	b2.*
FROM
	v1 AS b2
)

select
	*
from
	v2 as v200
