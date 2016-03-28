WITH

w1 AS
(
SELECT
	会社コード
,	社員コード
,	N'１級建設業経理事務士' AS 技術名
,	NULL AS 交付番号
,	NULL AS 取得日付
,	NULL AS 資格コード
,	NULL AS 順位
FROM
	工事技術者_T AS ww0
WHERE
	( ISNULL(建設業経理事務士, 0) = 1 )

UNION ALL

SELECT
	会社コード
,	社員コード
,	N'２級建設業経理事務士' AS 技術名
,	NULL AS 交付番号
,	NULL AS 取得日付
,	NULL AS 資格コード
,	NULL AS 順位
FROM
	工事技術者_T AS ww1
WHERE
	( ISNULL(建設業経理事務士, 0) = 2 )

UNION ALL

SELECT
	会社コード
,	社員コード
,	N'３級建設業経理事務士' AS 技術名
,	NULL AS 交付番号
,	NULL AS 取得日付
,	NULL AS 資格コード
,	NULL AS 順位
FROM
	工事技術者_T AS ww2
WHERE
	( ISNULL(建設業経理事務士, 0) = 3 )

UNION ALL

SELECT
	会社コード
,	社員コード
,	N'主任電気工事士' AS 技術名
,	NULL AS 交付番号
,	NULL AS 取得日付
,	NULL AS 資格コード
,	NULL AS 順位
FROM
	工事技術者_T AS ww3
WHERE
	( ISNULL(主任電気工事士, 0) <> 0 )

UNION ALL

SELECT
	会社コード
,	社員コード
,	N'使用人' AS 技術名
,	NULL AS 交付番号
,	NULL AS 取得日付
,	NULL AS 資格コード
,	NULL AS 順位
FROM
	工事技術者_T AS ww4
WHERE
	( ISNULL(使用人, 0) <> 0 )

UNION ALL

SELECT
	会社コード
,	社員コード
,	N'専任技術者' AS 技術名
,	NULL AS 交付番号
,	NULL AS 取得日付
,	NULL AS 資格コード
,	NULL AS 順位
FROM
	工事技術者_T AS ww5
WHERE
	( ISNULL(専任技術者, 0) <> 0 )

UNION ALL

SELECT
	会社コード
,	社員コード
,	N'監理技術者' AS 技術名
,	交付番号
,	交付日付 AS 取得日付
,	NULL AS 資格コード
,	NULL AS 順位
FROM
	工事技術者_T AS ww6
WHERE
	( ISNULL(監理技術者, 0) <> 0 )

UNION ALL

SELECT
	ww7.会社コード
,	ww7.社員コード
,	wt7.資格名 AS 技術名
,	ww7.交付番号
,	ww7.取得日付
,	ww7.資格コード
,	wt7.順位
FROM
	工事技術者_T資格 AS ww7
LEFT OUTER JOIN
	資格_T AS wt7
	ON wt7.資格コード = ww7.資格コード
)
,

w2 AS
(
SELECT
	v1.会社コード
,	v1.社員コード
,	ISNULL(v2.資格コード, v1.資格コード) AS 資格コード
,	v2.資格名
,	v2.技術名
,	v2.担当業種
,	v2.種類
,	v2.種類コード
,	v2.頁内行数
,	v2.頁内列数
,	v1.交付番号
,	v1.取得日付
,	ISNULL(v2.順位, v1.順位) AS 順位
FROM
	工事技術者資格名_T AS v2
INNER JOIN
	w1 AS v1
	ON v1.技術名 = v2.技術名
)
,

w3 AS
(
SELECT
	w3.会社コード
,	w3.社員コード
,	w3.資格コード
,	w3.資格名
,	w3.技術名
,	w3.担当業種
,	w3.種類
,	w3.種類コード
,	w3.頁内行数
,	w3.頁内列数
,	w3.交付番号
,	w3.取得日付
,	w3.順位
,	w4.[name]
,	w4.[u_fullpath_name]
,	w4.[u_fullpath_name_exp]
,	1 AS 資格数
,
	CASE
		WHEN isnull(w4.[name], N'') = N''
		THEN 0
		ELSE 1
	END
	AS ファイル数
FROM
	w2 AS w3
LEFT OUTER JOIN
	[FileTable_Q資格者証一覧] AS w4
	ON w4.[company_code] = w3.会社コード
	AND w4.[employee_code] = w3.社員コード
	AND w4.[qualify_code] = w3.資格コード
)

SELECT
	*
FROM
	w3 AS w300
