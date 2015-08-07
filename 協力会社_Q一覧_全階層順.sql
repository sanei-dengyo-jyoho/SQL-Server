with

v0 as
(
select distinct
	a0.協力会社コード
,	a0.社員コード
from
	協力会社運転許可証_T as a0
inner join
	協力会社社員_T as b0
	on b0.協力会社コード = a0.協力会社コード
	and b0.社員コード = a0.社員コード
where
	( isnull(a0.停止日,'') = '' )
	and ( isnull(b0.退職日,'') = '' )
group by
	a0.協力会社コード
,	a0.社員コード
)
,

v1 as
(
select
	協力会社コード
,	count(社員コード) as 人数
from
	v0 as a1
group by
	協力会社コード
)
,

v2 as
(
select
	協力会社コード
,	count(社員コード) as 人数
from
	協力会社社員_T as a2
where
	( isnull(退職日,'') = '' )
group by
	協力会社コード
)
,

v3 as
(
select top 1
	null as 協力会社コード
,	'（全て）' as 協力会社名
,	'（スベテ）' as 協力会社名カナ
,	null as 安対協
,	(select sum(人数) as 人数
	 from 協力会社_T as v30) as 人数
,	(select sum(人数) as 人数
	 from v2 as v31) as 社員数
,	(select sum(人数) as 人数
	 from v1 as v32) as 運転認定者数
from
	協力会社_T as a3

union all

select
	b3.協力会社コード
,	b3.協力会社名
,	b3.協力会社名カナ
,	isnull(c3.区分1,0) as 安対協
,	isnull(b3.人数,0) as 人数
,	isnull(d3.人数,0) as 社員数
,	isnull(e3.人数,0) as 運転認定者数
from
	協力会社_T as b3
left join
	協力会社_T備考 as c3
	on c3.協力会社コード = b3.協力会社コード
left join
	v2 as d3
	on d3.協力会社コード = b3.協力会社コード
left join
	v1 as e3
	on e3.協力会社コード = b3.協力会社コード
)

select
	*
from
	v3 as a4
