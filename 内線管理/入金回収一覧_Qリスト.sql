select
    *
,
	CONCAT(
		dbo.FuncMakeConstructOrdered(
			CONCAT(工事種別名,N'#'),
			取引先略称
		),
		CASE
			WHEN ISNULL([JV出資比率],N'') <> N''
			THEN CONCAT(SPACE(2),[JV出資比率])
			ELSE N''
		END
	)
	as [発注先JVグループ]
,
	dbo.FuncMakeConstructSubject(
		CONCAT(N'工事件名','#'),
		工事番号,
		工事件名,
		ISNULL(受注金額,0),
		DEFAULT
	)
	as 工事件名グループ
,
	CONCAT(
		dbo.FuncMakeConstructOrdered(
			DEFAULT,
			取引先略称
		),
		CASE
			WHEN ISNULL([JV出資比率],N'') <> N''
			THEN CONCAT(SPACE(2),[JV出資比率])
			ELSE N''
		END
	)
	as [発注先JV出力]
,
	dbo.FuncMakeConstructSubject(
		DEFAULT,
		工事番号,
		工事件名,
		ISNULL(受注金額,0),
		DEFAULT
	)
	as 工事件名出力
,
	dbo.FuncMakeMoneyFormat(ISNULL(受注金額,0))
	as 税別受注金額文字列
,
	dbo.FuncMakeMoneyFormat(ISNULL(受注金額,0)+ISNULL(消費税額,0))
	as 税込受注金額文字列
from
    入金回収_Qリスト as v000
