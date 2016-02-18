with

p0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	取引先コード
,	取引先担当
,	工事件名
,	工事場所
,	工期自日付
,	工期至日付
,	受注日付
,	竣工日付
,	受注金額
,	消費税率
,	消費税額
,	担当会社コード
,	担当部門コード
,	担当社員コード
,	null as 振替先部門コード
from
    工事台帳_T AS pa0
where
    (isnull(停止日付,'') = '')
    and (isnull(竣工日付,'') <> '')
)
,

q00 as
(
select
    qa00.工事年度
,	qa00.工事種別
,	qa00.工事項番
,	case
		when qc00.入金条件名 = N'手形'
		then
		 	case
				when isnull(qa00.予定手形サイト,0) = 0
				then qa00.請求日付
				else dateadd(day,qa00.予定手形サイト,qa00.請求日付)
			end
		else qa00.請求日付
	end
	as 請求日付
,	qa00.請求本体金額
,	qa00.請求消費税率
,	qa00.請求消費税額
from
	請求_T as qa00
inner join
	入金条件_T as qc00
	on qc00.入金条件 = qa00.入金条件
where
	( isnull(qa00.振替先部門コード,0) = 0 )
)
,

q0 as
(
select
    qa0.工事年度
,	qa0.工事種別
,	qa0.工事項番
,	0 as 請求回数
,	qw0.年度 as 完工年度
,	qw0.年 as 完工年
,	qw0.月 as 完工月
,	max(qa0.請求日付) as 完工日付
,	null as 振替先部門コード
,	sum(qa0.請求本体金額) as 請求本体金額
,	max(qa0.請求消費税率) as 請求消費税率
,	sum(qa0.請求消費税額) as 請求消費税額
from
	q00 as qa0
left outer join
	カレンダ_Q as qw0
	on qw0.日付 = qa0.請求日付
group by
    qa0.工事年度
,	qa0.工事種別
,	qa0.工事項番
,	qw0.年度
,	qw0.年
,	qw0.月
)
,

q1 as
(
select
	qa1.工事年度
,	qa1.工事種別
,	qa1.工事項番
,	qa1.請求回数
,	qa1.完工年度
,	qa1.完工年
,	qa1.完工月
,	qa1.完工日付
,	qb1.取引先コード
,	qb1.取引先担当
,	qb1.工事件名
,	qb1.工事場所
,	qb1.工期自日付
,	qb1.工期至日付
,	qb1.受注日付
,	qb1.竣工日付
,	qa1.請求本体金額 as 受注金額
,	qa1.請求消費税率 as 消費税率
,	qa1.請求消費税額 as 消費税額
,	qb1.担当会社コード
,	qb1.担当部門コード
,	qb1.担当社員コード
,	qa1.振替先部門コード
from
	q0 as qa1
inner join
	p0 as qb1
    on qb1.工事年度 = qa1.工事年度
    and qb1.工事種別 = qa1.工事種別
    and qb1.工事項番 = qa1.工事項番
)
,

r0 as
(
select
    ra0.工事年度
,   ra0.工事種別
,   ra0.工事項番
,   ra0.請求回数
,	rw0.年度 as 完工年度
,	rw0.年 as 完工年
,	rw0.月 as 完工月
,	ra0.請求日付 as 完工日付
,	ra0.振替先部門コード
,	ra0.請求本体金額
,	ra0.請求消費税率
,	ra0.請求消費税額
from
	請求_T as ra0
left outer join
	カレンダ_Q as rw0
	on rw0.日付 = ra0.請求日付
where
	( isnull(ra0.振替先部門コード,0) <> 0 )
)
,

r1 as
(
select
	ra1.工事年度
,	ra1.工事種別
,	ra1.工事項番
,	ra1.請求回数
,	ra1.完工年度
,	ra1.完工年
,	ra1.完工月
,	ra1.完工日付
,	rb1.取引先コード
,	rb1.取引先担当
,	rb1.工事件名
,	rb1.工事場所
,	rb1.工期自日付
,	rb1.工期至日付
,	rb1.受注日付
,	rb1.竣工日付
,	ra1.請求本体金額 as 受注金額
,	ra1.請求消費税率 as 消費税率
,	ra1.請求消費税額 as 消費税額
,	rb1.担当会社コード
,	rb1.担当部門コード
,	rb1.担当社員コード
,	ra1.振替先部門コード
from
	r0 as ra1
inner join
	p0 as rb1
    on rb1.工事年度 = ra1.工事年度
    and rb1.工事種別 = ra1.工事種別
    and rb1.工事項番 = ra1.工事項番
)
,

x0 as
(
select
	xa0.*
from
	q1 as xa0

union all

select
	xb0.*
from
	r1 as xb0
)
,

v0 as
(
SELECT
	dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,   a0.工事年度
,   a0.工事種別
,   a0.工事項番
,   a0.請求回数
,	a0.完工年度
,	a0.完工年
,	a0.完工月
,	a0.完工年*100+a0.完工月 as 完工年月
,	a0.完工日付
,	c0.発注先種別名
,   a0.取引先コード
,   c0.取引先名
,   c0.取引先略称
,   a0.取引先担当
,   a0.工事件名
,   a0.工事場所
,   a0.工期自日付
,   a0.工期至日付
,
	case
		when isnull(a0.受注日付,'') = ''
		then null
		else year(a0.受注日付)*100+month(a0.受注日付)
	end
	as 受注年月
,	a0.受注日付
,	a0.竣工日付
,   a0.受注金額 as 税別受注金額
,   a0.消費税率
,   a0.消費税額
,   a0.受注金額+a0.消費税額 as 税込受注金額
,   a0.担当会社コード
,   a0.担当部門コード
,   s0.部門名 AS 担当部門名
,   s0.部門名略称 AS 担当部門名略称
,   a0.担当社員コード
,   e0.氏名 AS 担当者名
,	a0.振替先部門コード
,	s1.部門名 AS 振替先部門名
,   s1.部門名略称 AS 振替先部門名略称
FROM
    x0 AS a0
LEFT OUTER JOIN
    発注先_Q AS c0
    ON c0.工事種別 = a0.工事種別
    AND c0.取引先コード = a0.取引先コード
LEFT OUTER JOIN
    部門_T年度 AS s0
    ON s0.年度 = a0.工事年度
    AND s0.会社コード = a0.担当会社コード
    AND s0.部門コード = a0.担当部門コード
LEFT OUTER JOIN
    社員_T年度 AS e0
    ON e0.年度 = a0.工事年度
    AND e0.会社コード = a0.担当会社コード
    AND e0.社員コード = a0.担当社員コード
LEFT OUTER JOIN
    部門_T年度 AS s1
    ON s1.年度 = a0.工事年度
    AND s1.会社コード = a0.担当会社コード
    AND s1.部門コード = a0.振替先部門コード
)
,

v1 as
(
select
	*
,
	case
		when isnull(発注先種別名,N'') = N'顧客'
		then -9
		else 0
	end
	as 顧客
from
	v0 as a1
)

select
	*
from
	v1 as v100
