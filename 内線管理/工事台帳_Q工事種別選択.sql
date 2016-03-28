with

d0 as
(
select
	d1.digit * 1000 + d2.digit * 100 + d3.digit * 10 + d4.digit as 工事年度
from
	digits_T as d1
cross join
    digits_T as d2
cross join
    digits_T as d3
cross join
    digits_T as d4
)
,

v0 as
(
select
	工事年度
,	工事種別
,	工事項番
from
	工事台帳_T as a0
)
,

v1 as
(
select
	a1.工事年度
from
	d0 as a1
where
    (
	a1.工事年度
	between
		(
		select top 1
			cast(year(getdate()) - 20 as int) as 工事年度
		)
	and
		(
		select top 1
			cast(year(getdate()) + 20 as int) as 工事年度
		)
	)
)
,

v2 as
(
select
	b2.システム名
,	a2.工事年度
,	b2.工事種別
,	b2.工事種別コード
,	b2.工事種別名
from
	v1 as a2
cross join
	工事種別_T as b2
)
,

v3 as
(
select
	a3.システム名
,	a3.工事年度
,	a3.工事種別
,	a3.工事種別コード
,	a3.工事種別名
,	convert(nvarchar(6),isnull(count(b3.工事項番),0)) + N'件' as 件数
from
	v2 as a3
left outer join
	v0 as b3
	on ( b3.工事年度 = a3.工事年度 )
	and ( b3.工事種別 = a3.工事種別 )
group by
	a3.システム名
,	a3.工事年度
,	a3.工事種別
,	a3.工事種別コード
,	a3.工事種別名
)

select
	*
from
	v3 as v300
