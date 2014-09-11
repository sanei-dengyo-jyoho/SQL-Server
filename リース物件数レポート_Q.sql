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
,	datepart(year,z20.開始日) as 開始年
,	datepart(month,z20.開始日) as 開始月
,	z20.開始日
,	z20.終了年度
,	datepart(year,z20.終了日) as 終了年
,	datepart(month,z20.終了日) as 終了月
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

s0 as
(
select
	s00.年度
,	s00.[管理№]
,	s00.[コンピュータ管理№]
,	s09.開始日
,	s09.終了日
,	s02.機器名
,	s03.[コンピュータ分類№]
,	s03.コンピュータ分類
,	s03.保守
,	s03.資産
,	s01.部門コード

from
	リース物件_T as s00
left outer join
	リース契約_T as s09
	on s09.年度 = s00.年度
	and s09.[管理№] = s09.[管理№]
left outer join
	v0 as s01
	on s01.[コンピュータ管理№] = s00.[コンピュータ管理№]
left outer join
	v1 as s02
	on s02.[コンピュータ管理№] = s00.[コンピュータ管理№]
left outer join
	x0 as s03
	on s03.機器名 = s02.機器名
)
,

v2 as
(
select
	年度
,	[管理№]
,	count([コンピュータ管理№]) as 台数

from
	s0 as a2

group by
	年度
,	[管理№]
)
,

v3 as
(
select
	a3.開始年
,	a3.開始月
,	a3.終了年
,	a3.終了月
,	c3.[コンピュータ管理№]
,	c3.年度
,	c3.[管理№]
,	c3.機器名
,	c3.[コンピュータ分類№]
,	c3.コンピュータ分類
,	c3.保守
,	c3.資産
,	1 as 台数
,	convert(money,floor((isnull(a3.月額,0) + isnull(a3.月額消費税,0)) / isnull(b3.台数,1))) as 金額
,	isnull(c3.部門コード,dbo.FuncGetSectionCode(DEFAULT)) as 部門コード
,	case isnull(c3.部門コード,0) when 0 then 1 else 0 end as 保留

from
	z2 as a3
inner join
	v2 as b3
	on b3.年度 = a3.年度
	and b3.[管理№] = a3.[管理№]
inner join
	s0 as c3
	on c3.年度 = b3.年度
	and c3.[管理№] = b3.[管理№]
)
,

p0 as
(
select
	min(開始日) as 開始日
,	max(終了日) as 終了日
,	年度
,	[管理№]
,	機器名
,	[コンピュータ分類№]
,	コンピュータ分類

from
	s0 as p00

group by
	年度
,	[管理№]
,	機器名
,	[コンピュータ分類№]
,	コンピュータ分類
)
,

p1 as
(
select distinct
	p11.部門コード
,	p11.集計部門コード
,	datepart(year,p10.開始日) as 開始年
,	datepart(month,p10.開始日) as 開始月
,	datepart(year,p10.終了日) as 終了年
,	datepart(month,p10.終了日) as 終了月
,	p10.年度
,	p10.[管理№]
,	p10.機器名
,	p10.[コンピュータ分類№]
,	p10.コンピュータ分類

from
	p0 as p10
cross join
	部門_T as p11
)
,

v4 as
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
,	部門名略称 as 部門名

from
	部門_Q階層順_簡易版 as a4

where
	( isnull(集計先,0) <> 0 )
)
,

v5 as
(
select distinct
	b5.開始年
,	b5.開始月
,	b5.終了年
,	b5.終了月
,	b5.部門コード
,	b5.集計部門コード
,	b5.年度
,	b5.[管理№]
,	b5.機器名
,	b5.[コンピュータ分類№]
,	b5.コンピュータ分類
,	isnull(a5.保守,0) as 保守
,	isnull(a5.資産,0) as 資産
,	isnull(a5.[コンピュータ管理№],'') as [コンピュータ管理№]
,	isnull(a5.台数,0) as 台数
,	isnull(a5.金額,0) as 金額

from
	p1 as b5
left outer join
	v3 as a5
	on a5.部門コード = b5.部門コード
	and a5.[コンピュータ分類№] = b5.[コンピュータ分類№]
	and a5.機器名 = b5.機器名
	and a5.年度 = b5.年度
	and a5.[管理№] = b5.[管理№]
)
,

v6 as
(
select
	a6.開始年
,	a6.開始月
,	a6.終了年
,	a6.終了月
,	b6.事業所順序
,	b6.会社コード
,	b6.順序コード
,	b6.本部コード
,	b6.部コード
,	b6.課コード
,	b6.所在地コード
,	b6.部門レベル
,	b6.部門コード
,	b6.部門名
,	a6.年度
,	a6.[管理№]
,	a6.機器名
,	'【' + convert(nvarchar(4),a6.年度) + '-' + substring(convert(nvarchar(4),a6.[管理№] + 1000),2,3) + '】' + space(1) + a6.機器名 as 機器名グループ
,	a6.機器名 + space(1) + '【' + convert(nvarchar(4),a6.年度) + '-' + substring(convert(nvarchar(4),a6.[管理№] + 1000),2,3) + '】' as 機器名系列グループ
,	a6.機器名 + char(13)+char(10) + '【' + convert(nvarchar(4),a6.年度) + '-' + substring(convert(nvarchar(4),a6.[管理№] + 1000),2,3) + '】' as 機器名ラベル
,	a6.[コンピュータ分類№]
,	a6.コンピュータ分類
,	isnull(a6.保守,0) as 保守
,	isnull(a6.資産,0) as 資産
,	isnull(a6.[コンピュータ管理№],'') as [コンピュータ管理№]
,	isnull(a6.台数,0) as 台数
,	isnull(a6.金額,0) as 金額

from
	v5 as a6
left outer join
	v4 as b6
	on b6.部門コード = a6.集計部門コード

where
	( isnull(b6.部門名,'') <> '' )
)

select
	*

from
	v6 as v700

