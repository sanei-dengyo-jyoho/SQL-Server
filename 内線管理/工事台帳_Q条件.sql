with

v0 as
(
SELECT
    b0.システム名
,   dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,   a0.工事年度
,   a0.工事種別
,   a0.工事項番
,   b0.工事種別名
,   b0.工事種別コード
,   a0.竣工払
,   a0.前払
,   a0.前払金額
,   a0.出来高払
,   a0.出来高払締切日
,   a0.出来高払支払月
,   a0.出来高払支払日
,   a0.現金比率
,   a0.手形比率
,   a0.手形サイト
,   a0.摘要
,   j0.共同企業体形成コード
,   j0.[JV]
,   j0.[JV出資比率]
FROM
    工事台帳_T条件 as a0
LEFT OUTER JOIN
    工事種別_T as b0
    ON b0.工事種別 = a0.工事種別
LEFT OUTER JOIN
    工事台帳_Q共同企業体出資比率 AS j0
    ON j0.工事年度 = a0.工事年度
    AND j0.工事種別 = a0.工事種別
    AND j0.工事項番 = a0.工事項番
)

SELECT
    *
FROM
    v0 as v000
