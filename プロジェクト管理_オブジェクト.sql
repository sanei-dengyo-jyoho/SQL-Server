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
,	C0.オブジェクト番号
,	C0.オブジェクト名
,	D0.レポート番号
,	D0.レポート名
,	C0.新規区分
,
	CASE
		WHEN ISNULL(C0.新規区分,0) = 0
		THEN N'機能追加'
		ELSE N'新規'
	END
	AS 作成内容
,
	REPLACE(
    	REPLACE(
        	REPLACE(
                	(
                	SELECT TOP 100 PERCENT
                		N'@' +
                        N'' + N'+' +
                        X0.概要
                        AS [data()]
                	FROM
                		UserManageDB.dbo.プロジェクト管理_Tオブジェクト名_概要 as X0
                	WHERE
                		( X0.年度 = C0.年度 )
                		AND ( X0.プロジェクト番号 = C0.プロジェクト番号 )
                		AND ( X0.タスク番号 = C0.タスク番号 )
                		AND ( X0.オブジェクト番号 = C0.オブジェクト番号 )
                	ORDER BY
                		X0.[№]
                	FOR XML PATH ('')
                	)
        	        , N' ', CHAR(13)+CHAR(10)
                    )
    	        , N'+', N''
                )
	        , N'@', N''
            )
    AS 概要
,
	REPLACE(
    	REPLACE(
        	REPLACE(
                	(
                	SELECT TOP 100 PERCENT
                		N'@' +
                        CONVERT(nvarchar(3),Y0.[№]) + N'.' + N'+' +
                        Y0.機能
                        AS [data()]
                	FROM
                		UserManageDB.dbo.プロジェクト管理_Tオブジェクト名_機能 as Y0
                	WHERE
                		( Y0.年度 = C0.年度 )
                		AND ( Y0.プロジェクト番号 = C0.プロジェクト番号 )
                		AND ( Y0.タスク番号 = C0.タスク番号 )
                		AND ( Y0.オブジェクト番号 = C0.オブジェクト番号 )
                	ORDER BY
                		Y0.[№]
                	FOR XML PATH ('')
                	)
        	        , N' ', CHAR(13)+CHAR(10)
                    )
    	        , N'+', N' '
                )
	        , N'@', N'　'
            )
    AS 機能
FROM
    UserManageDB.dbo.プロジェクト管理_T AS A0
LEFT OUTER JOIN
    UserManageDB.dbo.プロジェクト管理_Tタスク AS B0
    ON B0.年度 = A0.年度
    AND B0.プロジェクト番号 = A0.プロジェクト番号
LEFT OUTER JOIN
    UserManageDB.dbo.プロジェクト管理_Tオブジェクト名 AS C0
    ON C0.年度 = B0.年度
    AND C0.プロジェクト番号 = B0.プロジェクト番号
    AND C0.タスク番号 = B0.タスク番号
LEFT OUTER JOIN
    UserManageDB.dbo.プロジェクト管理_Tレポート名 AS D0
    ON D0.年度 = C0.年度
    AND D0.プロジェクト番号 = C0.プロジェクト番号
    AND D0.タスク番号 = C0.タスク番号
    AND D0.オブジェクト番号 = C0.オブジェクト番号
WHERE
	( C0.プロジェクト番号 IS NOT NULL )
)
,

V1 AS
(
SELECT
    *
,
    CASE
        WHEN ISNULL(概要,N'') <> N'' AND ISNULL(機能,N'') <> N''
        THEN 概要 + CHAR(13)+CHAR(10) + 機能
        WHEN ISNULL(概要,N'') <> N'' AND ISNULL(機能,N'') = N''
        THEN 概要
        WHEN ISNULL(概要,N'') = N'' AND ISNULL(機能,N'') <> N''
        THEN 機能
        ELSE NULL
    END
    AS 機能概要
FROM
    V0 AS A1
)

SELECT
    *
FROM
    V1 AS V100
