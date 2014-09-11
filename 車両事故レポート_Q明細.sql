WITH 
v0 AS 
(
SELECT 
 TOP (1) 
 MIN(年度) AS 最小年, 
 MAX(年度) AS 最大年
FROM 
 車両事故報告_T AS y
), 

v001 AS 
( 
 SELECT max(年度) as 年度, 
        年号, 
        和暦年 
 FROM カレンダ_Q AS c001 
 GROUP BY 年号, 
          和暦年 
), 

v1 AS 
(
SELECT 
 c.年度, 
 c.年号, 
 c.和暦年, 
 c.年, 
 c.月, 
 c.年 * 100 + c.月 AS 年月
FROM 
 v001 AS d 
INNER JOIN カレンダ_Q AS c 
 ON c.年度 = d.年度 
INNER JOIN v0 AS v 
 ON c.年度 >= v.最小年 
 AND c.年度 <= v.最大年
GROUP BY 
 c.年度, 
 c.年号, 
 c.和暦年, 
 c.年, 
 c.月
)

SELECT 
 DISTINCT 
 b.年号+CONVERT(varchar(4),b.和暦年)+'年度' AS 年集計, 
 CONVERT(int,b.年度) AS 年, 
 CONVERT(varchar(4),b.月)+'月' AS 月集計, 
 CONVERT(int,b.月) AS 月, 
 CONVERT(int,b.年月) AS 年月, 
 'Q'+datename(quarter,convert(varchar(10),convert(varchar(4),b.年)+'/'+convert(varchar(2),b.月)+'/1',111)) AS 四半期, 
 CONVERT(int,b.年度) AS 年度, 
 a.[管理№] AS 番号, 
 CASE isnull(a.[管理№],'') WHEN '' THEN 0 ELSE 1 END AS 値, 
 a.日付, 
 a.曜日, 
 a.日付表示 AS 発生日, 
 a.時刻表示 AS 発生時刻, 
 a.時間帯コード, 
 a.時間帯, 
 a.協力会社コード, 
 a.協力会社名, 
 a.社員コード, 
 a.氏名, 
 a.年齢年, 
 a.年齢月, 
 a.年齢 AS 年齢年月, 
 a.年齢割合コード AS 年齢コード, 
 a.年齢割合 AS 年齢, 
 a.経験年, 
 a.経験月, 
 a.経験 AS 経験年月, 
 a.経験年数割合コード AS 経験年数コード, 
 a.経験年数割合 AS 経験年数, 
 a.部所グループコード, 
 a.部所コード, 
 a.部所グループ名, 
 a.部所名, 
 a.部門コード, 
 a.部門名, 
 a.部門名略称, 
 a.天候コード, 
 a.天候, 
 a.車両種別コード, 
 a.車両種別 AS 事故種別車両, 
 a.事故種別コード, 
 a.事故種別 AS 事故種別対, 
 a.事故種別名 AS 事故種別, 
 a.過失比率当社, 
 a.過失当社, 
 a.過失比率相手, 
 a.過失相手, 
 a.過失 AS 過失分, 
 a.過失割合コード AS 過失コード, 
 a.過失割合 AS 過失, 
 a.発生場所コード, 
 a.発生場所, 
 a.同乗者数, 
 a.同乗者の有無 AS 同乗者, 
 a.原因, 
 a.状況詳細, 
 a.原因詳細, 
 a.対策詳細, 
 a.事故処理報告書日付, 
 a.事故処理報告書年月, 
 a.事故処理報告書年, 
 a.事故処理報告書月, 
 a.事故処理報告書日 
FROM 
 v1 AS b 
LEFT OUTER JOIN 
 車両事故報告_Q AS a 
 ON a.年月 = b.年月

 