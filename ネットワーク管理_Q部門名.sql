with

s0 as
(
select distinct
	会社コード
,	順序コード
,	本部コード
,	部コード
,	課コード
,	所在地コード
,	部門レベル
,	部門コード
,	部門名略称 as 部門名

from
	部門_Q階層順_簡易版 as s00

where
	( isnull(集計先,0) <> 0 )
)
,

s1 as
(
select
	会社コード
,	順序コード
,	本部コード
,	部コード
,	課コード
,	所在地コード
,	-999 as 部門レベル
,	0 as 部門コード
,	'（全て）' as 部門名

from
	ネットワーク管理_Q事業所名 as s10
)
,

v0 as
(
select
	*

from
	s0 as a0

union all

select
	*

from
	s1 as a1
)

select
	*
from
	v0 as v000

