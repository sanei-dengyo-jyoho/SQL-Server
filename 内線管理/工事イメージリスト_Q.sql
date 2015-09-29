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
    N'工事着工' AS 名称
,   3001 AS 番号

UNION ALL

SELECT TOP 1
    N'工事竣工' AS 名称
,   3002 AS 番号

UNION ALL

SELECT TOP 1
    N'工事停止' AS 名称
,   3003 AS 番号

UNION ALL

SELECT TOP 1
    N'発注先' AS 名称
,   5001 AS 番号

UNION ALL

SELECT TOP 1
    N'工事件名' AS 名称
,   5002 AS 番号

UNION ALL

SELECT TOP 1
    N'現金' AS 名称
,   7001 AS 番号

UNION ALL

SELECT TOP 1
    N'手形' AS 名称
,   7002 AS 番号

UNION ALL

SELECT TOP 1
    N'入金振替' AS 名称
,   7003 AS 番号

UNION ALL

SELECT TOP 1
    N'入金回収' AS 名称
,   7004 AS 番号

UNION ALL

SELECT TOP 1
    N'入金確定' AS 名称
,   7005 AS 番号
)

SELECT
    *
FROM
    V0 AS V000
