WITH

v0 AS
(
SELECT
	a.会社コード
,	a.社員コード
,	a.日付
,	a.氏名
,	a.カナ氏名
,	c.本部名
,	c.部名
,	c.部門名
,	c.部門名略称
,	c.部門名省略
,	d.職制名
,	d.職制名略称
,	e.係名
,	e.係名略称
,	b.人事履歴 AS 履歴
,
	concat(
		N'\',
		convert(nvarchar(10),
			CASE
				WHEN isnull(a.登録区分, 0) > 0
				THEN - 1
				ELSE 0
			END
		)
	)
	AS 区分
FROM
	社員_T異動 AS a
LEFT OUTER JOIN
	コード登録区分_Q AS b
	ON b.登録区分 = a.登録区分
LEFT OUTER JOIN
	部門_Q異動履歴_全階層順 AS c
	ON c.年度 = a.年度
	AND c.部門コード = a.部門コード
LEFT OUTER JOIN
	職制_T AS d
	ON d.職制コード = a.職制コード
LEFT OUTER JOIN
	係名_T AS e
	ON e.係コード = a.係コード
)

SELECT
	*
FROM
	v0 AS v000
