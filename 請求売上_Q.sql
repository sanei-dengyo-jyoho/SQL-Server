WITH

r0 as
(
SELECT
    工事年度
,   工事種別
,   工事項番
,   MAX(確定日付) as 確定日付
FROM
    入金_T as ra0
GROUP BY
    工事年度
,   工事種別
,   工事項番
)
,

v0 as
(
SELECT
    t0.システム名
,   format(a0.工事年度,'D4') + a0.工事種別 + '-' + format(a0.工事項番,'D3') as 工事番号
,   a0.工事年度
,   a0.工事種別
,   a0.工事項番
,   t0.工事種別名
,   t0.工事種別コード
,   a0.請求回数
,   a0.請求先名
,   a0.請求日付
,   a0.発行日付
,   a0.請求本体金額
,   CASE
        WHEN isnull(a0.請求本体金額,0) = 0
        THEN ''
        ELSE format(isnull(a0.請求本体金額,0),'C')
    END
    as 請求本体額
,   a0.請求消費税率
,   a0.請求消費税額
,   CASE
        WHEN isnull(a0.請求消費税額,0) = 0
        THEN ''
        ELSE format(isnull(a0.請求消費税額,0),'C')
    END
    as 請求消費税
,   CASE
        WHEN isnull(a0.請求本体金額,0) + isnull(a0.請求消費税額,0) = 0
        THEN ''
        ELSE format(isnull(a0.請求本体金額,0) + isnull(a0.請求消費税額,0),'C')
    END
    as 請求額
,   format(convert(numeric,c0.現金割合)/100,'P0') as 現金割合表示
,   c0.現金割合
,   format(convert(numeric,c0.手形割合)/100,'P0') as 手形割合表示
,   c0.手形割合
,   a0.予定現金入金額
,   a0.予定手形入金額
,   a0.予定手形サイト
,   y0.確定日付
,   b0.回収日付
,   b0.振込日付
,   b0.振込金額
,   CASE
        WHEN isnull(b0.振込金額,0) = 0
        THEN ''
        ELSE format(isnull(b0.振込金額,0),'C')
    END
    as 振込額
,   b0.振込手数料
,   CASE
        WHEN isnull(b0.振込手数料,0) = 0
        THEN ''
        ELSE format(isnull(b0.振込手数料,0),'C')
    END
    as 手数料
,   CASE
        WHEN isnull(b0.振込金額,0) + isnull(b0.振込手数料,0) = 0
        THEN ''
        ELSE format(isnull(b0.振込金額,0) + isnull(b0.振込手数料,0),'C')
    END
    as 現金入金
,   b0.手形金額
,   CASE
        WHEN isnull(b0.手形金額,0) = 0
        THEN ''
        ELSE format(isnull(b0.手形金額,0),'C')
    END
    as 手形入金
,   b0.手形サイト
,   b0.手形振出日
,   b0.手形期日
,   b0.手形決済日
,   b0.相殺金額
,   CASE
        WHEN isnull(b0.相殺金額,0) = 0
        THEN ''
        ELSE format(isnull(b0.相殺金額,0),'C')
    END
    as 相殺額
,   a0.振替先会社コード
,   a0.振替先部門コード
,   s0.部門名 as 振替先部門名
,   s0.部門名略称 as 振替先部門名略称
,   a0.備考
FROM
    請求_T as a0
LEFT OUTER JOIN
    r0 as y0
    ON y0.工事年度 = a0.工事年度
    AND y0.工事種別 = a0.工事種別
    AND y0.工事項番 = a0.工事項番
LEFT OUTER JOIN
    入金_T as b0
    ON b0.工事年度 = a0.工事年度
    AND b0.工事種別 = a0.工事種別
    AND b0.工事項番 = a0.工事項番
    AND b0.請求回数 = a0.請求回数
LEFT OUTER JOIN
    工事台帳_T条件 as c0
    ON c0.工事年度 = a0.工事年度
    AND c0.工事種別 = a0.工事種別
    AND c0.工事項番 = a0.工事項番
LEFT OUTER JOIN
    工事種別_T as t0
    ON t0.工事種別 = a0.工事種別
LEFT OUTER JOIN
    部門_T年度 as s0
    ON s0.年度 = a0.工事年度
    AND s0.会社コード = a0.振替先会社コード
    AND s0.部門コード = a0.振替先部門コード
)

SELECT
    *
FROM
    v0 as v000
