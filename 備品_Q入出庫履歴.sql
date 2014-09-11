with

v1 as
(
select distinct
	a1.部門コード
,	a1.大分類コード
,	a1.中分類コード
,	a1.小分類コード
,	b1.分類コード
,	b1.分類名
,	a1.商品名
,	a1.年度
,	a1.[№]
,	a1.[明細№]
,	a1.日付
,	a1.年
,	a1.月
,	a1.年月
,	a1.入出庫区分
,	isnull(c1.入出庫名,'棚卸') as 入出庫名
,	isnull(c1.入出庫説明,'当部署にて棚卸') as 入出庫説明
,	isnull(a1.単価,0) as 単価
,	isnull(a1.数量,0) as 数量
,	isnull(a1.単価,0) * isnull(a1.数量,0) as 金額
,	s1.会社コード as 相手先会社コード
,	s1.順序コード as 相手先順序コード
,	s1.本部コード as 相手先本部コード
,	s1.部コード as 相手先部コード
,	s1.課コード as 相手先課コード
,	s1.所在地コード as 相手先所在地コード
,	s1.部門レベル as 相手先部門レベル
,	a1.相手先部門コード
,	d1.部門名 as 相手先部門名
,	d1.部門名略称 as 相手先部門名略称
,	d1.部門名省略 as 相手先部門名省略
,	d1.集計部門コード as 相手先集計部門コード
,	a1.購入先名

from
	備品_T入出庫明細 as a1
left outer join
	備品_Q分類 as b1
	on b1.大分類コード = a1.大分類コード
	and b1.中分類コード = a1.中分類コード
	and b1.小分類コード = a1.小分類コード
left outer join
	入出庫区分_Q as c1
	on c1.入出庫区分 = a1.入出庫区分
left outer join
	部門_Q異動最新 as d1
	on d1.部門コード = a1.相手先部門コード
left outer join
	部門_Q階層順_簡易版 as s1
	on s1.部門コード = d1.部門コード
)

select
	*

from
	v1 as a2

