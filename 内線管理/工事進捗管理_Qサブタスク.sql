with

v1 as
(
select
	a1.*
,
	case
		when a1.出来高 is not null
		then concat(convert(nvarchar(20),a1.出来高),N'%')
	end
	as 出来高表示
,
	case
		when a1.稼働人員 is not null
		then concat(convert(nvarchar(20),a1.稼働人員),N'人')
	end
	as 稼働人員表示
from
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
	,	max(c0.出来高) as 出来高
	,	sum(c0.稼働人員) as 稼働人員
	from
		工事進捗管理_Tタスク as a0
	left outer join
		工事進捗管理_Tサブタスク as b0
		on b0.工事年度 = a0.工事年度
		and b0.工事種別 = a0.工事種別
		and b0.工事項番 = a0.工事項番
		and b0.タスク番号 = a0.タスク番号
	left outer join
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
	as a1
)

select
	*
from
	v1 as v100
