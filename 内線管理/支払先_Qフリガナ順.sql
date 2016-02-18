WITH

T1 AS
(
SELECT
	名称 AS 読み順カナ
,	その他名称 AS 読み順
FROM
	名称_T AS A1
WHERE
	( 名称コード = 8 )
)
,

v0 as
(
SELECT
    新支払先コード
,	MAX(日付) AS 日付
FROM
    支払先_T異動 as va0
GROUP BY
    新支払先コード
)
,


v1 as
(
SELECT
    vb1.新支払先コード
,	vb1.支払先コード
,	vc1.支払先名
,	vc1.支払先名カナ
,	vc1.支払先種別コード
,	vc1.登録区分
FROM
    v0 as va1
INNER JOIN
    支払先_T異動 as vb1
    ON va1.新支払先コード = vb1.新支払先コード
    AND va1.日付 = vb1.日付
INNER JOIN
    支払先_T as vc1
    ON va1.新支払先コード = vc1.支払先コード
WHERE
    ( ISNULL(vc1.登録区分,-1) <= 0 )
)
,

T2 AS
(
SELECT
	A2.支払先コード
,	A2.支払先名
,	A2.支払先名カナ
,	A2.支払先種別コード
,	B2.支払先種別名
,	B2.支払先種別説明
,	A2.登録区分
,
	CASE
		WHEN ISNULL(A2.支払先名カナ,N'') = N''
		THEN N''
		ELSE SUBSTRING(A2.支払先名カナ, 1, 1)
	END
	AS 読み順カナ
FROM
	v1 AS A2
LEFT OUTER JOIN
	支払先種別_T AS B2
	ON B2.支払先種別コード = A2.支払先種別コード
)
,

T3 AS
(
SELECT
	A3.支払先コード
,	A3.支払先名
,	A3.支払先名カナ
,	A3.支払先種別コード
,	A3.支払先種別名
,	A3.支払先種別説明
,	A3.登録区分
,
	CASE
		WHEN ISNULL(B3.読み順,N'') = N''
		THEN N'　アルファベット'
		ELSE B3.読み順
	END
	AS 読み順
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
