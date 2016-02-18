WITH

V0 AS
(
SELECT
    プロジェクト名
,	タスク番号 AS 親タスク番号
,	タスク名 AS 親タスク名
FROM
    UserManageDB.dbo.タスク_T AS A0
WHERE
    ( ISNULL(親タスク番号, 0) = 0 )
GROUP BY
    プロジェクト名
,	タスク番号
,	タスク名
)
,

v1 AS
(
SELECT
    A1.プロジェクト名
,	A1.親タスク番号
,	A1.親タスク名
,	B1.タスク番号
,	B1.タスク名
,	C1.開始日付 AS 予定開始日付
,	C1.終了日付 AS 予定終了日付
,	D1.開始日付 AS 実績開始日付
,	D1.終了日付 AS 実績終了日付
FROM
    V0 AS A1
LEFT OUTER JOIN
    UserManageDB.dbo.タスク_T AS B1
	ON B1.プロジェクト名 = A1.プロジェクト名
	AND B1.親タスク番号 = A1.親タスク番号
LEFT OUTER JOIN
    UserManageDB.dbo.タスク_T予定 AS C1
	ON C1.プロジェクト名 = B1.プロジェクト名
	AND C1.タスク番号 = B1.タスク番号
LEFT OUTER JOIN
    UserManageDB.dbo.タスク_T実績 AS D1
	ON D1.プロジェクト名 = B1.プロジェクト名
	AND D1.タスク番号 = B1.タスク番号
)

SELECT
    *
FROM
    V1 AS V100
