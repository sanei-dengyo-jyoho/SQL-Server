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

v0 as
(
select
	c0.[コンピュータ分類№]
,	c0.コンピュータ分類
,	c0.[コンピュータタイプ№]
,	c0.コンピュータタイプ
,	convert(int,c0.[機器名№]) as [機器名№]
,	a0.機器名
,	c0.メーカ名
,	a0.[コンピュータ管理№] as コンピュータ管理番号
,	a0.[コンピュータ管理№]
,	q000.最大ネットワーク数 as ネットワーク数
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
	q0 as q000
left outer join
	コンピュータ振出_T as a0
	on a0.[コンピュータ管理№] = q000.[コンピュータ管理№]
	and a0.ネットワーク数 = q000.ネットワーク数
left outer join
	コンピュータ振出_T基本ソフト as s0
	on s0.[コンピュータ管理№] = a0.[コンピュータ管理№]
	and s0.ネットワーク数 = a0.ネットワーク数
left outer join
	q1 as q100
	on q100.[コンピュータ管理№] = a0.[コンピュータ管理№]
	and q100.ネットワーク数 = a0.ネットワーク数
left outer join
	コンピュータ異動_T as b0
	on b0.[コンピュータ管理№] = q100.[コンピュータ管理№]
	and b0.ネットワーク数 = q100.ネットワーク数
left outer join
	x0 as c0
	on c0.機器名 = a0.機器名
left outer join
	部門_Q最新 as g0
	on g0.部門コード = b0.部門コード
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
	( isnull(a0.廃止日,'') = '' )
)

select
	*

from
	v0 as v000

