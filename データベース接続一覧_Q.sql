WITH

v0 AS
(
SELECT
	A.IPアドレス
,	dbo.FuncMakeComputerIPAddress(
		ISNULL(B.IP1,0),
		ISNULL(B.IP2,0),
		ISNULL(B.IP3,0),
		ISNULL(B.IP4,0),1
	)
	AS IPAddr
,	A.ポート
,	A.プログラム
,	A.インターフェース
,	ISNULL(B.コンピュータ名,B.[コンピュータ管理№]) AS ホスト名
,	A.ログイン名
,	A.接続数
,	B.[コンピュータ管理№]
,	B.ネットワーク数
,	B.[コンピュータ管理№数]
,	B.設置日
,	B.[コンピュータ分類№]
,	B.コンピュータ分類
,	B.[コンピュータタイプ№]
,	B.コンピュータタイプ識別
,	B.コンピュータタイプ
,	B.機器名
,	B.メーカ名
,	B.基本ソフト分類
,	B.基本ソフト名
,	B.部門コード AS 所属部門コード
,	Z.部門名
,	Z.部門名略称
,	Z.部門名省略
,	B.利用
,	B.社員コード
,	B.氏名
,	B.カナ氏名
,	B.職制区分
,	B.職制コード
,	B.職制名
,	B.職制名略称
,	B.性別
,	B.登録区分
,	D.管理ドメイン
,	S.ドメイン名
,	Z.会社コード
,	Z.順序コード
,	Z.本部コード
,	Z.部コード
,	Z.課コード
,	Z.所在地コード
,	Z.部門レベル
,	Z.部門コード
,	Z.場所名
,	Z.場所略称
FROM
	db_session_connect_Q AS A
LEFT OUTER JOIN
	[コンピュータ一覧照会№_Q] AS B
	ON B.IPアドレス = A.IPアドレス
LEFT OUTER JOIN
	ドメイン名_T部門 AS S
	ON S.ドメイン名 = B.ドメイン名
	AND S.IP1 = B.IP1
	AND S.IP2 = B.IP2
	AND S.IP3 = B.IP3
	AND S.部門コード = B.部門コード
LEFT OUTER JOIN
	ドメイン名_T AS D
	ON D.ドメイン名 = S.ドメイン名
LEFT OUTER JOIN
	部門_Q階層順 AS Z
	ON Z.会社コード = S.会社コード
	AND Z.部門コード = S.部門コード
)

SELECT
	*
FROM
	v0 AS v000
