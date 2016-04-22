with

z0 as
(
select
	za0.工事年度
,	za0.工事種別
,	za0.工事項番
,	za0.取引先コード
,	za0.工事件名
,	za0.工期自日付
,	za0.工期至日付
,	year(za0.受注日付) * 100 + month(za0.受注日付) as 受注年月
,	za0.受注日付
,	za0.竣工日付
,	za0.受注金額
,	za0.消費税率
,	za0.消費税額
from
	工事台帳_T as za0
where
	( isnull(za0.停止日付,'') = '' )
)
,

v0 as
(
select
	a0.年度 +
	(
	SELECT TOP 1
		t0.期別加算
	FROM
		当社_Q内線 as t0
	)
	AS 期
,	a0.年度
,	a0.年
,	a0.月
,	a0.年月
,	a0.年月表示

,	dbo.FuncMakeConstructNumber(b0.工事年度,b0.工事種別,b0.工事項番)
	as 工事番号
,	b0.工事種別
,	d0.工事種別名 as 発注種別
,	c0.発注先種別名 as 顧客
,	b0.取引先コード
,	c0.取引先名 as 発注先
,	c0.取引先略称 as 発注先略称
,	b0.工事件名
,
	dbo.FuncMakeConstructPeriod(b0.工期自日付,b0.工期至日付,DEFAULT)
	as 工期
,	b0.受注年月
,
	case
		when isnull(b0.受注日付,'') = ''
		then null
		else
			case
				when b0.受注年月 = a0.年月
				then 1
				else null
			end
	end
	as 受注
,	b0.受注日付 as 受注日
,	w1.和暦日付 as 和暦受注日
,	w1.和暦日付略称 as 和暦受注日略称
,
	case
		when a0.年月 = b0.受注年月
		then b0.受注金額
		else null
	end
	as 受注金額
,	b0.消費税率
,
	case
		when a0.年月 = b0.受注年月
		then b0.消費税額
		else null
	end
	as 消費税額
,
	case
		when isnull(a0.完工日付,'') = ''
		then null
		else 1
	end
	as 完工
,	a0.完工日付 as 完工日
,	w2.和暦日付 as 和暦完工日
,	w2.和暦日付略称 as 和暦完工日略称
,	a0.完成金額
,
	case
		when isnull(a0.予定日付,'') = ''
		then null
		else 1
	end
	as 予定
,	a0.予定日付 as 予定日
,	w3.和暦日付 as 和暦予定日
,	w3.和暦日付略称 as 和暦予定日略称
,	a0.予定金額
,	j0.税別出資比率詳細
from
	(
	select
		xa0.年度
	,	xa0.年
	,	xa0.月
	,	xa0.年 * 100 + xa0.月 as 年月
	,
		convert(nvarchar(50),
			format(xa0.年,'D4') +
			N'年' +
			format(xa0.月,'D2') +
			N'月'
		) as 年月表示
	,	xa0.工事年度
	,	xa0.工事種別
	,	xa0.工事項番
	,	max(xa0.完工日付) as 完工日付
	,	max(xa0.完成金額) as 完成金額
	,	max(xa0.予定日付) as 予定日付
	,	max(xa0.予定金額) as 予定金額
	from
		(
		select
			yw1.年度 as 年度
		,	year(ya1.受注日付) as 年
		,	month(ya1.受注日付) as 月
		,	ya1.工事年度
		,	ya1.工事種別
		,	ya1.工事項番
		,	null as 完工日付
		,	null as 完成金額
		,	null as 予定日付
		,	null as 予定金額
		from
			z0 as ya1
		left outer join
			カレンダ_Q as yw1
			on yw1.日付 = ya1.受注日付

		union all

		select
			yw2.年度 as 年度
		,	year(ya2.竣工日付) as 年
		,	month(ya2.竣工日付) as 月
		,	ya2.工事年度
		,	ya2.工事種別
		,	ya2.工事項番
		,	ya2.竣工日付 as 完工日付
		,	ya2.受注金額 as 完成金額
		,	null as 予定日付
		,	null as 予定金額
		from
			z0 as ya2
		left outer join
			カレンダ_Q as yw2
			on yw2.日付 = ya2.竣工日付
		where
			( isnull(ya2.竣工日付,'') <> '' )

		union all

		select
			yw3.年度 as 年度
		,	year(ya3.工期至日付) as 年
		,	month(ya3.工期至日付) as 月
		,	ya3.工事年度
		,	ya3.工事種別
		,	ya3.工事項番
		,	null as 完工日付
		,	null as 完成金額
		,	ya3.工期至日付 as 予定日付
		,	ya3.受注金額 as 予定金額
		from
			z0 as ya3
		left outer join
			カレンダ_Q as yw3
			on yw3.日付 = ya3.工期至日付
		where
			( isnull(ya3.竣工日付,'') = '' )
		)
		as xa0
	group by
		xa0.年度
	,	xa0.年
	,	xa0.月
	,	xa0.工事年度
	,	xa0.工事種別
	,	xa0.工事項番
	)
	as a0
inner join
	z0 as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
inner join
	工事種別_T as d0
	on d0.工事種別 = b0.工事種別
inner join
    発注先_Q AS c0
    ON c0.工事種別 = b0.工事種別
    AND c0.取引先コード = b0.取引先コード
left outer join
	カレンダ_Q as w1
	on w1.日付 = b0.受注日付
left outer join
	カレンダ_Q as w2
	on w2.日付 = a0.完工日付
left outer join
	カレンダ_Q as w3
	on w3.日付 = a0.予定日付
left outer join
	工事台帳_Q共同企業体出資比率 as j0
	on j0.工事年度 = b0.工事年度
	and j0.工事種別 = b0.工事種別
	and j0.工事項番 = b0.工事項番
)

select
	*
from
	v0 as v000
