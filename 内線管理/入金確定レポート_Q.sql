with

v1 as
(
select distinct
	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.請求回数
,	a0.回収日付 as 入金日付
,	c0.年度 as 入金年度
,	year(a0.回収日付) * 100 + month(a0.回収日付) as 入金年月
,
	isnull(a0.振込金額,0) +
	isnull(a0.振込手数料,0) +
	isnull(a0.手形金額,0)
	as 入金金額
,	a0.振込手数料
,	b0.請求日付
,
	isnull(b0.請求本体金額,0) +
	isnull(b0.請求消費税額,0)
	as 請求金額
from
	入金_T as a0
inner join
	請求_T as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
	and b0.請求回数 = a0.請求回数
left outer join
	カレンダ_T as c0
	on c0.日付 = a0.回収日付
where
	( isnull(a0.回収日付,'') <> '' )
)
,

v2 as
(
select
	dbo.FuncMakeConstructNumber(a2.工事年度,a2.工事種別,a2.工事項番) AS 工事番号
,	a2.工事年度
,	a2.工事種別
,	a2.工事項番
,	b2.取引先コード
,	h2.取引先名
,	b2.工事件名
,
	case
		when a2.請求回数 = 1
		then N''
		else
			concat(
				N'第',
				convert(nvarchar(4),a2.請求回数),
				N'回',
				N'　（受注金額 ',
				dbo.FuncMakeMoneyFormat(
					isnull(b2.受注金額,0) +
					isnull(b2.消費税額,0)
				),
				N' の内請求金）'
			)
	end
	as 請求内容
,
	concat(
		case
			when a2.請求回数 = 1
			then N''
			else
				concat(
					N'工期 ',
					dbo.FuncMakeConstructPeriod(
						w21.和暦日付略称,
						w22.和暦日付略称,
						DEFAULT
					)
				)
		end,
		case
			when isnull(x2.予定手形入金額,0) <> 0
			then
				concat(
					N'　　　手形',
					dbo.FuncMakeMoneyFormat(x2.予定手形入金額),
					N'　未入金'
				)
			else N''
		end
	)
	as 工期
,	b2.受注日付
,	b2.竣工日付
,	a2.入金年度
,	a2.入金年月
,	a2.入金日付
,	a2.入金金額
,	a2.振込手数料
,	a2.請求日付
,	w2.和暦日付略称 as 請求日付略称
,	a2.請求回数
,	a2.請求金額
,
	case
		when isnull(b2.竣工日付,'') = ''
		then N'未成工事受入金'
		when isnull(a2.振込手数料,0) <> 0
		then concat(N'振込手数料 ',dbo.FuncMakeMoneyFormat(a2.振込手数料))
		else concat(convert(nvarchar(4),month(b2.竣工日付)),N'月分')
	end
	as 備考
from
	v1 as a2
inner join
	工事台帳_T as b2
	on b2.工事年度 = a2.工事年度
	and b2.工事種別 = a2.工事種別
	and b2.工事項番 = a2.工事項番
inner join
    発注先_Q AS h2
    ON h2.工事種別 = b2.工事種別
    AND h2.取引先コード = b2.取引先コード
OUTER APPLY
	(
	SELECT
		j0.工事年度
	,	j0.工事種別
	,	j0.工事項番
	,	COUNT(j0.工事年度) AS [JV]
	FROM
		工事台帳_T共同企業体 AS j0
	WHERE
		( j0.工事年度 = a2.工事年度 )
		AND ( j0.工事種別 = a2.工事種別 )
		AND ( j0.工事項番 = a2.工事項番 )
	GROUP BY
		j0.工事年度
	,	j0.工事種別
	,	j0.工事項番
	)
	AS j2
left outer join
	カレンダ_Q as w2
	on w2.日付 = a2.請求日付
left outer join
	カレンダ_Q as w21
	on w21.日付 = b2.工期自日付
left outer join
	カレンダ_Q as w22
	on w22.日付 = b2.工期至日付
left outer join
	(
	select
		ra1.工事年度
	,	ra1.工事種別
	,	ra1.工事項番
	,	sum(ra1.予定手形入金額) as 予定手形入金額
	from
		(
		select distinct
			ra0.工事年度
		,	ra0.工事種別
		,	ra0.工事項番
		,	ra0.請求回数
		,	ra0.予定手形入金額
		from
			請求_T as ra0
		left outer join
			入金_T as rb0
			on rb0.工事年度 = ra0.工事年度
			and rb0.工事種別 = ra0.工事種別
			and rb0.工事項番 = ra0.工事項番
			and rb0.請求回数 = ra0.請求回数
		where
			( isnull(ra0.請求日付,'') <> '' )
			and ( isnull(ra0.振替先部門コード,'') = '' )
			and ( isnull(ra0.入金条件,1) = 2 )
			and ( rb0.工事年度 is null )
		)
		as ra1
	group by
		ra1.工事年度
	,	ra1.工事種別
	,	ra1.工事項番
	)
	as x2
	on x2.工事年度 = a2.工事年度
	and x2.工事種別 = a2.工事種別
	and x2.工事項番 = a2.工事項番
where
	( isnull(j2.[JV],0) = 0 )
)

select
	*
from
	v2 as v200
