with

zg0 AS
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
,

zy0 AS
(
SELECT
	工事年度
,	工事種別
,	工事項番
,	SUM(契約金額) AS 契約金額
FROM
	工事原価_T予算 AS zya0
GROUP BY
	工事年度
,	工事種別
,	工事項番
)
,

zz0 AS
(
SELECT
	工事年度
,	工事種別
,	工事項番
,	SUM(契約金額) AS 契約金額
FROM
	工事原価_T決算 AS zza0
GROUP BY
	工事年度
,	工事種別
,	工事項番
)
,

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
,   y0.契約金額 AS 予算原価
,
	case
		when isnull(y0.契約金額,0) = 0
		then null
		else dbo.FuncMakePercentFormat(y0.契約金額,a0.請負受注金額)
	end
	AS 予算原価率
,   z0.契約金額 AS 決算原価
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
,	p0.開始日付 as 進捗開始日付
,	p0.終了日付 as 進捗終了日付
,	p0.出来高表示 as 進捗出来高表示
,	p0.稼働人員表示 as 進捗稼働人員表示
from
	工事台帳_Qリスト as a0
LEFT OUTER JOIN
    zy0 AS y0
    ON y0.工事年度 = a0.工事年度
    AND y0.工事種別 = a0.工事種別
    AND y0.工事項番 = a0.工事項番
LEFT OUTER JOIN
    zz0 AS z0
    ON z0.工事年度 = a0.工事年度
    AND z0.工事種別 = a0.工事種別
    AND z0.工事項番 = a0.工事項番
LEFT OUTER JOIN
    zg0 AS g0
    ON g0.工事年度 = a0.工事年度
    AND g0.工事種別 = a0.工事種別
    AND g0.工事項番 = a0.工事項番
LEFT OUTER JOIN
    工事進捗管理_Q AS p0
    ON p0.工事年度 = a0.工事年度
    AND p0.工事種別 = a0.工事種別
    AND p0.工事項番 = a0.工事項番
)
,

v1 as
(
select
	*
,
	case
		when isnull(原価表示,N'') = N''
		then N''
		else 原価表示
	end
	+
	case
		when isnull(決算原価率,'') <> ''
		then
			case
				when isnull(原価表示,N'') = N''
				then N''
				else char(13)
			end
			+
		 	N'【決算】' + 決算原価率
		when isnull(予算原価率,'') <> ''
		then
			case
				when isnull(原価表示,N'') = N''
				then N''
				else char(13)
			end
		 	+
			N'【予算】' + 予算原価率
		else N''
	end
	as 工事原価表示
,
	case
		when isnull(支払金額,'') = ''
		then N''
		else dbo.FuncMakeMoneyFormat(isnull(支払金額,0))
	end
	+
	case
		when isnull(支払完了日付,'') <> ''
		then
			case
				when isnull(支払金額,'') = ''
				then N''
				else char(13)
			end
			+
			N'【完了】' + format(支払完了日付,'d')
		when isnull(支払日付,'') <> ''
		then
			case
				when isnull(支払金額,'') = ''
				then N''
				else char(13)
			end
			+
			N'【支払】' + format(支払日付,'d')
		else N''
	end
	as 支払金額表示
,
	case
		when isnull(進捗終了日付,'') <> ''
		then
			N'～ ' + format(進捗終了日付,'d') +
			char(13) +
			N'【出来高】' + 進捗出来高表示
		when isnull(進捗開始日付,'') <> ''
		then
			format(進捗開始日付,'d') + N' ～' +
			char(13) +
			N'【出来高】' + 進捗出来高表示
		else N''
	end
	as 進捗状況表示
from
	v0 as a1
)

select
	*
from
	v1 as v100
