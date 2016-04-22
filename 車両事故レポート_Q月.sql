with

v0 as
(
select
	convert(nvarchar(100),
		isnull(w.年号,'') + format(isnull(w.年,0),'D2') + N'年度'
	)
	as 年集計
,	convert(int,b.年度) as 年
,
	convert(nvarchar(100),
		convert(varchar(4),b.月) + N'月'
	)
	as 月集計
,	convert(int,b.月) as 月
,	convert(int,b.年月) as 年月
,	a.[管理№] as 番号
,
	case
		isnull(a.[管理№],'')
		when ''
		then 0
		else 1
	end
	as 値
from
	(
	select
		c0.年度
	,	c0.年
	,	c0.月
	,	c0.年 * 100 + c0.月 as 年月
	from
		(
		select
			y00.年度
		from
			車両事故報告_T as y00
		group by
			y00.年度
		)
		as y0
	LEFT OUTER JOIN
		カレンダ_T as c0
		on c0.年度 = y0.年度
	group by
		c0.年度
	,	c0.年
	,	c0.月
	)
	as b
LEFT OUTER JOIN
    車両事故報告_T as a
	on a.年度 = b.年度
	and a.年月 = b.年月
LEFT OUTER JOIN
	和暦_T as w
	on w.西暦 = b.年度
)

SELECT
    *
FROM
    v0 as v000
