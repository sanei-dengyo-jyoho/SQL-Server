WITH

dx0 as
(
SELECT
    *
,   CASE
        WHEN isnull(振替先部門コード,0) = 0
        THEN 入金条件
        ELSE 999
    END
    as 入金条件索引
FROM
    請求_T as dxa0
)
,

d0 as
(
SELECT
    工事年度
,   工事種別
,   工事項番
,   max(請求回数) as 請求回数最大値
,   min(入金条件索引) as 入金条件グループ
FROM
    dx0 as da0
GROUP BY
    工事年度
,   工事種別
,   工事項番
)
,

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
,   dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,   a0.工事年度
,   a0.工事種別
,   a0.工事項番
,   t0.工事種別名
,   t0.工事種別コード
,   a0.請求回数
,   x0.請求回数最大値
,   a0.工事番号枝番
,   a0.請求先名
,   a0.請求日付
,   a0.発行日付
,   a0.請求本体金額
,   dbo.FuncMakeMoneyFormat(isnull(a0.請求本体金額,0)) as 請求本体額
,   a0.請求消費税率
,   a0.請求消費税額
,   dbo.FuncMakeMoneyFormat(isnull(a0.請求消費税額,0)) as 請求消費税
,   dbo.FuncMakeMoneyFormat(isnull(a0.請求本体金額,0) + isnull(a0.請求消費税額,0)) as 請求額
,   format(convert(numeric,c0.現金割合)/100,'P0') as 現金割合表示
,   c0.現金割合
,   format(convert(numeric,c0.手形割合)/100,'P0') as 手形割合表示
,   c0.手形割合
,   a0.請求区分
,   v0.請求区分名
,   v0.請求区分省略
,   x0.入金条件グループ
,   a0.入金条件
,   a0.入金条件索引
,   w0.入金条件名
,   dbo.FuncMakeReceiptStatus(y0.確定日付,b0.回収日付) as 入金状況
,   y0.確定日付
,   b0.回収日付
,   b0.振込日付
,   b0.振込金額
,   dbo.FuncMakeMoneyFormat(isnull(b0.振込金額,0)) as 振込額
,   b0.振込手数料
,   dbo.FuncMakeMoneyFormat(isnull(b0.振込手数料,0)) as 手数料
,   dbo.FuncMakeMoneyFormat(isnull(b0.振込金額,0) + isnull(b0.振込手数料,0)) as 現金入金
,   b0.手形金額
,   dbo.FuncMakeMoneyFormat(isnull(b0.手形金額,0)) as 手形入金
,   b0.入金手形サイト
,   b0.手形振出日
,   b0.手形期日
,   b0.手形決済日
,   b0.相殺金額
,   dbo.FuncMakeMoneyFormat(isnull(b0.相殺金額,0)) as 相殺額
,   a0.振替先会社コード
,   a0.振替先部門コード
,   s0.部門名 as 振替先部門名
,   s0.部門名略称 as 振替先部門名略称
,   a0.備考
FROM
    dx0 as a0
LEFT OUTER JOIN
    d0 as x0
    ON x0.工事年度 = a0.工事年度
    AND x0.工事種別 = a0.工事種別
    AND x0.工事項番 = a0.工事項番
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
    請求区分_T as v0
    ON v0.請求区分 = a0.請求区分
LEFT OUTER JOIN
    入金条件_T as w0
    ON w0.入金条件 = a0.入金条件索引
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
