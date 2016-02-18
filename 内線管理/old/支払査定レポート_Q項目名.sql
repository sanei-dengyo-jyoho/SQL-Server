WITH

v0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	大分類
,	中分類
,	小分類
,	費目
,	項目名
,	isnull(費目,N'')+CHAR(13)+CHAR(10)+isnull(項目名,N'') as 費目項目名
,	isnull(契約先1,契約先2) as 契約先
,	契約金額
,	isnull(支払先1,支払先2) as 支払先
,	支払金額
,	原価率
from
	支払査定_Q項目名 as a0
)

SELECT
	*
FROM
	v0 as v000
