with

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
	(
	select
		a0.ドメイン名
	,	a0.会社コード
	,	a0.IP1
	,	a0.IP2
	,	a0.IP3
	,	a0.IP4
		min(a0.部門コード) AS 部門コード
	from
		ドメイン名_T部門 as a0
	group by
		a0.ドメイン名
	,	a0.会社コード
	,	a0.IP1
	,	a0.IP2
	,	a0.IP3
	,	a0.IP4
	)
	as a1
inner join
	ドメイン名_T部門 as b1
	on b1.ドメイン名 = a1.ドメイン名
	and b1.会社コード = a1.会社コード
	and b1.IP1 = a1.IP1
	and b1.IP2 = a1.IP2
	and b1.IP3 = a1.IP3
	and b1.IP4 = a1.IP4
)
,

v2 as
(
select
	a2.ドメイン名
,	a2.会社コード
,	min(a2.部門コード) as 部門コード
,	c2.場所名
from
	v1 as a2
left outer join
	部門_T as b2
	on b2.会社コード = a2.会社コード
	and b2.部門コード = a2.部門コード
left outer join
	会社住所_T as c2
	on c2.会社コード = b2.会社コード
	and c2.所在地コード = b2.所在地コード
where
	( isnull(c2.場所名,'') <> '' )
group by
	a2.ドメイン名
,	a2.会社コード
,	c2.場所名
)
,

v3 as
(
select
	b3.ドメイン名
,	b3.会社コード
,	b3.部門コード
,	b3.IP1
,	b3.IP2
,	b3.IP3
,	b3.IP4
,	b3.コンピュータ名識別
,	b3.予備機
,	a3.場所名
from
	v2 as a3
left outer join
	v1 as b3
	on b3.ドメイン名 = a3.ドメイン名
	and b3.会社コード = a3.会社コード
	and b3.部門コード = a3.部門コード
)

select
	*
from
	v3 as v300
