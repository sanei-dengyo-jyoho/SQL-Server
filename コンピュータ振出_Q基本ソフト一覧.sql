with

v0 as
(
select
	a0.[基本ソフト分類№]
,	a0.基本ソフト分類
,	b0.基本ソフト名
,	c0.[コンピュータ管理№]
,	c0.ネットワーク数
,	isnull(c0.[コンピュータ管理№],'') + '(' + convert(varchar(4),isnull(c0.ネットワーク数,0)) + ')' as [コンピュータ管理№数]
,	1 as CPU
from
	基本ソフト分類_Q as a0
left outer join
	基本ソフト名_T as b0
	on b0.基本ソフト分類 = a0.基本ソフト分類
left outer join
	コンピュータ振出_T基本ソフト as c0
	on c0.基本ソフト分類 = a0.基本ソフト分類
	and c0.基本ソフト名 = b0.基本ソフト名
where
	( isnull(b0.登録区分,-1) <= 0)
)

select
	*
from
	v0 as a1

