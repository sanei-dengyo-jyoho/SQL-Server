WITH

V AS
(
SELECT DISTINCT
	CASE WHEN ISNULL(V0.場所名,'') = '本社' THEN ISNULL(V0.会社コード,'')+CONVERT(varchar(5),10000+ISNULL(V0.順序コード,0))+'@'+'本社' ELSE ISNULL(V0.会社コード,'')+CONVERT(varchar(5),10000+ISNULL(V0.順序コード,0))+CONVERT(varchar(5),10000+ISNULL(V0.本部コード,0))+CONVERT(varchar(5),10000+ISNULL(V0.部コード,0))+CONVERT(varchar(5),10000+ISNULL(V0.課コード,0))+CONVERT(varchar(5),10000+ISNULL(V0.所在地コード,0))+'@'+ISNULL(V0.場所名,'') END as 事業所レコード順序
,	V0.会社コード
,	V0.所在地コード
,	V0.場所名

FROM
	部門_T AS S0
INNER JOIN
	部門_Q階層順_簡易版 as V0
	on V0.会社コード = S0.会社コード
	and V0.部門コード = S0.集計部門コード

GROUP BY
	V0.会社コード
,	V0.順序コード
,	V0.本部コード
,	V0.部コード
,	V0.課コード
,	V0.所在地コード
,	V0.場所名
)
,

Z AS
(
SELECT
	B.事業所レコード順序
,	SUBSTRING(B.事業所レコード順序,1,CHARINDEX('@',B.事業所レコード順序)-1) AS 事業所順序
,	B.会社コード
,	B.所在地コード
,	B.場所名

FROM
	V AS B
)

SELECT
	*

FROM
	Z AS Z000
