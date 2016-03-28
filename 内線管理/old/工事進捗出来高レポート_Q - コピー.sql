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

cte0
(
	工事年度
,	工事種別
,	工事項番
,	タスク番号
,	タスク名
,	サブタスク番号
,	サブタスク名
,	工期日付
)
as
(
select
	ct0.工事年度
,	ct0.工事種別
,	ct0.工事項番
,	ct0.タスク番号
,	ct0.タスク名
,	ct0.サブタスク番号
,	ct0.サブタスク名
,	ct0.開始日付 as 工期日付
from
	z0 as ct0

union all

select
	bt1.工事年度
,	bt1.工事種別
,	bt1.工事項番
,	bt1.タスク番号
,	bt1.タスク名
,	bt1.サブタスク番号
,	bt1.サブタスク名
,	dateadd(day,1,bt1.工期日付) as 工期日付
from
	cte0 as bt1
inner join
	z0 as ct1
	on ct1.工事年度 = bt1.工事年度
	and ct1.工事種別 = bt1.工事種別
	and ct1.工事項番 = bt1.工事項番
	and ct1.タスク番号 = bt1.タスク番号
	and ct1.タスク名 = bt1.タスク名
	and ct1.サブタスク番号 = bt1.サブタスク番号
	and ct1.サブタスク名 = bt1.サブタスク名
where
	bt1.工期日付 < ct1.終了日付
)
,

d0 as
(
select distinct
	da0.工事年度
,	da0.工事種別
,	da0.工事項番
,	da0.タスク番号
,	da0.タスク名
,	da0.サブタスク番号
,	da0.サブタスク名
,	dc0.年 as 工期年
,	dc0.月 as 工期月
,	dc0.年 * 100 + dc0.月 as 工期年月
,	DATEFROMPARTS(dc0.年,dc0.月,1) as 工期日付
from
	cte0 as da0
left outer join
	カレンダ_T as dc0
	on dc0.日付 = da0.工期日付
group by
	da0.工事年度
,	da0.工事種別
,	da0.工事項番
,	da0.タスク番号
,	da0.タスク名
,	da0.サブタスク番号
,	da0.サブタスク名
,	dc0.年
,	dc0.月
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
,	w1.和暦年表示 + N'度' as 和暦工期年度
,	w0.年度 as 工期年度
,	w0.和暦年表示 as 和暦工期年
,	a0.工期年月
,	a0.工期年
,	a0.工期月
,	b0.取引先コード
,   b0.取引先名
,   b0.取引先略称
,   b0.工事件名
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
	d0 as a0
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
,

v1 as
(
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
	v0 as a1
)

select
	*
from
	v1 as v100
