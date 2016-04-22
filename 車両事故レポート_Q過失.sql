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
,   convert(int,b.過失割合コード) as 過失割合コード
,   b.過失割合
from
    (
    select
        v10.年度
    ,   v10.年号
    ,   v10.和暦年
    ,   v20.過失コード
    ,   v20.過失割合コード
    ,   v20.過失割合
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
            d.過失コード
        ,   e.過失割合コード
        ,   e.過失割合
        from
            過失コード_Q as d
        inner join
            過失割合コード_Q as e
            on e.過失割合コード = d.過失割合コード
        )
        as v20
    )
    as b
LEFT OUTER JOIN
    車両事故報告_T as a
    on a.年度 = b.年度
    and a.過失比率当社 = b.過失コード
)

SELECT
    *
FROM
    v0 as v000
