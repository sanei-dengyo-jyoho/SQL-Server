with

z0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	取引先コード
,	工事件名
,	工期自日付 as 工期自日付
,
	case
		when isnull(竣工日付,'') = ''
		then 工期至日付
		else
			case
				when 竣工日付 > 工期至日付
				then 竣工日付
				else 工期至日付
			end
	end
	as 工期至日付
,	受注日付
,	着工日付
,	竣工日付
,   受注金額
,   消費税率
,   消費税額
from
	UserDB.dbo.工事台帳_T as za0
where
	( isnull(停止日付,'') = '' )
)
,

v0 as
(
select
	UserDB.dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.取引先コード
,   c0.取引先名
,   c0.取引先略称
,   a0.工事件名
,	a0.工期自日付
,	a0.工期至日付
,	a0.受注日付
,	w1.和暦日付 as 和暦受注日付
,	w1.和暦日付略称 as 和暦受注日付略称
,	w1.年度 as 年度
,	year(a0.受注日付) as 年
,	month(a0.受注日付) as 月
,	year(a0.受注日付) * 100 + month(a0.受注日付) as 年月
,
	CONVERT(nvarchar(10),year(a0.受注日付)) +
	N'年' +
	CONVERT(nvarchar(10),month(a0.受注日付)) +
	N'月'
	as 年月表示
,	a0.着工日付
,	a0.竣工日付
,	w2.和暦日付 as 和暦竣工日付
,	w2.和暦日付略称 as 和暦竣工日付略称
,   a0.受注金額
,   a0.消費税率
,   a0.消費税額
from
	z0 as a0
left outer join
	UserDB.dbo.カレンダ_Q as w0
	on w0.日付 = a0.工期至日付
left outer join
	UserDB.dbo.カレンダ_Q as w1
	on w1.日付 = a0.受注日付
left outer join
	UserDB.dbo.カレンダ_Q as w2
	on w2.日付 = a0.竣工日付
LEFT OUTER JOIN
    UserDB.dbo.発注先_Q AS c0
    ON c0.工事種別 = a0.工事種別
    AND c0.取引先コード = a0.取引先コード
)

select
	*
from
	v0 as v000
