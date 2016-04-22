with

v0 as
(
select
	a00.年度
,	a00.受付年月 as 年月
,	a00.部門コード
,	N'A' as 作業コード
,	N'業務依頼' as 作業名
,	a00.[管理№]
,	1 as 件数
from
	作業票_T業務依頼書 as a00

union all

select
	b00.年度
,	b00.受付年月 as 年月
,	b00.部門コード
,	N'B' as 作業コード
,	N'連絡票' as 作業名
,	b00.[管理№]
,	1 as 件数
from
	作業票_T連絡票 as b00

union all

select
	c00.年度
,	c00.受付年月 as 年月
,	c00.部門コード
,	N'C' as 作業コード
,	N'ヘルプコール' as 作業名
,	c00.[管理№]
,	1 as 件数
from
	作業票_Tヘルプコール as c00
)
,

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
	(
	select top 1
		N'A' as 作業コード,
		N'業務依頼' as 作業名

	union all

	select top 1
		N'B' as 作業コード,
		N'連絡票' as 作業名

	union all

	select top 1
		N'C' as 作業コード,
		N'ヘルプコール' as 作業名
	)
	as p10
cross join
	(
	select distinct
		v100.年度
	,	v100.年月
	from
		v0 as v100
	group by
		v100.年度
	,	v100.年月
	)
	as p11
cross join
	部門_Q最新 as p12
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
	(
	select distinct
		a30.年度
	,	a30.会社コード
	,	a30.順序コード
	,	a30.本部コード
	,	a30.部コード
	,	a30.所在地コード
	,	a30.部門レベル
	,	a30.部門コード
	,	a30.部門名略称 as 部門名
	from
		部門_Q異動履歴_全階層順 as a30
	where
		( isnull(a30.集計先,0) <> 0 )
	)
	as b50
	on b50.年度 = a50.年度
	and b50.部門コード = a50.集計部門コード
where
	( isnull(b50.部門名,N'') <> N'' )
)

select
	*
from
	v5 as v500
