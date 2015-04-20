with

v0 as
(
select distinct
	z.年度
,	z.部門コード
,	z.[伝票№]
,	z.行数
,	a.[行№]
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
,	a.品番
,	a.型番
,	a.希望納期
,	isnull(a.単位,isnull(b.単位,'')) as 単位
,	isnull(a.単価,c.単価) as 単価
,	a.数量
,	a.金額
,	z.日付
,	z.年
,	z.月
,	z.年月
,	a.検収日付
,	a.検収単価
,	a.検収数量
,	a.検収金額
,	a.受入日付
,	a.受入単価
,	a.受入数量
,	a.受入金額
,	a.購入先名
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
	備品購入_T as z
LEFT OUTER JOIN
	備品購入_T明細 as a
	on a.年度=z.年度
	and a.部門コード=z.部門コード
	and a.[伝票№]=z.[伝票№]
LEFT OUTER JOIN
	備品_Q分類 as d
	on d.大分類コード=a.大分類コード
	and d.中分類コード=a.中分類コード
	and d.小分類コード=a.小分類コード
LEFT OUTER JOIN
	備品_T商品名 as b
	on b.大分類コード=a.大分類コード
	and b.中分類コード=a.中分類コード
	and b.小分類コード=a.小分類コード
	and b.商品名=a.商品名
LEFT OUTER JOIN
	備品_T在庫 as c
	on c.部門コード=a.部門コード
	and c.大分類コード=a.大分類コード
	and c.中分類コード=a.中分類コード
	and c.小分類コード=a.小分類コード
	and c.商品名=b.商品名
LEFT OUTER JOIN
	部門_T年度 as s
	on s.年度=z.年度
	and s.部門コード=z.部門コード
LEFT OUTER JOIN
	社員_T年度 as e
	on e.年度=z.年度
	and e.社員コード=z.登録社員コード
LEFT OUTER JOIN
	職制区分_T as j
	on j.職制区分=e.職制区分
LEFT OUTER JOIN 職制_T as k
	on k.職制コード=e.職制コード
LEFT OUTER JOIN
	係名_T as r
	on r.係コード=e.係コード
)

select
	DENSE_RANK() OVER(PARTITION BY 年度,部門コード,[伝票№] ORDER BY 受入数量 DESC,[行№]) as 受入順
,	*

from
	v0 as v10

