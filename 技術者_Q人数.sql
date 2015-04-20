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

v1 as
(
select
	a1.会社コード
,	a1.年度
,	a1.資格コード1 as 資格コード
,	b1.部門コード
,	count(a1.社員コード) as 人数

from
	技術職員名簿_T明細 as a1
LEFT OUTER JOIN
	社員_T年度 as b1
	on b1.会社コード = a1.会社コード
	and b1.年度 = a1.年度
	and b1.社員コード = a1.社員コード

where
	( isnull(a1.[№],'') <> '' )
	and ( isnull(a1.枝番,0) = 1 )

group by
	a1.会社コード
,	a1.年度
,	a1.資格コード1
,	b1.部門コード
)
,

v2 as
(
select
	a2.会社コード
,	a2.年度
,	a2.資格コード
,	b2.部門コード
,	count(a2.社員コード) as 人数

from
	技術職員名簿_T資格 as a2
LEFT OUTER JOIN
	社員_T年度 as b2
	on b2.会社コード = a2.会社コード
	and b2.年度 = a2.年度
	and b2.社員コード = a2.社員コード

where
	( isnull(a2.[№],'') <> '' )

group by
	a2.会社コード
,	a2.年度
,	a2.資格コード
,	b2.部門コード
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
LEFT OUTER JOIN
	v1 as b3
	on b3.会社コード = a3.会社コード
	and b3.年度 = a3.年度
	and b3.資格コード = a3.資格コード
	and b3.部門コード = a3.部門コード
LEFT OUTER JOIN
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

