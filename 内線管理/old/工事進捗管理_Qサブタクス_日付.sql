with

v0 as
(
select
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.タスク番号
,	a0.タスク名
,	b0.サブタスク番号
,	b0.サブタスク名
,	min(c0.日付) as 開始日付
,	max(c0.日付) as 終了日付
from
	工事進捗管理_Tタスク as a0
inner join
	工事進捗管理_Tサブタスク as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
	and b0.タスク番号 = a0.タスク番号
inner join
	工事進捗管理_Tサブタスク_出来高 as c0
	on c0.工事年度 = b0.工事年度
	and c0.工事種別 = b0.工事種別
	and c0.工事項番 = b0.工事項番
	and c0.タスク番号 = b0.タスク番号
	and c0.サブタスク番号 = b0.サブタスク番号
group by
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.タスク番号
,	a0.タスク名
,	b0.サブタスク番号
,	b0.サブタスク名
)

SELECT
	*
FROM
	v0 as v000
