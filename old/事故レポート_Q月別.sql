WITH

z0 as
(
select
    z000.*
from
    災害事故報告_T as z000
where
    ( isnull(z000.労災認定,0) <> 0 )
    and ( z000.[管理№] > 0 )
)
,

z1 as
(
select
    z100.*
from
    車両事故報告_T as z100
where
    ( z100.[管理№] > 0 )
)
,

v2 as
(
select
    convert(int,x.年度) as 年度
,
    convert(nvarchar(100),
        convert(nvarchar(4),x.年度) + N'年度'
    )
    AS 年度表示
,
    convert(nvarchar(100),
        y.年号 + convert(nvarchar(4),y.年) + N'年度'
    )
    AS 和暦年度表示
,
    convert(nvarchar(100),
        convert(nvarchar(4),x.月) + N'月'
    )
    AS 月表示
,   convert(int,x.年) as 年
,   convert(int,x.月) as 月
,   convert(int,x.年月) as 年月
from
    (
    select
        c.年度
    ,   c.年
    ,   c.月
    ,   c.年 * 100 + c.月 as 年月
    from
        カレンダ_T as c
    inner join
        (
        select top 1
            min(t.最小年度) as 最小年度
        ,   max(t.最大年度) as 最大年度
        from
            (
            select top 1
                min(y00.年度) as 最小年度
            ,   max(y00.年度) as 最大年度
            from
                z0 as y00

            union all

            select top 1
                min(y01.年度) as 最小年度
            ,   max(y01.年度) as 最大年度
            from z1 as y01
            ) as t
        )
        as v
        on c.年度 >= v.最小年度
        and c.年度 <= v.最大年度
    group by
        c.年度
    ,   c.年
    ,   c.月
    )
    as x
inner join
    和暦_T as y
    on y.西暦 = x.年度
)
,

v3 as
(
select
    v21.年度
,   v21.年度表示
,   v21.和暦年度表示
,   v21.月表示
,   v21.年
,   v21.月
,   v21.年月
,   convert(int,1) as 事故種別コード
,   convert(int,isnull(v31.[管理№],0)) as 番号
,
    case
        isnull(v31.[管理№],0)
        when 0
        then 0
        else 1
    end
    as 値
from
    v2 as v21
LEFT OUTER JOIN
    z0 as v31
    on v31.年度 = v21.年度
    and v31.年月 = v21.年月

union all

select
    v22.年度
,   v22.年度表示
,   v22.和暦年度表示
,   v22.月表示
,   v22.年
,   v22.月
,   v22.年月
,   convert(int,2) as 事故種別コード
,   convert(int,isnull(v32.[管理№],0)) as 番号
,
    case
        isnull(v32.[管理№],0)
        when 0
        then 0
        else 1
    end
    as 値
from
    v2 as v22
LEFT OUTER JOIN
    z1 as v32
    on v32.年度 = v22.年度
    and v32.年月 = v22.年月
)
,

v30 as
(
select
    a30.年度
,   a30.年度表示
,   a30.和暦年度表示
,   a30.月表示
,   a30.年
,   a30.月
,   a30.年月
,   a30.事故種別コード
,   b30.事故種別
,   a30.番号
,   a30.値
from
    (
    select
        v32.*
    from
        v3 as v32

    union all

    select
        v33.年度
    ,   v33.年度表示
    ,   v33.和暦年度表示
    ,   v33.月表示
    ,   v33.年
    ,   v33.月
    ,   v33.年月
    ,   convert(int,0) as 事故種別コード
    ,   max(v33.番号) as 番号
    ,   sum(v33.値) as 値
    from
        v3 as v33
    group by
        v33.年度
    ,   v33.年度表示
    ,   v33.和暦年度表示
    ,   v33.月表示
    ,   v33.年
    ,   v33.月
    ,   v33.年月
    )
    as a30
LEFT OUTER JOIN
    事故種別_Q as b30
    on b30.事故種別コード = a30.事故種別コード
)

SELECT
    *
FROM
    v30 as v300
