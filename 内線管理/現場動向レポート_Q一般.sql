with

p0 as
(
select
	工事年度
,	工事種別
,	工事項番
,	min(日付) as 開始日付
,	max(日付) as 終了日付
from
	工事進捗管理_Tサブタスク_出来高 as pa0
group by
	工事年度
,	工事種別
,	工事項番
)
,

z0 as
(
select
	za0.工事年度
,	za0.工事種別
,	za0.工事項番
,	zc0.発注先種別名
,	za0.取引先コード
,	zc0.取引先名
,	zc0.取引先略称
,	za0.工事件名
,
	case
		when isnull(zp0.開始日付,'') = ''
		then isnull(za0.着工日付,za0.工期自日付)
		else
			case
				when zp0.開始日付 < isnull(za0.着工日付,za0.工期自日付)
				then zp0.開始日付
				else isnull(za0.着工日付,za0.工期自日付)
			end
	end
	as 開始日付
,
	case
		when isnull(zp0.終了日付,'') = ''
		then isnull(za0.竣工日付,za0.工期至日付)
		else
			case
				when zp0.終了日付 > isnull(za0.竣工日付,za0.工期至日付)
				then zp0.終了日付
				else isnull(za0.竣工日付,za0.工期至日付)
			end
	end
	as 終了日付
,
	case
		when isnull(zp0.開始日付,'') = ''
		then isnull(za0.着工日付,za0.工期自日付)
		else
			case
				when zp0.開始日付 < isnull(za0.着工日付,za0.工期自日付)
				then zp0.開始日付
				else isnull(za0.着工日付,za0.工期自日付)
			end
	end
	as 工期自日付
,
	case
		when isnull(zp0.終了日付,'') = ''
		then isnull(za0.竣工日付,za0.工期至日付)
		else
			case
				when zp0.終了日付 > isnull(za0.竣工日付,za0.工期至日付)
				then zp0.終了日付
				else isnull(za0.竣工日付,za0.工期至日付)
			end
	end
	as 工期至日付
,	za0.受注日付
,	za0.着工日付
,	za0.竣工日付
,   za0.受注金額
,   za0.消費税率
,   za0.消費税額
,	za0.担当会社コード
,	za0.担当部門コード
,	za0.担当社員コード
from
	工事台帳_T as za0
INNER JOIN
    p0 AS zp0
    ON zp0.工事年度 = za0.工事年度
    AND zp0.工事種別 = za0.工事種別
    AND zp0.工事項番 = za0.工事項番
LEFT OUTER JOIN
    発注先_Q AS zc0
    ON zc0.工事種別 = za0.工事種別
    AND zc0.取引先コード = za0.取引先コード
where
	( isnull(za0.停止日付,'') = '' )
	and ( isnull(zc0.発注先種別名,N'') <> N'顧客' )
)
,

cal as
(
select top 100 percent
    年度
,	年
,	月
,	日
,	日付
from
	カレンダ_T as cal0
order by
	日付
)
,

d0 as
(
select distinct
	ct0.工事年度
,	ct0.工事種別
,	ct0.工事項番
,	ct1.年 as 工期年
,	ct1.月 as 工期月
,	ct1.年 * 100 + ct1.月 as 工期年月
,	DATEFROMPARTS(ct1.年,ct1.月,1) as 工期日付
from
	z0 as ct0
/*　開始日から終了日までのレコードを生成　*/
cross apply
	(
	select
        ct2.年
	,	ct2.月
	from
		cal as ct2
	where
		( ct2.日付 between ct0.開始日付 and ct0.終了日付 )
	)
    as ct1
/*　年月でレコードを集計　*/
group by
	ct0.工事年度
,	ct0.工事種別
,	ct0.工事項番
,	ct1.年
,	ct1.月
)
,

v0 as
(
select
   	dbo.FuncMakeConstructNumber(a0.工事年度,a0.工事種別,a0.工事項番) AS 工事番号
,	a0.工事年度
,	a0.工事種別
,	a0.工事項番
,	d0.工事種別名
,	d0.工事種別コード
,	w1.和暦年表示 + N'度' as 和暦工期年度
,	w0.年度 as 工期年度
,	w0.和暦年表示 as 和暦工期年
,	a0.工期年月
,	a0.工期年
,	a0.工期月
,	b0.発注先種別名
,	b0.取引先コード
,   b0.取引先名
,   b0.取引先略称
,   b0.工事件名
,	b0.工期自日付
,	b0.工期至日付
,	w2.和暦日付 as 和暦工期自日付
,	w2.和暦日付略称 as 和暦工期自日付略称
,	w3.和暦日付 as 和暦工期至日付
,	w3.和暦日付略称 as 和暦工期至日付略称
,	year(b0.工期自日付) * 100 + month(b0.工期自日付) as 工期自年月
,	year(b0.工期至日付) * 100 + month(b0.工期至日付) as 工期至年月
,
	case
		when isnull(b0.受注日付,'') = ''
		then null
		else year(b0.受注日付) * 100 + month(b0.受注日付)
	end
	as 受注年月
,	b0.受注日付
,	b0.着工日付
,	b0.竣工日付
,	p0.出来高
,	p0.稼働人員
,	b0.受注金額
,	b0.消費税率
,	b0.消費税額
,	j0.[JV]
,	j0.税別出資比率詳細
,	s0.部門名 AS 担当部門名
,	s0.部門名略称 AS 担当部門名略称
,	isnull(e0.氏,N'') as 担当者
,
	case
	 	when isnull(s0.部門名略称,N'') = N''
		then N''
	 	when isnull(s0.部門名略称,N'') like N'内線%'
		then N''
		else s0.部門名略称 + N'　'
	end
	+ isnull(e0.氏,N'')
	as 担当
,	0 as 顧客
from
	d0 as a0
inner join
	工事進捗出来高_Q月別 as p0
	on p0.工事年度 = a0.工事年度
	and p0.工事種別 = a0.工事種別
	and p0.工事項番 = a0.工事項番
	and p0.工期年月 = a0.工期年月
inner join
	z0 as b0
	on b0.工事年度 = a0.工事年度
	and b0.工事種別 = a0.工事種別
	and b0.工事項番 = a0.工事項番
inner join
    工事種別_T AS d0
    ON d0.工事種別 = a0.工事種別
left outer join
	カレンダ_Q as w0
	on w0.日付 = a0.工期日付
left outer join
	カレンダ_Q as w1
	on w1.日付 = datefromparts(w0.年度,1,1)
left outer join
	カレンダ_Q as w2
	on w2.日付 = b0.工期自日付
left outer join
	カレンダ_Q as w3
	on w3.日付 = b0.工期至日付
left outer join
	工事台帳_Q共同企業体出資比率 as j0
	on j0.工事年度 = a0.工事年度
	and j0.工事種別 = a0.工事種別
	and j0.工事項番 = a0.工事項番
LEFT OUTER JOIN
    部門_T年度 AS s0
    ON s0.年度 = a0.工事年度
    AND s0.会社コード = b0.担当会社コード
    AND s0.部門コード = b0.担当部門コード
LEFT OUTER JOIN
    社員_T年度 AS e0
    ON e0.年度 = a0.工事年度
    AND e0.会社コード = b0.担当会社コード
    AND e0.社員コード = b0.担当社員コード
LEFT OUTER JOIN
    職制_T AS y0
    ON y0.職制区分 = e0.職制区分
    AND y0.職制コード = e0.職制コード
where
	( b0.工期至日付 >= a0.工期日付 )
)

select
	*
from
	v0 as v000
