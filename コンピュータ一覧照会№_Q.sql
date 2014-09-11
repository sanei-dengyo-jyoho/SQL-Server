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

v0 as
(
select
	b0.[コンピュータ管理№]
,	q000.最大ネットワーク数 as ネットワーク数
,	isnull(b0.[コンピュータ管理№],'') + '(' + convert(varchar(4),isnull(q000.ネットワーク数,0)) + ')' as [コンピュータ管理№数]
,	d0.ドメイン名
,	d0.IP1
,	d0.IP2
,	d0.IP3
,	d0.IP4
,	dbo.FuncMakeComputerIPAddress(isnull(d0.IP1,0),isnull(d0.IP2,0),isnull(d0.IP3,0),isnull(d0.IP4,0),DEFAULT) as IPアドレス
,	d0.IP1SORT
,	d0.IP2SORT
,	d0.IP3SORT
,	d0.IP4SORT
,	d0.設置日
,	q0.[コンピュータ分類№]
,	q0.コンピュータ分類
,	n0.[コンピュータタイプ№]
,	n0.コンピュータタイプ識別
,	n0.コンピュータタイプ
,	n0.コンピュータタイプ略称
,	isnull(n0.CPU,0) as CPU
,	isnull(n0.トラブル報告,0) as 種類の停止
,	d0.コンピュータ名
,	d0.[接続コンピュータ管理№]
,	m0.機器名
,	m0.メーカ名
,	isnull(m0.停止,0) as 機器の停止
,	r0.基本ソフト分類
,	r0.基本ソフト名
,	d0.登録区分
,	d0.異動区分
,	isnull(d0.最新区分,0) as 最新区分
,	d0.部門コード
,	s0.部門名
,	s0.部門名略称
,	s0.部門名省略
,	dbo.FuncMakeComputerUseString(isnull(s0.部門名省略,''),isnull(d0.フロア,''),isnull(e0.氏,''),isnull(d0.備考,'')) as 利用
,	d0.社員コード
,	e0.氏名
,	e0.氏
,	e0.名
,	e0.カナ氏名
,	e0.カナ氏
,	e0.カナ名
,	case when isnull(e0.社員コード,0) = 0 then -2 else isnull(e0.登録区分,-1) end as 社員登録区分
,	e0.読み順
,	e0.メールアドレス
,	e0.職制区分
,	h0.職制区分名
,	e0.職制コード
,	f0.職制名
,	f0.職制名略称
,	e0.係コード
,	g0.係名
,	g0.係名略称
,	g0.係名省略
,	e0.生年月日
,	e0.性別
,	e0.入社日
,	e0.退職日
,	e0.退職年度

from
	q0 as q000
left outer join
	コンピュータ振出_T as b0
	on b0.[コンピュータ管理№] = q000.[コンピュータ管理№]
	and b0.ネットワーク数 = q000.ネットワーク数
left outer join
	q1 as q100
	on q100.[コンピュータ管理№] = b0.[コンピュータ管理№]
	and q100.ネットワーク数 = b0.ネットワーク数
left outer join
	コンピュータ異動_T as d0
	on d0.[コンピュータ管理№] = q100.[コンピュータ管理№]
	and d0.ネットワーク数 = q100.ネットワーク数
left outer join
	コンピュータ機器_T as m0
	on m0.機器名 = b0.機器名
left outer join
	コンピュータ振出_T基本ソフト as r0
	on r0.[コンピュータ管理№] = b0.[コンピュータ管理№]
	and r0.ネットワーク数 = b0.ネットワーク数
left outer join
	コンピュータタイプ_T as n0
	on n0.コンピュータタイプ = m0.コンピュータタイプ
left outer join
	コンピュータ分類_Q as q0
	on q0.コンピュータ分類 = n0.コンピュータ分類
left outer join
	部門_Q最新 as s0
	on s0.部門コード = d0.部門コード
left outer join
	社員_T as e0
	on e0.社員コード = d0.社員コード
left outer join
	職制区分_T as h0
	on h0.職制区分 = e0.職制区分
left outer join
	職制_T as f0
	on f0.職制区分 = e0.職制区分
	and f0.職制コード = e0.職制コード
left outer join
	係名_T as g0
	on g0.係コード = e0.係コード

where
	( isnull(b0.廃止日,'') = '' )
)

select
	*

from
	v0 as a1

