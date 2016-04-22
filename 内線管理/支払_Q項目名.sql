with

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
	(
	select top 100 percent
		qp.*
	from
	 	(
		select
			qp0.工事年度
		,	qp0.工事種別
		,	qp0.工事項番
		,	qp0.大分類
		,	qp0.中分類
		,	qp0.小分類
		,	qp0.順位
		,	qp0.支払先
		from
			(
			select
				qpa0.工事年度
			,	qpa0.工事種別
			,	qpa0.工事項番
			,	qpa0.大分類
			,	qpa0.中分類
			,	qpa0.小分類
			,	qpb0.支払先略称 as 支払先
			,
				--- 金額が同じ場合は、同じ順位とする
				dense_rank()
				over(
					partition by
						qpa0.工事年度
					,	qpa0.工事種別
					,	qpa0.工事項番
					,	qpa0.大分類
					,	qpa0.中分類
					,	qpa0.小分類
					order by
						sum(qpa0.支払金額) desc
					,	qpb0.支払先略称
				)
				as 順位
			from
				支払_T支払先 as qpa0
			inner join
				支払先_T as qpb0
				on qpb0.支払先コード = qpa0.支払先コード
			group by
				qpa0.工事年度
			,	qpa0.工事種別
			,	qpa0.工事項番
			,	qpa0.大分類
			,	qpa0.中分類
			,	qpa0.小分類
			,	qpb0.支払先略称
			)
			as qp0
		)
		as qA
	--- 順位が1～2位までを列に並べる
	pivot
		(
		max(qA.支払先)
		for qA.順位 in ([1], [2])
		)
		as qp
	order by
		qp.工事年度
	,	qp.工事種別
	,	qp.工事項番
	,	qp.大分類
	,	qp.中分類
	,	qp.小分類
	)
	as z0
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
