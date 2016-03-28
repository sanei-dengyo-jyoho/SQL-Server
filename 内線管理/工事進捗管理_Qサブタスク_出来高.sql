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
,	c0.日付
,	c0.出来高
,	c0.稼働人員
,	c0.連絡内容
,	c0.備考
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
)
,

v1 as
(
select
	*
,
	case
		when 出来高 is null
		then null
		else convert(nvarchar(20),出来高) + N'%'
	end
	as 出来高表示
,
	case
		when 稼働人員 is null
		then null
		else convert(nvarchar(20),稼働人員) + N'人'
	end
	as 稼働人員表示
,
	case
		when 連絡内容 is null
		then null
		else
			case
				when len(連絡内容) > 15
				then substring(連絡内容,1,15)
				else 連絡内容
			end
	end
	as 連絡内容表示
,
	case
		when 備考 is null
		then null
		else
			case
				when len(備考) > 15
				then substring(備考,1,15)
				else 備考
			end
	end
	as 備考表示
from
	v0 as a1
)

select
	*
from
	v1 as v100
