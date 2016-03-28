with

v0 as
(
select
	N'工種区分' as レコード名
,	工種区分
,
	convert(nvarchar(100),
		dbo.SqlStrConv(工種区分,4)
	)
	as 工種区分表示
,	工種区分名
,
	convert(nvarchar(100),
		dbo.SqlStrConv(工種区分,4) +
		dbo.SqlStrConv(N'=',4) +
		工種区分名
	)
	as 工種区分名表示
,	備品区分
from
	工種区分_T as a0
)

select
	*
from
	v0 as v000
