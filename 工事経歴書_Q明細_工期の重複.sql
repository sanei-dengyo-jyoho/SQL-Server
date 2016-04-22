with

v0 as
(
select
	a0.会社コード
,	format(c0.日付,'d') as 審査基準日
,	year(c0.日付) * 100 + month(c0.日付) as 年月
,	a0.作成年度
,	a0.[№]
,	a0.提出先区分
,	a0.工事内容コード
,	a0.担当者名
,	format(a0.着工日,'d') as 着工日
,	format(a0.完成日,'d') as 完成日
,	a0.請負金額
from
	工事経歴書_T明細 as a0
inner join
	(
	select
		c000.年度
	,	max(c000.日付) as 日付
	from
		カレンダ_T as c000
	group by
		c000.年度
	)
	as c0
	on c0.年度 = a0.作成年度
where
	( a0.提出先区分 = 2 )
	and ( isnull(a0.請負金額,0) <> 0 )
	and ( isnull(a0.担当者名,N'別紙参照') <> N'別紙参照' )
	and ( isnull(a0.担当者名,N'別紙参照') <> N'？' )
	and ( isnull(a0.着工日,'') <> '' )
	and ( isnull(a0.完成日,'') <> '' )
)
,

v1 as
(
select
	a1.会社コード
,	a1.審査基準日
,	a1.作成年度
,	a1.[№]
,	a1.提出先区分
,	a1.工事内容コード
,	a1.担当者名
,	a1.着工日
,	a1.完成日
,	a1.請負金額
from
	v0 as a1
where
	(
	a1.請負金額 >=
	abs(
		isnull(
				(
				select top 1
					x1.数値
				from
					数値条件_Q as x1
				where
					( x1.数値コード = 119 )
					and ( x1.年月 <= a1.年月 )
				order by
					x1.年月 desc
				)
				,0)
		/ 1000
		)
	)
)
,

v2 as
(
select distinct
	a2.会社コード
,	min(b2.作成年度) as 参照作成年度
,	a2.審査基準日
,	a2.作成年度
,	a2.[№]
,	a2.提出先区分
,	a2.工事内容コード
,	a2.担当者名
,	a2.着工日
,	a2.完成日
,	a2.請負金額
from
	v0 as a2
inner join
	v1 as b2
	on ( b2.会社コード = a2.会社コード )
	and ( b2.提出先区分 = a2.提出先区分 )
	and ( b2.工事内容コード = a2.工事内容コード )
	and ( b2.担当者名 = a2.担当者名 )
	and ( abs(b2.作成年度 * 10000 + b2.[№]) <> abs(a2.作成年度 * 10000 + a2.[№]) )
where
	/* 工期の適用範囲 */
	( a2.着工日 <= a2.審査基準日　and a2.完成日 <= a2.審査基準日 )
	/* 工期の重複 */
	and ( ( a2.着工日 > b2.着工日 and a2.完成日 < b2.完成日 )
		or ( a2.完成日 > b2.着工日 and a2.着工日 < b2.完成日 ) )
	and ( a2.着工日 != b2.着工日 or a2.完成日 != b2.完成日 )
group by
	a2.会社コード
,	a2.審査基準日
,	a2.作成年度
,	a2.[№]
,	a2.提出先区分
,	a2.工事内容コード
,	a2.担当者名
,	a2.着工日
,	a2.完成日
,	a2.請負金額
)

select
	*
from
	v2 as a3
