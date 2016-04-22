with

v0 as
(
select
	a0.*
,	a0.単価 * a0.数量 as 金額
,
	case
		a0.数量
		when 0
		then 9
		else
			case
				when a0.数量 < a0.安全在庫数量
				then 8
				else 0
			end
	end
	as 警告
from
	(
	select
		qa0.部門コード
	,	qa0.大分類コード
	,	qa0.中分類コード
	,	qa0.小分類コード
	,	qb0.大分類名
	,	qb0.中分類名
	,	qb0.小分類名
	,	qb0.分類コード
	,	qb0.分類名
	,	qa0.商品名
	,	qa0.メーカー
	,	qa0.単位
	,	isnull(qp0.単価,qa0.単価) as 単価
	,	isnull(qu0.数量,0) as 数量
	,	isnull(qa0.安全在庫数量,0) as 安全在庫数量
	,	qa0.備考
	from
		備品_T商品名 as qa0
	INNER JOIN
		備品_Q分類 as qb0
		on qb0.大分類コード = qa0.大分類コード
		and qb0.中分類コード = qa0.中分類コード
		and qb0.小分類コード = qa0.小分類コード
	LEFT OUTER JOIN
		備品_T在庫 as qu0
		on qu0.部門コード = qa0.部門コード
		and qu0.大分類コード = qa0.大分類コード
		and qu0.中分類コード = qa0.中分類コード
		and qu0.小分類コード = qa0.小分類コード
		and qu0.商品名 = qa0.商品名
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
		as qp0
		on qp0.部門コード = qa0.部門コード
		and qp0.大分類コード = qa0.大分類コード
		and qp0.中分類コード = qa0.中分類コード
		and qp0.小分類コード = qa0.小分類コード
		and qp0.商品名 = qa0.商品名
	)
	as a0
)

select
	*
from
	v0 as v000
