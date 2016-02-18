with

p0 as
(
select
    pa0.工事年度
,   pa0.工事種別
,   pa0.工事項番
,   100+pa0.請求回数 as 追加回数
,   N'（追加）' as 追加種別
,   pa0.請求本体金額
,   pa0.請求消費税率
,   pa0.請求消費税額
from
    請求_T as pa0
where
    ( isnull(pa0.振替先部門コード,0) = 0 )
    and ( isnull(pa0.請求区分,0) > 1 )

union all

select
    pb0.工事年度
,   pb0.工事種別
,   pb0.工事項番
,   200+pb0.請求回数 as 追加回数
,   N'（振替）' as 追加種別
,   pb0.請求本体金額
,   pb0.請求消費税率
,   pb0.請求消費税額
from
    請求_T as pb0
where
    ( isnull(pb0.振替先部門コード,0) <> 0 )
)
,

r0 as
(
select top 100 percent
    工事年度
,   工事種別
,   工事項番
,
	row_number()
	over(
		partition by
		    工事年度
        ,   工事種別
        ,   工事項番
		order by
            追加回数
		)
	as 回数
,   追加種別
,   請求本体金額
,   請求消費税率
,   請求消費税額
from
    p0 as ra0
)
,

s0 as
(
select
    工事年度
,	工事種別
,	工事項番
,	sum(請求本体金額) as 請求本体金額
,	max(請求消費税率) as 請求消費税率
,	sum(請求消費税額) as 請求消費税額
from
    r0 as sa0
group by
    工事年度
,   工事種別
,   工事項番
)
,

z0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	取引先コード
,	工事件名
,	isnull(着工日付,工期自日付) as 開始日付
,	isnull(竣工日付,工期至日付) as 終了日付
,	isnull(着工日付,工期自日付) as 工期自日付
,	isnull(竣工日付,工期至日付) as 工期至日付
,	受注日付
,	着工日付
,	竣工日付
,   受注金額
,   消費税率
,   消費税額
,	担当会社コード
,	担当部門コード
,	担当社員コード
from
	工事台帳_T as za0
where
	( isnull(停止日付,'') = '' )
)
,

cte
(
	工事年度
,	工事種別
,	工事項番
,	工期日付
)
as
(
select
	ct0.工事年度
,	ct0.工事種別
,	ct0.工事項番
,	datefromparts(year(ct0.開始日付),month(ct0.開始日付),1) as 工期日付
from
	z0 as ct0

union all

select
	bt1.工事年度
,	bt1.工事種別
,	bt1.工事項番
,	dateadd(day,1,bt1.工期日付) as 工期日付
from
	cte as bt1
inner join
	z0 as ct1
	on ct1.工事年度 = bt1.工事年度
	and ct1.工事種別 = bt1.工事種別
	and ct1.工事項番 = bt1.工事項番
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
,	dc0.年 as 工期年
,	dc0.月 as 工期月
,	dc0.年*100+dc0.月 as 工期年月
,	DATEFROMPARTS(dc0.年,dc0.月,1) as 工期日付
from
	cte as da0
left outer join
	カレンダ_T as dc0
	on dc0.日付 = da0.工期日付
group by
	da0.工事年度
,	da0.工事種別
,	da0.工事項番
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
,	w1.和暦年表示+N'度' as 和暦工期年度
,	w0.年度 as 工期年度
,	w0.和暦年表示 as 和暦工期年
,	a0.工期年月
,	a0.工期年
,	a0.工期月
,	b0.取引先コード
,   c0.取引先名
,   c0.取引先略称
,   b0.工事件名
,	b0.開始日付
,	b0.終了日付
,	year(b0.開始日付)*100+month(b0.開始日付) as 開始年月
,	year(b0.終了日付)*100+month(b0.終了日付) as 終了年月
,	b0.工期自日付
,	b0.工期至日付
,	w2.和暦日付 as 和暦工期自日付
,	w2.和暦日付略称 as 和暦工期自日付略称
,	w3.和暦日付 as 和暦工期至日付
,	w3.和暦日付略称 as 和暦工期至日付略称
,
	case
		when isnull(b0.受注日付,'') = ''
		then null
		else year(b0.受注日付)*100+month(b0.受注日付)
	end
	as 受注年月
,	b0.受注日付
,	b0.着工日付
,	b0.竣工日付
,	w4.和暦日付 as 和暦竣工日付
,	w4.和暦日付略称 as 和暦竣工日付略称
,	day(eomonth(a0.工期日付)) as 最終日
,
	case
		when b0.開始日付 > a0.工期日付
		then day(b0.開始日付)
		else 0
	end
	as 着工日
,
	case
		when b0.終了日付 >= a0.工期日付
		then
			case
				when b0.終了日付 > eomonth(a0.工期日付)
				then day(eomonth(a0.工期日付))
				else day(b0.終了日付)
			end
		else 0
	end
	as 完工日
,
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
	as 工期至日
,
	case
		when b0.竣工日付 >= a0.工期日付
		then
			case
				when b0.竣工日付 > eomonth(a0.工期日付)
				then day(eomonth(a0.工期日付))
				else day(b0.竣工日付)
			end
		else 0
	end
	as 竣工日
,
	replace(
        	(
        	select top 100 percent
				/*N'（追加' + convert(nvarchar(10),xr0.回数) + N'）' +*/
				xr0.追加種別 +
				convert(nvarchar(50),format(xr0.請求本体金額,'C'))
				as [data()]
        	from
        		r0 as xr0
        	where
        		( xr0.工事年度 = b0.工事年度 )
        		and ( xr0.工事種別 = b0.工事種別 )
        		and ( xr0.工事項番 = b0.工事項番 )
        	order by
        		xr0.回数
        	for XML PATH ('')
        	)
	        , ' ', char(13)+char(10)
            )
    as 追加受注金額
,	isnull(b0.受注金額,0)+isnull(xs0.請求本体金額,0) as 売上受注金額
,   b0.受注金額
,   b0.消費税率
,   b0.消費税額
,	j0.税別出資比率詳細
,   s0.部門名 AS 担当部門名
,   s0.部門名略称 AS 担当部門名略称
,   e0.氏名 AS 担当者名
,
	isnull(e0.氏,N'')
	+
	case
		when isnull(y0.職制名略称,N'') = N''
		then N''
		when isnull(y0.職制名略称,N'') = N'課長'
		then N'ＧＬ'
		when isnull(y0.職制区分,0) > 5
		then N'担当'
		else y0.職制名略称
	end
	as 担当者
from
	d0 as a0
left outer join
	z0 as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
left outer join
	s0 as xs0
	on xs0.工事年度 = a0.工事年度
	and xs0.工事種別 = a0.工事種別
	and xs0.工事項番 = a0.工事項番
left outer join
	カレンダ_Q as w0
	on w0.日付 = a0.工期日付
left outer join
	カレンダ_Q as w1
	on w1.日付 = datefromparts(w0.年度,1,1)
left outer join
	カレンダ_Q as w2
	on w2.日付 = b0.工期自日付
left outer join
	カレンダ_Q as w3
	on w3.日付 = b0.工期至日付
left outer join
	カレンダ_Q as w4
	on w4.日付 = b0.竣工日付
left outer join
	工事台帳_Q共同企業体出資比率 as j0
	on j0.工事年度 = a0.工事年度
	and j0.工事種別 = a0.工事種別
	and j0.工事項番 = a0.工事項番
LEFT OUTER JOIN
    発注先_Q AS c0
    ON c0.工事種別 = b0.工事種別
    AND c0.取引先コード = b0.取引先コード
LEFT OUTER JOIN
    部門_T年度 AS s0
    ON s0.年度 = a0.工事年度
    AND s0.会社コード = b0.担当会社コード
    AND s0.部門コード = b0.担当部門コード
LEFT OUTER JOIN
    社員_T年度 AS e0
    ON e0.年度 = a0.工事年度
    AND e0.会社コード = b0.担当会社コード
    AND e0.社員コード = b0.担当社員コード
LEFT OUTER JOIN
    職制_T AS y0
    ON y0.職制区分 = e0.職制区分
    AND y0.職制コード = e0.職制コード
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
	 	when isnull(担当部門名略称,N'') = N''
		then N''
	 	when isnull(担当部門名略称,N'') like N'内線%'
		then N''
		else 担当部門名略称+N'　'
	end
	+ 担当者 as 担当
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
