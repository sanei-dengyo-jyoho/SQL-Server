with

z0 as
(
select
	za0.工事年度
,	za0.工事種別
,	za0.工事項番
,	za0.取引先コード
,	zc0.取引先名
,	zc0.取引先略称
,	0 as 得意先
,	za0.工事件名
,	isnull(za0.着工日付,za0.工期自日付) as 工期自日付
,	isnull(za0.竣工日付,za0.工期至日付) as 工期至日付
,	za0.受注日付
,	za0.着工日付
,	za0.竣工日付
,   za0.受注金額
,   za0.消費税率
,   za0.消費税額
,	za0.担当会社コード
,	za0.担当部門コード
,	za0.担当社員コード
from
	工事台帳_T as za0
LEFT OUTER JOIN
    発注先_Q AS zc0
    ON zc0.工事種別 = za0.工事種別
    AND zc0.取引先コード = za0.取引先コード
where
	( isnull(za0.停止日付,'') = '' )
	and ( zc0.取引先名 like N'%日本工業大学' )
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
,	ct0.工期自日付 as 工期日付
from
	z0 as ct0

union all

select
	bt1.工事年度
,	bt1.工事種別
,	bt1.工事項番
,	dateadd(month,1,bt1.工期日付) as 工期日付
from
	cte as bt1
inner join
	z0 as ct1
	on ct1.工事年度 = bt1.工事年度
	and ct1.工事種別 = bt1.工事種別
	and ct1.工事項番 = bt1.工事項番
where
	eomonth(bt1.工期日付) < ct1.工期至日付
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
,	d0.工事種別名
,	d0.工事種別コード
,	w1.和暦年表示+N'度' as 和暦工期年度
,	w0.年度 as 工期年度
,	w0.和暦年表示 as 和暦工期年
,	a0.工期年月
,	a0.工期年
,	a0.工期月
,	b0.取引先コード
,	b0.取引先名
,	b0.取引先略称
,	b0.得意先
,	b0.工事件名
,	b0.工期自日付
,	b0.工期至日付
,	'' as 和暦工期自日付
,	N'' as 和暦工期自日付略称
,	'' as 和暦工期至日付
,	N'' as 和暦工期至日付略称
,	year(b0.工期自日付)*100+month(b0.工期自日付) as 工期自年月
,	year(b0.工期至日付)*100+month(b0.工期至日付) as 工期至年月
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
,	day(eomonth(datefromparts(工期年,工期月,1))) as 最終日
,
	case
		when b0.工期自日付 > datefromparts(工期年,工期月,1)
		then day(b0.工期自日付)
		else 0
	end
	as 着工日
,
	case
		when b0.工期至日付 >= datefromparts(工期年,工期月,1)
		then
			case
				when b0.工期至日付 > eomonth(datefromparts(工期年,工期月,1))
				then day(eomonth(datefromparts(工期年,工期月,1)))
				else day(b0.工期至日付)
			end
		else 0
	end
	as 完工日
,   b0.受注金額
,   b0.消費税率
,   b0.消費税額
,	j0.[JV]
,	j0.税別出資比率詳細
,   s0.部門名 AS 担当部門名
,   s0.部門名略称 AS 担当部門名略称
,	isnull(e0.氏,N'') as 担当者
from
	d0 as a0
left outer join
	z0 as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
LEFT OUTER JOIN
    工事種別_T AS d0
    ON d0.工事種別 = a0.工事種別
left outer join
	カレンダ_Q as w0
	on w0.日付 = a0.工期日付
left outer join
	カレンダ_Q as w1
	on w1.日付 = datefromparts(w0.年度,1,1)
left outer join
	工事台帳_Q共同企業体出資比率 as j0
	on j0.工事年度 = a0.工事年度
	and j0.工事種別 = a0.工事種別
	and j0.工事項番 = a0.工事項番
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
	( b0.工期至日付 >= datefromparts(工期年,工期月,1) )
)
,

v01 as
(
select
	min(工事番号) as 工事番号
,	min(工事年度) as 工事年度
,	min(工事種別) as 工事種別
,	min(工事項番) as 工事項番
,	min(工事種別名) as 工事種別名
,	min(工事種別コード) as 工事種別コード
,	和暦工期年度
,	工期年度
,	和暦工期年
,	工期年月
,	工期年
,	工期月
,	min(取引先コード) as 取引先コード
,	min(取引先名) as 取引先名
,	min(取引先略称) as 取引先略称
,	N'小工事関係' as 工事件名
,	null as 工期自日付
,	null as 工期至日付
,	'' as 和暦工期自日付
,	N'' as 和暦工期自日付略称
,	'' as 和暦工期至日付
,	N'' as 和暦工期至日付略称
,	null as 工期自年月
,	null as 工期至年月
,	null as 受注年月
,	null as 受注日付
,	null as 着工日付
,	null as 竣工日付
,	null as 最終日
,	null as 着工日
,	null as 完工日
,   sum(受注金額) as 受注金額
,   min(消費税率) as 消費税率
,   sum(消費税額) as 消費税額
,	min([JV]) as [JV]
,	min(税別出資比率詳細) as 税別出資比率詳細
,   min(担当部門名) AS 担当部門名
,   min(担当部門名略称) AS 担当部門名略称
,	min(担当者) as 担当者
from
	v0 as a01
group by
	和暦工期年度
,	工期年度
,	和暦工期年
,	工期年月
,	工期年
,	工期月
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
,	-9 as 得意先
from
	v01 as a1
)

select
	*
from
	v1 as v100
