with

v0 as
(
select
	v00.新部門コード
,	v00.日付
,	v00.年度
,	v00.会社コード
,	v00.部門レベル
,	v00.部門コード
,	v00.上位コード
,	v00.所在地コード
,	v00.集計部門コード
,	v00.部門名
,	v00.部門名カナ
,	v00.部門名略称
,	v00.部門名省略
,	v00.集計先
from
	部門_T異動 as v00
inner join
	(
	select
		max(s1.日付) as 日付
	,	s1.部門コード
	from
		部門_T異動 as s1
	group by
		s1.部門コード
	)
	as v10
	on v10.日付 = v00.日付
	and v10.部門コード = v00.部門コード
)

select
	*
from
	v0 as v000
