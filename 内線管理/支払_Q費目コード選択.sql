with

v1 as
(
select
	a1.システム名
,	a1.工事年度
,	a1.工事種別
,	a1.工事項番
,	a1.費目コード
,	a1.大分類
,	a1.中分類
,	a1.小分類
,	a1.費目
,	b1.項目名
,	b1.支払先1
,	b1.支払先2
,	isnull(b1.支払先1,b1.支払先2) as 支払先
,	b1.支払金額
,	b1.支払自日付
,	b1.支払至日付
,	b1.支払至日付 as 支払日付
,	b1.確定日付
from
	(
	select
		a0.システム名
	,	b0.工事年度
	,	b0.工事種別
	,	b0.工事項番
	,	a0.費目コード
	,	a0.大分類
	,	a0.中分類
	,	a0.小分類
	,	a0.費目
	from
		(
		select
			ga0.システム名
		,	ga0.費目コード
		,	ga0.大分類
		,	ga0.中分類
		,	ga0.小分類
		,	ga0.費目
		from
			工事原価項目_Q小分類 as ga0
		where
			( ga0.大分類 = 10 )
		)
		as a0
	cross join
		工事台帳_T as b0
	)
	as a1
left outer join
	支払_Q項目名 as b1
	on b1.工事年度 = a1.工事年度
	and b1.工事種別 = a1.工事種別
	and b1.工事項番 = a1.工事項番
	and b1.大分類 = a1.大分類
	and b1.中分類 = a1.中分類
	and b1.小分類 = a1.小分類
)

select
	*
from
	v1 as v100
