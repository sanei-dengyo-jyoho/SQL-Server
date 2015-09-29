WITH

v0 AS
(
SELECT
    a0.取引先コード
,   a0.取引先名 AS 請求先名
FROM
    発注先_Q AS a0
UNION ALL
SELECT
    b0.取引先コード
,   b0.取引先略称 AS 請求先名
FROM
    発注先_Q AS b0
UNION ALL
SELECT
    c0.取引先コード * -1 AS 取引先コード
,   c0.請求先名
FROM
    請求_T AS c0
)
,

v1 AS
(
SELECT
    MAX(取引先コード) AS 取引先コード
,   請求先名
FROM
    v0 AS a1
GROUP BY
    請求先名
)

SELECT
    *
FROM
    v1 AS v100
