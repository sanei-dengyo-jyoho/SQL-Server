WITH

T1 AS
(
SELECT
	名称 AS 読み順カナ
,	その他名称 AS 読み順
FROM
	名称_T AS A1
WHERE
	(名称コード = 8)
)
,

T2 AS
(
SELECT
	A2.取引先コード
,	A2.取引先名
,	A2.取引先名カナ
,	A2.種別コード
,	B2.種別
,	B2.表示コード
,	A2.得意先
,	A2.登録区分
,	CASE WHEN ISNULL(A2.取引先名カナ,N'') = N''
		 THEN N''
		 ELSE SUBSTRING(A2.取引先名カナ, 1, 1)
	END AS 読み順カナ
FROM
	取引先最新レコード_Q AS A2
LEFT OUTER JOIN
	取引先種別_T AS B2
	ON B2.種別コード = A2.種別コード
)
,

T3 AS
(
SELECT
	A3.取引先コード
,	A3.取引先名
,	A3.取引先名カナ
,	A3.種別コード
,	A3.種別
,	A3.表示コード
,	A3.得意先
,	A3.登録区分
,	CASE WHEN ISNULL(B3.読み順,N'') = N''
		 THEN N'　アルファベット'
		 ELSE B3.読み順
	END AS 読み順
,	A3.読み順カナ
FROM
	T2 AS A3
LEFT OUTER JOIN
	T1 AS B3
	ON B3.読み順カナ = A3.読み順カナ
)

SELECT
	*
FROM
	T3 AS T300
