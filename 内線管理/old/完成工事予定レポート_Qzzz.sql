with

p0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	min(工期自日付) as 工期自日付
,	max(工期至日付) as 工期至日付
from
	工事台帳_T as pa0
where
	( isnull(竣工日付,'') = '' )
group by
	工事年度
,	工事種別
,	工事項番
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
	p0 as ct0

union all

select
	bt1.工事年度
,	bt1.工事種別
,	bt1.工事項番
,	dateadd(day,1,bt1.工期日付) as 工期日付
from
	cte as bt1
inner join
	p0 as ct1
	on ct1.工事年度 = bt1.工事年度
	and ct1.工事種別 = bt1.工事種別
	and ct1.工事項番 = bt1.工事項番
where
	bt1.工期日付 < ct1.工期至日付
)
,

d0 as
(
select
	da0.工事年度
,	da0.工事種別
,	da0.工事項番
,	dc0.年 as 工期年
,	dc0.月 as 工期月
,	dc0.年*100+dc0.月 as 工期年月
,	dc0.年号+convert(nvarchar(2),dc0.和暦年)+N'年' as 和暦工期年
,	100 as 進捗
from
	cte as da0
left outer join
	カレンダ_Q as dc0
	on dc0.日付 = da0.工期日付
group by
	da0.工事年度
,	da0.工事種別
,	da0.工事項番
,	dc0.年
,	dc0.月
,	dc0.年号
,	dc0.和暦年
)
,

v0 as
(
select
   	dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.工期年
,	a0.工期月
,	a0.工期年月
,	a0.和暦工期年
,	a0.進捗
,	b0.取引先コード
,   c0.取引先名
,   c0.取引先名カナ
,   c0.取引先略称
,   c0.取引先略称カナ
,   b0.取引先担当
,   b0.工事件名
,   b0.工事概要
,   b0.受注金額
,   b0.消費税率
,   b0.消費税額
,	j0.税別出資比率詳細
,   b0.担当会社コード
,   b0.担当部門コード
,   s0.部門名 AS 担当部門名
,   s0.部門名略称 AS 担当部門名略称
,   b0.担当社員コード
,   e0.氏名 AS 担当者名
from
	d0 as a0
left outer join
	工事台帳_T as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
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
)
,

v1 as
(
select
	*
,	case
		when isnull(税別出資比率詳細,N'') = N''
		then 工事件名
		else 工事件名+CHAR(13)++CHAR(10)+税別出資比率詳細
	end
	as 工事件名詳細
,	isnull(担当者名,担当部門名) as 担当
from
	v0 as a1
)

select
	*
from
	v1 as v100
