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
FROM
    工事台帳_T条件 as a0
LEFT OUTER JOIN
    工事種別_T as b0
    ON b0.工事種別 = a0.工事種別
)

SELECT
    *
FROM
    v0 as v000
