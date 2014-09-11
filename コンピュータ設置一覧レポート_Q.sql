with

x0 as
(
select
	[コンピュータ分類№]
,	コンピュータ分類
,	[コンピュータタイプ№]
,	コンピュータタイプ
,	[機器名№]
,	機器名
,	メーカ名
,	機器の停止
,	保守
,	資産
,	種類の停止

from
	コンピュータ機器一覧_Q as x00

where
	( [コンピュータ分類№] >= 0 )
	and ( [コンピュータタイプ№] >= 0 )
	and ( [機器名№] >= 0 )
)
,

s0 as
(
select
	会社コード
,	順序コード
,	本部コード
,	部コード
,	課コード
,	所在地コード
,	部門レベル
,	部門コード
,	部門名略称

from
	部門_Q階層順_簡易版 as s00

where
	( isnull(集計先,0) <> 0 )
)
,

s1 as
(
select
	基幹ドメイン
,	ドメイン名
,	会社コード
,	順序コード
,	本部コード
,	部コード
,	課コード
,	所在地コード
,	部門レベル
,	部門コード
,	場所名

from
	ネットワーク管理_Q部門ドメイン名 as s10

where
	( isnull(基幹ドメイン,0) <> 0 )
)
,

v0 as
(
select
	c0.[コンピュータ分類№]
,	c0.コンピュータ分類
,	c0.[コンピュータタイプ№]
,	c0.コンピュータタイプ
,	convert(int,c0.[機器名№]) as [機器名№]
,	c0.機器名
,	c0.メーカ名
,	a0.[コンピュータ管理№] as コンピュータ管理番号
,	a0.[コンピュータ管理№]
,	a0.ネットワーク数
,	z1.基幹ドメイン as 設置基幹ドメイン
,	z1.ドメイン名 as 設置ドメイン名
,	z1.会社コード as 設置会社コード
,	z1.順序コード as 設置順序コード
,	z1.本部コード as 設置本部コード
,	z1.部コード as 設置部コード
,	z1.課コード as 設置課コード
,	z1.所在地コード as 設置所在地コード
,	z1.部門レベル as 設置部門レベル
,	z1.部門コード as 設置部門コード
,	z1.場所名 as 設置場所名
,	z0.会社コード as 集計会社コード
,	z0.順序コード as 集計順序コード
,	z0.本部コード as 集計本部コード
,	z0.部コード as 集計部コード
,	z0.課コード as 集計課コード
,	z0.所在地コード as 集計所在地コード
,	z0.部門レベル as 集計部門レベル
,	z0.部門コード as 集計部門コード
,	z0.部門名略称 as 集計部門名
,	g0.会社コード
,	g0.所在地コード
,	b0.部門コード
,	g0.部門名略称
,	g0.部門名省略
,	b0.社員コード
,	case isnull(b0.部門コード,'') when '' then 0 else 1 end as 設置済
,	a0.購入日
,	b0.設置日
,	a0.廃止日
,	case isnull(a0.廃止日,'') when '' then 0 else 1 end as 廃止済
,	b0.ドメイン名
,	b0.IP1
,	b0.IP2
,	b0.IP3
,	b0.IP4
,	dbo.FuncMakeComputerIPAddress(isnull(b0.IP1,0),isnull(b0.IP2,0),isnull(b0.IP3,0),isnull(b0.IP4,0),DEFAULT) as IPアドレス
,	b0.コンピュータ名
,	s0.基本ソフト分類
,	s0.基本ソフト名
,	b0.[接続コンピュータ管理№] as 接続コンピュータ管理番号
,	b0.[接続コンピュータ管理№]
,	dbo.FuncMakeComputerUseString(isnull(g0.部門名省略,''),isnull(b0.フロア,''),isnull(h0.氏,''),isnull(b0.備考,'')) as 利用
,	i0.契約日 as リース契約日
,	i0.開始日 as リース開始日
,	i0.終了日 as リース終了日
,	j0.契約日 as 購入契約日
,	case isnull(j0.契約種別,0) when 0 then case isnull(i0.契約種別,0) when 0 then 0 else i0.契約種別 end else j0.契約種別 end as 契約種別
,	case isnull(j0.契約種別名,'') when '' then case isnull(i0.契約種別名, '') when '' then '' else i0.契約種別名 end else j0.契約種別名 end as 契約種別名

from
	コンピュータ振出_T as a0
left outer join
	コンピュータ振出_T基本ソフト as s0
	on s0.[コンピュータ管理№] = a0.[コンピュータ管理№]
	and s0.ネットワーク数 = a0.ネットワーク数
left outer join
	コンピュータ異動_T as b0
	on b0.[コンピュータ管理№] = a0.[コンピュータ管理№]
	and b0.ネットワーク数 = a0.ネットワーク数
left outer join
	x0 as c0
	on c0.機器名 = a0.機器名
left outer join
	部門_Q最新 as g0
	on g0.部門コード = b0.部門コード
left outer join
	s0 as z0
	on z0.部門コード = g0.集計部門コード
left outer join
	s1 as z1
	on z1.所在地コード = g0.所在地コード
left outer join
	社員_T as h0
	on h0.社員コード = b0.社員コード
left outer join
	リース物件一覧_Q as i0
	on i0.[コンピュータ管理№] = a0.[コンピュータ管理№]
left outer join
	購入物件一覧_Q as j0
	on j0.[コンピュータ管理№] = a0.[コンピュータ管理№]

where
	( isnull(b0.部門コード,'') <> '' )
)

select
	*

from
	v0 as v000

