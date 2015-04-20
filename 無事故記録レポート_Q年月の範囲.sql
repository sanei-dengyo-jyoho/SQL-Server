WITH

v1 AS
(
SELECT TOP (24)
	年度
,	年
,	月
,	年月

FROM
	無事故記録_T AS y0

GROUP BY
	年度
,	年
,	月
,	年月

ORDER BY
	年月 DESC
)
,

v2 AS
(
SELECT
	a.年度
,	isnull(w0.年号,'') + dbo.FuncGetNumberFixed(isnull(w0.年,0), DEFAULT) + '年度' AS 和暦年度表示
,	a.年
,	a.月
,	a.年月
,	SUBSTRING(REPLACE(CONVERT(varchar(10), datefromparts(a.年, a.月, 1)), '-', '/'), 1, 7) AS 年月表示
,	isnull(w1.年号,'') + dbo.FuncGetNumberFixed(isnull(w1.年,0), DEFAULT) + '年' + dbo.FuncGetNumberFixed(a.月, DEFAULT) + '月' AS 和暦年月表示

FROM
	v1 AS a
LEFT OUTER JOIN
	和暦_T as w0
	on w0.西暦 = a.年度
LEFT OUTER JOIN
	和暦_T as w1
	on w1.西暦 = a.年
)

SELECT
	*

FROM
	v2 AS q2

