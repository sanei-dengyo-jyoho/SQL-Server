with

v0 as
(
select distinct
	z.年度
,	z.部門コード
,	z.日付
,	z.年
,	z.月
,	z.年月
,	z.工事年度
,	z.工事種別
,	z.工事項番
,	z.行数
,	z.[伝票№]
,	z.[行№]
,	d.システム名
,	d.資材
,	a.大分類コード
,	a.中分類コード
,	a.小分類コード
,	d.分類コード
,	d.大分類名
,	d.中分類名
,	d.小分類名
,	d.分類名
,	a.商品名
,	a.商品説明
,	a.支払先コード
,
	case
		when len(a.大分類コード) = 2
		then isnull(a.支払先,isnull(ap.支払先略称,isnull(bp.支払先略称,b.メーカー)))
		else a.支払先
	end
	as 支払先
,	a.品番
,	a.型番
,	a.希望納期
,	isnull(a.単位,b.単位) as 単位
,	isnull(a.単価,isnull(p.単価,b.単価)) as 単価
,	a.数量
,	isnull(a.金額,isnull(a.単価,isnull(p.単価,b.単価)) * a.数量) as 金額
,	a.検収日付
,	a.検収単価
,	a.検収数量
,	a.検収金額
,	a.受入日付
,	a.受入単価
,	a.受入数量
,	a.受入金額
,	isnull(a.購入先名,a.支払先) as 購入先名
,	z.登録部門コード
,	z.登録社員コード
,	s.部門名
,	s.部門名略称
,	s.部門名省略
,	e.氏名
,	e.性別
,	e.職制区分
,	e.職制コード
,	j.職制区分名
,	j.職制区分名略称
,	k.職制名
,	k.職制名略称
,	e.係コード
,	r.係名
,	r.係名略称
,	r.係名省略
,	z.登録区分
,	z.登録日時
from
    (
    select
        za0.年度
    ,	za0.部門コード
    ,	za0.日付
    ,	za0.年
    ,	za0.月
    ,	za0.年月
	,	za0.工事年度
	,	za0.工事種別
	,	za0.工事項番
    ,	za0.行数
    ,	za0.[伝票№]
    ,   zb0.[行№]
    ,	za0.登録部門コード
    ,	za0.登録社員コード
    ,	za0.登録区分
    ,	za0.登録日時
    from
        備品購入_T as za0
    cross join
    	(
    	select
    		xa0.seq as [行№]
    	from
    		digits_Q_99 AS xa0
    	where
    		(
	        xa0.seq
			between
				1
	        and
	            (
	            select top 1
	            	xb0.行数
	            from
	                レポート管理条件_T as xb0
	            where
	                ( xb0.レポート名 = N'発注依頼書' )
				order by
					xb0.レポート名
	            )
	        )
    	)
        as zb0
    )
	as z
LEFT OUTER JOIN
	備品購入_T明細 as a
	on a.年度 = z.年度
	and a.部門コード = z.部門コード
	and a.[伝票№] = z.[伝票№]
	and a.[行№] = z.[行№]
LEFT OUTER JOIN
	備品_Q分類 as d
	on d.大分類コード = a.大分類コード
	and d.中分類コード = a.中分類コード
	and d.小分類コード = a.小分類コード
LEFT OUTER JOIN
	備品_T商品名 as b
	on b.大分類コード = a.大分類コード
	and b.中分類コード = a.中分類コード
	and b.小分類コード = a.小分類コード
	and b.商品名 = a.商品名
LEFT OUTER JOIN
	(
	-- 商品レコードの最新単価を取得 --
	select
		za0.部門コード
	,	za0.大分類コード
	,	za0.中分類コード
	,	za0.小分類コード
	,	za0.商品名
	,	min(za0.単価) as 単価
	from
		備品_Q単価 as za0
	inner join
		(
		select
			zaz0.部門コード
		,	zaz0.大分類コード
		,	zaz0.中分類コード
		,	zaz0.小分類コード
		,	zaz0.商品名
		,	max(zaz0.日付) as 日付
		from
			備品_Q単価 as zaz0
		where
			( isnull(zaz0.単価,0) <> 0 )
		group by
			zaz0.部門コード
		,	zaz0.大分類コード
		,	zaz0.中分類コード
		,	zaz0.小分類コード
		,	zaz0.商品名
		)
		as zb0
		on zb0.部門コード = za0.部門コード
		and zb0.大分類コード = za0.大分類コード
		and zb0.中分類コード = za0.中分類コード
		and zb0.小分類コード = za0.小分類コード
		and zb0.商品名 = za0.商品名
		and zb0.日付 = za0.日付
	group by
		za0.部門コード
	,	za0.大分類コード
	,	za0.中分類コード
	,	za0.小分類コード
	,	za0.商品名
	)
	as p
	on p.部門コード = a.部門コード
	and p.大分類コード = a.大分類コード
	and p.中分類コード = a.中分類コード
	and p.小分類コード = a.小分類コード
	and p.商品名 = a.商品名
LEFT OUTER JOIN
	支払先_T as bp
	on bp.支払先名 = b.メーカー
LEFT OUTER JOIN
	支払先_T as ap
	on ap.支払先コード = a.支払先コード
LEFT OUTER JOIN
	部門_T年度 as s
	on s.年度 = z.年度
	and s.部門コード = z.部門コード
LEFT OUTER JOIN
	社員_T年度 as e
	on e.年度 = z.年度
	and e.社員コード = z.登録社員コード
LEFT OUTER JOIN
	職制区分_T as j
	on j.職制区分 = e.職制区分
LEFT OUTER JOIN 職制_T as k
	on k.職制コード = e.職制コード
LEFT OUTER JOIN
	係名_T as r
	on r.係コード = e.係コード
)

select
	*
,
	DENSE_RANK()
	OVER(
		PARTITION BY
			年度
		,	部門コード
		,	[伝票№]
		ORDER BY
			受入数量 DESC
		,	[行№]
	)
	as 受入順
from
	v0 as v000
