with

v2 as
(
select distinct
	a2.年 * 100 + a2.月 as 年月
,	a2.年
,	a2.月
,	a2.過失比率当社
,	a2.年度
,	a2.[管理№]
,	a2.部所グループコード
,	a2.部所コード
,	convert(varchar(10),a2.日付,111) as 日付
,	a2.曜日
,	a2.時刻
,	a2.天候
,	a2.協力会社コード
,	a2.部門コード
,	a2.社員コード
,	a2.災害コード
,	a2.状況詳細
,	a2.部門名
,	a2.協力会社名
,	a2.氏名
,	a2.カナ氏名
,	a2.過失
,	a2.休業名
,	a2.休業
,	b2.日付 as 記録日付
from
	車両事故報告_Q当社過失 as a2
LEFT OUTER JOIN
	(
	select distinct
		a0.年
	,	a0.月
	,	a0.部所グループコード
	,	a0.部所コード
	,	convert(varchar(10),a0.日付,111) as 日付
	from
		事故報告_Q as a0
	where
		( isnull(a0.日付,'') <> '' )
		and ( isnull(a0.部所コード,0) <> 0 )
		and ( isnull(a0.災害警告コード,0) = 9 )
	)
	as b2
	on b2.日付 = a2.日付
	and b2.部所コード = a2.部所コード
where
	( isnull(a2.日付,'') <> '' )
	and ( isnull(a2.部所コード,0) <> 0 )
)

select
	*
from
	v2 as v200
