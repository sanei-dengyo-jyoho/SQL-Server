WITH

V0 AS
(
SELECT
	新取引先コード
,	MAX(日付) AS 日付
FROM
	取引先_T異動 AS A0
GROUP BY
	新取引先コード	
)
,

V1 AS
(
SELECT
	B1.新取引先コード
,	B1.日付
,	B1.年度
,	B1.取引先コード
,	C1.取引先名
,	C1.取引先名カナ
,	C1.取引先略称
,	C1.取引先略称カナ
,	C1.担当部署名
,	C1.担当者名
,	C1.種別コード
,	C1.業種コード
,	C1.請負コード
,	C1.得意先
,	C1.ホームページアドレス
,	C1.メールアドレス
,	C1.郵便番号
,	C1.住所
,	C1.建物名
,	C1.TEL
,	C1.FAX
,	C1.最寄駅
,	C1.部門コード
,	C1.社員コード
,	C1.状態コード
,	C1.登録区分
,	C1.登録日時
FROM
  	V0 AS A1
	INNER JOIN 取引先_T異動 AS B1
	ON A1.新取引先コード = B1.新取引先コード
	AND A1.日付 = B1.日付
	INNER JOIN 取引先_T AS C1
	ON A1.新取引先コード = C1.取引先コード
WHERE
	( C1.登録区分 <= 0)
)

SELECT
	*
FROM
	V1 AS A2
