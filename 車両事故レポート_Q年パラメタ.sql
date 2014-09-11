WITH

v00 AS
(
SELECT TOP (6)
	年集計
,	年

FROM
	車両事故レポート_Q年の範囲 AS v000

ORDER BY
	年 DESC
)
,

v0 AS
(
SELECT
	MIN(年) AS 年度自
,	MAX(年) AS 年度至

FROM
	v00 AS y0
)
,

v1 AS
(
SELECT
	年度
,	MAX(日付) AS 日付

FROM
	カレンダ_T AS c0

GROUP BY
	年度
)
,

v2 AS
(
SELECT
	a.年度自
,	m1.年集計 AS 和暦年度表示自
,	isnull(w1.年号,'') + dbo.FuncGetNumberFixed(isnull(w1.年,0), DEFAULT) + '年' + dbo.FuncGetNumberFixed(month(c1.日付), DEFAULT) + '月' + dbo.FuncGetNumberFixed(day(c1.日付), DEFAULT) + '日' AS 和暦日付自
,	a.年度至
,	m2.年集計 AS 和暦年度表示至
,	isnull(w2.年号,'') + dbo.FuncGetNumberFixed(isnull(w2.年,0), DEFAULT) + '年' + dbo.FuncGetNumberFixed(month(c2.日付), DEFAULT) + '月' + dbo.FuncGetNumberFixed(day(c2.日付), DEFAULT) + '日' AS 和暦日付至

FROM
	v0 AS a
LEFT OUTER JOIN
	車両事故レポート_Q年の範囲 AS m1
	ON m1.年 = a.年度自
LEFT OUTER JOIN
	車両事故レポート_Q年の範囲 AS m2
	ON m2.年 = a.年度至
LEFT OUTER JOIN
	v1 AS c1
	ON c1.年度 = a.年度自
LEFT OUTER JOIN
	和暦_T AS w1
	ON w1.西暦 = c1.年度
LEFT OUTER JOIN
	v1 AS c2
	ON c2.年度 = a.年度至
LEFT OUTER JOIN
	和暦_T AS w2
	ON w2.西暦 = c2.年度
)


SELECT
	*

FROM
	v2 AS v20

