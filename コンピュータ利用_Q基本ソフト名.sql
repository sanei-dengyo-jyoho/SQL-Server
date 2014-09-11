with

v0 as
(
select
	a0.コンピュータ利用コード
,	b0.基本ソフト分類
,	b0.基本ソフト名
,	isnull(b0.登録区分,-1) as 登録区分

from
	コンピュータ利用コード_T as a0
cross join
	基本ソフト名_T as b0
)
,

v1 as
(
select
	a1.コンピュータ利用コード
,	b1.基本ソフト分類
,	b1.基本ソフト名
,	count(b1.基本ソフト名) as 件数

from
	コンピュータ利用_T as a1
left outer join
	コンピュータ振出_T基本ソフト as b1
	on b1.[コンピュータ管理№] = a1.[コンピュータ管理№]
	and b1.ネットワーク数 = a1.ネットワーク数

group by
	a1.コンピュータ利用コード
,	b1.基本ソフト分類
,	b1.基本ソフト名
)
,

v2 as
(
select
	コンピュータ利用コード
,	基本ソフト分類
,	基本ソフト名

from
	v0 as a1

union all

select
	コンピュータ利用コード
,	基本ソフト分類
,	基本ソフト名

from
	v1 as b2
)
,

v3 as
(
select
	a3.コンピュータ利用コード
,	a3.基本ソフト分類
,	a3.基本ソフト名
,	isnull(b3.登録区分,-1) as 登録区分
,	isnull(c3.件数,0) as 件数

from
	v2 as a3
left outer join
	v0 as b3
	on b3.コンピュータ利用コード = a3.コンピュータ利用コード
	and b3.基本ソフト分類 = a3.基本ソフト分類
	and b3.基本ソフト名 = a3.基本ソフト名
left outer join
	v1 as c3
	on c3.コンピュータ利用コード = a3.コンピュータ利用コード
	and c3.基本ソフト分類 = a3.基本ソフト分類
	and c3.基本ソフト名 = a3.基本ソフト名

where
	( isnull(a3.基本ソフト分類,'') <> '' )
	and ( isnull(a3.基本ソフト名,'') <> '' )
)

select
	*

from
	v3 as a4

