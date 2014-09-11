with

x0 as
(
select
	[コンピュータ分類№]
,	コンピュータ分類
,	[コンピュータタイプ№]
,	コンピュータタイプ
,	[機器名№]
,	機器名
,	メーカ名
,	機器の停止
,	保守
,	資産
,	種類の停止

from
	コンピュータ機器一覧_Q as x00

where
	( [コンピュータ分類№] >= 0 )
	and ( [コンピュータタイプ№] >= 0 )
	and ( [機器名№] >= 0 )
),

q0 as
(
select
	[コンピュータ管理№]
,	min(ネットワーク数) as ネットワーク数

from
	コンピュータ異動_T as a0

group by
	[コンピュータ管理№]
),

q1 as
(
select
	[コンピュータ管理№]
,	min(ネットワーク数) as ネットワーク数

from
	コンピュータ振出_T as a1

group by
	[コンピュータ管理№]
),

v0 as
(
select
	a00.[コンピュータ管理№]
,	a00.部門コード

from
	コンピュータ異動_T as a00
inner join
	q0 as b00
	on b00.[コンピュータ管理№] = a00.[コンピュータ管理№]
	and b00.ネットワーク数 = a00.ネットワーク数
),

v1 as
(
select
	a10.[コンピュータ管理№]
,	a10.機器名

from
	コンピュータ振出_T as a10
inner join
	q1 as b10
	on b10.[コンピュータ管理№] = a10.[コンピュータ管理№]
	and b10.ネットワーク数 = a10.ネットワーク数

where
	( isnull(a10.廃止日,'') = '' )
),

v2 as
(
select
	a20.部門コード
,	a20.[コンピュータ管理№]
,	c20.[コンピュータ分類№]
,	c20.コンピュータ分類
,	c20.[コンピュータタイプ№]
,	c20.コンピュータタイプ
,	c20.機器名
,	isnull(c20.保守,0) as 保守
,	isnull(c20.資産,0) as 資産
,	1 as 台数

from
	v0 as a20
inner join
	v1 as b20
	on b20.[コンピュータ管理№] = a20.[コンピュータ管理№]
inner join
	x0 as c20
	on c20.機器名 = b20.機器名
),

p0 as
(
select
	[コンピュータ分類№]
,	コンピュータ分類
,	[コンピュータタイプ№]
,	コンピュータタイプ
,	保守
,	資産

from
	v2 as p00

group by
	[コンピュータ分類№]
,	コンピュータ分類
,	[コンピュータタイプ№]
,	コンピュータタイプ
,	保守
,	資産
),

p1 as
(
select distinct
	p11.部門コード
,	p11.集計部門コード
,	p10.[コンピュータ分類№]
,	p10.コンピュータ分類
,	p10.[コンピュータタイプ№]
,	p10.コンピュータタイプ
,	p10.保守
,	p10.資産

from
	p0 as p10
cross join
	部門_T as p11
),

v3 as
(
select
	CASE WHEN ISNULL(場所名,'') = '本社' THEN ISNULL(会社コード,'')+CONVERT(varchar(5),10000+ISNULL(順序コード,0))+'@'+'本社' ELSE ISNULL(会社コード,'')+CONVERT(varchar(5),10000+ISNULL(順序コード,0))+CONVERT(varchar(5),10000+ISNULL(本部コード,0))+CONVERT(varchar(5),10000+ISNULL(部コード,0))+CONVERT(varchar(5),10000+ISNULL(課コード,0))+CONVERT(varchar(5),10000+ISNULL(所在地コード,0)) END as 事業所順序
,	会社コード
,	順序コード
,	本部コード
,	部コード
,	課コード
,	所在地コード
,	部門レベル
,	部門コード
,	場所名 as 事業所名
,	部門名略称 as 部門名

from
	部門_Q階層順_簡易版 as a30

where
	( isnull(集計先,0) <> 0 )
),

v4 as
(
select distinct
	b40.部門コード
,	b40.集計部門コード
,	b40.[コンピュータ分類№]
,	b40.コンピュータ分類
,	b40.[コンピュータタイプ№]
,	b40.コンピュータタイプ
,	isnull(a40.機器名,'') as 機器名
,	b40.保守
,	b40.資産
,	isnull(a40.[コンピュータ管理№],'') as [コンピュータ管理№]
,	isnull(a40.台数,0) as 台数

from
	p1 as b40
left outer join
	v2 as a40
	on a40.部門コード = b40.部門コード
	and a40.[コンピュータ分類№] = b40.[コンピュータ分類№]
	and a40.コンピュータ分類 = b40.コンピュータ分類
	and a40.[コンピュータタイプ№] = b40.[コンピュータタイプ№]
	and a40.コンピュータタイプ = b40.コンピュータタイプ
	and a40.保守 = b40.保守
	and a40.資産 = b40.資産
),

v5 as
(
select
	b50.事業所順序
,	b50.会社コード
,	b50.順序コード
,	b50.本部コード
,	b50.部コード
,	b50.課コード
,	b50.所在地コード
,	b50.部門レベル
,	b50.部門コード
,	b50.事業所名
,	b50.部門名
,	a50.[コンピュータ分類№]
,	a50.コンピュータ分類
,	a50.[コンピュータタイプ№]
,	a50.コンピュータタイプ
,	isnull(a50.機器名,'') as 機器名
,	a50.保守
,	a50.資産
,	isnull(a50.[コンピュータ管理№],'') as [コンピュータ管理№]
,	isnull(a50.台数,0) as 台数

from
	v4 as a50
left outer join
	v3 as b50
	on b50.部門コード = a50.集計部門コード

where
	( isnull(b50.部門名,'') <> '' )
)

select
	*

from
	v5 as a60
