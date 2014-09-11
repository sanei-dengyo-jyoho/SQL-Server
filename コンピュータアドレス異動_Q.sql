with

v0 as
(
select
	a0.年度
,	a0.[管理№]
,	isnull(a0.確定済,0) as 確定済
,	a0.ドメイン名
,	min(c0.ドメイン名称) as ドメイン名称
,	min(d0.部門コード) as 部門コード
,	min(d0.社員コード) as 社員コード
,	a0.IP1
,	a0.IP2
,	a0.IP3
,	a0.IP4
,	dbo.FuncMakeComputerIPAddress(isnull(a0.IP1,0),isnull(a0.IP2,0),isnull(a0.IP3,0),isnull(a0.IP4,0),DEFAULT) as IPアドレス
,	count(b0.IP4) as 台数
,	min(b0.設置日) as 設置日

from
	コンピュータアドレス異動_T as a0
left join
	コンピュータアドレス異動_T明細 as b0
	on b0.年度 = a0.年度
	and b0.[管理№] = a0.[管理№]
left join
	ドメイン名_T as c0
	on c0.ドメイン名 = a0.ドメイン名
	and c0.IP1 = a0.IP1
	and c0.IP2 = a0.IP2
	and c0.IP3 = a0.IP3
	and c0.IP4 = a0.IP4
left join
	コンピュータ異動_T as d0
	on d0.[コンピュータ管理№] = b0.[コンピュータ管理№]
	and d0.ネットワーク数 = b0.ネットワーク数

group by
	a0.年度
,	a0.[管理№]
,	a0.確定済
,	a0.ドメイン名
,	a0.IP1
,	a0.IP2
,	a0.IP3
,	a0.IP4
)
,

v1 as
(
select
	a1.年度
,	a1.[管理№]
,	a1.確定済
,	a1.ドメイン名
,	a1.ドメイン名称
,	a1.部門コード
,	b1.部門名
,	a1.社員コード
,	c1.氏名
,	a1.IP1
,	a1.IP2
,	a1.IP3
,	a1.IP4
,	a1.IPアドレス
,	a1.台数
,	a1.設置日

from
	v0 as a1
left join
	部門_T年度 as b1
	on b1.年度 = a1.年度
	and b1.部門コード = a1.部門コード
left join
	社員_T年度 as c1
	on c1.年度 = a1.年度
	and c1.社員コード = a1.社員コード
)

select
	*

from
	v1 as a2

