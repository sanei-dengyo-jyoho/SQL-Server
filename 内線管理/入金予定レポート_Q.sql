with

v1 as
(
select distinct
	ar1.工事年度
,	ar1.工事種別
,	ar1.工事項番
,	ar1.請求回数
,	ar1.請求日付
,	ar1.請求区分
,	ar1.請求区分名
,	ar1.請求区分省略
,	ar1.請求金額
,	cr1.年度 as 入金年度
,	year(ar1.入金日付) * 100 + month(ar1.入金日付) as 入金年月
,	ar1.入金日付
from
	(
	select distinct
		ar0.工事年度
	,	ar0.工事種別
	,	ar0.工事項番
	,	ar0.請求回数
	,	ar0.請求日付
	,	ar0.請求区分
	,	hr0.請求区分名
	,	hr0.請求区分省略
	,
		isnull(ar0.請求本体金額,0) +
		isnull(ar0.請求消費税額,0)
		as 請求金額
	,
		case
			when cr0.入金条件名 = N'手形'
			then
			 	case
					when isnull(ar0.予定手形サイト,0) = 0
					then dateadd(month,1,ar0.請求日付)
					else dateadd(day,ar0.予定手形サイト,ar0.請求日付)
				end
			else dateadd(month,1,ar0.請求日付)
		end
		as 入金日付
	from
		請求_T as ar0
	inner join
		入金条件_T as cr0
		on cr0.入金条件 = ar0.入金条件
	left outer join
		入金_T as br0
		on br0.工事年度 = ar0.工事年度
		and br0.工事種別 = ar0.工事種別
		and br0.工事項番 = ar0.工事項番
		and br0.請求回数 = ar0.請求回数
	left outer join
	    請求区分_T as hr0
	    on hr0.請求区分 = ar0.請求区分
	where
		( isnull(ar0.請求日付,'') <> '' )
		and ( isnull(ar0.振替先部門コード,'') = '' )
		and ( br0.工事年度 is null )
	)
	as ar1
left outer join
	カレンダ_T as cr1
	on cr1.日付 = ar1.入金日付
)
,

v2 as
(
select
	dbo.FuncMakeConstructNumber(a2.工事年度,a2.工事種別,a2.工事項番) AS 工事番号
,	a2.工事年度
,	a2.工事種別
,	a2.工事項番
,	a2.請求区分
,	a2.請求区分名
,	a2.請求区分省略
,	b2.取引先コード
,	h2.取引先名
,	b2.工事件名
,
	case
		when isnull(b2.竣工日付,'') <> ''
		then 0
		else 999999
	end
	as 完工区分
,
	concat(
		case
			when isnull(b2.竣工日付,'') <> ''
			then N''
			else
				concat(
					N'（ 第',
					convert(nvarchar(4),a2.請求回数),
					N'回請求 ）'
				)
		end,
		case
			when isnull(a2.請求区分省略,N'') = N''
			then N''
			else concat(N'　',a2.請求区分省略)
		end
	)
	as 請求内容
,
	case
		when isnull(b2.竣工日付,'') <> ''
		then N''
		else
			concat(
				N'（ 工期 ',
				dbo.FuncMakeConstructPeriod(
					w21.和暦日付略称,
					w22.和暦日付略称,
					DEFAULT
				)
			)
	end
	as 工期
,	b2.受注日付
,	b2.竣工日付
,	a2.入金年度
,	a2.入金年月
,	a2.入金日付
,	a2.請求日付
,	w2.和暦日付略称 as 請求日付略称
,	a2.請求回数
,	a2.請求金額
,
	case
		when isnull(b2.竣工日付,'') <> ''
		then concat(w23.和暦日付略称,N' 完工')
		else
			concat(
				N'未成　　 ',
				dbo.FuncMakeMoneyFormat(
					isnull(b2.受注金額,0) +
					isnull(b2.消費税額,0)
				)
			)
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
	カレンダ_Q as w23
	on w23.日付 = b2.竣工日付
where
	( isnull(j2.[JV],0) = 0 )
)

select
	*
from
	v2 as v200
