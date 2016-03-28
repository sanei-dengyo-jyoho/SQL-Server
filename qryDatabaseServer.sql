WITH

V0 AS
(
SELECT
    A0.ID
,   convert(varchar(100),SERVERPROPERTY('MachineName')) AS ServerName
,   convert(varchar(100),@@SERVICENAME) AS ServerInstance
FROM
    dbo.tblDatabaseServer AS A0
)
,

V1 AS
(
SELECT
    A1.ID
,   isnull(A1.ServerName, B1.ServerName) AS ServerName
,   isnull(A1.ServerInstance, B1.ServerInstance) AS ServerInstance
,   A1.ResourceFolder
FROM
    dbo.tblDatabaseServer AS A1
INNER JOIN
    V0 AS B1
    ON A1.ID = B1.ID
)
,

V2 AS
(
SELECT TOP 1
    A2.ID
,   A2.ServerName
,
    CASE
        WHEN A2.ServerInstance = 'MSSQLSERVER'
        THEN ''
        ELSE A2.ServerInstance
    END
    AS ServerInstance
,   A2.ResourceFolder
FROM
    V1 AS A2
INNER JOIN
    (
    SELECT
        MAX(X2.ID) AS ID
    FROM
        V1 AS X2
    )
    AS B2
    ON A2.ID = B2.ID
)

SELECT
    *
FROM
    V2 AS V200
