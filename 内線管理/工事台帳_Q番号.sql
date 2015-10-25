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
FROM
    工事台帳_T as a0
LEFT OUTER JOIN
    工事種別_T as b0
    ON b0.工事種別 = a0.工事種別
)

SELECT
    *
FROM
    v0 as v000
