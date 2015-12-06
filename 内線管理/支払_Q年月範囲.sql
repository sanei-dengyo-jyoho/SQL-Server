with

cte
(
	工事年度
,	工事種別
,	工事項番
,	日付
)
as
(
SELECT
	c0.工事年度
,	c0.工事種別
,	c0.工事項番
,	c0.工期自年月 as 日付
,	c0.工期至年月
FROM
	支払_Q年月範囲 as c0

union all

SELECT
	c1.工事年度
,	c1.工事種別
,	c1.工事項番
,	dateadd(day,1,c1.日付)
FROM
	cte as c1
WHERE
	( c1.工事年度 = c0.工事年度 )
	AND ( c1.工事種別 = c0.工事種別 )
	AND ( c1.工事項番 = c0.工事項番 )
	AND ( c1.日付 < c0.工期至年月 )
)
,

v1 as
(
SELECT
	a1.工事年度
,	a1.工事種別
,	a1.工事項番
,	max(a1.確定日付) as 確定日付
,	format(min(c1.日付),'d') as 支払自日付
,	format(max(c1.日付),'d') as 支払至日付
FROM
	支払_T as a1
left outer join
    支払_T項目名 as b1
    on b1.工事年度 = a1.工事年度
    and b1.工事種別 = a1.工事種別
    and b1.工事項番 = a1.工事項番
left outer join
    支払_T支払先 as c1
    on c1.工事年度 = b1.工事年度
    and c1.工事種別 = b1.工事種別
    and c1.工事項番 = b1.工事項番
group by
	a1.工事年度
,	a1.工事種別
,	a1.工事項番
)
,

v2 as
(
SELECT
	a2.工事年度
,	a2.工事種別
,	a2.工事項番
,	case
		when b2.確定日付 is null
		then null
		else format(b2.確定日付,'d')
	end as 確定日付
,	case
		when b2.工事項番 is null
		then -999
		when b2.確定日付 is null
		then 1
		else -1
	end as 支払状況
,	case
		when isnull(b2.支払自日付,a2.工期自日付) < a2.工期自日付
		then isnull(b2.支払自日付,a2.工期自日付)
		else a2.工期自日付
	end as 支払自日付
,	case
		when isnull(b2.支払至日付,a2.工期至日付) > a2.工期至日付
		then isnull(b2.支払至日付,a2.工期至日付)
		else a2.工期至日付
	end as 支払至日付
FROM
	v0 as a2
left outer join
    v1 as b2
    on b2.工事年度 = a2.工事年度
    and b2.工事種別 = a2.工事種別
    and b2.工事項番 = a2.工事項番
)
,

v3 as
(
SELECT
	工事年度
,	工事種別
,	工事項番
,	確定日付
,	支払状況
,	year(支払自日付)*100+month(支払自日付) as 支払自年月
,	year(支払至日付)*100+month(支払至日付) as 支払至年月
FROM
	v2 as a3
)

SELECT
	*
FROM
	v3 as v300



v4 as
(
SELECT
	工事年度
,	工事種別
,	工事項番
,	確定日付
,	支払状況
,	支払自年月 as 年月
FROM
	v2 as a3

UNION ALL

SELECT
	工事年度
,	工事種別
,	工事項番
,	確定日付
,	支払状況
,	dateadd(MM,年月,1)
FROM
	v2 as a3
)
,
