WITH

V0 AS
(
SELECT
    工事年度
,   工事種別
,   工事項番
,	タスク番号 AS 親タスク番号
,	タスク名 AS 親タスク名
FROM
    工事管理_Tタスク AS A0
WHERE
    ( ISNULL(親タスク番号, 0) = 0 )
GROUP BY
    工事年度
,   工事種別
,   工事項番
,	タスク番号
,	タスク名
)
,

v1 AS
(
SELECT
    A1.工事年度
,   A1.工事種別
,   A1.工事項番
,	A1.親タスク番号
,	A1.親タスク名
,	B1.タスク番号
,	B1.タスク名
,	B1.開始日付
,	B1.終了日付
,	B1.進捗率
FROM
    V0 AS A1
LEFT OUTER JOIN
    工事管理_Tタスク AS B1
	ON B1.工事年度 = A1.工事年度
	AND B1.工事種別 = A1.工事種別
	AND B1.工事項番 = A1.工事項番
	AND B1.親タスク番号 = A1.親タスク番号
)

SELECT
    *
FROM
    V1 AS V100
