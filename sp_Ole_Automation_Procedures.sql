EXEC sp_configure 'Ole Automation Procedures';
GO

--アドバンスドオプションを表示
sp_configure 'show advanced options', 1;
GO

RECONFIGURE;
GO

--Ole Automation を有効
sp_configure 'Ole Automation Procedures', 1;
GO

RECONFIGURE;
GO

EXEC sp_configure 'Ole Automation Procedures';
GO