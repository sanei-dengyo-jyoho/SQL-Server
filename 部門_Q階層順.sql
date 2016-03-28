with

v0 as
(
select
	a0.会社コード
,	b0.県コード
,	a0.部門レベル
,	a0.上位コード
,	a0.所在地コード
,	a0.集計部門コード
,	a0.部門コード
,	a0.部門名
,	a0.部門名カナ
,	a0.部門名略称
,	a0.部門名省略
,	a0.集計先
,	a0.フロア
,	a0.内線番号
,	a0.登録区分
,	a0.更新日時
,	b0.場所名
,	b0.場所略称
,	c0.県名
from
	部門_T as a0
inner join
	会社住所_T as b0
	on b0.会社コード = a0.会社コード
	and b0.所在地コード = a0.所在地コード
inner join
	県_Q as c0
	on c0.県コード = b0.県コード
where
	( isnull(a0.登録区分,-1) <= 0 )
)
,

cte
(
	会社コード
,	県コード
,	部門レベル
,	階層レベル
,	番号階層
,	名前階層
,	上位コード
,	所在地コード
,	集計部門コード
,	部門コード
,	部門名
,	部門名カナ
,	部門名略称
,	部門名省略
,	集計先
,	フロア
,	内線番号
,	登録区分
,	更新日時
,	場所名
,	場所略称
,	県名
,	path
)
as
(
select
	a1.会社コード
,	a1.県コード
,	a1.部門レベル
,	1 as 階層レベル
,	convert(nvarchar(4000),a1.部門コード) as 番号階層
,	convert(nvarchar(4000),a1.部門名) as 名前階層
,	a1.上位コード
,	a1.所在地コード
,	a1.集計部門コード
,	a1.部門コード
,	a1.部門名
,	a1.部門名カナ
,	a1.部門名略称
,	a1.部門名省略
,	a1.集計先
,	a1.フロア
,	a1.内線番号
,	a1.登録区分
,	a1.更新日時
,	a1.場所名
,	a1.場所略称
,	a1.県名
,	HierarchyID::GetRoot() as root
from
	v0 as a1
where
	( isnull(a1.上位コード,0) = 0 )

union all

select
	a2.会社コード
,	a2.県コード
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
,	a2.部門名カナ
,	a2.部門名略称
,	a2.部門名省略
,	a2.集計先
,	a2.フロア
,	a2.内線番号
,	a2.登録区分
,	a2.更新日時
,	a2.場所名
,	a2.場所略称
,	a2.県名
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

v1 as
(
select
	会社コード
,	県コード
,	部門レベル
,	階層レベル
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
,	部門名カナ
,	部門名略称
,	部門名省略
,	集計先
,	フロア
,	内線番号
,	登録区分
,	更新日時
,	場所名
,	場所略称
,	県名
,	path
,	path.GetLevel() as path_level
,	path.ToString() as path_string
from
	cte as a3
)
,

v10 as
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
,	dbo.FuncGetStateCode(DEFAULT) as 県コード
,	1 as 階層レベル
,	N'事業所' as 本部名
,	N'事業所' as 部名
,	N'事業所' as 課名
,	N'事業所' as 部門名
,	0 as 上位コード
,	0 as 集計部門コード
,	N'ジギョウショ' as 部門名カナ
,	N'事業所' as 部門名略称
,	N'事業所' as 部門名省略
,	0 as 集計先
,	NULL as フロア
,	NULL as 内線番号
,	0 as 登録区分
,	NULL as 更新日時
,	N'本社' as 場所名
,	N'本社' as 場所略称
,	N'東京都' as 県名
,	null as path
,	-20 as path_level
,	'/' as path_string
from
	部門_T as a10
)
,

v20 as
(
select distinct
	会社コード
,	dbo.FuncMakeDepartmentOrder(場所名,本部コード,dbo.FuncGetSectionCode(N'管理本部')) 順序コード
,	dbo.FuncMakeDepartmentCode(場所名,本部名,本部コード) as 本部コード
,	dbo.FuncMakeDepartmentCode(場所名,本部名,部コード) as 部コード
,	dbo.FuncMakeDepartmentCode(場所名,本部名,課コード) as 課コード
,	所在地コード
,	部門レベル
,	班コード as 部門コード
,	県コード
,	階層レベル
,	dbo.FuncMakeHeadquartersName(場所名,本部名) as 本部名
,	部名
,	課名
,	班名 as 部門名
,	上位コード
,	集計部門コード
,	部門名カナ
,	部門名略称
,	部門名省略
,	集計先
,	フロア
,	内線番号
,	登録区分
,	更新日時
,	場所名
,	場所略称
,	県名
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
