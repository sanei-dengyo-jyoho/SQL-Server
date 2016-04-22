with

v1 as
(
select
	convert(nvarchar(100),
		isnull(w1.年号,'') +
		format(isnull(w1.年,0),'D2') + N'年度'
	)
	as 年度集計
,	convert(int, a1.年度) as 年度
from
	(
	select
		a0.年度
	from
		車両事故報告_T as a0
	group by
		a0.年度
	)
	as a1
LEFT OUTER JOIN
	和暦_T as w1
	on w1.西暦 = a1.年度
)

select
	*
from
	v1 as v100
