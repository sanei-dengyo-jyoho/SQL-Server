with

v0 as
(
select distinct
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.請求回数
,	a0.請求日付 as 請求日付
,	c0.年度 as 請求年度
,	year(a0.請求日付)*100+month(a0.請求日付) as 請求年月
,	isnull(a0.請求本体金額,0)+isnull(a0.請求消費税額,0) as 請求金額
from
	請求_T as a0
left outer join
	入金_T as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
	and b0.請求回数 = a0.請求回数
left outer join
	カレンダ_T as c0
	on c0.日付 = a0.請求日付
where
	( isnull(a0.請求日付,'') <> '' )
	and ( isnull(a0.振替先部門コード,'') = '' )
	and ( b0.工事年度 is null )
)
,

v1 as
(
select
	工事年度
,	工事種別
,	工事項番
,	max(請求回数) as 請求回数
,	max(請求日付) as 請求日付
,	請求年度
,	請求年月
,	sum(請求金額) as 請求金額
from
	v0 as a1
group by
	工事年度
,	工事種別
,	工事項番
,	請求年度
,	請求年月
)
,

v2 as
(
select
	dbo.FuncMakeConstructNumber(a2.工事年度,a2.工事種別,a2.工事項番) AS 工事番号
,	a2.工事年度
,	a2.工事種別
,	a2.工事項番
,   b2.取引先コード
,   h2.取引先名
,   b2.工事件名
,
	case
		when isnull(b2.竣工日付,'') <> ''
		then 0
		else 999999
	end
	as 完工区分
,
	case
		when isnull(b2.竣工日付,'') <> ''
		then null
		else
			N'（ 第' + convert(nvarchar(4),a2.請求回数) + N'回請求 ）'
	end
	as 請求内容
,
	case
		when isnull(b2.竣工日付,'') <> ''
		then null
		else
			N'（ 工期 ' +
			convert(nvarchar(20),w21.和暦日付略称) +
			N' ～ ' +
			convert(nvarchar(20),w22.和暦日付略称) +
			N' ）'
	end
	as 工期
,	b2.受注日付
,	b2.竣工日付
,	a2.請求年度
,	a2.請求年月
,	a2.請求日付
,	w2.和暦日付略称 as 請求日付略称
,	a2.請求回数
,	a2.請求金額
,
	case
		when isnull(b2.竣工日付,'') <> ''
		then N'　完　工'
		else
			N'未成　　　' +
			dbo.FuncMakeMoneyFormat(isnull(b2.受注金額,0)+isnull(b2.消費税額,0))
	end
	as 備考
from
	v1 as a2
inner join
	工事台帳_T as b2
	on b2.工事年度 = a2.工事年度
	and b2.工事種別 = a2.工事種別
	and b2.工事項番 = a2.工事項番
LEFT OUTER JOIN
    発注先_Q AS h2
    ON h2.工事種別 = b2.工事種別
    AND h2.取引先コード = b2.取引先コード
left outer join
	カレンダ_Q as w2
	on w2.日付 = a2.請求日付
left outer join
	カレンダ_Q as w21
	on w21.日付 = b2.工期自日付
left outer join
	カレンダ_Q as w22
	on w22.日付 = b2.工期至日付
)

select
	*
from
	v2 as v200
