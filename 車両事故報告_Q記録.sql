with

v0 as
(
select distinct
	年
,	月
,	部所グループコード
,	部所コード
,	convert(varchar(10),日付,111) as 日付
from
	事故報告_Q as a0
where
	( isnull(日付,'') <> '' )
	and ( isnull(部所コード,0) <> 0 )
	and ( isnull(災害警告コード,0) = 9 )
)
,

v1 as
(
select distinct
	年 * 100 + 月 as 年月
,	年
,	月
,	過失比率当社
,	年度
,	[管理№]
,	部所グループコード
,	部所コード
,	convert(varchar(10),日付,111) as 日付
,	曜日
,	時刻
,	天候
,	協力会社コード
,	部門コード
,	社員コード
,	災害コード
,	状況詳細
,	部門名
,	協力会社名
,	氏名
,	カナ氏名
,	過失
,	休業名
,	休業
from
	車両事故報告_Q as a1
where
	( isnull(日付,'') <> '' )
	and ( isnull(部所コード,0) <> 0 )
)
,

v2 as
(
select distinct
	a2.年月
,	a2.年
,	a2.月
,	a2.過失比率当社
,	a2.年度
,	a2.[管理№]
,	a2.部所グループコード
,	a2.部所コード
,	a2.日付
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
	v1 as a2
LEFT OUTER JOIN
	v0 as b2
	on b2.日付 = a2.日付
	and b2.部所コード = a2.部所コード
)

select
	*
from
	v2 as v200

