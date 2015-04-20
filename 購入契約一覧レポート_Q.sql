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
LEFT OUTER JOIN
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
LEFT OUTER JOIN
	x1 as x21
	on x21.[コンピュータ管理№] = x20.[コンピュータ管理№]

group by
	x20.年度
,	x20.[管理№]
)
,

q0 as
(
select
	[コンピュータ管理№]
,	min(ネットワーク数) as ネットワーク数

from
	コンピュータ異動_T as q00

group by
	[コンピュータ管理№]
)
,

q1 as
(
select
	[コンピュータ管理№]
,	min(ネットワーク数) as ネットワーク数

from
	コンピュータ振出_T as q10

group by
	[コンピュータ管理№]
)
,

v0 as
(
select
	a0.[コンピュータ管理№]
,	a0.部門コード

from
	コンピュータ異動_T as a0
inner join
	q0 as b0
	on b0.[コンピュータ管理№] = a0.[コンピュータ管理№]
	and b0.ネットワーク数 = a0.ネットワーク数
)
,

v1 as
(
select
	a1.[コンピュータ管理№]
,	a1.機器名

from
	コンピュータ振出_T as a1
inner join
	q1 as b1
	on b1.[コンピュータ管理№] = a1.[コンピュータ管理№]
	and b1.ネットワーク数 = a1.ネットワーク数

where
	( isnull(a1.廃止日,'') = '' )
)
,

v2 as
(
select
	a2.年度
,	a2.[管理№]
,	substring(convert(varchar(5),10000 + a2.[管理№]),2,4) as 管理番号
,	a2.契約番号
,	a2.契約種別
,	a2.売主名
,	a2.契約年度
,	a2.契約日
,	a2.購入年度
,	a2.購入日
,	convert(money,isnull(a2.総額,0)) as 総額
,	convert(money,isnull(a2.総額消費税,0)) as 総額消費税
,	a2.備考
,	c2.[コンピュータ管理№]
,	e2.機器名
,	1 as 台数
,	case isnull(d2.部門コード,'') when '' then 0 else 1 end as 設置済
,	case isnull(d2.部門コード,'') when '' then 1 else 0 end as 保留中
,	d2.部門コード

from
	購入契約_T as a2
LEFT OUTER JOIN
	x2 as b2
	on b2.年度 = a2.年度
	and b2.[管理№] = a2.[管理№]
LEFT OUTER JOIN
	購入物件_T as c2
	on c2.年度 = a2.年度
	and c2.[管理№] = a2.[管理№]
LEFT OUTER JOIN
	v0 as d2
	on d2.[コンピュータ管理№] = c2.[コンピュータ管理№]
LEFT OUTER JOIN
	v1 as e2
	on e2.[コンピュータ管理№] = c2.[コンピュータ管理№]

where
	( isnull(b2.台数,0) = 0 )
	or ( isnull(b2.稼働台数,0) > 0 )
)

select
	*

from
	v2 as v200

