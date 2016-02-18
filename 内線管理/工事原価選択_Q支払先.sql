WITH

v0 AS
(
SELECT
    b0.システム名
,	10 AS 大分類
,	a0.支払先略称 AS 支払先
,	a0.支払先略称カナ AS 支払先カナ
FROM
    支払先_T AS a0
CROSS JOIN
    工事種別_T AS b0
WHERE
	( ISNULL(a0.支払先名, N'') <> N'' )
)
,

v1 AS
(
SELECT
    システム名
,	大分類
,	支払先
,	支払先カナ
FROM
    v0 AS a1
group by
    システム名
,	大分類
,	支払先
,	支払先カナ
)

SELECT
    *
FROM
    v1 AS v100
