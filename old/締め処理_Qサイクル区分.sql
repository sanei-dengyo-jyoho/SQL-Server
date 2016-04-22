with

v0 as
(
select
	a0.会社コード
,	b0.システム名
,	c0.サイクル区分
,	d0.年度
,	d0.年
,	d0.月
,	0 as 日
from
	会社_T as a0
cross join
	プロジェクト名_T as b0
cross join
	運用サイクル名_Q as c0
cross join
	年月_Q as d0
where
	( c0.サイクル名 = N'月次' )

union all

select
	a1.会社コード
,	b1.システム名
,	c1.サイクル区分
,	d1.年度
,	d1.年度 as 年
,	0 as 月
,	0 as 日
from
	会社_T as a1
cross join
	プロジェクト名_T as b1
cross join
	運用サイクル名_Q as c1
cross join
	年度_Q as d1
where
	( c1.サイクル名 = N'年次' )
)

select
	*
from
	v0 as a2
