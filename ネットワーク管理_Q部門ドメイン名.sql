with

v0 as
(
select
	ドメイン名
,	会社コード
,	min(部門コード) as 部門コード
,	IP1
,	IP2
,	IP3

from
	ドメイン名_T部門 as a0

group by
	ドメイン名
,	会社コード
,	IP1
,	IP2
,	IP3
)
,

v1 as
(
select
	a1.ドメイン名
,	a1.会社コード
,	c1.所在地コード
,	c1.場所名
,	a1.IP1
,	a1.IP2
,	a1.IP3
,	0 as IP4

from
	v0 as a1
left join
	部門_T as b1
	on b1.会社コード = a1.会社コード
	and b1.部門コード = a1.部門コード
left join
	会社住所_T as c1
	on c1.会社コード = b1.会社コード
	and c1.所在地コード = b1.所在地コード

where
	( isnull(c1.場所名,'') <> '' )
)
,

v2 as
(
select distinct
	会社コード
,	min(順序コード) as 順序コード
,	min(本部コード) as 本部コード
,	min(部コード) as 部コード
,	min(課コード) as 課コード
,	所在地コード
,	min(部門レベル) as 部門レベル
,	min(部門コード) as 部門コード

from
	部門_Q階層順_簡易版 as a2

where
	( isnull(部門名,'') <> '' )

group by
	会社コード
,	所在地コード
)
,

v3 as
(
select
	case a3.ドメイン名 when dbo.FuncGetPrimaryDomain() then 1 else 0 end as 基幹ドメイン
,	a3.ドメイン名
,	a3.会社コード
,	b3.順序コード
,	b3.本部コード
,	b3.部コード
,	b3.課コード
,	a3.所在地コード
,	b3.部門レベル
,	b3.部門コード
,	a3.場所名
,	dbo.FuncMakeComputerIPAddress(isnull(a3.IP1,0),isnull(a3.IP2,0),isnull(a3.IP3,0),isnull(a3.IP4,0),DEFAULT) as IPアドレス
,	dbo.FuncMakeComputerIPAddress(isnull(a3.IP1,0),isnull(a3.IP2,0),isnull(a3.IP3,0),isnull(a3.IP4,0),1) + space(1) + isnull(a3.場所名,'') as ネットワークアドレス
,	a3.IP1
,	a3.IP2
,	a3.IP3
,	a3.IP4

from
	v1 as a3
left join
	v2 as b3
	on b3.会社コード = a3.会社コード
	and b3.所在地コード = a3.所在地コード
)

select
	*

from
	v3 as a4

