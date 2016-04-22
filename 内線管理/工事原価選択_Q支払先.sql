WITH

v1 AS
(
SELECT
    a1.システム名
,	a1.大分類
,	a1.支払先
,	a1.支払先カナ
FROM
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
    AS a1
group by
    a1.システム名
,	a1.大分類
,	a1.支払先
,	a1.支払先カナ
)

SELECT
    *
FROM
    v1 AS v100
