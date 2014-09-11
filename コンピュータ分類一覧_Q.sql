with

v0 as
(
select
	[コンピュータ分類№]
,	コンピュータ分類
from
	コンピュータ分類_Q as a0
)
,

v1 as
(
select top 1
	-999 as [コンピュータ分類№]
,	'（全て）' as コンピュータ分類
from
	v0 as a1

union all

select
	[コンピュータ分類№]
,	コンピュータ分類
from
	v0 as b1
)

select distinct
	*
from
	v1 as v000
where
	( isnull(コンピュータ分類,'') <> '' )

