WITH

V AS
(
SELECT DISTINCT
	V0.年度
,
	CASE
		WHEN ISNULL(V0.場所名,N'') = N'本社'
		THEN
			ISNULL(V0.会社コード,N'') +
			CONVERT(nvarchar(5),10000+ISNULL(V0.順序コード,0)) +
			N'@本社'
		ELSE
			ISNULL(V0.会社コード,N'') +
			CONVERT(nvarchar(5),10000+ISNULL(V0.順序コード,0)) +
			CONVERT(nvarchar(5),10000+ISNULL(V0.本部コード,0)) +
			CONVERT(nvarchar(5),10000+ISNULL(V0.部コード,0)) +
			CONVERT(nvarchar(5),10000+ISNULL(V0.課コード,0)) +
			CONVERT(nvarchar(5),10000+ISNULL(V0.所在地コード,0)) +
			N'@' +
			ISNULL(V0.場所名,N'')
	END
	AS 事業所レコード順序
,	V0.会社コード
,	V0.所在地コード
,	V0.場所名
,	V0.場所略称
FROM
	部門_T年度 AS S0
INNER JOIN
	部門_Q異動履歴_全階層順_簡易版 as V0
	on V0.年度 = S0.年度
	and V0.会社コード = S0.会社コード
	and V0.部門コード = S0.集計部門コード
GROUP BY
	V0.年度
,	V0.会社コード
,	V0.順序コード
,	V0.本部コード
,	V0.部コード
,	V0.課コード
,	V0.所在地コード
,	V0.場所名
,	V0.場所略称
)
,

Z AS
(
SELECT
	B.年度
,	B.事業所レコード順序
,
	SUBSTRING(B.事業所レコード順序,1,CHARINDEX(N'@',B.事業所レコード順序)-1)
	AS 事業所順序
,	B.会社コード
,	B.所在地コード
,	B.場所名
,	B.場所略称
FROM
	V AS B
)

SELECT
	*
FROM
	Z AS Z000
