WITH

v0 AS
(
SELECT
	a0.部所グループコード
,	a0.部所コード
,	a0.部所名
,	a0.部所名カナ
,	a0.部所名略称
,	a0.部所名略称カナ
,	d0.日付 AS 発足日
,	a0.登録区分
,	a0.更新日時
FROM
    部所_T AS a0
LEFT OUTER JOIN
	(
	SELECT
	    d00.部所グループコード
	,	d00.部所コード
	,	MAX(d00.日付) AS 日付
	FROM
	    部所_T発足日 AS d00
	GROUP BY
		d00.部所グループコード
	,	d00.部所コード
	)
	AS d0
	ON d0.部所グループコード = a0.部所グループコード
	AND d0.部所コード = a0.部所コード
)

SELECT
	*
FROM
	v0 AS v000
