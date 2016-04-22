with

v2 as
(
select
	a0.年度
,	0 as 協力会社コード
,
	convert(nvarchar(4000),
		N'計　' +
		convert(nvarchar(8),count(a0.協力会社コード)) +
		N'社'
	)
	as 協力会社名
,	sum(a0.人数) as 人数
from
	協力会社_T年度 as a0
left join
	協力会社_T備考 as b0
	on b0.協力会社コード = a0.協力会社コード
where
	( isnull(b0.区分1,0) <> 0 )
group by
	a0.年度

union all

select
	a1.年度
,	a1.協力会社コード
,	a1.協力会社名
,	a1.人数
from
	協力会社_T年度 as a1
left join
	協力会社_T備考 as b1
	on b1.協力会社コード = a1.協力会社コード
where
	( isnull(b1.区分1,0) <> 0 )
)

select
	*
from
	v2 as v200
