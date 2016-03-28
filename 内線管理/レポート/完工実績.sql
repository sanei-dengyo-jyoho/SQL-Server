with

z0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	取引先コード
,	工事件名
,	工期自日付
,	工期至日付
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
	and ( isnull(竣工日付,'') <> '' )
)
,

v0 as
(
select
	w2.年度 as 年度
,	year(a0.竣工日付) * 100 + month(a0.竣工日付) as 年月
,
	CONVERT(nvarchar(10),year(a0.竣工日付)) +
	N'年' +
	CONVERT(nvarchar(10),month(a0.竣工日付)) +
	N'月'
	as 年月表示

,	UserDB.dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番)
	as 工事番号
,   c0.取引先名 as 発注先
,   c0.取引先略称 as 発注先略称
,   a0.工事件名
,
	UserDB.dbo.FuncMakeConstructPeriod(a0.工期自日付,a0.工期至日付,DEFAULT)
	as 工期
,	a0.受注日付 as 受注日
,	w1.和暦日付 as 和暦受注日
,	w1.和暦日付略称 as 和暦受注日略称
,	a0.竣工日付 as 竣工日
,	w2.和暦日付 as 和暦竣工日
,	w2.和暦日付略称 as 和暦竣工日略称
,   a0.受注金額
,   a0.消費税率
,   a0.消費税額
from
	z0 as a0
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
