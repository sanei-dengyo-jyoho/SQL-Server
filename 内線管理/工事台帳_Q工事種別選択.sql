with

v1 as
(
select
	a1.システム名
,	a1.工事年度
,	a1.工事種別
,	a1.工事種別コード
,	a1.工事種別名
,
	concat(
		convert(nvarchar(6),isnull(count(b1.工事項番),0)),
		N'件'
	)
	as 件数
from
	(
	select
		a0.システム名
	,	b0.工事年度
	,	a0.工事種別
	,	a0.工事種別コード
	,	a0.工事種別名
	from
		工事種別_T as a0
	cross join
		(
		select
			xb0.seq as 工事年度
		from
			digits_Q_9999 as xb0
		where
		    (
			xb0.seq
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
		as b0
	)
	as a1
left outer join
	工事台帳_T as b1
	on ( b1.工事年度 = a1.工事年度 )
	and ( b1.工事種別 = a1.工事種別 )
group by
	a1.システム名
,	a1.工事年度
,	a1.工事種別
,	a1.工事種別コード
,	a1.工事種別名
)

select
	*
from
	v1 as v100
