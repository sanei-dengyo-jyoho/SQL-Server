WITH

t0 AS
(
SELECT
	利用者名
,	オブジェクト名
,	コントロール名
,	CONVERT(int, ISNULL(キー1, 0)) AS キー1
,	CONVERT(int, ISNULL(キー2, 0)) AS キー2
,	CONVERT(int, ISNULL(キー3, 0)) AS キー3
,	CONVERT(int, ISNULL(キー4, 0)) AS キー4
,	CONVERT(int, ISNULL(キー5, 0)) AS キー5
,	ISNULL(列1,  '') AS 列1
,	ISNULL(列2,  '') AS 列2
,	ISNULL(列3,  '') AS 列3
,	ISNULL(列4,  '') AS 列4
,	ISNULL(列5,  '') AS 列5
,	ISNULL(列6,  '') AS 列6
,	ISNULL(列7,  '') AS 列7
,	ISNULL(列8,  '') AS 列8
,	ISNULL(列9,  '') AS 列9
,	ISNULL(列10, '') AS 列10
,	ISNULL(列11, '') AS 列11
,	ISNULL(列12, '') AS 列12
,	ISNULL(列13, '') AS 列13
,	ISNULL(列14, '') AS 列14
,	ISNULL(列15, '') AS 列15
,	ISNULL(列16, '') AS 列16
,	ISNULL(列17, '') AS 列17
,	ISNULL(列18, '') AS 列18
,	ISNULL(列19, '') AS 列19
,	ISNULL(列20, '') AS 列20
,	ISNULL(列21, '') AS 列21
,	ISNULL(列22, '') AS 列22
,	ISNULL(列23, '') AS 列23
,	ISNULL(列24, '') AS 列24
,	ISNULL(列25, '') AS 列25
,	ISNULL(列26, '') AS 列26
,	ISNULL(列27, '') AS 列27
,	ISNULL(列28, '') AS 列28
,	ISNULL(列29, '') AS 列29
,	ISNULL(列30, '') AS 列30
FROM
    汎用登録_T AS v0
WHERE
	( オブジェクト名 = N'協力会社車両運転認定証_F' )
	AND ( コントロール名 = N'協力会社車両運転認定証_F' )
	AND ( CONVERT(int, ISNULL(キー1, 0)) BETWEEN 500 AND 520 )
)
,

t1 AS
(
SELECT
	v1.利用者名
,	v1.オブジェクト名
,	v1.コントロール名
,	v1.キー1 AS 動作コード
,	v1.キー2 AS 運転許可コード
,	v1.キー4 AS 頁
,	v1.キー5 AS 行
,	v1.列1  AS 列101
,	v1.列2  AS 列102
,	v1.列3  AS 列103
,	v1.列4  AS 列104
,	v1.列5  AS 列105
,	v1.列6  AS 列106
,	v1.列7  AS 列107
,	v1.列8  AS 列108
,	v1.列9  AS 列109
,	v1.列10 AS 列110
,	v1.列11 AS 列111
,	v1.列12 AS 列112
,	v1.列13 AS 列113
,	v1.列14 AS 列114
,	v1.列15 AS 列115
,	v1.列16 AS 列116
,	v1.列17 AS 列117
,	v1.列18 AS 列118
,	v1.列19 AS 列119
,	v1.列20 AS 列120
,	v1.列21 AS 列121
,	v1.列22 AS 列122
,	v1.列23 AS 列123
,	v1.列24 AS 列124
,	v1.列25 AS 列125
,	v1.列26 AS 列126
,	v1.列27 AS 列127
,	v1.列28 AS 列128
,	v1.列29 AS 列129
,	v1.列30 AS 列130
,	v2.列1  AS 列201
,	v2.列2  AS 列202
,	v2.列3  AS 列203
,	v2.列4  AS 列204
,	v2.列5  AS 列205
,	v2.列6  AS 列206
,	v2.列7  AS 列207
,	v2.列8  AS 列208
,	v2.列9  AS 列209
,	v2.列10 AS 列210
,	v2.列11 AS 列211
,	v2.列12 AS 列212
,	v2.列13 AS 列213
,	v2.列14 AS 列214
,	v2.列15 AS 列215
,	v2.列16 AS 列216
,	v2.列17 AS 列217
,	v2.列18 AS 列218
,	v2.列19 AS 列219
,	v2.列20 AS 列220
,	v2.列21 AS 列221
,	v2.列22 AS 列222
,	v2.列23 AS 列223
,	v2.列24 AS 列224
,	v2.列25 AS 列225
,	v2.列26 AS 列226
,	v2.列27 AS 列227
,	v2.列28 AS 列228
,	v2.列29 AS 列229
,	v2.列30 AS 列230
FROM
	(
	SELECT
		t11.*
	FROM
	    t0 AS t11
	WHERE
		( t11.キー3 % 2 <> 0 )
	)
    AS v1
INNER JOIN
	(
	SELECT
		t12.*
	FROM
	    t0 AS t12
	WHERE
		( t12.キー3 % 2 = 0 )
	)
    AS v2
	ON v2.利用者名 = v1.利用者名
	AND v2.オブジェクト名 = v1.オブジェクト名
	AND v2.コントロール名 = v1.コントロール名
	AND v2.キー1 = v1.キー1
	AND v2.キー2 = v1.キー2
	AND v2.キー4 = v1.キー4
	AND v2.キー5 = v1.キー5
)

SELECT
	*
FROM
	t1 AS t100
