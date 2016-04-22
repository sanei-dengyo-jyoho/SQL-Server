WITH

v0 as
(
select distinct
    convert(nvarchar(100),
        b.年号 + convert(varchar(4),b.和暦年) + N'年度'
    )
    as 年集計
,   convert(int,b.年度) as 年
,   a.[№] as 番号
,
    case
        isnull(a.[№],'')
        when ''
        then 0
        else 1
    end
    as 値
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
    as b
LEFT OUTER JOIN
    車両台数_T明細 as a
    on a.年度 = b.年度
)

SELECT
    *
FROM
    v0 as v000
