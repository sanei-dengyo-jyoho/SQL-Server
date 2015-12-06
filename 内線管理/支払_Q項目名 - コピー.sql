with

p0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	小分類
,	支払先
,	rank() over(
				partition by
					工事年度
				,	工事種別
				,	工事項番
				,	大分類
				,	中分類
				,	小分類
				order by
					sum(契約金額) desc
				) as 順位
from
	支払_T支払先
group by
	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	小分類
,	支払先
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
,	(
	select top 1
        p01.支払先
    from
        p0 as p01
    where
        ( p01.工事年度 = a0.工事年度 )
        and ( p01.工事種別 = a0.工事種別 )
        and ( p01.工事項番 = a0.工事項番 )
        and ( p01.大分類 = b0.大分類 )
        and ( p01.中分類 = b0.中分類 )
        and ( p01.小分類 = b0.小分類 )
		and ( p01.順位 = 1)
	) as 支払先1
,	(
	select top 1
        p02.支払先
    from
        p0 as p02
    where
        ( p02.工事年度 = a0.工事年度 )
        and ( p02.工事種別 = a0.工事種別 )
        and ( p02.工事項番 = a0.工事項番 )
        and ( p02.大分類 = b0.大分類 )
        and ( p02.中分類 = b0.中分類 )
        and ( p02.小分類 = b0.小分類 )
		and ( p02.順位 = 2)
	) as 支払先2
,	sum(c0.契約金額) as 契約金額
,	max(c0.日付) as 支払日付
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
