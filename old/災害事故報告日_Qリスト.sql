with

v0 as
(
SELECT
	a0.部所グループコード
,	a0.部所コード
,	a0.部門コード
,	s0.部門名
,	c0.年度
,	a0.日付
,	a0.災害コード
,	r0.災害名
,	r0.災害警告コード
FROM
    災害事故報告日_Q as a0
INNER JOIN
    災害コード_Q as r0
	ON r0.災害コード = a0.災害コード
INNER JOIN
    カレンダ_T as c0
	ON c0.日付 = a0.日付
LEFT OUTER JOIN
    部門_T年度 as s0
	ON s0.年度 = c0.年度
	AND s0.部門コード = a0.部門コード
)

select
	*
from
	v0 as v000
