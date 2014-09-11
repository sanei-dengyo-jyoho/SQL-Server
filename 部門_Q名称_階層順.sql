with

v0 as
(
select
	x.年度
,	x.会社コード
,	x.部門コード
,	x.部門名
,	x.部門名カナ
,	x.部門名略称
,	x.部門名省略
,	x.上位コード
,	x.部門レベル
,	x.所在地コード
,	isnull(y.場所名,x.部門名) as 場所名
,	isnull(y.場所略称,x.部門名略称) as 場所略称

from
	部門_T年度 as x
inner join
	会社住所_T年度 as y
	on y.年度 = x.年度
	and y.会社コード = x.会社コード
	and y.所在地コード = x.所在地コード

where
	( isnull(x.登録区分,-1) <= 0 )
)
,

cte
(
	年度
,	会社コード
,	部門コード
,	部門名
,	部門名カナ
,	部門名略称
,	部門名省略
,	上位コード
,	部門レベル
,	所在地コード
,	場所名
,	場所略称
,	階層レベル
,	部門名階層
,	部門名カナ階層
,	部門名略称階層
,	部門名省略階層
,	部門名階層段落
,	部門名カナ階層段落
,	部門名略称階層段落
,	部門名省略階層段落
)
as
(
select
	a.年度
,	a.会社コード
,	a.部門コード
,	a.部門名
,	a.部門名カナ
,	a.部門名略称
,	a.部門名省略
,	a.上位コード
,	a.部門レベル
,	a.所在地コード
,	a.場所名
,	a.場所略称
,	1 as 階層レベル
,	convert(nvarchar(4000),a.部門名) as 部門名階層
,	convert(nvarchar(4000),a.部門名カナ) as 部門名カナ階層
,	convert(nvarchar(4000),a.部門名略称) as 部門名略称階層
,	convert(nvarchar(4000),a.部門名省略) as 部門省略名階層
,	convert(nvarchar(4000),a.部門名) as 部門名階層段落
,	convert(nvarchar(4000),a.部門名カナ) as 部門名カナ階層段落
,	convert(nvarchar(4000),a.部門名略称) as 部門名略称階層段落
,	convert(nvarchar(4000),a.部門名省略) as 部門省略名階層段落

from
	v0 as a

where
	( isnull(a.上位コード,0) = 0 )

union all

select
	b.年度
,	b.会社コード
,	b.部門コード
,	b.部門名
,	b.部門名カナ
,	b.部門名略称
,	b.部門名省略
,	b.上位コード
,	b.部門レベル
,	b.所在地コード
,	b.場所名
,	b.場所略称
,	階層レベル + 1 as 階層レベル
,	convert(nvarchar(4000),case when (b.場所名 = b.部門名) and (b.部門レベル = 30) then '' else c.部門名階層 + '）' end + b.部門名) as 部門名階層
,	convert(nvarchar(4000),case when (b.場所名 = b.部門名) and (b.部門レベル = 30) then '' else c.部門名カナ階層 + '）' end + b.部門名カナ) as 部門名カナ階層
,	convert(nvarchar(4000),case when (b.場所名 = b.部門名) and (b.部門レベル = 30) then '' else c.部門名略称階層 + '）' end + b.部門名略称) as 部門名略称階層
,	convert(nvarchar(4000),case when (b.場所名 = b.部門名) and (b.部門レベル = 30) then '' else c.部門名省略階層 + '）' end + b.部門名省略) as 部門省略名階層
,	convert(nvarchar(4000),case when (b.場所名 = b.部門名) and (b.部門レベル = 30) then '' else c.部門名階層段落 + '）' + CHAR(13) + CHAR(10) end + b.部門名) as 部門名階層段落
,	convert(nvarchar(4000),case when (b.場所名 = b.部門名) and (b.部門レベル = 30) then '' else c.部門名カナ階層段落 + '）' + CHAR(13) + CHAR(10) end + b.部門名カナ) as 部門名カナ階層段落
,	convert(nvarchar(4000),case when (b.場所名 = b.部門名) and (b.部門レベル = 30) then '' else c.部門名略称階層段落 + '）' + CHAR(13) + CHAR(10) end + b.部門名略称) as 部門名略称階層段落
,	convert(nvarchar(4000),case when (b.場所名 = b.部門名) and (b.部門レベル = 30) then '' else c.部門名省略階層段落 + '）' + CHAR(13) + CHAR(10) end + b.部門名省略) as 部門省略名階層段落

from
	v0 as b
inner join
	cte as c
	on c.部門コード = b.上位コード
	and c.年度 = b.年度
)

select
	*

from
	cte as z

option (MAXRECURSION 0)

