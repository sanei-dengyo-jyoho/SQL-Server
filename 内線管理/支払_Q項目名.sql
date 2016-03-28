with

p0 as
(
select
	pa0.工事年度
,	pa0.工事種別
,	pa0.工事項番
,	pa0.大分類
,	pa0.中分類
,	pa0.小分類
,	pb0.支払先略称 as 支払先
,	rank()
	over(
		partition by
			pa0.工事年度
		,	pa0.工事種別
		,	pa0.工事項番
		,	pa0.大分類
		,	pa0.中分類
		,	pa0.小分類
		order by
			sum(pa0.支払金額) desc
		,	pb0.支払先略称
		)
	as 順位
from
	支払_T支払先 as pa0
inner join
	支払先_T as pb0
	on pb0.支払先コード = pa0.支払先コード
group by
	pa0.工事年度
,	pa0.工事種別
,	pa0.工事項番
,	pa0.大分類
,	pa0.中分類
,	pa0.小分類
,	pb0.支払先略称
)
,

p1 as
(
select top 100 percent
	*
from
 	(
	select
		工事年度
	,	工事種別
	,	工事項番
	,	大分類
	,	中分類
	,	小分類
	,	順位
	,	支払先
	from
		p0
	)
	as A
pivot
	(
	max(支払先)
	for 順位 in ([1], [2])
	)
	as p
order by
	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	小分類
)
,

v0 as
(
select
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	b0.大分類
,	b0.中分類
,	b0.小分類
,	max(b0.項目名) as 項目名
,	max(z0.[1]) as 支払先1
,	max(z0.[2]) as 支払先2
,	sum(c0.支払金額) as 支払金額
,	min(c0.支払日付) as 支払自日付
,	max(c0.支払日付) as 支払至日付
,	max(a0.確定日付) as 確定日付
from
	支払_T as a0
left outer join
	支払_T項目名 as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
left outer join
	支払_T支払先 as c0
	on c0.工事年度 = a0.工事年度
	and c0.工事種別 = a0.工事種別
	and c0.工事項番 = a0.工事項番
	and c0.大分類 = b0.大分類
	and c0.中分類 = b0.中分類
	and c0.小分類 = b0.小分類
left outer join
	p1 as z0
	on z0.工事年度 = a0.工事年度
	and z0.工事種別 = a0.工事種別
	and z0.工事項番 = a0.工事項番
	and z0.大分類 = b0.大分類
	and z0.中分類 = b0.中分類
	and z0.小分類 = b0.小分類
where
	( b0.大分類 is not null )
	and ( b0.中分類 is not null )
	and ( b0.小分類 is not null )
group by
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	b0.大分類
,	b0.中分類
,	b0.小分類
)

select
	*
from
	v0 as v000
