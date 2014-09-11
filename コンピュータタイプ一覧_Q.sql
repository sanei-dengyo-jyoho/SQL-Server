with

v0 as
(
select
	a0.[コンピュータ分類№]
,	a0.コンピュータ分類
,	b0.[コンピュータタイプ№]
,	b0.コンピュータタイプ
,	convert(int,isnull(b0.保守,0)) as 保守
,	convert(int,isnull(b0.資産,0)) as 資産
,	convert(int,isnull(b0.トラブル報告,0)) as 種類の停止
from
	コンピュータ分類一覧_Q as a0
left join
	コンピュータタイプ_T as b0
	on b0.コンピュータ分類 = a0.コンピュータ分類
)
,

v1 as
(
select
	[コンピュータ分類№]
,	コンピュータ分類
,	-999 as [コンピュータタイプ№]
,	'（全て）' as コンピュータタイプ
,	convert(int,0) as 保守
,	convert(int,0) as 資産
,	convert(int,0) as 種類の停止
from
	v0 as a1

union all

select
	[コンピュータ分類№]
,	コンピュータ分類
,	[コンピュータタイプ№]
,	コンピュータタイプ
,	convert(int,保守) as 保守
,	convert(int,資産) as 資産
,	convert(int,種類の停止) as 種類の停止
from
	v0 as b1
)

select distinct
	*
from
	v1 as v000
where
	( isnull(コンピュータ分類,'') <> '' )
	and ( isnull(コンピュータタイプ,'') <> '' )

