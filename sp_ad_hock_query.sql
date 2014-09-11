--アドバンスドオプションを表示
EXEC sp_configure 'show advanced options', 1;
GO

RECONFIGURE;
GO

--アドホッククエリ有効化(OPENROWSETを実行可能にする)
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
GO

RECONFIGURE;
GO
