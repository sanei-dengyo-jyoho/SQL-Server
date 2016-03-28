SELECT
	CAST(期 AS nvarchar) + N'期' AS 期
,	CAST(年度 AS nvarchar) + N'年度' AS 年度
,	年月表示 AS 年月
,	発注種別
,	ISNULL(顧客,N'一般') AS 顧客
,
	CASE
	WHEN CHARINDEX(N'　',REVERSE(発注先)) = 0
	THEN 発注先
	ELSE
		CASE
		WHEN SUBSTRING(発注先,CHARINDEX(N'　',REVERSE(発注先))-1,1) =  N'都'
		THEN 発注先
		WHEN SUBSTRING(発注先,CHARINDEX(N'　',REVERSE(発注先))-1,1) =  N'道'
		THEN 発注先
		WHEN SUBSTRING(発注先,CHARINDEX(N'　',REVERSE(発注先))-1,1) =  N'府'
		THEN 発注先
		WHEN SUBSTRING(発注先,CHARINDEX(N'　',REVERSE(発注先))-1,1) =  N'県'
		THEN 発注先
		ELSE LEFT(発注先,LEN(発注先)-CHARINDEX(N'　',REVERSE(発注先)))
		END
	END
	AS 発注先
,	工事番号
,	工事件名
,	受注
,	受注日
,	和暦受注日
,	和暦受注日略称
,	受注金額
,	消費税率
,	消費税額
,	完工
,	完工日
,	和暦完工日
,	和暦完工日略称
,	完成金額
,	予定
,	予定日
,	和暦予定日
,	和暦予定日略称
,	予定金額
,	税別出資比率詳細 AS JV受注
FROM
	UserDB.dbo.月別工事受注実績レポート_Q AS A
