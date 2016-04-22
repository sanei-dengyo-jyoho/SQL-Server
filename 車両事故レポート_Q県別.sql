WITH

v0 as
(
select
    p00.年集計
,   p00.年
,   p00.県コード
,   p00.県名
,   sum(p00.値) as 件数
from
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
    ,   convert(int,b.県コード) as 県コード
    ,   b.県名
    from
        (
        select
            v10.年度
        ,   v10.年号
        ,   v10.和暦年
        ,   v20.県コード
        ,   v20.県名
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
                e.県コード
            ,   e.県名
            from
                県_Q as e
            )
            as v20
        )
        as b
    LEFT OUTER JOIN
        (
        select
            isnull(v40.県コード,isnull(v90.県コード,0)) as 県コード
        ,   v40.年度
        ,   v40.[管理№]
        from
            車両事故報告_T as v40
        LEFT OUTER JOIN
            部門_T年度 as v80
            on v80.年度 = v40.年度
            and v80.部門コード = v40.部門コード
        LEFT OUTER JOIN
            会社住所_T as v90
            on v90.会社コード = v80.会社コード
            and v90.所在地コード = v80.所在地コード
        )
        as a
        on a.年度 = b.年度
        and a.県コード = b.県コード
    )
    as p00
group by
    p00.年集計
,   p00.年
,   p00.県コード
,   p00.県名
)

SELECT
    *
FROM
    v0 as v000
