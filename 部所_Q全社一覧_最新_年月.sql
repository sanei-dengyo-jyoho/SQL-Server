with

v0 as
(
select
	a0.年度
,	a0.年
,	a0.月
,	a0.年 * 100 + a0.月 as 年月
,	a0.部所グループコード
,	a0.部所コード
,	a0.部所グループ名
,	a0.部所名
,	isnull(a0.赤,255) as 赤
,	isnull(a0.緑,255) as 緑
,	isnull(a0.青,255) as 青
,	isnull(b0.人員,isnull(a0.人数,0)) as 人数
from
	部所_Q全社一覧_最新 as a0
left join
	無災害記録_T as b0
	on b0.年度 = a0.年度
	and b0.年 = a0.年
	and b0.月 = a0.月
	and b0.部所グループコード = a0.部所グループコード
	and b0.部所コード = a0.部所コード
)

select
	*
from
	v0 as a1
