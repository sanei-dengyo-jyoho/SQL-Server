WITH

v0 AS
(
SELECT distinct
	a0.年度
,	a0.和暦年度
,	a0.期
,	a0.期別
,	a0.和暦年
,	a0.年月
,	a0.年
,	a0.月
,	a0.月分
,	a0.上下期
,	a0.上下期名
,	b0.税別受注金額
,	b0.消費税率
,	b0.消費税額
,	b0.税込受注金額
FROM
    繰越年月_Q内線管理 AS a0
LEFT OUTER JOIN
	完成工事高レポート_Q AS b0
	ON b0.完工年度 = a0.年度
	AND b0.完工年 = a0.年
	AND b0.完工月 = a0.月
)

SELECT
    *
FROM
    v0 AS v000
