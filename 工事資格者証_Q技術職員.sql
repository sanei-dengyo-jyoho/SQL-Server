WITH

a AS
(
SELECT
	年度
,	会社コード
,	社員コード
,	資格名1 AS 技術名
,	0 AS 講習受講
FROM
	技術職員名簿_T明細 as aa0
WHERE
	( ISNULL(社員コード,'') <> '' )
	AND ( ISNULL(資格名1,'') <> '' )

UNION ALL

SELECT
	年度
,	会社コード
,	社員コード
,	資格名2 AS 技術名
,	0 AS 講習受講
FROM
	技術職員名簿_T明細 as aa1
WHERE
	( ISNULL(社員コード,'') <> '' )
	AND ( ISNULL(資格名2,'') <> '' )

UNION ALL

SELECT
	年度
,	会社コード
,	社員コード
,	N'監理技術者' AS 技術名
,	講習受講1 AS 講習受講
FROM
	技術職員名簿_T明細 as aa2
WHERE
	( ISNULL(社員コード,'') <> '' )
	AND ( ISNULL(講習受講1,'') <> '' )
	AND ( ISNULL(交付番号,'') <> '' )

UNION ALL

SELECT
	年度
,	会社コード
,	社員コード
,	N'監理技術者' AS 技術名
,	講習受講2 AS 講習受講
FROM
	技術職員名簿_T明細 as aa3
WHERE
	( ISNULL(社員コード,'') <> '' )
	AND ( ISNULL(講習受講2,'') <> '' )
	AND ( ISNULL(交付番号,'') <> '' )

UNION ALL

SELECT
	年度
,	会社コード
,	社員コード
,	N'専任技術者' AS 技術名
,	0 AS 講習受講
FROM
	技術職員名簿_T専任技術者 as aa4
WHERE
	( ISNULL(社員コード,'') <> '' )

UNION ALL

SELECT
	年度
,	会社コード
,	社員コード
,	N'使用人' AS 技術名
,	0 AS 講習受講
FROM
	技術職員名簿_T使用人 as aa5
WHERE
	( ISNULL(社員コード,'') <> '' )

UNION ALL

SELECT
	年度
,	会社コード
,	社員コード
,	N'主任電気工事士' AS 技術名
,	0 AS 講習受講
FROM
	技術職員名簿_T主任電気工事士 as aa5
WHERE
	( ISNULL(社員コード,'') <> '' )

UNION ALL

SELECT
	年度
,	会社コード
,	社員コード
,
	CASE
		WHEN 建設業経理事務士 = 1
		THEN N'１級建設業経理事務士'
		WHEN 建設業経理事務士 = 2
		THEN N'２級建設業経理事務士'
		WHEN 建設業経理事務士 = 3
		THEN N'３級建設業経理事務士'
		ELSE N''
	END
	AS 技術名
,	0 AS 講習受講
FROM
	技術職員名簿_T経理事務士 as aa6
WHERE
	( ISNULL(社員コード,'') <> '' )
	AND ( ISNULL(建設業経理事務士,'') <> '' )
)
,

b AS
(
SELECT
	年度
,	会社コード
,	社員コード
,	技術名
,	SUM(講習受講) AS 講習受講
FROM
	a AS a1
GROUP BY
	年度
,	会社コード
,	社員コード
,	技術名
)
,

v AS
(
SELECT
	t0.年度
,	t0.会社コード
,	t0.社員コード
,	v0.氏名
,	v0.氏
,	v0.名
,	v0.カナ氏名
,	v0.カナ氏
,	v0.カナ名
,	v0.読み順
,	v0.資格コード
,	v0.資格名
,	v0.技術名
,	v0.担当業種
,	v0.種類
,	v0.種類コード
,	v0.頁内行数
,	v0.頁内列数
,	v0.交付番号
,	v0.取得日付
,	v0.順位
,	v0.[name]
,	v0.[u_fullpath_name]
,	v0.[u_fullpath_name_exp]
,	v0.資格数
,	v0.ファイル数
,	t0.講習受講
,	v0.部門コード
,	v0.部門レベル
,	v0.上位コード
,	v0.所在地コード
,	v0.集計部門コード
,	v0.部門名
,	v0.部門名カナ
,	v0.部門名略称
,	v0.部門名省略
,	v0.職制区分
,	v0.職制区分名
,	v0.職制区分名略称
,	v0.職制コード
,	v0.職制名
,	v0.職制名略称
,	v0.係コード
,	v0.係名
,	v0.係名略称
,	v0.係名省略
,	v0.性別
,	v0.入社日
,	v0.退職日
,	v0.退職年度
,	v0.登録区分
FROM
	b AS t0
INNER JOIN
	工事資格者証_Q社員 AS v0
	ON v0.会社コード = t0.会社コード
	AND v0.社員コード = t0.社員コード
	AND v0.技術名 = t0.技術名
)

SELECT
	*
FROM
	v AS v000
