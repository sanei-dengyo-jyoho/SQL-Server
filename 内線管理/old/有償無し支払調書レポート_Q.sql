with

t0 as
(
SELECT
    tc0.*
from
	支払_T as ta0
inner join
	支払_T項目名 as tb0
    on tb0.工事年度 = ta0.工事年度
    and tb0.工事種別 = ta0.工事種別
    and tb0.工事項番 = ta0.工事項番
inner join
	支払_T支払先 as tc0
    on tc0.工事年度 = tb0.工事年度
    and tc0.工事種別 = tb0.工事種別
    and tc0.工事項番 = tb0.工事項番
    and tc0.大分類 = tb0.大分類
    and tc0.中分類 = tb0.中分類
    and tc0.小分類 = tb0.小分類
left outer join
    工事原価_T as tg0
    on tg0.工事年度 = ta0.工事年度
    and tg0.工事種別 = ta0.工事種別
    and tg0.工事項番 = ta0.工事項番
where
    ( tg0.工事年度 is null )
    and ( tg0.工事種別 is null )
    and ( tg0.工事項番 is null )
)
,

v0 as
(
SELECT
   	dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	g0.取引先コード
,	h0.取引先名
,	h0.取引先略称
,	g0.取引先担当
,	g0.工事件名
,	g0.受注日付
,	g0.受注金額
,	g0.消費税率
,	g0.消費税額
,	g0.受注金額+g0.消費税額 as 請負金額
,	a0.支払日付
,	c0.年度 as 支払年度
,	year(a0.支払日付) as 支払年
,	month(a0.支払日付) as 支払月
,	year(a0.支払日付)*100+month(a0.支払日付) as 支払年月
,	b0.支払先種別コード
,	CASE
		when d0.支払先種別名 = N'資材'
		then N'資材'
		else N'一般'
	END as 支払種別
,	b0.支払先コード
,	b0.支払先名
,	a0.支払先
,	a0.支払金額
from
	t0 as a0
left outer join
	支払先_T as b0
	on b0.支払先略称 = a0.支払先
left outer join
	支払先種別_T as d0
	on d0.支払先種別コード = b0.支払先種別コード
left outer join
	カレンダ_T as c0
	on c0.日付 = a0.支払日付
left outer join
    工事台帳_T as g0
    on g0.工事年度 = a0.工事年度
    and g0.工事種別 = a0.工事種別
    and g0.工事項番 = a0.工事項番
left outer join
    発注先_Q AS h0
    on h0.工事種別 = g0.工事種別
    and h0.取引先コード = g0.取引先コード
)

SELECT
	*
FROM
	v0 as v000
