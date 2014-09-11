with

v0 as
(
select
	a0.会社コード
,	a0.年度
,	b0.資格コード
,	b0.資格名
,	b0.順位
,	a0.部門コード

from
	部門_T年度 as a0
cross join
	資格_T as b0

where
	( isnull(a0.登録区分,-1) < 1 )
)
,

v2 as
(
select
	a1.会社コード
,	a1.年度
,	a1.資格コード
,	b1.部門コード
,	count(a1.社員コード) as 人数

from
	技術者_Q資格順位 as a1
left outer join
	社員_T年度 as b1
	on b1.会社コード = a1.会社コード
	and b1.年度 = a1.年度
	and b1.社員コード = a1.社員コード

where
	( isnull(a1.[№],'') <> '' )

group by
	a1.会社コード
,	a1.年度
,	a1.資格コード
,	b1.部門コード
)
,

v3 as
(
select
	a3.会社コード
,	a3.年度
,	a3.資格コード
,	a3.資格名
,	a3.順位
,	a3.部門コード
,	isnull(b3.人数,0) as 実人数
,	isnull(c3.人数,0) as 総人数

from
	v0 as a3
left outer join
	v2 as b3
	on b3.会社コード = a3.会社コード
	and b3.年度 = a3.年度
	and b3.資格コード = a3.資格コード
	and b3.部門コード = a3.部門コード
left outer join
	v2 as c3
	on c3.会社コード = a3.会社コード
	and c3.年度 = a3.年度
	and c3.資格コード = a3.資格コード
	and c3.部門コード = a3.部門コード
)

select
	*

from
	v3 as a4

