WITH

v2 AS
(
SELECT
	a.年度自
,	m1.和暦年度表示 AS 和暦年度表示自
,
	convert(nvarchar(100),
		isnull(w1.年号,'') + format(isnull(w1.年,0),'D2') + N'年' +
		format(month(c1.日付),'D2') + N'月' +
		format(day(c1.日付),'D2') + '日'
	)
	AS 和暦日付自
,	a.年度至
,	m2.和暦年度表示 AS 和暦年度表示至
,
	convert(nvarchar(100),
		isnull(w2.年号,'') + format(isnull(w2.年,0),'D2') + N'年' +
		format(month(c2.日付),'D2') + N'月' +
		format(day(c2.日付),'D2') + '日'
	)
	AS 和暦日付至
FROM
	(
	SELECT
		MIN(y0.年度) AS 年度自
	,	MAX(y0.年度) AS 年度至
	FROM
		(
		SELECT TOP (7)
			v000.年度
		,	v000.年度表示
		,	v000.和暦年度表示
		FROM
			災害集計レポート_Q年度の範囲 AS v000
		ORDER BY
			v000.年度 DESC
		)
		AS y0
	)
	AS a
LEFT OUTER JOIN
	災害集計レポート_Q年度の範囲 AS m1
	ON m1.年度 = a.年度自
LEFT OUTER JOIN
	災害集計レポート_Q年度の範囲 AS m2
	ON m2.年度 = a.年度至
LEFT OUTER JOIN
    (
    SELECT
        c100.年度
    ,	MAX(c100.日付) AS 日付
    FROM
        カレンダ_T AS c100
    GROUP BY
        c100.年度
    )
	AS c1
	ON c1.年度 = a.年度自
LEFT OUTER JOIN
	和暦_T AS w1
	ON w1.西暦 = c1.年度
LEFT OUTER JOIN
    (
    SELECT
        c200.年度
    ,	MAX(c200.日付) AS 日付
    FROM
        カレンダ_T AS c200
    GROUP BY
        c200.年度
    )
	AS c2
	ON c2.年度 = a.年度至
LEFT OUTER JOIN
	和暦_T AS w2
	ON w2.西暦 = c2.年度
)

SELECT
	*
FROM
	v2 AS v200
