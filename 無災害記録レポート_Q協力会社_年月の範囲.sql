WITH

v2 AS
(
SELECT
	a.年度
,
	convert(nvarchar(500),
		isnull(w0.年号,'') +
		format(isnull(w0.年,0),'D2') + N'年度'
	)
	AS 和暦年度表示
,	a.年
,	a.月
,	a.年月
,
	convert(nvarchar(500),
		SUBSTRING(
			REPLACE(CONVERT(varchar(20),datefromparts(a.年,a.月,1)),'-','/')
			,1,7
		)
	)
	AS 年月表示
,
	convert(nvarchar(500),
		isnull(w1.年号,'') +
		format(isnull(w1.年,0),'D2') + N'年' +
		format(a.月,'D2') + N'月'
	)
	AS 和暦年月表示
FROM
	(
	SELECT TOP (24)
		y0.年度
	,	y0.年
	,	y0.月
	,	y0.年月
	FROM
		無災害記録_T協力会社 AS y0
	GROUP BY
		y0.年度
	,	y0.年
	,	y0.月
	,	y0.年月
	ORDER BY
		y0.年月 DESC
	)
	AS a
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
	v2 AS v200
