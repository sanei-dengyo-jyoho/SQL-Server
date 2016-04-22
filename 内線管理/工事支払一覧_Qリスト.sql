with

v0 as
(
select
	a0.*
,
	case
		when isnull(z0.契約金額,0) = 0
		then 1
		else 2
	end
	AS 原価状況グループ
,
	case
		when isnull(y0.契約金額,0) = 0
		then 0
		when isnull(z0.契約金額,0) = 0
		then 1
		else 2
	end
	AS 原価状況
,
	case
		when (isnull(y0.契約金額,0) = 0) and (isnull(z0.契約金額,0) = 0)
		then null
		else dbo.FuncMakeMoneyFormat(isnull(z0.契約金額,isnull(y0.契約金額,0)))
	end
	AS 原価表示
,	y0.契約金額 AS 予算原価
,
	case
		when isnull(y0.契約金額,0) = 0
		then null
		else dbo.FuncMakePercentFormat(y0.契約金額,a0.請負受注金額)
	end
	AS 予算原価率
,	z0.契約金額 AS 決算原価
,
	case
		when isnull(z0.契約金額,0) = 0
		then null
		else dbo.FuncMakePercentFormat(z0.契約金額,a0.請負受注金額)
	end
	AS 決算原価率
,	g0.支払完了日付
,	g0.支払日付
,	g0.支払金額
from
	工事台帳_Qリスト as a0
LEFT OUTER JOIN
	(
	SELECT
		zya0.工事年度
	,	zya0.工事種別
	,	zya0.工事項番
	,	SUM(zya0.契約金額) AS 契約金額
	FROM
		工事原価_T予算 AS zya0
	GROUP BY
		zya0.工事年度
	,	zya0.工事種別
	,	zya0.工事項番
	)
    AS y0
    ON y0.工事年度 = a0.工事年度
    AND y0.工事種別 = a0.工事種別
    AND y0.工事項番 = a0.工事項番
LEFT OUTER JOIN
	(
	SELECT
		zza0.工事年度
	,	zza0.工事種別
	,	zza0.工事項番
	,	SUM(zza0.契約金額) AS 契約金額
	FROM
		工事原価_T決算 AS zza0
	GROUP BY
		zza0.工事年度
	,	zza0.工事種別
	,	zza0.工事項番
	)
    AS z0
    ON z0.工事年度 = a0.工事年度
    AND z0.工事種別 = a0.工事種別
    AND z0.工事項番 = a0.工事項番
LEFT OUTER JOIN
	(
	SELECT
		zga0.工事年度
	,	zga0.工事種別
	,	zga0.工事項番
	,	MAX(zga0.確定日付) AS 支払完了日付
	,	MAX(zgc0.支払日付) AS 支払日付
	,	SUM(zgc0.支払金額) AS 支払金額
	FROM
		支払_T AS zga0
	LEFT OUTER JOIN
		支払_T支払先 AS zgc0
	    ON zgc0.工事年度 = zga0.工事年度
	    AND zgc0.工事種別 = zga0.工事種別
	    AND zgc0.工事項番 = zga0.工事項番
	GROUP BY
		zga0.工事年度
	,	zga0.工事種別
	,	zga0.工事項番
	)
    AS g0
    ON g0.工事年度 = a0.工事年度
    AND g0.工事種別 = a0.工事種別
    AND g0.工事項番 = a0.工事項番
)

select
	*
,
	concat(
		case
			when isnull(原価表示,N'') <> N''
			then 原価表示
			else N''
		end,
		case
			when isnull(決算原価率,'') <> ''
			then
				concat(
					case
						when isnull(原価表示,N'') <> N''
						then char(13)
						else N''
					end,
					N'【決算】',
					決算原価率
				)
			when isnull(予算原価率,'') <> ''
			then
				concat(
					case
						when isnull(原価表示,N'') <> N''
						then char(13)
						else N''
					end,
					N'【予算】',
					予算原価率
				)
			else N''
		end
	)
	as 工事原価表示
,
	concat(
		case
			when isnull(支払金額,'') <> ''
			then dbo.FuncMakeMoneyFormat(isnull(支払金額,0))
			else N''
		end,
		case
			when isnull(支払完了日付,'') <> ''
			then
				concat(
					case
						when isnull(支払金額,'') <> ''
						then char(13)
						else N''
					end,
					N'【完了】',
					format(支払完了日付,'d')
				)
			when isnull(支払日付,'') <> ''
			then
				concat(
					case
						when isnull(支払金額,'') <> ''
						then char(13)
						else N''
					end,
					N'【支払】',
					format(支払日付,'d')
				)
			else N''
		end
	)
	as 支払金額表示
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
