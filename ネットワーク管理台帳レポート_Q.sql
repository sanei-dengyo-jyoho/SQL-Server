with

p0 as
(
select top 1
	'' as IP4

union all

select
	IP4

from
	IP4_T as p00
)
,

v0 as
(
select
	a0.基幹ドメイン
,	a0.ドメイン名
,	a0.会社コード
,	a0.順序コード
,	a0.本部コード
,	a0.部コード
,	a0.課コード
,	a0.所在地コード
,	a0.部門レベル
,	a0.部門コード
,	a0.場所名
,	a0.ネットワークアドレス
,	a0.IP1
,	a0.IP2
,	a0.IP3
,	b0.IP4

from
	ネットワーク管理_Q部門ドメイン名 as a0
cross join
	p0 as b0
)
,

v1 as
(
select
	a1.[コンピュータ管理№]
,	a1.ネットワーク数
,	c1.コンピュータタイプ
,	b1.機器名
,	c1.メーカ名
,	a1.コンピュータ名
,	s1.基本ソフト分類
,	s1.基本ソフト名
,	a1.ドメイン名
,	e1.所在地コード
,	a1.IP1
,	a1.IP2
,	a1.IP3
,	a1.IP4
,	a1.設置日
,	a1.部門コード as 設置部門コード
,	a1.社員コード as 設置社員コード
,	dbo.FuncMakeComputerUseString(isnull(e1.部門名省略,''),isnull(a1.フロア,''),isnull(f1.氏,''),isnull(a1.備考,'')) as 利用
,	a1.[接続コンピュータ管理№]

from
	コンピュータ異動_T as a1
LEFT OUTER JOIN
	コンピュータ振出_T as b1
	on b1.[コンピュータ管理№] = a1.[コンピュータ管理№]
	and b1.ネットワーク数 = a1.ネットワーク数
LEFT OUTER JOIN
	コンピュータ振出_T基本ソフト as s1
	on s1.[コンピュータ管理№] = b1.[コンピュータ管理№]
	and s1.ネットワーク数 = b1.ネットワーク数
LEFT OUTER JOIN
	コンピュータ機器_T as c1
	on c1.機器名 = b1.機器名
LEFT OUTER JOIN
	コンピュータタイプ_T as d1
	on d1.コンピュータタイプ = c1.コンピュータタイプ
LEFT OUTER JOIN
	部門_Q最新 as e1
	on e1.部門コード = a1.部門コード
LEFT OUTER JOIN
	社員_T as f1
	on f1.社員コード = a1.社員コード
)
,

v2 as
(
select distinct
	a2.基幹ドメイン
,	a2.ドメイン名
,	a2.会社コード
,	a2.順序コード
,	a2.本部コード
,	a2.部コード
,	a2.課コード
,	a2.所在地コード
,	a2.部門レベル
,	a2.部門コード
,	a2.場所名
,	a2.ネットワークアドレス
,	a2.IP1
,	a2.IP2
,	a2.IP3
,	a2.IP4
,	a2.IP1 as IP1順
,	a2.IP2 as IP2順
,	a2.IP3 as IP3順
,	a2.IP4 as IP4順
,	(convert(int,a2.IP4) / 64 + 1) * 64 -1 as IP4グループ
,	'XXX' as IP4グループ名
,	0 as IPグループ
,	'XXX' as IPグループ名
,	b2.[コンピュータ管理№]　as コンピュータ管理番号
,	b2.[コンピュータ管理№]
,	b2.ネットワーク数
,	b2.コンピュータタイプ
,	b2.機器名
,	b2.メーカ名
,	b2.コンピュータ名
,	b2.基本ソフト分類
,	b2.基本ソフト名
,	b2.設置日
,	b2.設置部門コード
,	b2.設置社員コード
,	b2.利用
,	b2.[接続コンピュータ管理№] as 接続コンピュータ管理番号
,	b2.[接続コンピュータ管理№]

from
	v0 as a2
LEFT OUTER JOIN
	v1 as b2
	on b2.所在地コード = a2.所在地コード
	and isnull(b2.ドメイン名,'') = a2.ドメイン名
	and isnull(b2.IP1,0) = a2.IP1
	and isnull(b2.IP2,0) = a2.IP2
	and isnull(b2.IP3,0) = a2.IP3
	and isnull(b2.IP4,0) = a2.IP4
)
,

v3 as
(
select distinct
	a3.基幹ドメイン
,	a3.ドメイン名
,	a3.会社コード
,	a3.順序コード
,	a3.本部コード
,	a3.部コード
,	a3.課コード
,	a3.所在地コード
,	a3.部門レベル
,	a3.部門コード
,	a3.場所名
,	a3.ネットワークアドレス
,	isnull(b3.IP1,0) as IP1
,	isnull(b3.IP2,0) as IP2
,	isnull(b3.IP3,0) as IP3
,	isnull(b3.IP4,0) as IP4
,	isnull(b3.IP1,999) as IP1順
,	isnull(b3.IP2,999) as IP2順
,	isnull(b3.IP3,999) as IP3順
,	isnull(b3.IP4,999) as IP4順
,	999 as IP4グループ
,	'' as IP4グループ名
,	999 as IPグループ
,	'' as IPグループ名
,	b3.[コンピュータ管理№]　as コンピュータ管理番号
,	b3.[コンピュータ管理№]
,	b3.ネットワーク数
,	b3.コンピュータタイプ
,	b3.機器名
,	b3.メーカ名
,	b3.コンピュータ名
,	b3.基本ソフト分類
,	b3.基本ソフト名
,	b3.設置日
,	b3.設置部門コード
,	b3.設置社員コード
,	b3.利用
,	b3.[接続コンピュータ管理№]　as 接続コンピュータ管理番号
,	b3.[接続コンピュータ管理№]

from
	v0 as a3
LEFT OUTER JOIN
	v1 as b3
	on b3.所在地コード = a3.所在地コード

where
	( a3.基幹ドメイン <> 0 )
	and ( isnull(b3.IP1,0) = 0 )
	and ( isnull(b3.IP2,0) = 0 )
	and ( isnull(b3.IP3,0) = 0 )
	and ( isnull(b3.IP4,0) = 0 )
)
,

v4 as
(
select
	*

from
	v2 as a4

union all

select
	*

from
	v3 as b4
)

select
	*

from
	v4 as v000

