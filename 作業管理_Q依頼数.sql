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
	作業票_T業務依頼書 as a00

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
	作業票_T連絡票 as b00

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
	作業票_Tヘルプコール as c00
),

v1 as
(
select distinct
	年度,
	年月
from
	v0 as v100
group by
	年度,
	年月
),

p0 as
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

p1 as
(
select distinct
	p11.年度,
	p11.年月,
	p12.部門コード,
	p12.部門名略称,
	p12.集計部門コード,
	p10.作業コード,
	p10.作業名
from
	p0 as p10
cross join
	v1 as p11
cross join
	部門_Q最新 as p12
),

v3 as
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
	部門_Q異動履歴_全階層順 as a30
where
	(isnull(集計先,0) <> 0)
),

v4 as
(
select
	b40.年度,
	b40.年月,
	b40.部門コード as 設置部門コード,
	b40.部門名略称 as 設置部門名,
	b40.集計部門コード,
	b40.作業コード,
	b40.作業名,
	isnull(a40.[管理№],0) as [管理№],
	isnull(a40.件数,0) as 件数
from
	p1 as b40
left join
	v0 as a40
	on a40.年度 = b40.年度
	and a40.年月 = b40.年月
	and a40.部門コード = b40.部門コード
	and a40.作業コード = b40.作業コード
	and a40.作業名 = b40.作業名
),

v5 as
(
select
	a50.年度,
	a50.年月,
	convert(nvarchar(4),floor(a50.年月 / 100))+'年'+convert(nvarchar(4),floor(a50.年月 % 100))+'月' as 年月表示,
	b50.会社コード,
	b50.順序コード,
	b50.本部コード,
	b50.部コード,
	b50.所在地コード,
	b50.部門レベル,
	b50.部門コード,
	b50.部門名,
	a50.設置部門コード,
	a50.設置部門名,
	a50.作業コード,
	a50.作業名,
	isnull(a50.[管理№],0) as [管理№],
	isnull(a50.件数,0) as 件数
from
	v4 as a50
left join
	v3 as b50
	on b50.年度 = a50.年度
	and b50.部門コード = a50.集計部門コード
)

select
	*
from
	v5 as a60
where
	(isnull(部門名,'') <> '')
