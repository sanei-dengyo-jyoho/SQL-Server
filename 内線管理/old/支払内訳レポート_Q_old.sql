with

v0 as
(
select
	c0.年度 as 支払年度
,	c0.年 as 支払年
,	c0.月 as 支払月
,	CASE
		when d0.支払先種別名 = N'資材'
		then N'資材'
		else N'一般'
	END as 支払種別
,	b0.支払先コード
,	b0.支払先名
,	a0.支払金額
from
	支払_T支払先 as a0
left outer join
	支払先_T as b0
	on b0.支払先略称 = a0.支払先
left outer join
	支払先種別_T as d0
	on d0.支払先種別コード = b0.支払先種別コード
left outer join
	カレンダ_T as c0
	on c0.日付 = a0.支払日付
)

select
	*
from
	v0 as v000
