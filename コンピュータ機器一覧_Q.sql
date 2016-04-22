with

v0 as
(
select
	a0.[コンピュータ分類№]
,	a0.コンピュータ分類
,	a0.[コンピュータタイプ№]
,	a0.コンピュータタイプ
,	b0.機器名
,	b0.メーカ名
,	convert(int,isnull(b0.停止,0)) as 機器の停止
,	convert(int,isnull(a0.保守,0)) as 保守
,	convert(int,isnull(a0.資産,0)) as 資産
,	convert(int,isnull(a0.種類の停止,0)) as 種類の停止
from
	コンピュータタイプ一覧_Q as a0
left join
	コンピュータ機器_T as b0
	on b0.コンピュータタイプ = a0.コンピュータタイプ
)
,

v1 as
(
select
	a1.[コンピュータ分類№]
,	a1.コンピュータ分類
,	a1.[コンピュータタイプ№]
,	a1.コンピュータタイプ
,	-999 as [機器名№]
,	N'（全て）' as 機器名
,	N'' as メーカ名
,	convert(int,0) as 機器の停止
,	convert(int,0) as 保守
,	convert(int,0) as 資産
,	convert(int,0) as 種類の停止
from
	v0 as a1

union all

select
	a00.[コンピュータ分類№]
,	a00.コンピュータ分類
,	a00.[コンピュータタイプ№]
,	a00.コンピュータタイプ
,
	convert(int,
		ROW_NUMBER()
		over(
			order by
				a00.[コンピュータ分類№]
			,	a00.コンピュータ分類
			,	a00.[コンピュータタイプ№]
			,	a00.コンピュータタイプ,機器名
			)
	)
	as [機器名№]
,	a00.機器名
,	a00.メーカ名
,	convert(int,a00.機器の停止) as 機器の停止
,	convert(int,a00.保守) as 保守
,	convert(int,a00.資産) as 資産
,	convert(int,a00.種類の停止) as 種類の停止
from
	v0 as a00
)

select distinct
	*
from
	v1 as v000
where
	( isnull(コンピュータ分類,'') <> '' )
	and ( isnull(コンピュータタイプ,'') <> '' )
	and ( isnull(機器名,'') <> '' )
