with

v0 as
(
select
	ドメイン名
,	会社コード
,	IP1
,	IP2
,	IP3
,	IP4

from
	ドメイン名_T部門 as a0

group by
	ドメイン名
,	会社コード
,	IP1
,	IP2
,	IP3
,	IP4
)
,

v1 as
(
select
	b1.ドメイン名
,	b1.会社コード
,	b1.部門コード
,	b1.IP1
,	b1.IP2
,	b1.IP3
,	b1.IP4
,	b1.コンピュータ名識別
,	b1.予備機

from
	v0 as a1
inner join
	ドメイン名_T部門 as b1
	on b1.ドメイン名 = a1.ドメイン名
	and b1.会社コード = a1.会社コード
	and b1.IP1 = a1.IP1
	and b1.IP2 = a1.IP2
	and b1.IP3 = a1.IP3
	and b1.IP4 = a1.IP4
)

select
	*

from
	v1 as a2

