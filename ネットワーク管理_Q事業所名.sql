with

v0 as
(
select
	会社コード
,	順序コード
,	本部コード
,	部コード
,	課コード
,	所在地コード
,	部門レベル
,	部門コード
,	場所名 as 事業所名

from
	ネットワーク管理_Q部門ドメイン名 as a0

group by
	会社コード
,	順序コード
,	本部コード
,	部コード
,	課コード
,	所在地コード
,	部門レベル
,	部門コード
,	場所名
)

select
	*

from
	v0 as v000

