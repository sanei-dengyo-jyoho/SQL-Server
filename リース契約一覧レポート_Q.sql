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
	リース物件_T as x20
left outer join
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

z1 as
(
select
	年度
,	[管理№]
,	max(回数) as 最大回数

from
	リース契約_T as z10

group by
	年度
,	[管理№]
)
,

z2 as
(
select
	z20.年度
,	z20.[管理№]
,	z20.回数
,	z20.契約番号
,	z20.契約種別
,	z20.業者名
,	z20.契約年度
,	z20.契約日
,	z20.開始年度
,	z20.開始日
,	z20.終了年度
,	z20.終了日
,	z20.期間月
,	z20.部門コード
,	z20.売主名
,	z20.物件名
,	z20.総額
,	z20.総額消費税
,	z20.月額
,	z20.月額消費税
,	z20.備考
,	z20.参照年度
,	z20.[参照管理№]
,	z20.参照契約種別名
,	z21.最大回数

from
	リース契約_T as z20

inner join
	z1 as z21
	on z21.年度 = z20.年度
	and z21.[管理№] = z20.[管理№]
	and z21.最大回数 = z20.回数
)
,

v2 as
(
select
	a2.年度
,	a2.[管理№]
,	substring(convert(varchar(5),10000 + a2.[管理№]),2,4) as 管理番号
,	a2.回数
,	a2.契約番号
,	a2.契約種別
,	a2.業者名
,	a2.売主名
,	a2.契約年度
,	a2.契約日
,	a2.開始年度
,	a2.開始日
,	a2.終了年度
,	a2.終了日
,	a2.期間月
,	convert(varchar(10),a2.開始日,111) + '～' + convert(varchar(10),a2.終了日,111) as リース期間
,	case a2.回数 when 0 then '' else '（再）' end + convert(varchar(10),a2.開始日,111) + '～' + convert(varchar(10),a2.終了日,111) as リース期間表示
,	convert(money,isnull(a2.総額,0)) as 総額
,	convert(money,isnull(a2.総額消費税,0)) as 総額消費税
,	convert(money,isnull(a2.月額,0)) as 月額
,	convert(money,isnull(a2.月額消費税,0)) as 月額消費税
,	a2.備考
,	c2.[コンピュータ管理№]
,	e2.機器名
,	1 as 台数
,	case isnull(d2.部門コード,'') when '' then 0 else 1 end as 設置済
,	case isnull(d2.部門コード,'') when '' then 1 else 0 end as 保留中
,	d2.部門コード

from
	z2 as a2
left outer join
	x2 as b2
	on b2.年度 = a2.年度
	and b2.[管理№] = a2.[管理№]
left outer join
	リース物件_T as c2
	on c2.年度 = a2.年度
	and c2.[管理№] = a2.[管理№]
left outer join
	v0 as d2
	on d2.[コンピュータ管理№] = c2.[コンピュータ管理№]
left outer join
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

