WITH

v0 AS
(
SELECT
	協力会社コード
,	MAX(日付) AS 起算日
FROM
	災害報告_T協力会社 AS q0
WHERE
	( isnull(災害コード,0) = 2 )
GROUP BY
	協力会社コード
)

SELECT
	t0.協力会社コード
,	t0.協力会社名
,	t0.協力会社名カナ
,	t0.人数
,	t0.登録区分
,	t0.更新日時
,	t1.起算日
,	t2.区分1
,	t2.区分2
,	t2.区分3
,	t2.備考1
,	t2.備考2
,	t2.備考3
FROM
	協力会社_T AS t0
LEFT OUTER JOIN
	v0 AS t1
	ON t1.協力会社コード = t0.協力会社コード
LEFT OUTER JOIN
	協力会社_T備考 AS t2
	ON t2.協力会社コード = t0.協力会社コード
