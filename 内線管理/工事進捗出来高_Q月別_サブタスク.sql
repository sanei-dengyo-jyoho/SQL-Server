with

t0 as
(
select top 100 percent
	ta0.工事年度
,	ta0.工事種別
,	ta0.工事項番
,	ta0.タスク番号
,	ta0.サブタスク番号
,	ta0.日付
,	ta0.出来高
,	ta0.稼働人員
from
	工事進捗管理_Tサブタスク_出来高 as ta0
order by
	ta0.工事年度
,	ta0.工事種別
,	ta0.工事項番
,	ta0.タスク番号
,	ta0.サブタスク番号
,	ta0.日付 desc
)
,

v2 as
(
select
	dbo.FuncMakeConstructNumber(a2.工事年度,a2.工事種別,a2.工事項番) AS 工事番号
,	a2.工事年度
,	a2.工事種別
,	a2.工事項番
,	a2.タスク番号
,	a2.タスク名
,	a2.サブタスク番号
,	a2.サブタスク名
,	b2.工期年度
,	b2.工期年月
,	b2.工期日付
,
	case
		when b2.工期日付 > a2.開始日付
		then
			case
				when
					year(b2.工期日付) * 100 + month(b2.工期日付)
					<>
					year(a2.開始日付) * 100 + month(a2.開始日付)
				then datefromparts(year(b2.工期日付),month(b2.工期日付),1)
				else a2.開始日付
			end
		else datefromparts(year(a2.開始日付),month(a2.開始日付),1)
	end
	as 開始日付
,
	case
		when a2.終了日付 > b2.工期日付
		then eomonth(b2.工期日付)
		else a2.終了日付
	end
	as 終了日付
,	b2.出来高
,	b2.稼働人員
from
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
    as a2
left outer join
	(
	select distinct
		ct0.工事年度
	,	ct0.工事種別
	,	ct0.工事項番
	,	ct0.タスク番号
	,	ct0.サブタスク番号
	,	ct1.年度 as 工期年度
	,	ct1.年 * 100 + ct1.月 as 工期年月
	,	max(ct1.日付) as 工期日付
	,	max(l0.出来高) as 出来高
	,	sum(l1.稼働人員) as 稼働人員
	-- 開始日から終了日までのレコードを生成 --
	from
		(
		select
			za0.工事年度
		,	za0.工事種別
		,	za0.工事項番
		,	za0.タスク番号
		,	za0.サブタスク番号
		,	min(za0.日付) as 開始日付
		,	max(za0.日付) as 終了日付
		from
			t0 as za0
		group by
			za0.工事年度
		,	za0.工事種別
		,	za0.工事項番
		,	za0.タスク番号
		,	za0.サブタスク番号
		)
		as ct0
	cross apply
		(
		select
			ct2.年度
		,	ct2.年
		,	ct2.月
		,	ct2.日付
		from
			(
			select top 100 percent
				cal0.年度
			,	cal0.年
			,	cal0.月
			,	cal0.日
			,	cal0.日付
			from
				カレンダ_T as cal0
			order by
				cal0.日付
			)
			as ct2
		where
			( ct2.日付 between ct0.開始日付 and ct0.終了日付 )
		)
	    as ct1
	-- 最近の日付ごとの出来高を検索 --
	outer apply
		(
		select top 1
			max(t01.出来高)
		from
			t0 as t01
		where
			( t01.工事年度 = ct0.工事年度 )
			and ( t01.工事種別 = ct0.工事種別 )
			and ( t01.工事項番 = ct0.工事項番 )
			and ( t01.タスク番号 = ct0.タスク番号 )
			and ( t01.サブタスク番号 = ct0.サブタスク番号 )
			and ( t01.日付 <= ct1.日付 )
		)
		as l0 (出来高)
	-- 日付ごとの稼働人員を検索 --
	outer apply
		(
		select top 1
			e01.稼働人員
		from
			t0 as e01
		where
			( e01.工事年度 = ct0.工事年度 )
			and ( e01.工事種別 = ct0.工事種別 )
			and ( e01.工事項番 = ct0.工事項番 )
			and ( e01.タスク番号 = ct0.タスク番号 )
			and ( e01.サブタスク番号 = ct0.サブタスク番号 )
			and ( e01.日付 = ct1.日付 )
		)
		as l1 (稼働人員)
	group by
		ct0.工事年度
	,	ct0.工事種別
	,	ct0.工事項番
	,	ct0.タスク番号
	,	ct0.サブタスク番号
	,	ct1.年度
	,	ct1.年
	,	ct1.月
	)
	as b2
	on b2.工事年度 = a2.工事年度
	and b2.工事種別 = a2.工事種別
	and b2.工事項番 = a2.工事項番
	and b2.タスク番号 = a2.タスク番号
	and b2.サブタスク番号 = a2.サブタスク番号
)

select
	*
from
	v2 as v200
