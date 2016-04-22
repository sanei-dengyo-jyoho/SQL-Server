WITH

v0 AS
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
	(
	SELECT
		e1.年度
	,	e1.年
	,	e1.月
	,	e1.会社コード
	,
		CASE
			ISNULL(e1.職制区分,0)
			WHEN 5
			THEN e1.部門コード
			ELSE ISNULL(e1.出向部門コード,e1.部門コード)
		END
		AS 部門コード
	,	1 AS 人数
	,	e1.退職日
	,	e1.入社日
	,	e1.発令日
	FROM
		社員_T年月 AS e1
	WHERE
		( ISNULL(e1.登録区分,0) < 1 )
		AND ( ISNULL(e1.職制区分,0) <> 1 )
		AND ( ISNULL(e1.職制区分,0) <> 7 )
	)
	AS e
	ON e.年度 = c.年度
	AND e.年 = c.年
	AND e.月 = c.月
	AND e.会社コード = d.会社コード
	AND e.部門コード = d.部門コード
WHERE
	(
	cast(ISNULL(e.入社日,ISNULL(e.発令日,'2079/06/06')) as datetime)
	<=
	cast(eomonth(datefromparts(a.年,a.月,1)) as datetime)
	)
	AND
	(
	cast(ISNULL(e.退職日,'2079/06/06') as datetime)
	>=
	cast(eomonth(datefromparts(a.年,a.月,1)) as datetime)
	)
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

v2 AS
(
SELECT
	a2.年度
,	a2.年
,	a2.月
,	isnull(a2.部所グループコード,0) AS 部所グループコード
,	isnull(a2.部所コード,0) AS 部所コード
,
	case
		when
			( a2.部所グループコード is null )
			and ( a2.部所コード is null )
		then N'全社'
		else isnull(a2.部所グループ名,b2.部所グループ名)
	end
	AS 部所グループ名
,
	case
		when
			( a2.部所グループコード is null )
			and ( a2.部所コード is null )
		then N'全社'
		else isnull(a2.部所名,b2.部所グループ名)
	end
	AS 部所名
,	a2.赤
,	a2.緑
,	a2.青
,	a2.人数
FROM
	(
	SELECT DISTINCT
		a1.年度
	,	a1.年
	,	a1.月
	,	a1.部所グループコード
	,	a1.部所コード
	,	a1.部所グループ名
	,	a1.部所名
	,
		case
			when
				( a1.部所グループコード is null )
				and ( a1.部所コード is null )
			then 255
			when
				( a1.部所グループコード is not null )
				and ( a1.部所コード is not null )
			then 255
			else a1.赤
		end
		as 赤
	,
		case
			when
				( a1.部所グループコード is null )
				and ( a1.部所コード is null )
			then 255
			when
				( a1.部所グループコード is not null )
				and ( a1.部所コード is not null )
			then 255
			else a1.緑
		end
		as 緑
	,
		case
			when
				( a1.部所グループコード is null )
				and ( a1.部所コード is null )
			then 255
			when
				( a1.部所グループコード is not null )
				and ( a1.部所コード is not null )
			then 255
			else a1.青
		end
		as 青
	,	a1.人数
	from
		(
		select top 100 percent
			a30.年度
		,	a30.年
		,	a30.月
		,	a30.部所グループコード
		,	a30.部所コード
		,	a30.部所グループ名
		,	a30.部所名
		,	min(a30.赤) AS 赤
		,	min(a30.緑) AS 緑
		,	min(a30.青) AS 青
		,	SUM(a30.人数) AS 人数
		from
			v0 as a30
		GROUP BY
			ROLLUP
			(
				a30.年度
			,	a30.年
			,	a30.月
			,	a30.部所グループコード
			,	a30.部所コード
			,	a30.部所グループ名
			,	a30.部所名
			)
		HAVING
			( a30.年度 IS NOT NULL )
			AND ( a30.年 IS NOT NULL )
			AND ( a30.月 IS NOT NULL )
		ORDER BY
			a30.年度
		,	a30.年
		,	a30.月
		,	a30.部所グループコード
		,	a30.部所コード

		UNION ALL

		SELECT
			a3.年度
		,	a3.年
		,	a3.月
		,	a3.部所グループコード
		,	a3.部所コード
		,	a3.部所グループ名
		,	a3.部所名
		,	255 AS 赤
		,	255 AS 緑
		,	255 AS 青
		,	a3.人数
		FROM
			v0 AS a3
		)
		as a1
	WHERE
		(
		case
			when
				( a1.部所グループコード is not null )
				and ( a1.部所コード is not null )
				and ( a1.部所名 is null )
			then 9
			else 1
		end
		<> 9
		)
	)
	AS a2
LEFT OUTER JOIN
	部所グループ_Q年月 AS b2
	ON b2.年度 = a2.年度
	AND b2.年 = a2.年
	AND b2.月 = a2.月
	AND b2.部所グループコード = a2.部所グループコード
)

select
	*
from
	v2 as v200
