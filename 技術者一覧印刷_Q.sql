WITH

V0 AS
(
SELECT
	A0.利用者名
,	A0.オブジェクト名
,	A0.コントロール名
,	CONVERT(int, A0.キー1) AS 頁
,	CONVERT(int, A0.キー2) AS 行
,	CONVERT(int, A0.キー3) AS [№]
,	CONVERT(int, A0.キー5) AS 社員コード
,	A0.列1 AS 会社コード
,	CONVERT(int, A0.列2) AS 年度
,	CONVERT(int, A0.列3) AS 検索区分
,	A0.列4 AS 番号
,	B0.資格区分
,	B0.氏名
,	B0.出身校
,	B0.専攻
,	B0.所在地コード
,	B0.部門コード
,	B0.県コード
,	B0.年齢
,	B0.表示資格名1
,	B0.表示資格名2
,	B0.交付番号1
,	B0.交付番号2
,	B0.取得日付1
,	B0.取得日付2
,	B0.経験年数
,	B0.交付番号
,	B0.職制区分
,	B0.職制コード
FROM
	汎用一覧_T AS A0
LEFT OUTER JOIN
	技術者一覧_Q AS B0
	ON A0.列1 = B0.会社コード
	AND CONVERT(int, A0.列2) = B0.年度
	AND CONVERT(int, A0.キー5) = B0.社員コード
)

SELECT
	*
FROM
	V0 AS A1
