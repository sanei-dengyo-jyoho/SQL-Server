with

v0 as
(
select
	format(大分類,'D3')+'-'+format(中分類,'D3')+'-'+format(小分類,'D3') as 費目コード
,	*
from
	工事原価項目_T小分類 as a0
)

select
	*
from
	v0 as v000
