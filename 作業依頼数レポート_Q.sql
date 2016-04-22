with

v3 as
(
select distinct
	a3.年度
,	a3.年月
,	c3.部門コード
,	c3.部門名略称
,	c3.集計部門コード
,	b3.作業コード
,	b3.作業名
from
	(
	select distinct
		a1.年度
	,	a1.年月
	from
		年月_Q as a1
	where
		(a1.年度
			between
			(select min(b1.年度) from v0 as b1)
			and
			(select max(c1.年度) from v0 as c1)
		)
		and
		(a1.年月 <=
			(select max(d1.年月) from v0 as d1)
		)

	)
	as a3
cross join
	(
	select top 1
		N'A' as 作業コード
	,	N'業務依頼' as 作業名

	union all

	select top 1
		N'B' as 作業コード
	,	N'連絡票' as 作業名

	union all

	select top 1
		N'C' as 作業コード
	,	N'ヘルプコール' as 作業名
	)
	as b3
cross join
	部門_Q最新 as c3
),

v5 as
(
select
	a5.年度
,	a5.年月
,	a5.部門コード as 設置部門コード
,	a5.部門名略称 as 設置部門名
,	a5.集計部門コード
,	a5.作業コード
,	a5.作業名
,	isnull(b5.[管理№],0) as [管理№]
,	isnull(b5.件数,0) as 件数
from
	v3 as a5
left outer join
	(
	select
		a0.年度
	,	a0.受付年月 as 年月
	,	a0.部門コード
	,	N'A' as 作業コード
	,	N'業務依頼' as 作業名
	,	a0.[管理№]
	,	1 as 件数
	from
		作業票_T業務依頼書 as a0

	union all

	select
		b0.年度
	,	b0.受付年月 as 年月
	,	b0.部門コード
	,	N'B' as 作業コード
	,	N'連絡票' as 作業名
	,	b0.[管理№]
	,	1 as 件数
	from
		作業票_T連絡票 as b0

	union all

	select
		c0.年度
	,	c0.受付年月 as 年月
	,	c0.部門コード
	,	N'C' as 作業コード
	,	N'ヘルプコール' as 作業名
	,	c0.[管理№]
	,	1 as 件数
	from
		作業票_Tヘルプコール as c0
	)
	as b5
	on b5.年度 = a5.年度
	and b5.年月 = a5.年月
	and b5.部門コード = a5.部門コード
	and b5.作業コード = a5.作業コード
	and b5.作業名 = a5.作業名
),

v6 as
(
select
	a6.年度
,	a6.年月
,
	convert(nvarchar(100),
		convert(nvarchar(4),floor(a6.年月 / 100)) + N'年' +
		convert(nvarchar(4),floor(a6.年月 % 100)) + N'月'
	)
	as 年月表示
,	convert(int,floor(a6.年月 % 100)) as 月
,
	substring(
		convert(varchar(4),
			1000 + convert(int,floor(a6.年月 % 100))
		)
		,3,2
	)
	as 月表示
,	b6.会社コード
,	b6.順序コード
,	b6.本部コード
,	b6.部コード
,	b6.所在地コード
,	b6.部門レベル
,	b6.部門コード
,	b6.部門名
,	a6.設置部門コード
,	a6.設置部門名
,	a6.作業コード
,	a6.作業名
,	isnull(a6.[管理№],0) as [管理№]
,	isnull(a6.件数,0) as 件数
from
	v5 as a6
left join
	(
	select distinct
		a4.年度
	,	a4.会社コード
	,	a4.順序コード
	,	a4.本部コード
	,	a4.部コード
	,	a4.所在地コード
	,	a4.部門レベル
	,	a4.部門コード
	,	a4.部門名略称 as 部門名
	from
		部門_Q異動履歴_全階層順 as a4
	where
		( isnull(a4.集計先,0) <> 0 )
	)
	as b6
	on b6.年度 = a6.年度
	and b6.部門コード = a6.集計部門コード
where
	( isnull(b6.部門名,N'') <> N'' )
)

select
	*
from
	v6 as v600
