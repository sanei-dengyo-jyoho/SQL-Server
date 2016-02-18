with

v0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	支払年月
,	sum(契約金額) as 契約金額
,	sum(支払金額) as 支払金額
from
	支払査定レポート_Q as a0
where
	( 小分類 <> 999999 )
group by
	工事年度
,	工事種別
,	工事項番
,	支払年月
)

select
	*
from
	v0 as v000

OPTION (MAXRECURSION 0)
