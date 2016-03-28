with

x0 as
(
select
	xa0.seq as [行№]
from
	digits_Q_999 AS xa0
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
	    )
    )
)
,

z0 as
(
select
    za0.年度
,	za0.部門コード
,	za0.[伝票№]
,   zb0.[行№]
from
    備品購入_T as za0
cross join
    x0 as zb0
)
,

v0 as
(
select distinct
   	a0.年度
,	a0.部門コード
,	a0.[伝票№]
,   a0.[行№]
,   b0.商品名
,   b0.商品説明
,   b0.支払先コード
,	isnull(b0.支払先,p0.支払先略称) as 支払先
,   b0.品番
,   b0.型番
,   b0.希望納期
,   b0.単位
,   b0.単価
,   b0.数量
,   b0.単価 * b0.数量 as 金額
from
    z0 as a0
left outer join
    備品購入_T明細 as b0
    on b0.年度 = a0.年度
    and b0.部門コード = a0.部門コード
    and b0.[伝票№] = a0.[伝票№]
    and b0.[行№] = a0.[行№]
left outer join
    支払先_T as p0
    on p0.支払先コード = b0.支払先コード
)

select
    *
from
    v0 as v000
