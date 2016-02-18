WITH

X0 AS
(
SELECT
    工事種別名 AS 名称
,   1000+MAX(工事種別コード) AS 番号
FROM
    工事種別_T AS X00
GROUP BY
    工事種別名
)
,

V0 AS
(
SELECT
    A0.名称
,   A0.番号
FROM
    X0 AS A0

UNION ALL

SELECT
    B0.名称
,   B0.番号
FROM
    工事イメージリスト_T AS B0
)

SELECT
    *
FROM
    V0 AS V000
