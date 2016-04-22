with

-- 各種レコードの最新単価を取得 --
p0 as
(
select
	pa0.部門コード
,	pa0.大分類コード
,	pa0.中分類コード
,	pa0.小分類コード
,	pa0.商品名
,	pa0.日付
,	pa0.単価
from
	備品_T棚卸 as pa0
inner join
	(
	select
		paz0.部門コード
	,	paz0.大分類コード
	,	paz0.中分類コード
	,	paz0.小分類コード
	,	paz0.商品名
	,	max(paz0.日付) as 日付
	from
		備品_T棚卸 as paz0
	where
		( isnull(paz0.単価,0) <> 0 )
	group by
		paz0.部門コード
	,	paz0.大分類コード
	,	paz0.中分類コード
	,	paz0.小分類コード
	,	paz0.商品名
	)
	as pb0
	on pb0.部門コード = pa0.部門コード
	and pb0.大分類コード = pa0.大分類コード
	and pb0.中分類コード = pa0.中分類コード
	and pb0.小分類コード = pa0.小分類コード
	and pb0.商品名 = pa0.商品名
	and pb0.日付 = pa0.日付

union all

select
	pa1.部門コード
,	pa1.大分類コード
,	pa1.中分類コード
,	pa1.小分類コード
,	pa1.商品名
,	pa1.日付
,	pa1.単価
from
	備品_T購入 as pa1
inner join
	(
	select
		paz1.部門コード
	,	paz1.大分類コード
	,	paz1.中分類コード
	,	paz1.小分類コード
	,	paz1.商品名
	,	max(paz1.日付) as 日付
	from
		備品_T購入 as paz1
	where
		( isnull(paz1.単価,0) <> 0 )
	group by
		paz1.部門コード
	,	paz1.大分類コード
	,	paz1.中分類コード
	,	paz1.小分類コード
	,	paz1.商品名
	)
	as pb1
	on pb1.部門コード = pa1.部門コード
	and pb1.大分類コード = pa1.大分類コード
	and pb1.中分類コード = pa1.中分類コード
	and pb1.小分類コード = pa1.小分類コード
	and pb1.商品名 = pa1.商品名
	and pb1.日付 = pa1.日付

union all

select
	pa2.部門コード
,	pa2.大分類コード
,	pa2.中分類コード
,	pa2.小分類コード
,	pa2.商品名
,	pa2.日付
,	pa2.単価
from
	備品_T入出庫 as pa2
inner join
	(
	select
		paz2.部門コード
	,	paz2.大分類コード
	,	paz2.中分類コード
	,	paz2.小分類コード
	,	paz2.商品名
	,	max(paz2.日付) as 日付
	from
		備品_T入出庫 as paz2
	where
		( isnull(paz2.単価,0) <> 0 )
	group by
		paz2.部門コード
	,	paz2.大分類コード
	,	paz2.中分類コード
	,	paz2.小分類コード
	,	paz2.商品名
	)
	as pb2
	on pb2.部門コード = pa2.部門コード
	and pb2.大分類コード = pa2.大分類コード
	and pb2.中分類コード = pa2.中分類コード
	and pb2.小分類コード = pa2.小分類コード
	and pb2.商品名 = pa2.商品名
	and pb2.日付 = pa2.日付
)
,

-- 日付ごとの最新単価を取得 --
v0 as
(
select
	a0.部門コード
,	a0.大分類コード
,	a0.中分類コード
,	a0.小分類コード
,	a0.商品名
,	a0.日付
,	min(a0.単価) as 単価
from
	p0 as a0
inner join
	(
	select
		bz0.部門コード
	,	bz0.大分類コード
	,	bz0.中分類コード
	,	bz0.小分類コード
	,	bz0.商品名
	,	max(bz0.日付) as 日付
	from
		p0 as bz0
	where
		( isnull(bz0.単価,0) <> 0 )
	group by
		bz0.部門コード
	,	bz0.大分類コード
	,	bz0.中分類コード
	,	bz0.小分類コード
	,	bz0.商品名
	)
	as b0
	on b0.部門コード = a0.部門コード
	and b0.大分類コード = a0.大分類コード
	and b0.中分類コード = a0.中分類コード
	and b0.小分類コード = a0.小分類コード
	and b0.商品名 = a0.商品名
	and b0.日付 = a0.日付
group by
	a0.部門コード
,	a0.大分類コード
,	a0.中分類コード
,	a0.小分類コード
,	a0.商品名
,	a0.日付
)

select
	*
from
	v0 as v000
