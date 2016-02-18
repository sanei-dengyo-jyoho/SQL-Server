with

v0 as
(
select
	a0.ユーザ名
,	a0.社員コード
,	b0.氏名
,	b0.氏
,	b0.名
,	b0.カナ氏名
,	b0.カナ氏
,	b0.カナ名
,	b0.部門名
,	b0.部門名カナ
,	b0.部門名略称
,	b0.部門名省略
,	b0.職制名
,	b0.職制名略称
from
	ユーザ_T as a0
inner join
	社員_Q as b0
	on b0.社員コード = a0.社員コード
)

select
	*
from
	v0 as v000
