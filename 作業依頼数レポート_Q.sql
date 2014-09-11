with

v0 as
(
select
	年度,
	受付年月 as 年月,
	部門コード,
	'A' as 作業コード,
	'業務依頼' as 作業名,
	[管理№],
	1 as 件数
from
	作業票_T業務依頼書 as a0

union all

select
	年度,
	受付年月 as 年月,
	部門コード,
	'B' as 作業コード,
	'連絡票' as 作業名,
	[管理№],
	1 as 件数
from
	作業票_T連絡票 as b0

union all

select
	年度,
	受付年月 as 年月,
	部門コード,
	'C' as 作業コード,
	'ヘルプコール' as 作業名,
	[管理№],
	1 as 件数
from
	作業票_Tヘルプコール as c0
),

v1 as
(
select distinct
	a1.年度,
	a1.年月
from
	年月_Q as a1
where
	(a1.年度 between (select min(b1.年度) from v0 as b1) and (select max(c1.年度) from v0 as c1))
	and (a1.年月 <= (select max(d1.年月) from v0 as d1))

),

v2 as
(
select
	'A' as 作業コード,
	'業務依頼' as 作業名

union all

select
	'B' as 作業コード,
	'連絡票' as 作業名

union all

select
	'C' as 作業コード,
	'ヘルプコール' as 作業名
),

v3 as
(
select distinct
	a3.年度,
	a3.年月,
	c3.部門コード,
	c3.部門名略称,
	c3.集計部門コード,
	b3.作業コード,
	b3.作業名
from
	v1 as a3
cross join
	v2 as b3
cross join
	部門_Q最新 as c3
),

v4 as
(
select distinct
	年度,
	会社コード,
	順序コード,
	本部コード,
	部コード,
	所在地コード,
	部門レベル,
	部門コード,
	部門名略称 as 部門名
from
	部門_Q異動履歴_全階層順 as a4
where
	(isnull(集計先,0) <> 0)
),

v5 as
(
select
	a5.年度,
	a5.年月,
	a5.部門コード as 設置部門コード,
	a5.部門名略称 as 設置部門名,
	a5.集計部門コード,
	a5.作業コード,
	a5.作業名,
	isnull(b5.[管理№],0) as [管理№],
	isnull(b5.件数,0) as 件数
from
	v3 as a5
left join
	v0 as b5
	on b5.年度 = a5.年度
	and b5.年月 = a5.年月
	and b5.部門コード = a5.部門コード
	and b5.作業コード = a5.作業コード
	and b5.作業名 = a5.作業名
),

v6 as
(
select
	a6.年度,
	a6.年月,
	convert(nvarchar(4),floor(a6.年月 / 100))+'年'+convert(nvarchar(4),floor(a6.年月 % 100))+'月' as 年月表示,
	convert(int,floor(a6.年月 % 100)) as 月,
	substring(convert(varchar(4),1000+convert(int,floor(a6.年月 % 100))),3,2) as 月表示,
	b6.会社コード,
	b6.順序コード,
	b6.本部コード,
	b6.部コード,
	b6.所在地コード,
	b6.部門レベル,
	b6.部門コード,
	b6.部門名,
	a6.設置部門コード,
	a6.設置部門名,
	a6.作業コード,
	a6.作業名,
	isnull(a6.[管理№],0) as [管理№],
	isnull(a6.件数,0) as 件数
from
	v5 as a6
left join
	v4 as b6
	on b6.年度 = a6.年度
	and b6.部門コード = a6.集計部門コード
)

select
	*
from
	v6 as v600
where
	(isnull(部門名,'') <> '')
