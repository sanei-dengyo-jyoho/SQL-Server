with

v0 as
(
select distinct
	f0.[コンピュータ分類№]
,	e0.コンピュータ分類
,	e0.[コンピュータタイプ№]
,	c0.コンピュータタイプ
,	a0.[コンピュータ管理№]
,	a0.ネットワーク数
,	isnull(a0.[コンピュータ管理№],'') + '(' + convert(varchar(4),isnull(a0.ネットワーク数,0)) + ')' as [コンピュータ管理№数]
,	d0.基本ソフト分類
,	d0.基本ソフト名
,	g0.会社コード
,	g0.順序コード
,	g0.本部コード
,	g0.部コード
,	g0.部門レベル
,	g0.所在地コード
,	g0.集計先
,	g0.集計部門コード
,	b0.部門コード
,	g0.部門名
,	b0.社員コード
,	j0.氏名
,	b0.ドメイン名
,	b0.IP1
,	b0.IP2
,	b0.IP3
,	b0.IP4
,	r0.IPアドレス
from
	コンピュータ振出_T as a0
left join
	コンピュータ異動_T as b0
	on b0.[コンピュータ管理№] = a0.[コンピュータ管理№]
	and b0.ネットワーク数 = a0.ネットワーク数
left join
	コンピュータ機器_T as c0
	on c0.機器名 = a0.機器名
left join
	コンピュータ振出_T基本ソフト as d0
	on d0.[コンピュータ管理№] = a0.[コンピュータ管理№]
	and d0.ネットワーク数 = a0.ネットワーク数
left join
	コンピュータタイプ_T as e0
	on e0.コンピュータタイプ = c0.コンピュータタイプ
left join
	コンピュータ分類_Q as f0
	on f0.コンピュータ分類 = e0.コンピュータ分類
left join
	部門_Q階層順 as g0
	on g0.部門コード = b0.部門コード
left join
	社員_T as j0
	on j0.社員コード = b0.社員コード
LEFT OUTER JOIN
	ネットワーク管理_Q部門ドメイン名 as r0
	on r0.ドメイン名 = b0.ドメイン名
	and r0.会社コード = g0.会社コード
	and r0.所在地コード = g0.所在地コード
where
	( isnull(a0.廃止日,'') = '' )
	and ( isnull(b0.部門コード,0) <> 0 )
)

select
	*
from
	v0 as a1

