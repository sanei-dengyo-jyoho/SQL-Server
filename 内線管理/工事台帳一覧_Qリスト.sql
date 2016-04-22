with

v0 as
(
select
    a0.*
from
    工事台帳_Qリスト as a0

union all

select
    b0.*
from
    工事台帳_Q追加工事リスト as b0
)

select
    *
,
	dbo.FuncMakeConstructSubject(
		CONCAT(N'工事件名','#'),
		工事番号,
		工事件名,
		ISNULL(受注金額,0),
		DEFAULT)
	as 工事件名グループ
,
	CONCAT(
		取引先略称,
		CASE
			WHEN ISNULL([JV出資比率],N'') <> N''
			THEN CONCAT(CHAR(13),[JV出資比率])
			ELSE N''
		END
	)
	as [発注先JV]
,
	dbo.FuncMakeMoneyFormat(ISNULL(受注金額,0))
	as 税別受注金額文字列
,
	dbo.FuncMakeMoneyFormat(ISNULL(受注金額,0)+ISNULL(消費税額,0))
	as 税込受注金額文字列
from
    v0 as v000
