with

z0 as
(
select
	za0.工事年度
,	za0.工事種別
,	za0.工事項番
,	za0.取引先コード
,	za0.取引先担当
,	za0.工事件名
,	za0.工事場所
,	za0.工期自日付
,	za0.工期至日付
,	za0.受注日付
,	za0.竣工日付
,	za0.受注金額
,	za0.消費税率
,	za0.消費税額
,	za0.担当会社コード
,	za0.担当部門コード
,	za0.担当社員コード
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
,	c0.発注先種別名
,	a0.取引先コード
,	c0.取引先名
,	c0.取引先略称
,	a0.取引先担当
,	a0.工事件名
,	a0.工事場所
,	a0.工期自日付
,	a0.工期至日付
,
	case
		when isnull(a0.受注日付,'') = ''
		then null
		else year(a0.受注日付) * 100 + month(a0.受注日付)
	end
	as 受注年月
,	a0.受注日付
,	a0.竣工日付
,	a0.受注金額 as 税別受注金額
,	a0.消費税率
,	a0.消費税額
,	a0.受注金額 + a0.消費税額 as 税込受注金額
,	a0.担当会社コード
,	a0.担当部門コード
,	s0.部門名 AS 担当部門名
,	s0.部門名略称 AS 担当部門名略称
,	a0.担当社員コード
,	e0.氏名 AS 担当者名
,	a0.振替先部門コード
,	s1.部門名 AS 振替先部門名
,	s1.部門名略称 AS 振替先部門名略称
,
	case
		when isnull(c0.発注先種別名,N'') = N'顧客'
		then -9
		else 0
	end
	as 顧客
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
	,	qb1.取引先コード
	,	qb1.取引先担当
	,	qb1.工事件名
	,	qb1.工事場所
	,	qb1.工期自日付
	,	qb1.工期至日付
	,	qb1.受注日付
	,	qb1.竣工日付
	,	qa1.請求本体金額 as 受注金額
	,	qa1.請求消費税率 as 消費税率
	,	qa1.請求消費税額 as 消費税額
	,	qb1.担当会社コード
	,	qb1.担当部門コード
	,	qb1.担当社員コード
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
	,	rb1.取引先コード
	,	rb1.取引先担当
	,	rb1.工事件名
	,	rb1.工事場所
	,	rb1.工期自日付
	,	rb1.工期至日付
	,	rb1.受注日付
	,	rb1.竣工日付
	,	ra1.請求本体金額 as 受注金額
	,	ra1.請求消費税率 as 消費税率
	,	ra1.請求消費税額 as 消費税額
	,	rb1.担当会社コード
	,	rb1.担当部門コード
	,	rb1.担当社員コード
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
INNER JOIN
    発注先_Q AS c0
    ON c0.工事種別 = a0.工事種別
    AND c0.取引先コード = a0.取引先コード
LEFT OUTER JOIN
    部門_T年度 AS s0
    ON s0.年度 = a0.工事年度
    AND s0.会社コード = a0.担当会社コード
    AND s0.部門コード = a0.担当部門コード
LEFT OUTER JOIN
    社員_T年度 AS e0
    ON e0.年度 = a0.工事年度
    AND e0.会社コード = a0.担当会社コード
    AND e0.社員コード = a0.担当社員コード
LEFT OUTER JOIN
    部門_T年度 AS s1
    ON s1.年度 = a0.工事年度
    AND s1.会社コード = a0.担当会社コード
    AND s1.部門コード = a0.振替先部門コード
)

select
	*
from
	v0 as v000
