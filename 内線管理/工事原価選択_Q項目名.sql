WITH

v0 AS
(
SELECT
    a0.システム名
,	a0.大分類
,	a0.中分類
,	a0.項目名
FROM
    工事原価項目_T項目名 AS a0
WHERE
    ( a0.大分類 = 10 )
	AND (ISNULL(a0.項目名, N'') <> N'')

UNION ALL

SELECT
    b1.システム名
,	a1.大分類
,	a1.中分類
,	a1.項目名
FROM
    工事原価_T予算 AS a1
LEFT OUTER JOIN
    工事種別_T AS b1
    ON b1.工事種別 = a1.工事種別
WHERE
    ( a1.大分類 = 10 )
	AND (ISNULL(a1.項目名, N'') <> N'')

UNION ALL

SELECT
    b2.システム名
,	a2.大分類
,	a2.中分類
,	a2.項目名
FROM
    工事原価_T決算 AS a2
LEFT OUTER JOIN
    工事種別_T AS b2
    ON b2.工事種別 = a2.工事種別
WHERE
    ( a2.大分類 = 10 )
	AND (ISNULL(a2.項目名, N'') <> N'')

UNION ALL

SELECT
    b3.システム名
,	a3.大分類
,	a3.中分類
,	a3.項目名
FROM
    支払_T項目名 AS a3
LEFT OUTER JOIN
    工事種別_T AS b3
    ON b3.工事種別 = a3.工事種別
WHERE
    ( a3.大分類 = 10 )
	AND (ISNULL(a3.項目名, N'') <> N'')
)
,

v1 AS
(
SELECT
    システム名
,	大分類
,	中分類
,	項目名
,	COUNT(項目名) AS 件数
,	RANK()
    OVER(
        ORDER BY
            count(項目名) DESC
        ) AS 順位
FROM
    v0 AS v1
GROUP BY
	システム名
,	大分類
,	中分類
,	項目名
)

SELECT
    *
FROM
    v1 AS v100
