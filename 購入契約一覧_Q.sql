with

x0 as
(
select
	[コンピュータ管理№]
,	min(ネットワーク数) as ネットワーク数
,	max(ネットワーク数) as 最大ネットワーク数

from
	コンピュータ振出_T as x00

group by
	[コンピュータ管理№]
)
,

x1 as
(
select
	x11.[コンピュータ管理№]
,	x11.廃止日

from
	x0 as x10
left outer join
	コンピュータ振出_T as x11
	on x11.[コンピュータ管理№] = x10.[コンピュータ管理№]
	and x11.ネットワーク数 = x10.ネットワーク数
)
,

x2 as
(
select
	x20.年度
,	x20.[管理№]
,	count(x20.[コンピュータ管理№]) as 台数
,	sum(case isnull(x21.廃止日,'') when '' then 1 else 0 end) as 稼働台数

from
	購入物件_T as x20
left outer join
	x1 as x21
	on x21.[コンピュータ管理№] = x20.[コンピュータ管理№]

group by
	x20.年度
,	x20.[管理№]
)
,

v2 as
(
select
	a2.年度
,	a2.[管理№]
,	convert(varchar(5),a2.年度) + '-' + substring(convert(varchar(5),10000 + a2.[管理№]),2,4) as [年度-№]
,	0 as 回数
,	a2.契約番号
,	a2.契約種別
,	d2.契約種別名
,	a2.契約年度
,	a2.契約日
,	a2.購入年度
,	a2.購入日
,	a2.部門コード
,	e2.部門名
,	e2.部門名略称
,	a2.売主名
,	a2.物件名
,	b2.台数
,	b2.稼働台数
,	a2.総額
,	a2.総額消費税
,	a2.備考
,	a2.参照年度
,	a2.[参照管理№]
,	a2.参照契約種別名
,	case when isnull(a2.参照年度,0) <> 0 and isnull(a2.[参照管理№],0) <> 0 then 1 else 0 end as 警告

from
	購入契約_T as a2
left outer join
	x2 as b2
	on b2.年度 = a2.年度
	and b2.[管理№] = a2.[管理№]
left outer join
	契約種別_Q as d2
	on d2.契約種別 = a2.契約種別
left outer join
	部門_Q最新 as e2
	on e2.部門コード = a2.部門コード

where
	( isnull(b2.台数,0) = 0 )
	or ( isnull(b2.稼働台数,0) > 0 )
)

select
	*

from
	v2 as v200

