with

q0 as
(
SELECT
    qt0.システム名
,   qb0.工事年度
,   qb0.工事種別
,   qb0.工事項番
,   ISNULL(MAX(qa0.請求回数),0) + 1 AS 請求回数
FROM
    工事台帳_T as qb0
LEFT OUTER JOIN
    工事種別_T AS qt0
    ON qt0.工事種別 = qb0.工事種別
LEFT OUTER JOIN
    請求_T as qa0
    ON qa0.工事年度 = qb0.工事年度
    AND qa0.工事種別 = qb0.工事種別
    AND qa0.工事項番 = qb0.工事項番
GROUP BY
    qt0.システム名
,   qb0.工事年度
,   qb0.工事種別
,   qb0.工事項番
)
,

q1 as
(
SELECT
    qa1.システム名
,   qa1.工事年度
,   qa1.工事種別
,   qa1.工事項番
,   qa1.請求回数
,   0 AS レコード有無
FROM
    q0 AS qa1
UNION ALL
SELECT
    qb1.システム名
,   qb1.工事年度
,   qb1.工事種別
,   qb1.工事項番
,   qb1.請求回数
,   1 AS レコード有無
FROM
    請求売上_Q as qb1
)
,

v0 as
(
SELECT
    b0.システム名
,   b0.工事年度
,   b0.工事種別
,   b0.工事項番
,   b0.請求回数
,   b0.レコード有無
,   a0.請求先名
,   a0.請求日付
,   a0.発行日付
,   a0.請求本体金額
,   a0.請求本体額
,   a0.請求消費税率
,   a0.請求消費税額
,   a0.請求消費税
,   a0.請求額
,   a0.現金割合表示
,   a0.現金割合
,   a0.手形割合表示
,   a0.手形割合
,   a0.予定現金入金額
,   a0.予定手形入金額
,   a0.予定手形サイト
,   a0.確定日付
,   a0.回収日付
,   a0.振込日付
,   a0.振込金額
,   a0.振込額
,   a0.振込手数料
,   a0.手数料
,   a0.現金入金
,   a0.手形金額
,   a0.手形入金
,   a0.手形サイト
,   a0.手形期日
,   a0.相殺金額
,   a0.相殺額
,   a0.振替先会社コード
,   a0.振替先部門コード
,   a0.振替先部門名
,   a0.振替先部門名略称
,   a0.備考
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
