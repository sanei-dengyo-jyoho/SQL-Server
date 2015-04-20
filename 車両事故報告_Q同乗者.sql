with

v0 as
(
select
	a1.年度
,	a1.[管理№]
,	a1.[№]
,	b1.部門コード
,	ISNULL(c1.部門名,a1.部門名) as 部門名
,	a1.社員コード
,	ISNULL(b1.氏名,a1.運転者名) as 氏名
,	b1.職制区分
,	b1.職制コード
,	d1.職制名
,	d1.職制名略称
,	b1.係コード
,	e1.係名
,	e1.係名省略
,	b1.性別

from
	車両事故報告_T同乗者 as a1
LEFT OUTER JOIN
	社員_T年度 as b1
	on b1.年度 = a1.年度
	and b1.社員コード = a1.社員コード
LEFT OUTER JOIN
	部門_T年度 as c1
	on c1.年度 = b1.年度
	and c1.部門コード = b1.部門コード
LEFT OUTER JOIN
	職制_T as d1
	on d1.職制区分 = b1.職制区分
	and d1.職制コード = b1.職制コード
LEFT OUTER JOIN
	係名_T as e1
	on e1.係コード = b1.係コード
)

select
	*

from
	v0 as v000
