WITH

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
,
	concat(
		substring(CONVERT(varchar(6),b1.数値番号),1,4),
		N'/',
		substring(CONVERT(varchar(6),b1.数値番号),5,2)
	)
	AS 年月表示
,	b1.数値番号 AS 年月
,	CONVERT(int,substring(CONVERT(varchar(6),b1.数値番号),1,4)) AS 年
,	CONVERT(int,substring(CONVERT(varchar(6),b1.数値番号),5,2)) AS 月
,	b1.数値
,	concat(ltrim(str(isnull(b1.固定,0))),'.00') AS 固定
FROM
	(
	SELECT
		a0.名称番号 AS 数値コード
	,	CONVERT(int,row_number() OVER (ORDER BY a0.名称番号)) AS 項番
	,	a0.名称 AS 名前
	,	a0.その他名称 AS システム名
	,	a0.備考 AS 列名
	,	a0.その他備考 AS 単位名
	,	a0.リスト書式 AS 書式
	,	a0.リスト幅 AS 小数点以下表示桁数
	FROM
		名称_T AS a0
	WHERE
		( a0.名称コード = - 11 )
	)
	AS a1
LEFT OUTER JOIN
	数値_T AS b1
	ON b1.数値コード = a1.数値コード
)

SELECT
	*
FROM
	v1 AS v100
