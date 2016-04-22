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
	a1.[コンピュータ分類№]
,	a1.コンピュータ分類
,	-999 as [コンピュータタイプ№]
,	N'（全て）' as コンピュータタイプ
,	convert(int,0) as 保守
,	convert(int,0) as 資産
,	convert(int,0) as 種類の停止
from
	v0 as a1

union all

select
	b1.[コンピュータ分類№]
,	b1.コンピュータ分類
,	b1.[コンピュータタイプ№]
,	b1.コンピュータタイプ
,	convert(int,b1.保守) as 保守
,	convert(int,b1.資産) as 資産
,	convert(int,b1.種類の停止) as 種類の停止
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
