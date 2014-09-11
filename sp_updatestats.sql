--データベースのすべての統計を更新する
USE UserDB;
GO
EXEC sp_updatestats; 
