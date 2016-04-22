WITH

v0 AS
(
SELECT
	a0.協力会社コード
,	a0.協力会社名
,	a0.協力会社名カナ
,	a0.人数
,	d0.日付 AS 発足日
,	a0.登録区分
,	a0.更新日時
,	z0.区分1
,	z0.区分2
,	z0.区分3
,	z0.備考1
,	z0.備考2
,	z0.備考3
FROM
	協力会社_T AS a0
LEFT OUTER JOIN
	(
	SELECT
		d00.協力会社コード
	,	MAX(d00.日付) AS 日付
	FROM
		協力会社_T発足日 AS d00
	GROUP BY
		d00.協力会社コード
	)
	AS d0
	ON d0.協力会社コード = a0.協力会社コード
LEFT OUTER JOIN
	協力会社_T備考 AS z0
	ON z0.協力会社コード = a0.協力会社コード
)

SELECT
	*
FROM
	v0 as v000
