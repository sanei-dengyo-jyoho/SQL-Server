WITH

T3 AS
(
SELECT
	A3.取引先コード
,	A3.取引先名
,	A3.取引先名カナ
,	A3.取引先略称
,	A3.取引先略称カナ
,	A3.担当部署名
,	A3.担当者名
,	A3.種別コード
,	A3.種別
,	A3.表示コード
,	A3.業種コード
,	A3.請負コード
,	A3.得意先
,	A3.ホームページアドレス
,	A3.メールアドレス
,	A3.郵便番号
,	A3.住所
,	A3.建物名
,	A3.TEL
,	A3.FAX
,	A3.最寄駅
,	A3.部門コード
,	A3.社員コード
,	A3.状態コード
,	A3.登録区分
,	A3.登録日時
,
	CASE WHEN
		ISNULL(B3.読み順,N'') = N''
		THEN N'上記以外の読み'
		ELSE B3.読み順
	END
	AS 読み順
,	A3.読み順カナ
FROM
	(
	SELECT
		A2.取引先コード
	,	A2.取引先名
	,	A2.取引先名カナ
	,	A2.取引先略称
	,	A2.取引先略称カナ
	,	A2.担当部署名
	,	A2.担当者名
	,	A2.種別コード
	,	B2.種別
	,	B2.表示コード
	,	A2.業種コード
	,	A2.請負コード
	,	A2.得意先
	,	A2.ホームページアドレス
	,	A2.メールアドレス
	,	A2.郵便番号
	,	A2.住所
	,	A2.建物名
	,	A2.TEL
	,	A2.FAX
	,	A2.最寄駅
	,	A2.部門コード
	,	A2.社員コード
	,	A2.状態コード
	,	A2.登録区分
	,	A2.登録日時
	,
		CASE
			WHEN ISNULL(A2.取引先名カナ,'') = N''
			THEN N''
			ELSE SUBSTRING(A2.取引先名カナ, 1, 1)
		END
		AS 読み順カナ
	FROM
		取引先_T AS A2
	LEFT OUTER JOIN
		取引先種別_T AS B2
		ON B2.種別コード = A2.種別コード
	)
	AS A3
LEFT OUTER JOIN
	(
	SELECT
		A1.名称 AS 読み順カナ
	,	A1.その他名称 AS 読み順
	FROM
		名称_T AS A1
	WHERE
		( A1.名称コード = 8 )
	)
	AS B3
	ON B3.読み順カナ = A3.読み順カナ
)

SELECT
	*
FROM
	T3 AS T300
