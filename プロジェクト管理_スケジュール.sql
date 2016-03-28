WITH

VX0 AS
(
SELECT
    年度
,   プロジェクト番号
,	タスク番号
,	サブタスク番号
,	MIN(日付) AS 開始日付
,	MAX(日付) AS 終了日付
FROM
    UserManageDB.dbo.プロジェクト管理_Tサブタスク_予定 AS AX0
GROUP BY
    年度
,   プロジェクト番号
,	タスク番号
,	サブタスク番号
)
,

VY0 AS
(
SELECT
    年度
,   プロジェクト番号
,	タスク番号
,	サブタスク番号
,	MIN(日付) AS 開始日付
,	MAX(日付) AS 終了日付
FROM
    UserManageDB.dbo.プロジェクト管理_Tサブタスク_実績 AS AY0
GROUP BY
    年度
,   プロジェクト番号
,	タスク番号
,	サブタスク番号
)
,

VZ0 AS
(
SELECT
    年度
,   プロジェクト番号
,	タスク番号
,	サブタスク番号
,	MIN(日付) AS 開始日付
,	MAX(日付) AS 終了日付
FROM
    UserManageDB.dbo.プロジェクト管理_Tサブタスク_稼働 AS AZ0
GROUP BY
    年度
,   プロジェクト番号
,	タスク番号
,	サブタスク番号
)
,

V0 AS
(
SELECT
    A0.社員コード
,   A0.年度
,   A0.プロジェクト番号
,   A0.プロジェクト名
,	B0.タスク番号
,	B0.タスク名
,	C0.サブタスク番号
,	C0.サブタスク名
,	X0.開始日付 AS 予定開始日付
,	X0.終了日付 AS 予定終了日付
,	Y0.開始日付 AS 実績開始日付
,	Y0.終了日付 AS 実績終了日付
,	Z0.開始日付 AS 稼働開始日付
,	Z0.終了日付 AS 稼働終了日付
FROM
    UserManageDB.dbo.プロジェクト管理_T AS A0
LEFT OUTER JOIN
    UserManageDB.dbo.プロジェクト管理_Tタスク AS B0
    ON B0.年度 = A0.年度
    AND B0.プロジェクト番号 = A0.プロジェクト番号
LEFT OUTER JOIN
    UserManageDB.dbo.プロジェクト管理_Tサブタスク AS C0
    ON C0.年度 = B0.年度
    AND C0.プロジェクト番号 = B0.プロジェクト番号
    AND C0.タスク番号 = B0.タスク番号
LEFT OUTER JOIN
    VX0 AS X0
    ON X0.年度 = C0.年度
    AND X0.プロジェクト番号 = C0.プロジェクト番号
    AND X0.タスク番号 = C0.タスク番号
    AND X0.サブタスク番号 = C0.サブタスク番号
LEFT OUTER JOIN
    VY0 AS Y0
    ON Y0.年度 = C0.年度
    AND Y0.プロジェクト番号 = C0.プロジェクト番号
    AND Y0.タスク番号 = C0.タスク番号
    AND Y0.サブタスク番号 = C0.サブタスク番号
LEFT OUTER JOIN
    VZ0 AS Z0
    ON Z0.年度 = C0.年度
    AND Z0.プロジェクト番号 = C0.プロジェクト番号
    AND Z0.タスク番号 = C0.タスク番号
    AND Z0.サブタスク番号 = c0.サブタスク番号
)

SELECT
    *
FROM
    V0 AS V000
