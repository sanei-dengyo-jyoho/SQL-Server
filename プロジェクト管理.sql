WITH

V1 AS
(
SELECT
    A1.*
,   concat(A1.部門名略称,N'　',A1.氏) AS 氏名表示
FROM
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
    AS A1
)

SELECT
    *
FROM
    V1 AS V100
