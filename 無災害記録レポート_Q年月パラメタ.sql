WITH

v0 AS
(
SELECT
	MIN(年月) AS 年月自
,	MAX(年月) AS 年月至

FROM
	無災害記録レポート_Q年月の範囲 AS m0
)
,

v1 AS
(
SELECT
	年度
,	年
,	月
,	年 * 100 + 月 AS 年月
,	MAX(日付) AS 日付

FROM
	カレンダ_T AS c0

GROUP BY
	年度
,	年
,	月
)
,

v2 AS
(
SELECT
	a.年月自
,	m1.和暦年月表示 AS 和暦年月表示自
,	isnull(w1.年号,'') + dbo.FuncGetNumberFixed(isnull(w1.年,0), DEFAULT) + '年' + dbo.FuncGetNumberFixed(month(c1.日付), DEFAULT) + '月' + dbo.FuncGetNumberFixed(day(c1.日付), DEFAULT) + '日' AS 和暦日付自
,	a.年月至
,	m2.和暦年月表示 AS 和暦年月表示至
,	isnull(w2.年号,'') + dbo.FuncGetNumberFixed(isnull(w2.年,0), DEFAULT) + '年' + dbo.FuncGetNumberFixed(month(c2.日付), DEFAULT) + '月' + dbo.FuncGetNumberFixed(day(c2.日付), DEFAULT) + '日' AS 和暦日付至

FROM
	v0 AS a
LEFT OUTER JOIN
	無災害記録レポート_Q年月の範囲 AS m1
	ON m1.年月 = a.年月自
LEFT OUTER JOIN
	無災害記録レポート_Q年月の範囲 AS m2
	ON m2.年月 = a.年月至
LEFT OUTER JOIN
	v1 AS c1
	ON c1.年月 = a.年月自
LEFT OUTER JOIN
	和暦_T AS w1
	ON w1.西暦 = c1.年度
LEFT OUTER JOIN
	v1 AS c2
	ON c2.年月 = a.年月至
LEFT OUTER JOIN
	和暦_T AS w2
	ON w2.西暦 = c2.年度
)


SELECT
	*

FROM
	v2 AS v20

