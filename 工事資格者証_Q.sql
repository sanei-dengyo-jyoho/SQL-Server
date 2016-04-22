WITH

v0 AS
(
SELECT
	a0.会社コード
,	a0.社員コード
,	a0.資格コード
,	a0.資格名
,	a0.技術名
,	a0.担当業種
,	a0.種類
,	a0.種類コード
,	a0.頁内行数
,	a0.頁内列数
,	a0.交付番号
,	a0.取得日付
,	a0.順位
,	b0.[name]
,	b0.[u_fullpath_name]
,	b0.[u_fullpath_name_exp]
,	1 AS 資格数
,
	CASE
		WHEN isnull(b0.[name],N'') = N''
		THEN 0
		ELSE 1
	END
	AS ファイル数
FROM
	(
	SELECT
		ax0.会社コード
	,	ax0.社員コード
	,	ISNULL(aq0.資格コード,ax0.資格コード) AS 資格コード
	,	aq0.資格名
	,	aq0.技術名
	,	aq0.担当業種
	,	aq0.種類
	,	aq0.種類コード
	,	aq0.頁内行数
	,	aq0.頁内列数
	,	ax0.交付番号
	,	ax0.取得日付
	,	ISNULL(aq0.順位,ax0.順位) AS 順位
	FROM
		工事技術者資格名_T AS aq0
	INNER JOIN
		(
		SELECT
			aa0.会社コード
		,	aa0.社員コード
		,	N'１級建設業経理事務士' AS 技術名
		,	NULL AS 交付番号
		,	NULL AS 取得日付
		,	NULL AS 資格コード
		,	NULL AS 順位
		FROM
			工事技術者_T AS aa0
		WHERE
			( ISNULL(aa0.建設業経理事務士,0) = 1 )

		UNION ALL

		SELECT
			aa1.会社コード
		,	aa1.社員コード
		,	N'２級建設業経理事務士' AS 技術名
		,	NULL AS 交付番号
		,	NULL AS 取得日付
		,	NULL AS 資格コード
		,	NULL AS 順位
		FROM
			工事技術者_T AS aa1
		WHERE
			( ISNULL(aa1.建設業経理事務士,0) = 2 )

		UNION ALL

		SELECT
			aa2.会社コード
		,	aa2.社員コード
		,	N'３級建設業経理事務士' AS 技術名
		,	NULL AS 交付番号
		,	NULL AS 取得日付
		,	NULL AS 資格コード
		,	NULL AS 順位
		FROM
			工事技術者_T AS aa2
		WHERE
			( ISNULL(aa2.建設業経理事務士,0) = 3 )

		UNION ALL

		SELECT
			aa3.会社コード
		,	aa3.社員コード
		,	N'主任電気工事士' AS 技術名
		,	NULL AS 交付番号
		,	NULL AS 取得日付
		,	NULL AS 資格コード
		,	NULL AS 順位
		FROM
			工事技術者_T AS aa3
		WHERE
			( ISNULL(aa3.主任電気工事士,0) <> 0 )

		UNION ALL

		SELECT
			aa4.会社コード
		,	aa4.社員コード
		,	N'使用人' AS 技術名
		,	NULL AS 交付番号
		,	NULL AS 取得日付
		,	NULL AS 資格コード
		,	NULL AS 順位
		FROM
			工事技術者_T AS aa4
		WHERE
			( ISNULL(aa4.使用人,0) <> 0 )

		UNION ALL

		SELECT
			aa5.会社コード
		,	aa5.社員コード
		,	N'専任技術者' AS 技術名
		,	NULL AS 交付番号
		,	NULL AS 取得日付
		,	NULL AS 資格コード
		,	NULL AS 順位
		FROM
			工事技術者_T AS aa5
		WHERE
			( ISNULL(aa5.専任技術者,0) <> 0 )

		UNION ALL

		SELECT
			aa6.会社コード
		,	aa6.社員コード
		,	N'監理技術者' AS 技術名
		,	aa6.交付番号
		,	aa6.交付日付 AS 取得日付
		,	NULL AS 資格コード
		,	NULL AS 順位
		FROM
			工事技術者_T AS aa6
		WHERE
			( ISNULL(aa6.監理技術者,0) <> 0 )

		UNION ALL

		SELECT
			aa7.会社コード
		,	aa7.社員コード
		,	ab7.資格名 AS 技術名
		,	aa7.交付番号
		,	aa7.取得日付
		,	aa7.資格コード
		,	ab7.順位
		FROM
			工事技術者_T資格 AS aa7
		LEFT OUTER JOIN
			資格_T AS ab7
			ON ab7.資格コード = aa7.資格コード
		)
		AS ax0
		ON ax0.技術名 = aq0.技術名
	)
	AS a0
LEFT OUTER JOIN
	[FileTable_Q資格者証一覧] AS b0
	ON b0.[company_code] = a0.会社コード
	AND b0.[employee_code] = a0.社員コード
	AND b0.[qualify_code] = a0.資格コード
)

SELECT
	*
FROM
	v0 AS v000
