with

v0 as
(
select
   	dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.タスク番号
,	a0.タスク名
,	a0.サブタスク番号
,	a0.サブタスク名
,	d0.工事種別名
,	d0.工事種別コード
,	b0.取引先コード
,	c0.取引先名
,	c0.取引先略称
,	b0.工事件名
,	a0.日付
,	w0.和暦日付 as 和暦日付
,	w0.和暦日付略称 as 和暦日付略称
,	a0.出来高
,	a0.稼働人員
,	a0.連絡内容
,	a0.備考
from
	工事進捗管理_Qサブタスク_出来高 as a0
inner join
	工事台帳_T as b0
    on b0.工事年度 = a0.工事年度
    and b0.工事種別 = a0.工事種別
    and b0.工事項番 = a0.工事項番
left outer join
    発注先_Q AS c0
    on c0.工事種別 = b0.工事種別
    and c0.取引先コード = b0.取引先コード
left outer join
    工事種別_T AS d0
    on d0.工事種別 = b0.工事種別
left outer join
	カレンダ_Q as w0
	on w0.日付 = a0.日付
)

select
	*
from
	v0 as v000
