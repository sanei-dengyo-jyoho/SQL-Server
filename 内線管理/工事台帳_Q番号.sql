with

v1 as
(
SELECT
    b1.システム名
,   format(a1.工事年度,'D4') + a1.工事種別 + '-' + format(a1.工事項番,'D3') AS 工事番号
,   a1.工事年度
,   a1.工事種別
,   a1.工事項番
,   b1.工事種別名
,   b1.工事種別コード
FROM
    工事台帳_T as a1
LEFT OUTER JOIN
    工事種別_T as b1
    ON b1.工事種別 = a1.工事種別
)

SELECT
    *
FROM
    v1 as v100
