WITH

v0 AS
(
SELECT
	名称番号 AS 数値コード
,	CONVERT(int,row_number() OVER (ORDER BY 名称番号)) AS 項番
,	名称 AS 名前
,	その他名称 AS システム名
,	備考 AS 列名
,	その他備考 AS 単位名
,	リスト書式 AS 書式
,	リスト幅 AS 小数点以下表示桁数

FROM
	名称_T AS a0

WHERE
	( 名称コード = - 11 )
)
,

v1 AS
(
SELECT
	a1.数値コード
,	a1.項番
,	a1.名前
,	a1.システム名
,	a1.列名
,	a1.単位名
,	a1.書式
,	a1.小数点以下表示桁数
,	substring(CONVERT(varchar(6),b1.数値番号),1,4) + '/' + substring(CONVERT(varchar(6),b1.数値番号),5,2) AS 年月表示
,	b1.数値番号 AS 年月
,	CONVERT(int,substring(CONVERT(varchar(6),b1.数値番号),1,4)) AS 年
,	CONVERT(int,substring(CONVERT(varchar(6),b1.数値番号),5,2)) AS 月
,	b1.数値
,	ltrim(str(isnull(b1.固定,0))) + '.00' AS 固定

FROM
	v0 AS a1
LEFT OUTER JOIN
	数値_T AS b1
	ON b1.数値コード = a1.数値コード
)

SELECT
	*

FROM
	v1 AS a2

