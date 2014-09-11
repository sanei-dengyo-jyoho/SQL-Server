with

v0 as
(
select
	a0.基本ソフト分類
,	a0.基本ソフト名
,	b0.[基本ソフト分類№]
,	convert(int,ROW_NUMBER() OVER (PARTITION BY a0.基本ソフト分類 ORDER BY a0.基本ソフト名 DESC)) as 基本ソフト名降順
from
	基本ソフト名_T as a0
inner join
	基本ソフト分類_Q as b0
	on b0.基本ソフト分類 = a0.基本ソフト分類
)

select
	*
from
	v0 as a1

