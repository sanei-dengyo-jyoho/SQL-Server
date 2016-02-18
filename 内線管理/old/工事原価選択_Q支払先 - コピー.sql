WITH

p0 AS
(
SELECT
    b0.システム名
,	10 AS 大分類
,	a0.支払先略称 AS 支払先
FROM
    支払先_T AS a0
CROSS JOIN
    工事種別_T AS b0
WHERE
	(ISNULL(a0.支払先名, N'') <> N'')
)
,

v0 AS
(
SELECT
    b1.システム名
,	a1.大分類
,	a1.支払先1 AS 支払先
FROM
    工事原価_T予算 AS a1
LEFT OUTER JOIN
    工事種別_T AS b1
    ON b1.工事種別 = a1.工事種別
WHERE
    ( a1.大分類 = 10 )
	AND (ISNULL(a1.支払先1, N'') <> N'')

UNION ALL

SELECT
    b2.システム名
,	a2.大分類
,	a2.支払先2 AS 支払先
FROM
    工事原価_T予算 AS a2
LEFT OUTER JOIN
    工事種別_T AS b2
    ON b2.工事種別 = a2.工事種別
WHERE
    ( a2.大分類 = 10 )
	AND (ISNULL(a2.支払先2, N'') <> N'')

UNION ALL

SELECT
    b3.システム名
,	a3.大分類
,	a3.支払先1 AS 支払先
FROM
    工事原価_T決算 AS a3
LEFT OUTER JOIN
    工事種別_T AS b3
    ON b3.工事種別 = a3.工事種別
WHERE
    ( a3.大分類 = 10 )
	AND (ISNULL(a3.支払先1, N'') <> N'')

UNION ALL

SELECT
    b4.システム名
,	a4.大分類
,	a4.支払先2 AS 支払先
FROM
    工事原価_T決算 AS a4
LEFT OUTER JOIN
    工事種別_T AS b4
    ON b4.工事種別 = a4.工事種別
WHERE
    ( a4.大分類 = 10 )
	AND (ISNULL(a4.支払先2, N'') <> N'')
)
,

v1 AS
(
SELECT
    a1.システム名
,	a1.大分類
,	999999 AS 中分類
,	a1.支払先
,	COUNT(b1.支払先) AS 件数
,	RANK()
    OVER(
        ORDER BY
            count(b1.支払先) DESC
        ) AS 順位
FROM
    p0 AS a1
LEFT OUTER JOIN
    v0 AS b1
    ON b1.システム名 = a1.システム名
	AND b1.大分類 = a1.大分類
	AND b1.支払先 = a1.支払先
GROUP BY
	a1.システム名
,	a1.大分類
,	a1.支払先
)

SELECT
    *
FROM
    v1 AS v100
