WITH

v0 as
(
SELECT DISTINCT
    convert(nvarchar(100),
        b.年号 +
        CONVERT(varchar(4),b.和暦年) + N'年度'
    )
    AS 年集計
,   CONVERT(int,b.年度) AS 年
,
    convert(nvarchar(100),
        CONVERT(nvarchar(4),b.月) + N'月'
    )
    AS 月集計
,   CONVERT(int,b.月) AS 月
,   CONVERT(int,b.年月) AS 年月
,
    convert(nvarchar(100),
        N'Q' +
        datename(quarter,datefromparts(b.年,b.月,1))
    )
    AS 四半期
,   CONVERT(int,b.年度) AS 年度
,   a.[管理№] AS 番号
,
    CASE
        isnull(a.[管理№],'')
        WHEN ''
        THEN 0
        ELSE 1
    END AS 値
,   a.県コード
,   a.県名
,   a.天候コード
,   a.天候
,   a.発生場所コード
,   a.発生場所
,   a.原因
FROM
    (
    SELECT
        c.年度
    ,   c.年号
    ,   c.和暦年
    ,   c.年
    ,   c.月
    ,   c.年 * 100 + c.月 AS 年月
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
        AS d
    INNER JOIN
        カレンダ_Q AS c
        ON c.年度 = d.年度
    INNER JOIN
        (
        SELECT TOP (1)
            MIN(y0.年度) AS 最小年
        ,   MAX(y0.年度) AS 最大年
        FROM
            車両事故報告_T AS y0
        )
        AS v
        ON c.年度 >= v.最小年
        AND c.年度 <= v.最大年
    GROUP BY
        c.年度
    ,   c.年号
    ,   c.和暦年
    ,   c.年
    ,   c.月
    )
    AS b
LEFT OUTER JOIN
    車両事故報告_Q AS a
    ON a.年月 = b.年月
)

SELECT
    *
FROM
    v0 as v000
