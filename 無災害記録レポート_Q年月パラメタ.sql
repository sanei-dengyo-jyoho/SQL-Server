WITH

v1 AS
(
SELECT
	c0.年度
,	c0.年
,	c0.月
,	c0.年 * 100 + c0.月 AS 年月
,	MAX(c0.日付) AS 日付
FROM
	カレンダ_T AS c0
GROUP BY
	c0.年度
,	c0.年
,	c0.月
)
,

v2 AS
(
SELECT
	a.年月自
,	m1.和暦年月表示 AS 和暦年月表示自
,
	convert(nvarchar(500),
		isnull(w1.年号,'') +
		format(isnull(w1.年,0),'D2') + N'年' +
		format(month(c1.日付),'D2') + N'月' +
		format(day(c1.日付),'D2') + N'日'
	)
	AS 和暦日付自
,	a.年月至
,	m2.和暦年月表示 AS 和暦年月表示至
,
	convert(nvarchar(500),
		isnull(w2.年号,'') +
		format(isnull(w2.年,0),'D2') + N'年' +
		format(month(c2.日付),'D2') + N'月' +
		format(day(c2.日付),'D2') + N'日'
	)
	AS 和暦日付至
FROM
	(
	SELECT
		MIN(m0.年月) AS 年月自
	,	MAX(m0.年月) AS 年月至
	FROM
		無災害記録レポート_Q年月の範囲 AS m0
	)
	AS a
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
	v2 AS v200
