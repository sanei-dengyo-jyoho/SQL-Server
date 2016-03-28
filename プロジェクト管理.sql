WITH

V0 AS
(
SELECT DISTINCT
    A0.社員コード
,   A0.年度
,   A0.プロジェクト番号
,   A0.プロジェクト名
,	B0.氏名
,	B0.氏
,	B0.名
,	B0.部門名
,	B0.部門名略称
FROM
    UserManageDB.dbo.プロジェクト管理_T AS A0
INNER JOIN
	ユーザ AS B0
	ON B0.社員コード = A0.社員コード
)
,

V1 AS
(
SELECT
    *
,	部門名略称 + N'　' + 氏 AS 氏名表示
FROM
    V0 AS A1
)

SELECT
    *
FROM
    V1 AS V100
