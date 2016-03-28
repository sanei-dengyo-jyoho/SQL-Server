WITH

v1 AS
(
SELECT
	1 AS 選択
,	会社コード
,	年度
,	所在地コード
,	部門コード
,	県コード
,	社員コード
,	氏名
,	資格区分順
,	担当業種コード1 AS 担当業種コード
,	担当業種名1 AS 担当業種名
,	資格コード1 AS 資格コード
,	資格名1 AS 資格名
,	講習受講1 AS 講習受講
,	交付番号
,	生年月日
FROM
	技術職員名簿_T明細 AS T1
WHERE
	(ISNULL(社員コード, N'') <> '')
	AND (ISNULL(担当業種コード1, N'') <> '')
	AND (ISNULL(資格コード1, N'') <> '')
)
,

v2 AS
(
SELECT
	2 AS 選択
,	会社コード
,	年度
,	所在地コード
,	部門コード
,	県コード
,	社員コード
,	氏名
,	資格区分順
,	担当業種コード2 AS 担当業種コード
,	担当業種名2 AS 担当業種名
,	資格コード2 AS 資格コード
,	資格名2 AS 資格名
,	講習受講2 AS 講習受講
,	交付番号
,	生年月日
FROM
	技術職員名簿_T明細 AS T2
WHERE
	(ISNULL(社員コード, N'') <> '')
	AND (ISNULL(担当業種コード2, N'') <> '')
	AND (ISNULL(資格コード2, N'') <> '')
)
,

v3 AS
(
SELECT
	*
FROM
	v1 AS v10

UNION ALL

SELECT
	*
FROM
	v2 AS v20
)
,

v4 AS
(
SELECT
	v30.選択
,	v30.会社コード
,	v30.年度
,	v30.所在地コード
,	T6.場所名
,	T6.場所略称
,	v30.部門コード
,	T7.部門名
,	T7.部門名略称
,	T7.部門名省略
,	v30.県コード
,	T5.県名
,	v30.社員コード
,	v30.氏名
,	v30.生年月日
,	T10.職制区分
,	T10.職制コード
,	T11.職制名
,	T11.職制名略称
,	v30.資格区分順
,	v30.担当業種コード
,	v30.担当業種名
,	T8.順位 AS 担当業種順位
,	v30.資格コード
,	v30.資格名
,	T9.順位 AS 資格順位
,	v30.講習受講
,	v30.交付番号
FROM
	v3 AS v30
LEFT OUTER JOIN
	担当業種_T AS T8
	ON T8.担当業種コード = v30.担当業種コード
LEFT OUTER JOIN
	資格_T AS T9
	ON T9.資格コード = v30.資格コード
LEFT OUTER JOIN
	部門_T年度 AS T7
	ON T7.年度 = v30.年度
	AND T7.部門コード = v30.部門コード
LEFT OUTER JOIN
	会社住所_T年度 AS T6
	ON T6.年度 = T7.年度
	AND T6.所在地コード = T7.所在地コード
LEFT OUTER JOIN
	県_Q AS T5
	ON T5.県コード = T6.県コード
LEFT OUTER JOIN
	社員_T年度 AS T10
	ON T10.年度 = v30.年度
	AND T10.社員コード = v30.社員コード
LEFT OUTER JOIN
	職制_T AS T11
	ON T11.職制区分 = T10.職制区分
	AND T11.職制コード = T10.職制コード
)

SELECT
	*
FROM
	v4 AS v400
