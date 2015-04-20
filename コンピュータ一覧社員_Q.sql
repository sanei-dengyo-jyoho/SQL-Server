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
	max([コンピュータ管理№]) as [コンピュータ管理№]
,	min(ネットワーク数) as ネットワーク数
,	max(ネットワーク数) as 最大ネットワーク数
,	社員コード

from
	コンピュータ異動_T as q10

group by
	社員コード
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
,	d0.社員コード

from
	q0 as q000
LEFT OUTER JOIN
	コンピュータ振出_T as b0
	on b0.[コンピュータ管理№] = q000.[コンピュータ管理№]
	and b0.ネットワーク数 = q000.ネットワーク数
LEFT OUTER JOIN
	q1 as q100
	on q100.[コンピュータ管理№] = b0.[コンピュータ管理№]
	and q100.ネットワーク数 = b0.ネットワーク数
LEFT OUTER JOIN
	コンピュータ異動_T as d0
	on d0.[コンピュータ管理№] = q100.[コンピュータ管理№]
	and d0.ネットワーク数 = q100.ネットワーク数
LEFT OUTER JOIN
	コンピュータ機器_T as m0
	on m0.機器名 = b0.機器名
LEFT OUTER JOIN
	コンピュータ振出_T基本ソフト as r0
	on r0.[コンピュータ管理№] = b0.[コンピュータ管理№]
	and r0.ネットワーク数 = b0.ネットワーク数
LEFT OUTER JOIN
	コンピュータタイプ_T as n0
	on n0.コンピュータタイプ = m0.コンピュータタイプ
LEFT OUTER JOIN
	コンピュータ分類_Q as q0
	on q0.コンピュータ分類 = n0.コンピュータ分類

where
	( isnull(b0.廃止日,'') = '' )
	and ( isnull(q100.社員コード,'') <> '' )
)

select
	*

from
	v0 as a1

