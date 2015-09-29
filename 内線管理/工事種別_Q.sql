WITH

V0 AS
(
SELECT
    A0.システム名
,   A0.工事種別
,   A0.工事種別名
,   A0.工事種別説明
,   A0.工事種別コード
,   B0.種別コード
,   C0.表示コード
,   C0.種別 
FROM
    工事種別_T AS A0
INNER JOIN
    工事種別_T種別コード AS B0
    ON B0.システム名 = A0.システム名
    AND B0.工事種別 = A0.工事種別
INNER JOIN
    取引先種別_T AS C0
    ON C0.種別コード = B0.種別コード
)

SELECT
    *
FROM
    V0 AS V000
