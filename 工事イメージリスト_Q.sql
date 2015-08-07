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
SELECT TOP 1
    N'発注先' AS 名称
,   8001 AS 番号
UNION ALL
SELECT TOP 1
    N'工事件名' AS 名称
,   8002 AS 番号
UNION ALL
SELECT TOP 1
    N'approval' AS 名称
,   9001 AS 番号
UNION ALL
SELECT TOP 1
    N'purse' AS 名称
,   9002 AS 番号
UNION ALL
SELECT TOP 1
    N'coins_add' AS 名称
,   9003 AS 番号
UNION ALL
SELECT TOP 1
    N'bill_add' AS 名称
,   9004 AS 番号
UNION ALL
SELECT TOP 1
    N'receive_cash' AS 名称
,   9005 AS 番号
)

SELECT
    *
FROM
    V0 AS V000
