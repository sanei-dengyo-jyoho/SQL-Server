WITH

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
    (
    SELECT
        AX0.年度
    ,   AX0.プロジェクト番号
    ,	AX0.タスク番号
    ,	AX0.サブタスク番号
    ,	MIN(AX0.日付) AS 開始日付
    ,	MAX(AX0.日付) AS 終了日付
    FROM
        UserManageDB.dbo.プロジェクト管理_Tサブタスク_予定 AS AX0
    GROUP BY
        AX0.年度
    ,   AX0.プロジェクト番号
    ,	AX0.タスク番号
    ,	AX0.サブタスク番号
    )
    AS X0
    ON X0.年度 = C0.年度
    AND X0.プロジェクト番号 = C0.プロジェクト番号
    AND X0.タスク番号 = C0.タスク番号
    AND X0.サブタスク番号 = C0.サブタスク番号
LEFT OUTER JOIN
    (
    SELECT
        AY0.年度
    ,   AY0.プロジェクト番号
    ,	AY0.タスク番号
    ,	AY0.サブタスク番号
    ,	MIN(AY0.日付) AS 開始日付
    ,	MAX(AY0.日付) AS 終了日付
    FROM
        UserManageDB.dbo.プロジェクト管理_Tサブタスク_実績 AS AY0
    GROUP BY
        AY0.年度
    ,   AY0.プロジェクト番号
    ,	AY0.タスク番号
    ,	AY0.サブタスク番号
    )
    AS Y0
    ON Y0.年度 = C0.年度
    AND Y0.プロジェクト番号 = C0.プロジェクト番号
    AND Y0.タスク番号 = C0.タスク番号
    AND Y0.サブタスク番号 = C0.サブタスク番号
LEFT OUTER JOIN
    (
    SELECT
        AZ0.年度
    ,   AZ0.プロジェクト番号
    ,	AZ0.タスク番号
    ,	AZ0.サブタスク番号
    ,	MIN(AZ0.日付) AS 開始日付
    ,	MAX(AZ0.日付) AS 終了日付
    FROM
        UserManageDB.dbo.プロジェクト管理_Tサブタスク_稼働 AS AZ0
    GROUP BY
        AZ0.年度
    ,   AZ0.プロジェクト番号
    ,	AZ0.タスク番号
    ,	AZ0.サブタスク番号
    )
    AS Z0
    ON Z0.年度 = C0.年度
    AND Z0.プロジェクト番号 = C0.プロジェクト番号
    AND Z0.タスク番号 = C0.タスク番号
    AND Z0.サブタスク番号 = c0.サブタスク番号
)

SELECT
    *
FROM
    V0 AS V000
