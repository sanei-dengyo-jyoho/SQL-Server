WITH

F0 as
(
SELECT TOP 100 PERCENT
    プロジェクト名
,   タスク番号
,   機能名
,
	ROW_NUMBER()
	OVER(
		PARTITION BY
		    プロジェクト名
		,   タスク番号
		ORDER BY
			機能番号
		)
	AS 順番
FROM
    UserManageDB.dbo.タスク_T機能名 AS FA0
)
,

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
,	B1.オブジェクト名
,	B1.新規
,
	CASE
		WHEN ISNULL(B1.新規,0) = 0
		THEN N'機能追加'
		ELSE N'新規'
	END
	AS 作成内容
,	B1.概要
,	R1.レポート番号
,	R1.レポート名
,
	REPLACE(
    	REPLACE(
        	REPLACE(
                	(
                	SELECT TOP 100 PERCENT
                		N'@' +
                        CONVERT(nvarchar(3),X1.順番) + N'.' + N'+' +
                        X1.機能名
                        AS [data()]
                	FROM
                		F0 as X1
                	WHERE
                		( X1.プロジェクト名 = B1.プロジェクト名 )
                		AND ( X1.タスク番号 = B1.タスク番号 )
                	ORDER BY
                		X1.順番
                	FOR XML PATH ('')
                	)
        	        , ' ', CHAR(13)+CHAR(10)
                    )
    	        , N'+', N' '
                )
	        , N'@', N'　'
            )
    AS 機能名
FROM
    V0 AS A1
LEFT OUTER JOIN
    UserManageDB.dbo.タスク_Tオブジェクト名 AS B1
	ON B1.プロジェクト名 = A1.プロジェクト名
	AND B1.親タスク番号 = A1.親タスク番号
LEFT OUTER JOIN
    UserManageDB.dbo.タスク_Tレポート名 AS R1
	ON R1.プロジェクト名 = B1.プロジェクト名
	AND R1.タスク番号 = B1.タスク番号
)
,

V2 AS
(
SELECT
    *
,
    概要 +
    CASE
        WHEN ISNULL(機能名,N'') = N''
        THEN N''
        ELSE CHAR(13)+CHAR(10) + 機能名
    END
    As 機能概要
FROM
    V1 AS V100
)

SELECT
    *
FROM
    V2 AS V200
