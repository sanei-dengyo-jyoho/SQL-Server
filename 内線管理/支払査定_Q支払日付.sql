with

q0 as
(
select
	qa0.工事年度
,	qa0.工事種別
,	qa0.工事項番
,	qa0.大分類
,	qa0.中分類
,	qa0.小分類
,	qa0.支払日付
,	qb0.支払先略称 as 支払先
,	qa0.支払金額
from
	支払_T支払先 as qa0
inner join
	支払先_T as qb0
	on qb0.支払先コード = qa0.支払先コード
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
,	max(a0.確定日付) as 確定日付
,	c0.支払日付
,	convert(nvarchar(50),min(z0.[1])) as 支払先1
,	convert(nvarchar(50),min(z0.[2])) as 支払先2
,	sum(c0.支払金額) as 支払金額
from
	支払_T as a0
left outer join
	支払_T項目名 as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
left outer join
	q0 as c0
	on c0.工事年度 = a0.工事年度
	and c0.工事種別 = a0.工事種別
	and c0.工事項番 = a0.工事項番
	and c0.大分類 = b0.大分類
	and c0.中分類 = b0.中分類
	and c0.小分類 = b0.小分類
left outer join
	(
	select top 100 percent
		qpa2.*
	from
	 	(
		select
			qpa1.工事年度
		,	qpa1.工事種別
		,	qpa1.工事項番
		,	qpa1.大分類
		,	qpa1.中分類
		,	qpa1.小分類
		,	qpa1.支払日付
		,	qpa1.順位
		,	qpa1.支払先
		from
			(
			select
				qpa0.工事年度
			,	qpa0.工事種別
			,	qpa0.工事項番
			,	qpa0.大分類
			,	qpa0.中分類
			,	qpa0.小分類
			,	qpa0.支払日付
			,	qpa0.支払先
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
					,	qpa0.支払日付
					order by
						sum(qpa0.支払金額) desc
					,	qpa0.支払先
				)
				as 順位
			from
				q0 as qpa0
			group by
				qpa0.工事年度
			,	qpa0.工事種別
			,	qpa0.工事項番
			,	qpa0.大分類
			,	qpa0.中分類
			,	qpa0.小分類
			,	qpa0.支払日付
			,	qpa0.支払先
			)
			as qpa1
		)
		as A
	--- 順位が1～2位までを列に並べる
	pivot
		(
		min(A.支払先)
		for A.順位 in ([1], [2])
		)
		as qpa2
	order by
		qpa2.工事年度
	,	qpa2.工事種別
	,	qpa2.工事項番
	,	qpa2.大分類
	,	qpa2.中分類
	,	qpa2.小分類
	,	qpa2.支払日付
	)
	as z0
	on z0.工事年度 = a0.工事年度
	and z0.工事種別 = a0.工事種別
	and z0.工事項番 = a0.工事項番
	and z0.大分類 = b0.大分類
	and z0.中分類 = b0.中分類
	and z0.小分類 = b0.小分類
	and z0.支払日付 = c0.支払日付
group by
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	b0.大分類
,	b0.中分類
,	b0.小分類
,	c0.支払日付
)

select
	*
from
	v0 as v000
