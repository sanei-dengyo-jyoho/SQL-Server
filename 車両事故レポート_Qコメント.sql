WITH

v0 as
(
SELECT DISTINCT
    convert(nvarchar(100),
        b.年号 + CONVERT(varchar(4),b.和暦年) + N'年'
    )
    AS 年集計
,   CONVERT(int,b.年) AS 年
,   ISNULL(a.状況,N'') AS 状況
,   ISNULL(a.対策,N'') AS 対策
,   ISNULL(a.考察,N'') AS 考察
FROM
    (
    SELECT
        c.年
    ,   c.年号
    ,   c.和暦年
    FROM
        カレンダ_Q AS c
    INNER JOIN
        (
        SELECT TOP (1)
            MIN(y0.年) AS 最小年
        ,   MAX(y0.年) AS 最大年
        FROM
            車両事故報告_T AS y0
        )
        AS y
        ON c.年 >= y.最小年
        AND c.年 <= y.最大年
    GROUP BY
        c.年
    ,   c.年号
    ,   c.和暦年
    )
    AS b
LEFT JOIN
    交通事故分析_Tコメント AS a
    ON a.年 = b.年
)

SELECT
    *
FROM
    v0 as v000
