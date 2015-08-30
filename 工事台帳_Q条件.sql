with

v1 as
(
SELECT
    b1.システム名
,   format(a1.工事年度,'D4') + a1.工事種別 + '-' + format(a1.工事項番,'D3') as 工事番号
,   a1.工事年度
,   a1.工事種別
,   a1.工事項番
,   b1.工事種別名
,   b1.工事種別コード
,   a1.竣工払
,   a1.前払
,   a1.前払金額
,   a1.出来高払
,   a1.出来高払締切日
,   a1.出来高払支払月
,   a1.出来高払支払日
,   a1.現金割合
,   a1.手形割合
,   a1.手形サイト
,   a1.摘要
FROM
    工事台帳_T条件 as a1
LEFT OUTER JOIN
    工事種別_T as b1
    ON b1.工事種別 = a1.工事種別
)

SELECT
    *
FROM
    v1 as v100
