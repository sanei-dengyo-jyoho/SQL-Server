with

x2 as
(
SELECT
    システム名
,	数値 as 行
FROM
	dbo.FuncViewConstConditionsInit(N'請求内訳の行数')
)
,

v0 as
(
SELECT
    z0.システム名
,   b0.工事年度
,   b0.工事種別
,   b0.工事項番
,   b0.請求回数
,   z0.行
,   a0.名称
,   a0.数量
,   a0.単位
,   a0.単価
,   a0.金額
FROM
    x2 as z0
LEFT OUTER JOIN
    請求売上_Qリスト as b0
    ON b0.システム名 = z0.システム名
LEFT OUTER JOIN
    請求_T内訳 as a0
    ON a0.工事年度 = b0.工事年度
    AND a0.工事種別 = b0.工事種別
    AND a0.工事項番 = b0.工事項番
    AND a0.請求回数 = b0.請求回数
    AND a0.行 = z0.行
)

SELECT
    *
FROM
    v0 as v000
