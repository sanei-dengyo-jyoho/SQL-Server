with

v0 as
(
select
	c0.年度 as 支払年度
,	c0.年 as 支払年
,	c0.月 as 支払月
,	b0.支払先略称 as 支払先
,	sum(a0.支払金額) as 支払金額
from
	支払_T支払先 as a0
inner join
	支払先_T as b0
	on b0.支払先コード = a0.支払先コード
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
	a1.支払年度
,	a1.支払年
,	a1.支払月
,	b1.支払先種別コード
,	isnull(c1.支払先種別名,N'') as 支払先種別名
,	isnull(c1.支払先種別説明,N'') as 支払先種別説明
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
	支払年度
,	支払年
,	支払月
,	isnull(支払先種別コード,999999) as 支払先種別コード
,	999999 as 支払先コード
,	支払先種別名 as 支払先種別名
,	支払先種別説明 as 支払先名
,	sum(支払金額) as 支払金額
from
	v1 as a2
GROUP BY
	ROLLUP
	(
	支払年度
,	支払年
,	支払月
,	支払先種別コード
,	支払先種別名
,	支払先種別説明
	)
HAVING
	( 支払年度 IS NOT NULL )
	AND ( 支払年 IS NOT NULL )
	AND ( 支払月 IS NOT NULL )
ORDER BY
	支払年度
,	支払年
,	支払月
,	支払先種別コード
)
,

v02 as
(
select
	支払年度
,	支払年
,	支払月
,	支払先種別コード
,	支払先コード
,	支払先種別名
,
	case
		when 支払先種別コード = 999999
		then N''
		else 支払先名
	end as 支払先名
,	支払金額
FROM
	v2 as a02
)
,

v3 as
(
select
	a3.支払年度
,	a3.支払年
,	a3.支払月
,	a3.支払先種別コード
,	a3.支払先コード
,	a3.支払先種別名
,	a3.支払先名
,	a3.支払金額
FROM
	v1 as a3

union ALL

select
	b3.支払年度
,	b3.支払年
,	b3.支払月
,	b3.支払先種別コード
,	b3.支払先コード
,	b3.支払先種別名
,	isnull(b3.支払先名,N'')+N'合計'
,	b3.支払金額
FROM
	v02 as b3
where
	( b3.支払先名 is not null )
)

select
	支払年度
,	支払年
,	支払月
,	支払年*100+支払月 as 支払年月
,	format(支払年,'D4')+'/'+format(支払月,'D2') as 支払年月度
,	支払先種別コード
,	支払先コード
,	支払先種別名
,	支払先名
,	支払金額
from
	v3 as v300
