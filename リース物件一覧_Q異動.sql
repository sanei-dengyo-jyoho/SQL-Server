with

v0 as
(
select
	max(a0.年度*100+a0.[管理№]) as [年度№]
,	a0.[コンピュータ管理№]

from
	リース物件_T as a0

group by
	a0.[コンピュータ管理№]
)
,

v1 as
(
select
	a1.[コンピュータ管理№]
,	b1.[元コンピュータ管理№] as [異動元コンピュータ管理№]

from
	v0 as a1
left outer join
	リース物件_T as x1
	on x1.年度*100+x1.[管理№] = a1.[年度№]
	and x1.[コンピュータ管理№] = a1.[コンピュータ管理№]
left outer join
	リース物件_T異動 as b1
	on b1.年度*100+b1.[管理№] = a1.[年度№]
	and b1.[コンピュータ管理№] = a1.[コンピュータ管理№]
)

select
	*

from
	v1 as a2

