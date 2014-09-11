with

v0 as
(
select top 1
	min(開始日) as 開始日
,	max(終了日) as 終了日

from
	リース契約_T as a00
)
,

v1 as
(
select
	a10.年
,	a10.月
,	convert(varchar(4),a10.年) + '年' + dbo.FuncGetNumberFixed(a10.月,DEFAULT) + '月' as 月表示

from
	年月_Q as a10

where
	( a10.年月 >= (select top 1　datepart(year,b10.開始日)*100+datepart(month,b10.開始日) as 開始年月 from v0 as b10) )
	and ( a10.年月 <= (select top 1　datepart(year,c10.終了日)*100+datepart(month,c10.終了日) as 終了年月 from v0 as c10) )
)

select
	*

from
	v1 as a20

