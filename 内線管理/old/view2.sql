with

t0 as
(
select
	ta0.工事年度
,	ta0.工事種別
,	ta0.工事項番
,	ta0.タスク番号
,	ta0.タスク名
,	ta0.サブタスク番号
,	ta0.サブタスク名
,	tb0.工期年度
,	tb0.工期年月
,	tb0.工期日付
,
	case
		when tb0.工期日付 > ta0.開始日付
		then
			case
				when
					year(tb0.工期日付) *100 + month(tb0.工期日付)
					<>
					year(ta0.開始日付) *100 + month(ta0.開始日付)
				then datefromparts(year(tb0.工期日付),month(tb0.工期日付),1)
				else ta0.開始日付
			end
		else datefromparts(year(ta0.開始日付),month(ta0.開始日付),1)
	end
	as 開始日付
,
	case
		when ta0.終了日付 > tb0.工期日付
		then eomonth(tb0.工期日付)
		else ta0.終了日付
	end
	as 終了日付
,	tb0.進捗率
,	tb0.人数
from
    工事進捗管理_Qサブタスク_日付 as ta0
left outer join
	工事進捗管理_Qサブタスク_出来高 as tb0
	on tb0.工事年度 = ta0.工事年度
	and tb0.工事種別 = ta0.工事種別
	and tb0.工事項番 = ta0.工事項番
	and tb0.タスク番号 = ta0.タスク番号
	and tb0.サブタスク番号 = ta0.サブタスク番号
)

SELECT
	*
FROM
	t0 as t000
