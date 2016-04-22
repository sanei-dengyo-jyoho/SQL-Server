with

v0 as
(
SELECT
	a0.協力会社コード
,	s0.協力会社名
,	c0.年度
,	s0.人数
,	z0.区分1
,	a0.日付
,	a0.部門コード
,	h0.部所グループコード
,	h0.部所コード
,	h0.部所名
,	a0.災害コード
,	r0.災害名
,	r0.災害警告コード
FROM
    車両事故報告日_Q協力会社 as a0
INNER JOIN
    災害コード_Q as r0
	ON r0.災害コード = a0.災害コード
INNER JOIN
    カレンダ_T as c0
	ON c0.日付 = a0.日付
LEFT OUTER JOIN
    協力会社_T年度 as s0
	ON s0.年度 = c0.年度
	AND s0.協力会社コード = a0.協力会社コード
LEFT OUTER JOIN
	協力会社_T備考 AS z0
	ON z0.協力会社コード = a0.協力会社コード
LEFT OUTER JOIN
    部所部門_T年度 as g0
	ON g0.年度 = c0.年度
	AND g0.部門コード = a0.部門コード
LEFT OUTER JOIN
    部所_T年度 as h0
	ON h0.年度 = c0.年度
	AND h0.部所グループコード = g0.部所グループコード
	AND h0.部所コード = g0.部所コード
)

select
	*
from
	v0 as v000
