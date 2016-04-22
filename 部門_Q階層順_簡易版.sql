with

v0 as
(
select
	a0.会社コード
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
	部門_T as a0
inner join
	会社住所_T as b0
	on b0.会社コード = a0.会社コード
	and b0.所在地コード = a0.所在地コード
where
	( isnull(a0.登録区分,-1) <= 0 )
)
,

cte
(
	会社コード
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
	a1.会社コード
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
	( isnull(a1.上位コード,0) = 0 )

union all

select
	a2.会社コード
,	a2.部門レベル
,	階層レベル + 1 as 階層レベル
,
	convert(nvarchar(4000),
		b2.番号階層 +
		N'@' +
		convert(nvarchar(6),a2.部門コード)
	)
	as 番号階層
,
	convert(nvarchar(4000),
		b2.名前階層 +
		N'@' +
		a2.部門名
	)
	as 名前階層
,	a2.上位コード
,	a2.所在地コード
,	a2.集計部門コード
,	a2.部門コード
,	a2.部門名
,	a2.部門名略称
,	a2.集計先
,	a2.場所名
,	a2.場所略称
,
	CAST(
		b2.path.ToString() +
		CAST(a2.部門コード as varchar(6)) +
		'/'
	as HierarchyID
	)
	as path
from
	v0 as a2
inner join
	cte as b2
	on b2.部門コード = a2.上位コード
)
,

v30 as
(
select distinct
	dbo.FuncGetPrimaryECode() as 会社コード
,	dbo.FuncGetSectionCode(N'本部') as 順序コード
,	dbo.FuncGetSectionCode(N'本部') as 本部コード
,	dbo.FuncGetSectionCode(N'本部') as 部コード
,	dbo.FuncGetSectionCode(N'本部') as 課コード
,	dbo.FuncGetSectionCode(N'本部') as 所在地コード
,	-20 as 部門レベル
,	999 as 部門コード
,	N'事業所' as 部門名
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
	部門_T as a10

union all

select distinct
	a20.会社コード
,
	dbo.FuncMakeDepartmentOrder(
		a20.場所名,
		a20.本部コード,
		dbo.FuncGetSectionCode(N'管理本部')
	)
	as 順序コード
,
	dbo.FuncMakeDepartmentCode(
		a20.場所名,
		a20.本部名,
		a20.本部コード
	)
	as 本部コード
,
	dbo.FuncMakeDepartmentCode(
		a20.場所名,
		a20.本部名,
		a20.部コード
	)
	as 部コード
,
	dbo.FuncMakeDepartmentCode(
		a20.場所名,
		a20.本部名,
		a20.課コード
	)
	as 課コード
,	a20.所在地コード
,	a20.部門レベル
,	a20.班コード as 部門コード
,	a20.班名 as 部門名
,	a20.上位コード
,	a20.集計部門コード
,	a20.部門名略称
,	a20.集計先
,	a20.場所名
,	a20.場所略称
,	a20.path
,	a20.path_level
,	a20.path_string
from
	(
	select
		a3.会社コード
	,	a3.部門レベル
	,
		convert(int,dbo.FuncGetHierarchieLevel(a3.番号階層,1,DEFAULT))
		as 本部コード
	,
		dbo.FuncGetHierarchieLevel(a3.名前階層,1,DEFAULT)
		as 本部名
	,
		convert(int,dbo.FuncGetHierarchieLevel(a3.番号階層,2,DEFAULT))
		as 部コード
	,
		dbo.FuncGetHierarchieLevel(a3.名前階層,2,DEFAULT)
		as 部名
	,
		convert(int,dbo.FuncGetHierarchieLevel(a3.番号階層,3,DEFAULT))
		as 課コード
	,
		dbo.FuncGetHierarchieLevel(a3.名前階層,3,DEFAULT)
		as 課名
	,
		convert(int,dbo.FuncGetHierarchieLevel(a3.番号階層,4,DEFAULT))
		as 班コード
	,
		dbo.FuncGetHierarchieLevel(a3.名前階層,4,DEFAULT)
		as 班名
	,	a3.上位コード
	,	a3.所在地コード
	,	a3.集計部門コード
	,	a3.部門コード
	,	a3.部門名
	,	a3.部門名略称
	,	a3.集計先
	,	a3.場所名
	,	a3.場所略称
	,	a3.path
	,	a3.path.GetLevel() as path_level
	,	a3.path.ToString() as path_string
	from
		cte as a3
	)
	as a20
)

select
	*
from
	v30 as v300
