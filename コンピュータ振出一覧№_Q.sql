with

q0 as
(
select
	[コンピュータ管理№]
,	min(ネットワーク数) as ネットワーク数
,	max(ネットワーク数) as 最大ネットワーク数

from
	コンピュータ振出_T as q00

group by
	[コンピュータ管理№]
)
,

q1 as
(
select
	[コンピュータ管理№]
,	min(ネットワーク数) as ネットワーク数
,	max(ネットワーク数) as 最大ネットワーク数

from
	コンピュータ異動_T as q10

group by
	[コンピュータ管理№]
)
,

s0 as
(
select
	会社コード
,	順序コード
,	本部コード
,	部コード
,	所在地コード
,	部門レベル
,	部門コード
,	部門名略称

from
	部門_Q階層順 as s00

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
	f0.[コンピュータ分類№]
,	e0.コンピュータ分類
,	c0.コンピュータタイプ
,	e0.コンピュータタイプ略称
,	e0.[コンピュータタイプ№]
,	e0.コンピュータタイプ識別
,	isnull(e0.トラブル報告,0) as 種類の停止
,	a0.機器名
,	d0.基本ソフト分類
,	d0.基本ソフト名
,	c0.メーカ名
,	isnull(c0.停止,0) as 機器の停止
,	a0.[コンピュータ管理№] as コンピュータ管理番号
,	a0.[コンピュータ管理№]
,	isnull(i0.[異動元コンピュータ管理№],j0.[異動元コンピュータ管理№]) as 異動元コンピュータ管理番号
,	isnull(i0.[異動元コンピュータ管理№],j0.[異動元コンピュータ管理№]) as [異動元コンピュータ管理№]
,	q000.最大ネットワーク数 as ネットワーク数
,	isnull(a0.[コンピュータ管理№],'') + '(' + convert(varchar(4),isnull(q000.ネットワーク数,0)) + ')' as [コンピュータ管理№数]
,	z1.基幹ドメイン as 設置基幹ドメイン
,	z1.ドメイン名 as 設置ドメイン名
,	z1.会社コード as 設置会社コード
,	z1.順序コード as 設置順序コード
,	z1.本部コード as 設置本部コード
,	z1.部コード as 設置部コード
,	z1.所在地コード as 設置所在地コード
,	z1.部門レベル as 設置部門レベル
,	z1.部門コード as 設置部門コード
,	z1.場所名 as 設置場所名
,	z0.会社コード as 集計会社コード
,	z0.順序コード as 集計順序コード
,	z0.本部コード as 集計本部コード
,	z0.部コード as 集計部コード
,	z0.所在地コード as 集計所在地コード
,	z0.部門レベル as 集計部門レベル
,	z0.部門コード as 集計部門コード
,	z0.部門名略称 as 集計部門名
,	g0.会社コード
,	g0.所在地コード
,	b0.部門コード
,	g0.部門名
,	g0.部門名略称
,	g0.部門名省略
,	b0.社員コード
,	h0.氏名
,	h0.カナ氏名
,	h0.性別
,	case when isnull(h0.社員コード,0) = 0 then -2 else isnull(h0.登録区分,-1) end as 社員登録区分
,	case isnull(b0.部門コード,0) when 0 then 0 else 1 end as 設置済
,	a0.購入日
,	b0.設置日
,	a0.廃止日
,	case isnull(a0.廃止日,'') when '' then 0 else 1 end as 廃止済
,	b0.登録区分
,	b0.異動区分
,	isnull(b0.最新区分,0) as 最新区分
,	b0.ドメイン名
,	b0.IP1
,	b0.IP2
,	b0.IP3
,	b0.IP4
,	dbo.FuncMakeComputerIPAddress(isnull(b0.IP1,0),isnull(b0.IP2,0),isnull(b0.IP3,0),isnull(b0.IP4,0),DEFAULT) as IPアドレス
,	b0.コンピュータ名
,	b0.端末名
,	'' as 接続詞
,	b0.[接続コンピュータ管理№] as 接続コンピュータ管理番号
,	b0.[接続コンピュータ管理№]
,	b0.IP1SORT
,	b0.IP2SORT
,	b0.IP3SORT
,	b0.IP4SORT
,	e0.ネットワーク接続
,	e0.ホスト名登録
,	e0.ホスト名識別
,	e0.IP先頭
,	e0.IP最後
,	e0.CPU
,	e0.トラブル報告
,	b0.フロア
,	b0.機能
,	b0.備考
,	dbo.FuncMakeComputerUseString(isnull(g0.部門名省略,''),isnull(b0.フロア,''),isnull(h0.氏,''),isnull(b0.備考,'')) as 利用
,	isnull(b0.備考, isnull(b0.機能,'')) as 機能備考
,	i0.年度 as リース年度
,	i0.[管理№] as [リース管理№]
,	i0.回数 as リース回数
,	i0.契約年度 as リース契約年度
,	i0.契約日 as リース契約日
,	i0.開始年度 as リース開始年度
,	i0.開始日 as リース開始日
,	i0.終了年度 as リース終了年度
,	i0.終了日 as リース終了日
,	i0.参照契約種別名 as リース参照契約種別名
,	j0.年度 as 購入年度
,	j0.[管理№] as [購入管理№]
,	j0.契約年度 as 購入契約年度
,	j0.契約日 as 購入契約日
,	case isnull(j0.契約種別,0) when 0 then case isnull(i0.契約種別,0) when 0 then 0 else i0.契約種別 end else j0.契約種別 end as 契約種別
,	case isnull(j0.契約種別名,'') when '' then case isnull(i0.契約種別名, '') when '' then '' else i0.契約種別名 end else j0.契約種別名 end as 契約種別名
,	j0.購入年度 as 物件購入年度
,	j0.購入日 as 物件購入日
,	j0.購入物件番号
,	j0.購入物件番号訂正
,	j0.参照契約種別名 as 購入参照契約種別名

from
	q0 as q000
left outer join
	コンピュータ振出_T as a0
	on a0.[コンピュータ管理№] = q000.[コンピュータ管理№]
	and a0.ネットワーク数 = q000.ネットワーク数
left outer join
	q1 as q100
	on q100.[コンピュータ管理№] = a0.[コンピュータ管理№]
	and q100.ネットワーク数 = a0.ネットワーク数
left outer join
	コンピュータ異動_T as b0
	on b0.[コンピュータ管理№] = q100.[コンピュータ管理№]
	and b0.ネットワーク数 = q100.ネットワーク数
left outer join
	コンピュータ機器_T as c0
	on c0.機器名 = a0.機器名
left outer join
	コンピュータ振出_T基本ソフト as d0
	on d0.[コンピュータ管理№] = a0.[コンピュータ管理№]
	and d0.ネットワーク数 = a0.ネットワーク数
left outer join
	コンピュータタイプ_T as e0
	on e0.コンピュータタイプ = c0.コンピュータタイプ
left outer join
	コンピュータ分類_Q as f0
	on f0.コンピュータ分類 = e0.コンピュータ分類
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
)

select
	*

from
	v0 as v000

