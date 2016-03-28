with

g0 as
(
select
	ga0.工事年度
,	ga0.工事種別
,	ga0.工事項番
,	ga0.タスク番号
,	ga0.タスク名
,	gb0.サブタスク番号
,	gb0.サブタスク名
,	min(gc0.日付) as 開始日付
,	max(gc0.日付) as 終了日付
,	max(gc0.出来高) as 出来高
,	sum(gc0.稼働人員) as 稼働人員
from
	工事進捗管理_Tタスク as ga0
inner join
	工事進捗管理_Tサブタスク as gb0
	on gb0.工事年度 = ga0.工事年度
	and gb0.工事種別 = ga0.工事種別
	and gb0.工事項番 = ga0.工事項番
	and gb0.タスク番号 = ga0.タスク番号
inner join
	工事進捗管理_Tサブタスク_出来高 as gc0
	on gc0.工事年度 = gb0.工事年度
	and gc0.工事種別 = gb0.工事種別
	and gc0.工事項番 = gb0.工事項番
	and gc0.タスク番号 = gb0.タスク番号
	and gc0.サブタスク番号 = gb0.サブタスク番号
group by
	ga0.工事年度
,	ga0.工事種別
,	ga0.工事項番
,	ga0.タスク番号
,	ga0.タスク名
,	gb0.サブタスク番号
,	gb0.サブタスク名
)
,

z0 as
(
select
	za0.工事年度
,	za0.工事種別
,	za0.工事項番
,	zp0.タスク番号
,	zp0.タスク名
,	zp0.サブタスク番号
,	zp0.サブタスク名
,	za0.取引先コード
,	zc0.取引先名
,	zc0.取引先略称
,	za0.工事件名
,	zp0.開始日付
,	zp0.終了日付
,
	case
		when isnull(zp0.開始日付,'') = ''
		then isnull(za0.着工日付,za0.工期自日付)
		else
			case
				when zp0.開始日付 < isnull(za0.着工日付,za0.工期自日付)
				then zp0.開始日付
				else isnull(za0.着工日付,za0.工期自日付)
			end
	end
	as 工期自日付
,
	case
		when isnull(zp0.終了日付,'') = ''
		then isnull(za0.竣工日付,za0.工期至日付)
		else
			case
				when zp0.終了日付 > isnull(za0.竣工日付,za0.工期至日付)
				then zp0.終了日付
				else isnull(za0.竣工日付,za0.工期至日付)
			end
	end
	as 工期至日付
,	za0.着工日付
,	za0.竣工日付
,	zp0.出来高
,	zp0.稼働人員
from
	工事台帳_T as za0
INNER JOIN
    g0 AS zp0
    ON zp0.工事年度 = za0.工事年度
    AND zp0.工事種別 = za0.工事種別
    AND zp0.工事項番 = za0.工事項番
LEFT OUTER JOIN
    発注先_Q AS zc0
    ON zc0.工事種別 = za0.工事種別
    AND zc0.取引先コード = za0.取引先コード
where
	( isnull(za0.停止日付,'') = '' )
)
,

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
,	a0.取引先コード
,   a0.取引先名
,   a0.取引先略称
,   a0.工事件名
,	a0.開始日付
,	a0.終了日付
,	w2.和暦日付 as 和暦開始日付
,	w2.和暦日付略称 as 和暦開始日付略称
,	w3.和暦日付 as 和暦終了日付
,	w3.和暦日付略称 as 和暦終了日付略称
,	a0.工期自日付
,	a0.工期至日付
,
	case
		when isnull(a0.終了日付,'') = ''
		then null
		when a0.終了日付 = a0.工期至日付
		then a0.終了日付
		else null
	end
	as 完了日付
,	a0.出来高
,	a0.稼働人員
FROM
	z0 as a0
LEFT OUTER JOIN
    工事種別_T AS d0
    ON d0.工事種別 = a0.工事種別
LEFT OUTER JOIN
	カレンダ_Q as w2
	on w2.日付 = a0.開始日付
LEFT OUTER JOIN
	カレンダ_Q as w3
	on w3.日付 = a0.終了日付
)

select
	*
from
	v0 as v000
