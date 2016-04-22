WITH

v0 AS
(
SELECT
	a0.年度
,	a0.会社コード
,	a0.社員コード
,	b0.氏名
,	b0.氏
,	b0.名
,	b0.カナ氏名
,	b0.カナ氏
,	b0.カナ名
,	b0.読み順
,	b0.資格コード
,	b0.資格名
,	b0.技術名
,	b0.担当業種
,	b0.種類
,	b0.種類コード
,	b0.頁内行数
,	b0.頁内列数
,	b0.交付番号
,	b0.取得日付
,	b0.順位
,	b0.[name]
,	b0.[u_fullpath_name]
,	b0.[u_fullpath_name_exp]
,	b0.資格数
,	b0.ファイル数
,	a0.講習受講
,	b0.部門コード
,	b0.部門レベル
,	b0.上位コード
,	b0.所在地コード
,	b0.集計部門コード
,	b0.部門名
,	b0.部門名カナ
,	b0.部門名略称
,	b0.部門名省略
,	b0.職制区分
,	b0.職制区分名
,	b0.職制区分名略称
,	b0.職制コード
,	b0.職制名
,	b0.職制名略称
,	b0.係コード
,	b0.係名
,	b0.係名略称
,	b0.係名省略
,	b0.性別
,	b0.入社日
,	b0.退職日
,	b0.退職年度
,	b0.登録区分
FROM
	(
	SELECT
		aax.年度
	,	aax.会社コード
	,	aax.社員コード
	,	aax.技術名
	,	SUM(aax.講習受講) AS 講習受講
	FROM
		(
		SELECT
			aa0.年度
		,	aa0.会社コード
		,	aa0.社員コード
		,	aa0.資格名1 AS 技術名
		,	0 AS 講習受講
		FROM
			技術職員名簿_T明細 as aa0
		WHERE
			( ISNULL(aa0.社員コード,'') <> '' )
			AND ( ISNULL(aa0.資格名1,N'') <> N'' )

		UNION ALL

		SELECT
			aa1.年度
		,	aa1.会社コード
		,	aa1.社員コード
		,	aa1.資格名2 AS 技術名
		,	0 AS 講習受講
		FROM
			技術職員名簿_T明細 as aa1
		WHERE
			( ISNULL(aa1.社員コード,'') <> '' )
			AND ( ISNULL(aa1.資格名2,N'') <> N'' )

		UNION ALL

		SELECT
			aa2.年度
		,	aa2.会社コード
		,	aa2.社員コード
		,	N'監理技術者' AS 技術名
		,	aa2.講習受講1 AS 講習受講
		FROM
			技術職員名簿_T明細 as aa2
		WHERE
			( ISNULL(aa2.社員コード,'') <> '' )
			AND ( ISNULL(aa2.講習受講1,'') <> '' )
			AND ( ISNULL(aa2.交付番号,'') <> '' )

		UNION ALL

		SELECT
			aa3.年度
		,	aa3.会社コード
		,	aa3.社員コード
		,	N'監理技術者' AS 技術名
		,	aa3.講習受講2 AS 講習受講
		FROM
			技術職員名簿_T明細 as aa3
		WHERE
			( ISNULL(aa3.社員コード,'') <> '' )
			AND ( ISNULL(aa3.講習受講2,'') <> '' )
			AND ( ISNULL(aa3.交付番号,'') <> '' )

		UNION ALL

		SELECT
			aa4.年度
		,	aa4.会社コード
		,	aa4.社員コード
		,	N'専任技術者' AS 技術名
		,	0 AS 講習受講
		FROM
			技術職員名簿_T専任技術者 as aa4
		WHERE
			( ISNULL(aa4.社員コード,'') <> '' )

		UNION ALL

		SELECT
			aa5.年度
		,	aa5.会社コード
		,	aa5.社員コード
		,	N'使用人' AS 技術名
		,	0 AS 講習受講
		FROM
			技術職員名簿_T使用人 as aa5
		WHERE
			( ISNULL(aa5.社員コード,'') <> '' )

		UNION ALL

		SELECT
			aa5.年度
		,	aa5.会社コード
		,	aa5.社員コード
		,	N'主任電気工事士' AS 技術名
		,	0 AS 講習受講
		FROM
			技術職員名簿_T主任電気工事士 as aa5
		WHERE
			( ISNULL(aa5.社員コード,'') <> '' )

		UNION ALL

		SELECT
			aa6.年度
		,	aa6.会社コード
		,	aa6.社員コード
		,
			convert(nvarchar(100),
				dbo.SqlStrConv(aa6.建設業経理事務士,4) +
				N'級建設業経理事務士'
			)
			AS 技術名
		,	0 AS 講習受講
		FROM
			技術職員名簿_T経理事務士 as aa6
		WHERE
			( ISNULL(aa6.社員コード,'') <> '' )
			AND ( ISNULL(aa6.建設業経理事務士,'') <> '' )
		)
		AS aax
	GROUP BY
		aax.年度
	,	aax.会社コード
	,	aax.社員コード
	,	aax.技術名
	)
	AS a0
INNER JOIN
	工事資格者証_Q社員 AS b0
	ON b0.会社コード = a0.会社コード
	AND b0.社員コード = a0.社員コード
	AND b0.技術名 = a0.技術名
)

SELECT
	*
FROM
	v0 AS v000
