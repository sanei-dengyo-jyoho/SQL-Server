with

q1 as
(
SELECT
    qt0.システム名
,	dbo.FuncMakeConstructNumber(qb0.工事年度,qb0.工事種別,qb0.工事項番) AS 工事番号
,	qb0.工事年度
,	qb0.工事種別
,	qb0.工事項番
,	ISNULL(MAX(qa0.請求回数),0) + 1 as 請求回数
,	0 as レコード有無
FROM
    工事台帳_T as qb0
LEFT OUTER JOIN
    工事種別_T as qt0
    ON qt0.工事種別 = qb0.工事種別
LEFT OUTER JOIN
    請求_T as qa0
    ON qa0.工事年度 = qb0.工事年度
    AND qa0.工事種別 = qb0.工事種別
    AND qa0.工事項番 = qb0.工事項番
GROUP BY
    qt0.システム名
,	qb0.工事年度
,	qb0.工事種別
,	qb0.工事項番

UNION ALL

SELECT
    rb0.システム名
,	dbo.FuncMakeConstructNumber(ra0.工事年度,ra0.工事種別,ra0.工事項番) AS 工事番号
,	ra0.工事年度
,	ra0.工事種別
,	ra0.工事項番
,	ra0.請求回数
,	1 as レコード有無
FROM
    請求_T as ra0
INNER JOIN
    工事種別_T as rb0
    ON rb0.工事種別 = ra0.工事種別
)
,

v0 as
(
SELECT
    b0.システム名
,	b0.工事番号
,	b0.工事年度
,	b0.工事種別
,	b0.工事項番
,	b0.請求回数
,	b0.レコード有無
,	a0.請求回数最大値
,	a0.工事番号枝番
,	a0.請求先名
,	a0.請求日付
,	a0.発行日付
,	a0.請求本体金額
,	a0.請求本体額
,	a0.請求消費税率
,	a0.請求消費税額
,	a0.請求消費税
,	a0.請求額
,	a0.請求区分
,	a0.請求区分名
,	a0.請求区分省略
,	a0.入金条件グループ
,	a0.入金条件
,	a0.入金条件索引
,	a0.入金条件名
,	a0.入金状況
,	a0.確定日付
,	a0.回収日付
,	a0.振込日付
,	a0.振込金額
,	a0.振込額
,	a0.振込手数料
,	a0.手数料
,	a0.現金入金
,	a0.手形金額
,	a0.手形入金
,	a0.入金手形サイト
,	a0.手形期日
,	a0.相殺金額
,	a0.相殺額
,	a0.振替先会社コード
,	a0.振替先部門コード
,	a0.振替先部門名
,	a0.振替先部門名略称
,	a0.備考
FROM
    q1 as b0
LEFT OUTER JOIN
    請求売上_Q as a0
    ON a0.システム名 = b0.システム名
    AND a0.工事年度 = b0.工事年度
    AND a0.工事種別 = b0.工事種別
    AND a0.工事項番 = b0.工事項番
    AND a0.請求回数 = b0.請求回数
)

SELECT
    *
FROM
    v0 as v000
