with

q1 as
(
select
	q10.[コンピュータ管理№]
,	max(q10.ネットワーク数) as ネットワーク数
,	max(s10.登録区分) as 登録区分
,	max(s10.異動区分) as 異動区分
,	max(s10.最新区分) as 最新区分

from
	コンピュータ振出_T as q10
LEFT OUTER JOIN
	コンピュータ異動_T as s10
	on s10.[コンピュータ管理№] = q10.[コンピュータ管理№]

group by
	q10.[コンピュータ管理№]
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

v0 as
(
select
	a0.年度
,	a0.[管理№]
,	a0.回数
,	b0.[コンピュータ管理№]
,	isnull(x0.ネットワーク数,0) as ネットワーク数
,	isnull(x0.登録区分,0) as 登録区分
,	isnull(x0.異動区分,0) as 異動区分
,	isnull(x0.最新区分,0) as 最新区分
,	m0.[元コンピュータ管理№] as [異動元コンピュータ管理№]
,	a0.契約種別
,	c0.契約種別名
,	a0.契約年度
,	a0.契約日
,	a0.開始年度
,	a0.開始日
,	a0.終了年度
,	a0.終了日
,	a0.参照年度
,	a0.[参照管理№]
,	a0.参照契約種別名

from
	z2 as a0
LEFT OUTER JOIN
	リース物件_T as b0
	on b0.年度 = a0.年度
	and b0.[管理№] = a0.[管理№]
LEFT OUTER JOIN
	リース物件_T異動 as m0
	on m0.年度 = b0.年度
	and m0.[管理№] = b0.[管理№]
	and m0.[コンピュータ管理№] = b0.[コンピュータ管理№]
LEFT OUTER JOIN
	契約種別_Q as c0
	on c0.契約種別 = a0.契約種別
LEFT OUTER JOIN
	q1 as x0
	on x0.[コンピュータ管理№] = b0.[コンピュータ管理№]
)

select
	*

from
	v0 as v000

