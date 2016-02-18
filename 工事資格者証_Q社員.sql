WITH

v0 AS
(
SELECT
	a0.会社コード
,	a0.社員コード
,	b0.氏名
,	b0.氏
,	b0.名
,	b0.カナ氏名
,	b0.カナ氏
,	b0.カナ名
,	b0.読み順
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
,	a0.[name]
,	a0.[u_fullpath_name]
,	a0.[u_fullpath_name_exp]
,	a0.資格数
,	a0.ファイル数
,	b0.部門コード
,	c0.部門レベル
,	c0.上位コード
,	c0.所在地コード
,	c0.集計部門コード
,	c0.部門名
,	c0.部門名カナ
,	c0.部門名略称
,	c0.部門名省略
,	b0.職制区分
,	d0.職制区分名
,	d0.職制区分名略称
,	b0.職制コード
,	e0.職制名
,	e0.職制名略称
,	b0.係コード
,	f0.係名
,	f0.係名略称
,	f0.係名省略
,	b0.性別
,	b0.入社日
,	b0.退職日
,	b0.退職年度
,	b0.登録区分
FROM
	工事資格者証_Q AS a0
LEFT OUTER JOIN
	社員_T AS b0
	ON b0.会社コード = a0.会社コード
	AND b0.社員コード = a0.社員コード
LEFT OUTER JOIN
	部門_T AS c0
	ON c0.会社コード = b0.会社コード
	AND c0.部門コード = b0.部門コード
LEFT OUTER JOIN
	職制区分_T AS d0
	ON d0.職制区分 = b0.職制区分
LEFT OUTER JOIN
	職制_T AS e0
	ON e0.職制コード = b0.職制コード
LEFT OUTER JOIN
	係名_T AS f0
	ON f0.係コード = b0.係コード
)

SELECT
	*
FROM
	v0 AS v000
