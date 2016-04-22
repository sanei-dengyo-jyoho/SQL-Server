WITH

v0 as
(
select distinct
    convert(nvarchar(100),
        b.年号 + convert(varchar(4),b.和暦年) + N'年度'
    )
    as 年集計
,   convert(int,b.年度) as 年
,   a.[管理№] as 番号
,
    case
        isnull(a.[管理№],'')
        when ''
        then 0
        else 1
    end
    as 値
,   convert(int,b.経験年数コード) as 経験年数コード
,   b.経験年数
from
    (
    select
        v10.年度
    ,   v10.年号
    ,   v10.和暦年
    ,   v20.経験年
    ,   v20.経験年数コード
    ,   v20.経験年数
    from
        (
        SELECT
            c.年度
        ,   c.年号
        ,   c.和暦年
        FROM
            (
            SELECT
                max(c0.年度) as 年度
            ,   c0.年号
            ,   c0.和暦年
            FROM
                カレンダ_Q AS c0
            GROUP BY
                c0.年号
            ,   c0.和暦年
            )
            AS c
        INNER JOIN
            (
            select top 1
                min(y0.年度) as 最小年
            ,   max(y0.年度) as 最大年
            from
                車両事故報告_T as y0
            )
            AS y
            ON c.年度 >= y.最小年
            AND c.年度 <= y.最大年
        GROUP BY
            c.年度
        ,   c.年号
        ,   c.和暦年
        )
        as v10
    cross join
        (
        select
            e.経験年数 as 経験年
        ,   e.経験年数割合コード as 経験年数コード
        ,   e.経験年数割合 as 経験年数
        from
            経験年数_Q as e
        )
        as v20
    )
    as b
LEFT OUTER JOIN
    車両事故報告_T as a
    on a.年度 = b.年度
    and a.経験年 = b.経験年
)

SELECT
    *
FROM
    v0 as v000
