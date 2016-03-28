with

v0 as
(
select
	a0.会社コード
,	a0.年度
,	a0.社員コード
,	min(distinct a0.資格コード) as 資格コード
from
	技術職員名簿_T資格 as a0
LEFT OUTER JOIN
	資格_T as b0
	on b0.資格コード = a0.資格コード
group by
	a0.会社コード
,	a0.年度
,	a0.社員コード
,	b0.資格種類
)
,

v1 as
(
select
	a1.会社コード
,	a1.年度
,	b1.所在地コード
,	b1.部門コード
,	b1.県コード
,	a1.資格コード
,	a1.社員コード
,	b1.[№]
from
	v0 as a1
inner join
	技術職員名簿_T資格 as b1
	on b1.会社コード = a1.会社コード
	and b1.年度 = a1.年度
	and b1.社員コード = a1.社員コード
	and b1.資格コード = a1.資格コード
)

select
	*
from
	v1 as a4
