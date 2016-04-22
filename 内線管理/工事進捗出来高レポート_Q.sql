with

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
,	zp0.開始日付 as サブタスク開始日付
,	zp0.終了日付 as サブタスク終了日付
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
	as 開始日付
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
	as 終了日付
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
FROM
	工事台帳_T as za0
INNER JOIN
    発注先_Q AS zc0
    ON zc0.工事種別 = za0.工事種別
    AND zc0.取引先コード = za0.取引先コード
INNER JOIN
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
    AS zp0
    ON zp0.工事年度 = za0.工事年度
    AND zp0.工事種別 = za0.工事種別
    AND zp0.工事項番 = za0.工事項番
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
,	concat(w1.和暦年表示,N'度') as 和暦工期年度
,	w0.年度 as 工期年度
,	w0.和暦年表示 as 和暦工期年
,	a0.工期年月
,	a0.工期年
,	a0.工期月
,	b0.取引先コード
,	b0.取引先名
,	b0.取引先略称
,	b0.工事件名
,	p0.開始日付
,	p0.終了日付
,	w2.和暦日付 as 和暦開始日付
,	w2.和暦日付略称 as 和暦開始日付略称
,	w3.和暦日付 as 和暦終了日付
,	w3.和暦日付略称 as 和暦終了日付略称
,	year(p0.開始日付) * 100 + month(p0.開始日付) as 開始年月
,	year(p0.終了日付) * 100 + month(p0.終了日付) as 終了年月
,	b0.着工日付
,	b0.竣工日付
,	day(eomonth(a0.工期日付)) as 最終日
,
	case
		when isnull(p0.工期年月,0) = 0
		then 0
		else
			case
				when p0.開始日付 > a0.工期日付
				then day(p0.開始日付)
				else 0
			end
	end
	as 着工日
,
	case
		when isnull(p0.工期年月,0) = 0
		then 0
		else
			case
				when p0.終了日付 >= a0.工期日付
				then
					case
						when p0.終了日付 > eomonth(a0.工期日付)
						then day(eomonth(a0.工期日付))
						else day(p0.終了日付)
					end
				else 0
			end
	end
	as 完工日
,
	case
		when isnull(p0.工期年月,0) = 0
		then 0
		else
			case
				when b0.工期至日付 >= a0.工期日付
				then
					case
						when b0.工期至日付 > eomonth(a0.工期日付)
						then day(eomonth(a0.工期日付))
						else day(b0.工期至日付)
					end
				else 0
			end
	end
	as 工期至日
,
	case
		when isnull(p0.工期年月,0) = 0
		then 0
		else
			case
				when b0.工期至日付 >= a0.工期日付
				then
					case
						when b0.工期至日付 > eomonth(a0.工期日付)
						then day(eomonth(a0.工期日付))
						else day(b0.工期至日付)
					end
				else 0
			end
	end
	as 竣工日
,	p0.出来高
,	p0.稼働人員
FROM
	(
	select distinct
		ct0.工事年度
	,	ct0.工事種別
	,	ct0.工事項番
	,	ct0.タスク番号
	,	ct0.タスク名
	,	ct0.サブタスク番号
	,	ct0.サブタスク名
	,	ct1.年 as 工期年
	,	ct1.月 as 工期月
	,	ct1.年 * 100 + ct1.月 as 工期年月
	,	DATEFROMPARTS(ct1.年,ct1.月,1) as 工期日付
	from
		z0 as ct0
	-- 開始日から終了日までのレコードを生成 --
	cross apply
		(
		select
			ct2.年
		,	ct2.月
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
	group by
		ct0.工事年度
	,	ct0.工事種別
	,	ct0.工事項番
	,	ct0.タスク番号
	,	ct0.タスク名
	,	ct0.サブタスク番号
	,	ct0.サブタスク名
	,	ct1.年
	,	ct1.月
	)
	as a0
LEFT OUTER JOIN
	z0 as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
	and b0.タスク番号 = a0.タスク番号
	and b0.サブタスク番号 = a0.サブタスク番号
LEFT OUTER JOIN
	工事進捗出来高_Q月別_サブタスク as p0
	on p0.工事年度 = a0.工事年度
	and p0.工事種別 = a0.工事種別
	and p0.工事項番 = a0.工事項番
	and p0.タスク番号 = a0.タスク番号
	and p0.サブタスク番号 = a0.サブタスク番号
	and p0.工期年月 = a0.工期年月
LEFT OUTER JOIN
    工事種別_T AS d0
    ON d0.工事種別 = a0.工事種別
LEFT OUTER JOIN
	カレンダ_Q as w0
	on w0.日付 = a0.工期日付
LEFT OUTER JOIN
	カレンダ_Q as w1
	on w1.日付 = datefromparts(w0.年度,1,1)
LEFT OUTER JOIN
	カレンダ_Q as w2
	on w2.日付 = b0.サブタスク開始日付
LEFT OUTER JOIN
	カレンダ_Q as w3
	on w3.日付 = b0.サブタスク終了日付
where
	( b0.終了日付 >= a0.工期日付 )
)

select
	*
,
	case
		when 完工日 = 工期至日
		then 完工日 - 着工日
		when 工期至日 = 0
		then 0
		else (完工日 - 着工日) - (竣工日 - 工期至日)
	end
	as 完工日数
,
	case
		when 工期至日 = 0
		then 完工日
		else (完工日 - 工期至日)
	end
	as 超過日数
from
	v0 as v000
