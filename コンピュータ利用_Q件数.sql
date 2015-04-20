with

v0 as
(
select
	b0.コンピュータ利用コード
,	b0.コンピュータ利用名
,	count(a0.[コンピュータ管理№]) as 件数

from
	コンピュータ利用コード_T as b0
LEFT OUTER JOIN
	コンピュータ利用_T as a0
	on a0.コンピュータ利用コード = b0.コンピュータ利用コード

group by
	b0.コンピュータ利用コード
,	b0.コンピュータ利用名
)

select
	*

from
	v0 as a1

