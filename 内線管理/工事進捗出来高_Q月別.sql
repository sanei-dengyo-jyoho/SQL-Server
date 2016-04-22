with

t0 as
(
select top 100 percent
	ta0.工事年度
,	ta0.工事種別
,	ta0.工事項番
,	ta0.日付
,	max(ta0.出来高) as 出来高
,	sum(ta0.稼働人員) as 稼働人員
from
	工事進捗管理_Tサブタスク_出来高 as ta0
group by
	ta0.工事年度
,	ta0.工事種別
,	ta0.工事項番
,	ta0.日付
order by
	ta0.工事年度
,	ta0.工事種別
,	ta0.工事項番
,	ta0.日付 desc
)
,

v1 as
(
select distinct
   	dbo.FuncMakeConstructNumber(ct0.工事年度,ct0.工事種別,ct0.工事項番) AS 工事番号
,	ct0.工事年度
,	ct0.工事種別
,	ct0.工事項番
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
	,	min(za0.日付) as 開始日付
	,	max(za0.日付) as 終了日付
	from
		t0 as za0
	group by
		za0.工事年度
	,	za0.工事種別
	,	za0.工事項番
	)
	as ct0
cross apply
	(
	select
		ct2.年度
	,	ct2.年
	,	ct2.月
	,	ct2.日
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
		max(t01.出来高) as 出来高
	from
		t0 as t01
	where
		( t01.工事年度 = ct0.工事年度 )
		and ( t01.工事種別 = ct0.工事種別 )
		and ( t01.工事項番 = ct0.工事項番 )
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
		and ( e01.日付 = ct1.日付 )
	)
	as l1 (稼働人員)
-- 年月でレコードを集計 --
group by
	ct0.工事年度
,	ct0.工事種別
,	ct0.工事項番
,	ct1.年度
,	ct1.年
,	ct1.月
)

select
	*
from
	v1 as v100
