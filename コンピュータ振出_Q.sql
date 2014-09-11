with

v0 as
(
select
	[コンピュータ管理№]
,	max(isnull(ネットワーク数,0)) as ネットワーク数
from
	コンピュータ振出_T as a0
group by
	[コンピュータ管理№]
)
,

v1 as
(
select
	b1.[コンピュータ管理№]
,	isnull(b1.ネットワーク数,0) as ネットワーク数
,	b1.機器名
,	b1.購入日
,	b1.廃止日
,	c1.基本ソフト分類
,	c1.基本ソフト名
,	b1.備考
,	b1.登録区分
from
	v0 as a1
left outer join
	コンピュータ振出_T as b1
	on b1.[コンピュータ管理№] = a1.[コンピュータ管理№]
	and isnull(b1.ネットワーク数,0) = isnull(a1.ネットワーク数,0)
left outer join
	コンピュータ振出_T基本ソフト as c1
	on c1.[コンピュータ管理№] = a1.[コンピュータ管理№]
	and isnull(c1.ネットワーク数,0) = isnull(a1.ネットワーク数,0)
)

select
	*
from
	v1 as v100

