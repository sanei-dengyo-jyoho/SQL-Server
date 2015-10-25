with

t0 as
(
select
	年度

from
	部門_T年度 as a00

group by
	年度
)
,

v0 as
(
select
	a0.年度
,	a0.会社コード
,	a0.部門レベル
,	a0.上位コード
,	a0.所在地コード
,	a0.集計部門コード
,	a0.部門コード
,	a0.部門名
,	a0.部門名略称
,	a0.集計先
,	b0.場所名
,	b0.場所略称

from
	部門_T年度 as a0

inner join
	会社住所_T年度 as b0
	on b0.年度 = a0.年度
	and b0.会社コード = a0.会社コード
	and b0.所在地コード = a0.所在地コード

where
	isnull(a0.登録区分,-1) <= 0
)
,

cte
(
	年度
,	会社コード
,	部門レベル
,	階層レベル
,	番号階層
,	名前階層
,	上位コード
,	所在地コード
,	集計部門コード
,	部門コード
,	部門名
,	部門名略称
,	集計先
,	場所名
,	場所略称
,	path
)
as
(
select
	a1.年度
,	a1.会社コード
,	a1.部門レベル
,	1 as 階層レベル
,	convert(nvarchar(4000),a1.部門コード) as 番号階層
,	convert(nvarchar(4000),a1.部門名) as 名前階層
,	a1.上位コード
,	a1.所在地コード
,	a1.集計部門コード
,	a1.部門コード
,	a1.部門名
,	a1.部門名略称
,	a1.集計先
,	a1.場所名
,	a1.場所略称
,	HierarchyID::GetRoot() as root

from
	v0 as a1

where
	isnull(a1.上位コード,0) = 0

union all

select
	a2.年度
,	a2.会社コード
,	a2.部門レベル
,	階層レベル + 1 as 階層レベル
,	convert(nvarchar(4000),b2.番号階層 + N'@' + convert(nvarchar(6),a2.部門コード)) as 番号階層
,	convert(nvarchar(4000),b2.名前階層 + N'@' + a2.部門名) as 名前階層
,	a2.上位コード
,	a2.所在地コード
,	a2.集計部門コード
,	a2.部門コード
,	a2.部門名
,	a2.部門名略称
,	a2.集計先
,	a2.場所名
,	a2.場所略称
,	CAST(b2.path.ToString() + CAST(a2.部門コード as varchar(6)) + '/' as HierarchyID) as path

from
	v0 as a2

inner join
	cte as b2
	on b2.部門コード = a2.上位コード
	and b2.年度 = a2.年度
)
,

v1 as
(
select
	年度
,	会社コード
,	部門レベル
,	convert(int,dbo.FuncGetHierarchieLevel(番号階層,1,DEFAULT)) as 本部コード
,	dbo.FuncGetHierarchieLevel(名前階層,1,DEFAULT) as 本部名
,	convert(int,dbo.FuncGetHierarchieLevel(番号階層,2,DEFAULT)) as 部コード
,	dbo.FuncGetHierarchieLevel(名前階層,2,DEFAULT) as 部名
,	convert(int,dbo.FuncGetHierarchieLevel(番号階層,3,DEFAULT)) as 課コード
,	dbo.FuncGetHierarchieLevel(名前階層,3,DEFAULT) as 課名
,	convert(int,dbo.FuncGetHierarchieLevel(番号階層,4,DEFAULT)) as 班コード
,	dbo.FuncGetHierarchieLevel(名前階層,4,DEFAULT) as 班名
,	上位コード
,	所在地コード
,	集計部門コード
,	部門コード
,	部門名
,	部門名略称
,	集計先
,	場所名
,	場所略称
,	path
,	path.GetLevel() as path_level
,	path.ToString() as path_string

from
	cte as a3
)
,

v10 as
(
select
	年度
,	dbo.FuncGetPrimaryECode() as 会社コード
,	dbo.FuncGetSectionCode(N'本部') as 順序コード
,	dbo.FuncGetSectionCode(N'本部') as 本部コード
,	dbo.FuncGetSectionCode(N'本部') as 部コード
,	dbo.FuncGetSectionCode(N'本部') as 課コード
,	dbo.FuncGetSectionCode(N'本部') as 所在地コード
,	-20 as 部門レベル
,	999 as 部門コード
,	N'事業所' as 部門名
,	N'事業所' as 本部名
,	0 as 上位コード
,	0 as 集計部門コード
,	N'事業所' as 部門名略称
,	0 as 集計先
,	N'本社' as 場所名
,	N'本社' as 場所略称
,	null as path
,	-20 as path_level
,	'/' as path_string

from
	t0 as a10
)
,

v20 as
(
select
	年度
,	会社コード
,	dbo.FuncMakeDepartmentOrder(場所名,本部コード,dbo.FuncGetSectionCode(N'管理本部')) 順序コード
,	dbo.FuncMakeDepartmentCode(場所名,本部名,本部コード) as 本部コード
,	dbo.FuncMakeDepartmentCode(場所名,本部名,部コード) as 部コード
,	dbo.FuncMakeDepartmentCode(場所名,本部名,課コード) as 課コード
,	所在地コード
,	部門レベル
,	班コード as 部門コード
,	本部名
,	班名 as 部門名
,	上位コード
,	集計部門コード
,	部門名略称
,	集計先
,	場所名
,	場所略称
,	path
,	path_level
,	path_string

from
	v1 as a20
)
,

v30 as
(
select
	*

from
	v10 as a30

union all

select
	*

from
	v20 as b30
)

select
	*

from
	v30 as zzz

option (MAXRECURSION 0)
