with

q0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	0 as 請求回数
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
    工事台帳_T AS qa0
where
    (isnull(停止日付,'') = '')
    and (isnull(竣工日付,'') <> '')
)
,

r0 as
(
select
    工事年度
,   工事種別
,   工事項番
,   請求回数
,	振替先部門コード
,	請求本体金額
,	請求消費税率
,	請求消費税額
from
    請求_T as ra0
where
    (isnull(振替先部門コード,0) <> 0)
)
,

r1 as
(
select
	ra1.工事年度
,	ra1.工事種別
,	ra1.工事項番
,	ra1.請求回数
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
	q0 as rb1
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
	q0 as xa0

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
,   a0.取引先コード
,   c0.取引先名
,   a0.取引先担当
,   a0.工事件名
,   a0.工事場所
,   a0.工期自日付
,   a0.工期至日付
,	a0.受注日付
,	w0.年度 as 完工年度
,	year(a0.竣工日付) as 完工年
,	month(a0.竣工日付) as 完工月
,	year(a0.竣工日付)*100+month(a0.竣工日付) as 完工年月
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
left outer join
	カレンダ_Q as w0
	on w0.日付 = a0.竣工日付
)

select
	*
from
	v0 as v000
