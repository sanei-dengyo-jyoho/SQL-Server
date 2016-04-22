with

v0 as
(
 select distinct
	z.[行№]
,	null as 資材
,	null as システム名
,	null as 大分類コード
,	null as 中分類コード
,	null as 小分類コード
,	null as 分類コード
,	null as 大分類名
,	null as 中分類名
,	null as 小分類名
,	null as 分類名
,	null as 商品名
,	null as 商品説明
,	null as 支払先コード
,	null as 支払先
,	null as 品番
,	null as 型番
,	null as 希望納期
,	null as 単位
,	null as 単価
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
,	null as 登録部門コード
,	null as 登録社員コード
,	null as 登録区分
,	null as 登録日時
FROM
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
	as z
)

select
	*
,
	DENSE_RANK()
	OVER(
		ORDER BY
			受入数量 DESC
		,	[行№]
	)
	as 受入順
from
	v0 as v000
