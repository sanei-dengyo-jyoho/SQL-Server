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

v0 as
(
SELECT
    新取引先コード
,   MAX(日付) AS 日付
FROM
    取引先_T異動 as va0
GROUP BY
    新取引先コード
)
,

v1 as
(
SELECT
    vb1.新取引先コード
,   ve1.システム名
,   ve1.工事種別
,   ve1.工事種別名
,   vb1.取引先コード
,   vc1.取引先名
,   vc1.取引先名カナ
,   vc1.種別コード
,   vc1.得意先
,   vc1.登録区分
FROM
    v0 as va1
INNER JOIN
    取引先_T異動 as vb1
    ON va1.新取引先コード = vb1.新取引先コード
    AND va1.日付 = vb1.日付
INNER JOIN
    取引先_T as vc1
    ON va1.新取引先コード = vc1.取引先コード
INNER JOIN
    工事種別_Q as ve1
    ON vc1.種別コード = ve1.種別コード
WHERE
    ( vc1.登録区分 <= 0 )
)
,

T2 AS
(
SELECT
	A2.システム名
,	A2.工事種別
,   A2.工事種別名
,   A2.取引先コード
,   A2.取引先名
,   A2.取引先名カナ
,   A2.種別コード
,	B2.種別
,	B2.表示コード
,   A2.得意先
,   A2.登録区分
,	CASE WHEN ISNULL(A2.取引先名カナ,N'') = N''
		 THEN N''
		 ELSE SUBSTRING(A2.取引先名カナ, 1, 1)
	END AS 読み順カナ
FROM
	v1 AS A2
LEFT OUTER JOIN
	取引先種別_T AS B2
	ON B2.種別コード = A2.種別コード
)
,

T3 AS
(
SELECT
	A3.システム名
,	A3.工事種別
,   A3.工事種別名
,   A3.取引先コード
,   A3.取引先名
,   A3.取引先名カナ
,   A3.種別コード
,	A3.種別
,	A3.表示コード
,   A3.得意先
,   A3.登録区分
,	CASE WHEN ISNULL(B3.読み順,N'') = N''
		 THEN N'上記以外の読み'
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
