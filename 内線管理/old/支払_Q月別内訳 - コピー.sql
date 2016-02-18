with

v0 as
(
select
	c0.年度
,	c0.年
,	c0.月
,	c0.年*100+c0.月 as 年月
,	a0.支払先
,	sum(a0.支払金額) as 支払金額
from
	支払_T支払先 as a0
left outer join
	カレンダ_T as c0
	on c0.日付 = a0.支払日付
group by
	c0.年度
,	c0.年
,	c0.月
,	a0.支払先
)
,

v1 as
(
select
	a1.年度
,	a1.年
,	a1.月
,	a1.年月
,	b1.支払先種別コード
,	isnull(c1.支払先種別説明,N'') as 支払先種別説明
,	isnull(c1.支払先種別名,N'') as 支払先種別名
,	b1.支払先コード
,	b1.支払先名
,	a1.支払先
,	a1.支払金額
from
	v0 as a1
left outer join
	支払先_T as b1
	on b1.支払先略称 = a1.支払先
left outer join
	支払先種別_T as c1
	on c1.支払先種別コード = b1.支払先種別コード
)
,

v2 as
(
select top 100 percent
	年度
,	年
,	月
,	年月
,	isnull(支払先種別コード,999999) as 支払先種別コード
,	999999 as 支払先コード
,	支払先種別説明 as 支払先名
,	支払先種別名 as 支払先
,	sum(支払金額) as 支払金額
from
	v1 as a2
GROUP BY
	ROLLUP
	(
	年度
,	年
,	月
,	年月
,	支払先種別コード
,	支払先種別説明
,	支払先種別名
	)
HAVING
	( 年度 IS NOT NULL )
	AND ( 年 IS NOT NULL )
	AND ( 月 IS NOT NULL )
	AND ( 年月 IS NOT NULL )
	AND ( 支払先種別コード IS NOT NULL )
	AND ( 支払先種別説明 IS NOT NULL )
	AND ( 支払先種別名 IS NOT NULL )
ORDER BY
	年度
,	年
,	月
,	年月
,	支払先種別コード
)
,

v3 as
(
select
	a3.年度
,	a3.年
,	a3.月
,	a3.年月
,	a3.支払先種別コード
,	a3.支払先コード
,	a3.支払先名
,	a3.支払先
,	a3.支払金額
FROM
	v1 as a3

union ALL

select
	b3.年度
,	b3.年
,	b3.月
,	b3.年月
,	b3.支払先種別コード
,	b3.支払先コード
,	b3.支払先名
,	b3.支払先
,	b3.支払金額
FROM
	v2 as b3
)

select
	format(年,'D4')+'/'+format(月,'D2') as 年月度
,	*
from
	v3 as v300
