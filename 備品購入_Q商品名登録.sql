with

v0 as
(
 select distinct
    a.部門コード
,	a.[行№]
,
	case
		when a.[行№] = 1
		then b.システム名
		else null
	end
	as システム名
,
	case
		when a.[行№] = 1
		then b.資材
		else null
	end
	as 資材
,	a.大分類コード as 検索大分類コード
,	a.中分類コード as 検索中分類コード
,	a.小分類コード as 検索小分類コード
,	a.商品名 as 検索商品名
,
	case
		when a.[行№] = 1
		then b.大分類コード
		else null
	end
	as 大分類コード
,
	case
		when a.[行№] = 1
		then b.中分類コード
		else null
	end
	as 中分類コード
,
	case
		when a.[行№] = 1
		then b.小分類コード
		else null
	end
	as 小分類コード
,
	case
		when a.[行№] = 1
		then b.分類コード
		else null
	end
	as 分類コード
,
	case
		when a.[行№] = 1
		then b.大分類名
		else null
	end
	as 大分類名
,
	case
		when a.[行№] = 1
		then b.中分類名
		else null
	end
	as 中分類名
,
	case
		when a.[行№] = 1
		then b.小分類名
		else null
	end
	as 小分類名
,
	case
		when a.[行№] = 1
		then b.分類名
		else null
	end
	as 分類名
,
	case
		when a.[行№] = 1
		then a.商品名
		else null
	end
	as 商品名
,	null as 商品説明
,	null as 支払先コード
,
	case
		when a.[行№] = 1
		then
			case
				when len(a.大分類コード) = 2
				then isnull(bp.支払先略称,a.メーカー)
				else a.メーカー
			end
		else null
	end
	as 支払先
,	null as 品番
,	null as 型番
,	null as 希望納期
,
	case
		when a.[行№] = 1
		then a.単位
		else null
	end
	as 単位
,
	case
		when a.[行№] = 1
		then isnull(p.単価,a.単価)
		else null
	end
	as 単価
,	null as 数量
,	null as 金額
,	null as 検収日付
,	null as 検収単価
,	null as 検収数量
,	null as 検収金額
,	null as 受入日付
,	null as 受入単価
,	null as 受入数量
,	null as 受入金額
,	null as 購入先名
,	a.登録部門コード
,	a.登録社員コード
,	a.登録区分
,	a.登録日時
FROM
	(
	select
	    za0.部門コード
    ,	zb0.[行№]
	,	za0.大分類コード
	,	za0.中分類コード
	,	za0.小分類コード
	,	za0.商品名
	,	za0.メーカー
	,	za0.単位
	,	za0.単価
	,	za0.登録部門コード
	,	za0.登録社員コード
	,	za0.登録区分
	,	za0.登録日時
    from
        備品_T商品名 as za0
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
	as a
LEFT OUTER JOIN
    備品_Q分類 as b
    on b.大分類コード = a.大分類コード
    and b.中分類コード = a.中分類コード
    and b.小分類コード = a.小分類コード
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
	on bp.支払先名 = a.メーカー
)

select
	*
,
	DENSE_RANK()
	OVER(
		PARTITION BY
			部門コード
		ORDER BY
			受入数量 DESC
		,	[行№]
	)
	as 受入順
from
	v0 as v000
