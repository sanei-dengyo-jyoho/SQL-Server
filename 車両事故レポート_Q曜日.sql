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
,   b.日付
,   convert(int,b.曜日コード) as 曜日コード
,   b.曜日
from
    (
    select
        c.年度
    ,   c.年号
    ,   c.和暦年
    ,   c.日付
    ,
        case
            c.曜日
            when 1
            then 7
            else c.曜日 - 1
        end
        as 曜日コード
    ,   c.曜日名 as 曜日
    from
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
        AS d
    inner join
        カレンダ_Q AS c
        on c.年度 = d.年度
    inner join
        (
        select top 1
            min(y0.年度) as 最小年
        ,   max(y0.年度) as 最大年
        from
            車両事故報告_T as y0
        )
        as y
        on c.年度 >= y.最小年
        and c.年度 <= y.最大年
    )
    as b
LEFT OUTER JOIN
    車両事故報告_T as a
    on a.年度 = b.年度
    and a.日付 = b.日付
)

SELECT
    *
FROM
    v0 as v000
