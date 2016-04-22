with

v0 as
(
select
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	b0.工事種別名
,	c0.取引先コード
,	d0.取引先略称
,	c0.工事件名
,	a0.確定日付
,	a0.支払金額
from
	(
	select
		pa0.工事年度
	,	pa0.工事種別
	,	pa0.工事項番
	,	max(pa0.確定日付) as 確定日付
	,	sum(pc0.支払金額) as 支払金額
	from
	    支払_T as pa0
	left outer join
	    支払_T支払先 as pc0
		on pc0.工事年度 = pa0.工事年度
		and pc0.工事種別 = pa0.工事種別
		and pc0.工事項番 = pa0.工事項番
	group by
		pa0.工事年度
	,	pa0.工事種別
	,	pa0.工事項番
	)
    as a0
inner join
    工事種別_T as b0
	on b0.工事種別 = a0.工事種別
inner join
    工事台帳_T as c0
	on c0.工事年度 = a0.工事年度
	and c0.工事種別 = a0.工事種別
	and c0.工事項番 = a0.工事項番
inner join
    取引先_T as d0
	on d0.取引先コード = c0.取引先コード
)

select
	*
from
	v0 as v000
