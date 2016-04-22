with

z0 as
(
select
	za0.工事年度
,	za0.工事種別
,	za0.工事項番
,	za0.受注金額
,	za0.消費税率
,	za0.消費税額
,	null as 振替先部門コード
from
    工事台帳_T AS za0
where
    ( isnull(za0.停止日付,'') = '' )
    and ( isnull(za0.竣工日付,'') <> '' )
)
,

v0 as
(
SELECT
	dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	a0.請求回数
,	a0.完工年度
,	a0.完工年
,	a0.完工月
,	a0.完工年 * 100 + a0.完工月 as 完工年月
,	a0.完工日付
,	a0.受注金額 as 税別受注金額
,	a0.消費税率
,	a0.消費税額
,	a0.受注金額 + a0.消費税額 as 税込受注金額
,	a0.振替先部門コード
FROM
	(
	select
		qa1.工事年度
	,	qa1.工事種別
	,	qa1.工事項番
	,	qa1.請求回数
	,	qw1.年度 as 完工年度
	,	qw1.年 as 完工年
	,	qw1.月 as 完工月
	,	qa1.請求日付 as 完工日付
	,	qa1.請求本体金額 as 受注金額
	,	qa1.請求消費税率 as 消費税率
	,	qa1.請求消費税額 as 消費税額
	,	qa1.振替先部門コード
	from
		(
		select
		    qa0.工事年度
		,	qa0.工事種別
		,	qa0.工事項番
		,	0 as 請求回数
		,	max(qb0.請求日付) as 請求日付
		,	sum(qa0.請求本体金額) as 請求本体金額
		,	max(qa0.請求消費税率) as 請求消費税率
		,	sum(qa0.請求消費税額) as 請求消費税額
		,	null as 振替先部門コード
		from
			(
			select
			    qbx0.工事年度
			,	qbx0.工事種別
			,	qbx0.工事項番
			,	max(qbx0.請求日付) as 請求日付
			from
				請求_T as qbx0
			group by
			    qbx0.工事年度
			,	qbx0.工事種別
			,	qbx0.工事項番
			)
			as qb0
		inner join
			請求_T as qa0
			on qa0.工事年度 = qb0.工事年度
			and qa0.工事種別 = qb0.工事種別
			and qa0.工事項番 = qb0.工事項番
		where
			( isnull(qa0.振替先部門コード,0) = 0 )
		group by
		    qa0.工事年度
		,	qa0.工事種別
		,	qa0.工事項番
		)
		as qa1
	inner join
		z0 as qb1
	    on qb1.工事年度 = qa1.工事年度
	    and qb1.工事種別 = qa1.工事種別
	    and qb1.工事項番 = qa1.工事項番
	left outer join
		カレンダ_Q as qw1
		on qw1.日付 = qa1.請求日付

	union all

	select
		ra1.工事年度
	,	ra1.工事種別
	,	ra1.工事項番
	,	ra1.請求回数
	,	rw1.年度 as 完工年度
	,	rw1.年 as 完工年
	,	rw1.月 as 完工月
	,	ra1.請求日付 as 完工日付
	,	ra1.請求本体金額 as 受注金額
	,	ra1.請求消費税率 as 消費税率
	,	ra1.請求消費税額 as 消費税額
	,	ra1.振替先部門コード
	from
	(
		select
		    ra0.工事年度
		,	ra0.工事種別
		,	ra0.工事項番
		,	max(ra0.請求回数) as 請求回数
		,	max(rb0.請求日付) as 請求日付
		,	sum(ra0.請求本体金額) as 請求本体金額
		,	max(ra0.請求消費税率) as 請求消費税率
		,	sum(ra0.請求消費税額) as 請求消費税額
		,	ra0.振替先部門コード
		from
			(
			select
			    rbx0.工事年度
			,	rbx0.工事種別
			,	rbx0.工事項番
			,	max(rbx0.請求日付) as 請求日付
			from
				請求_T as rbx0
			group by
			    rbx0.工事年度
			,	rbx0.工事種別
			,	rbx0.工事項番
			)
			as rb0
		inner join
			請求_T as ra0
			on ra0.工事年度 = rb0.工事年度
			and ra0.工事種別 = rb0.工事種別
			and ra0.工事項番 = rb0.工事項番
		where
			( isnull(ra0.振替先部門コード,0) <> 0 )
		group by
		    ra0.工事年度
		,	ra0.工事種別
		,	ra0.工事項番
		,	ra0.振替先部門コード
		)
		as ra1
	inner join
		z0 as rb1
	    on rb1.工事年度 = ra1.工事年度
	    and rb1.工事種別 = ra1.工事種別
	    and rb1.工事項番 = ra1.工事項番
	left outer join
		カレンダ_Q as rw1
		on rw1.日付 = ra1.請求日付
	)
    AS a0
)

select
	*
from
	v0 as v000
