WITH

e0 AS
(
SELECT
	年度
,	年
,	月
,	会社コード
,	CASE ISNULL(職制区分,0) WHEN 5 THEN 部門コード ELSE ISNULL(出向部門コード,部門コード) END AS 部門コード
,	社員コード
,	1 AS 人数
,	退職日
,	入社日
,	発令日

FROM
	社員_T年月 AS e1

WHERE
	( ISNULL(登録区分,0) < 1 )
	AND ( ISNULL(職制区分,0) <> 1 )
	AND ( ISNULL(職制区分,0) <> 7 )
)
,

q0 AS
(
SELECT
	a.年度
,	a.年
,	a.月
,	a.部所グループコード
,	b.部所コード
,	a.部所グループ名
,	b.部所名
,	a.赤
,	a.緑
,	a.青
,	SUM(ISNULL(e.人数,0)) AS 人数

FROM
	部所グループ_Q年月 AS a
LEFT OUTER JOIN
	部所_Q年月 AS b
	ON b.年度 = a.年度
	AND b.年 = a.年
	AND b.月 = a.月
	AND b.部所グループコード = a.部所グループコード
LEFT OUTER JOIN
	部所部門_Q年月 AS c
	ON c.年度 = b.年度
	AND c.年 = b.年
	AND c.月 = b.月
	AND c.部所グループコード = b.部所グループコード
	AND c.部所コード = b.部所コード
LEFT OUTER JOIN
	部門_T年度 AS d
	ON d.年度 = c.年度
	AND d.部門コード = c.部門コード
LEFT OUTER JOIN
	e0 AS e
	ON e.年度 = c.年度
	AND e.年 = c.年
	AND e.月 = c.月
	AND e.会社コード = d.会社コード
	AND e.部門コード = d.部門コード

WHERE
	( CONVERT(datetime,ISNULL(e.入社日,ISNULL(e.発令日,'2079/06/06')),111) <= CONVERT(datetime,eomonth(datefromparts(a.年,a.月,1)),111) )
	AND ( CONVERT(datetime,ISNULL(e.退職日,'2079/06/06'),111) >= CONVERT(datetime,eomonth(datefromparts(a.年,a.月,1)),111) )

GROUP BY
	a.年度
,	a.年
,	a.月
,	a.部所グループコード
,	b.部所コード
,	a.部所グループ名
,	b.部所名
,	a.赤
,	a.緑
,	a.青
)
,

q1 AS
(
SELECT
	年度
,	年
,	月
,	0 AS 部所グループコード
,	0 AS 部所コード
,	'全社' AS 部所グループ名
,	'全社' AS 部所名
,	255 AS 赤
,	255 AS 緑
,	255 AS 青
,	SUM(人数) AS 人数

FROM
	q0 AS t1

GROUP BY
	年度
,	年
,	月
)
,

q2 AS
(
SELECT
	年度
,	年
,	月
,	部所グループコード
,	0 AS 部所コード
,	部所グループ名
,	部所グループ名 AS 部所名
,	赤
,	緑
,	青
,	SUM(人数) AS 人数

FROM
	q0 AS t2

GROUP BY
	年度
,	年
,	月
,	部所グループコード
,	部所グループ名
,	赤
,	緑
,	青
)
,

q3 AS
(
SELECT
	年度
,	年
,	月
,	部所グループコード
,	部所コード
,	部所グループ名
,	部所名
,	赤
,	緑
,	青
,	人数

FROM
	q1 AS q10

UNION ALL

SELECT
	年度
,	年
,	月
,	部所グループコード
,	部所コード
,	部所グループ名
,	部所名
,	赤
,	緑
,	青
,	人数

FROM
	q2 AS q20

UNION ALL

SELECT
	年度
,	年
,	月
,	部所グループコード
,	部所コード
,	部所グループ名
,	部所名
,	255 AS 赤
,	255 AS 緑
,	255 AS 青
,	人数

FROM
	q0 AS q00
)

SELECT
	*

FROM
	q3 AS q30

