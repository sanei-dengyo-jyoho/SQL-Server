with


zy0 AS
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
,

zz0 AS
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
,

v0 as
(
select
	a0.*
,	case
		when isnull(z0.契約金額,0) = 0
		then 1
		else 2
	end
	AS 原価状況グループ
,	case
		when isnull(y0.契約金額,0) = 0
		then 0
		when isnull(z0.契約金額,0) = 0
		then 1
		else 2
	end
	AS 原価状況
,	case
		when (isnull(y0.契約金額,0) = 0) and (isnull(z0.契約金額,0) = 0)
		then N'-'
		else dbo.FuncMakeMoneyFormat(isnull(z0.契約金額,isnull(y0.契約金額,0)))
	end
	AS 原価表示
,   y0.契約金額 AS 予算原価
,	case
		when isnull(y0.契約金額,0) = 0
		then N''
		else dbo.FuncMakePercentFormat(y0.契約金額,a0.請負受注金額)
	end
	AS 予算原価率
,   z0.契約金額 AS 決算原価
,	case
		when isnull(z0.契約金額,0) = 0
		then N''
		else dbo.FuncMakePercentFormat(z0.契約金額,a0.請負受注金額)
	end
	AS 決算原価率
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
)

select
	*
from
	v0 as v000
