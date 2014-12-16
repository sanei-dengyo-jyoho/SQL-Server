with

v2 as
(
select
    部門コード
,    大分類コード
,    中分類コード
,    小分類コード
,    商品名
,    年度
,    -999 as [№]
,    日付
,    年
,    月
,    年月
,    0 as 入出庫区分
,    単価
,    isnull(数量,0) as 数量

from
    備品_T棚卸 as q20

)
,

v3 as
(
select
    q40.部門コード
,    q40.大分類コード
,    q40.中分類コード
,    q40.小分類コード
,    q40.商品名
,    case when isnull(q40.年度,0) > isnull(q30.年度,0) then q40.年度 else q30.年度 end as 年度
,    q40.[№]
,    q40.日付
,    q40.年
,    q40.月
,    q40.年月
,    q40.入出庫区分
,    q40.単価
,    isnull(q40.数量,0) as 数量

from
    備品_T入出庫 as q40
left outer join
    v2 as q30
    on q40.部門コード = q30.部門コード
    and q40.大分類コード = q30.大分類コード
    and q40.中分類コード = q30.中分類コード
    and q40.小分類コード = q30.小分類コード
    and q40.商品名 = q30.商品名

where
    ( isnull(q40.部門コード,0) <> 0 )
    and ( isnull(q40.大分類コード,'') <> '' )
    and ( isnull(q40.中分類コード,'') <> '' )
    and ( isnull(q40.小分類コード,'') <> '' )
)
,

v4 as
(
select
    *

from
    v2 as v200

union all

select
    *

from
    v3 as v300
)
,

v5 as
(
select
    部門コード
,    大分類コード
,    中分類コード
,    小分類コード
,    商品名
,    年度
,    [№]
,    max([明細№]) as [明細№]

from
    備品_T入出庫明細 as q5

group by
    部門コード
,    大分類コード
,    中分類コード
,    小分類コード
,    商品名
,    年度
,    [№]
)
,

v6 as
(
select distinct
    a.部門コード
,    a.大分類コード
,    a.中分類コード
,    a.小分類コード
,    b.分類コード
,    b.分類名
,    a.商品名
,    a.年度
,    a.[№]
,    a.日付
,    a.年
,    a.月
,    a.年月
,    a.入出庫区分
,    c.入出庫名
,    c.入出庫説明
,    a.単価
,    a.数量
,    isnull(a.単価,0) * isnull(a.数量,0) as 金額
,    isnull(d.[明細№],0) as [明細№]
,    replace(
            replace(
                    replace(
                            (
                            select
                                replace(replace(isnull(dx.相手先部門名,isnull(dx.購入先名,'')), ' ', '@'), N'　', N'＠')+'='+convert(varchar(8),isnull(dx.数量,0)) as [data()]
                            from
                                備品_Q入出庫履歴 as dx
                            where
                                ( dx.部門コード = a.部門コード )
                                and ( dx.大分類コード = a.大分類コード )
                                and ( dx.中分類コード = a.中分類コード )
                                and ( dx.小分類コード = a.小分類コード )
                                and ( dx.商品名 = a.商品名 )
                                and ( dx.年度 = a.年度 )
                                and ( dx.[№] = a.[№] )
                            order by
                                dx.相手先会社コード
                            ,    dx.相手先順序コード
                            ,    dx.相手先本部コード
                            ,    dx.相手先部コード
                            ,    dx.相手先課コード
                            ,    dx.相手先所在地コード
                            ,    dx.相手先部門レベル
                            ,    dx.相手先部門コード
                            for XML PATH ('')
                            )
                            , ' ', N'、'+CHAR(13)+CHAR(10))
                    , '@', ' ')
            , N'＠', N'　') as 相手先数量

from
    v4 as a
left outer join
    備品_Q分類 as b
    on b.大分類コード = a.大分類コード
    and b.中分類コード = a.中分類コード
    and b.小分類コード = a.小分類コード
left outer join
    入出庫区分_Q as c
    on c.入出庫区分 = a.入出庫区分
left outer join
    v5 as d
    on d.部門コード = a.部門コード
    and d.大分類コード = a.大分類コード
    and d.中分類コード = a.中分類コード
    and d.小分類コード = a.小分類コード
    and d.商品名 = a.商品名
    and d.年度 = a.年度
    and d.[№] = a.[№]
)

select
    *

from
    v6 as v500

