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

v0 as
(
select
	a0.年度
,	a0.[管理№]
,	b0.[コンピュータ管理№]
,	isnull(x0.ネットワーク数,0) as ネットワーク数
,	isnull(x0.登録区分,0) as 登録区分
,	isnull(x0.異動区分,0) as 異動区分
,	isnull(x0.最新区分,0) as 最新区分
,	m0.[元コンピュータ管理№] as [異動元コンピュータ管理№]
,	b0.物件番号 as 購入物件番号
,	b0.物件番号訂正 as 購入物件番号訂正
,	a0.契約種別
,	c0.契約種別名
,	a0.契約年度
,	a0.契約日
,	a0.購入年度
,	a0.購入日
,	a0.参照年度
,	a0.[参照管理№]
,	a0.参照契約種別名

from
	購入契約_T as a0
LEFT OUTER JOIN
	購入物件_T as b0
	on b0.年度 = a0.年度
	and b0.[管理№] = a0.[管理№]
LEFT OUTER JOIN
	購入物件_T異動 as m0
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
