WITH 

v0 AS 
( 
 SELECT TOP (1) 
        MIN(年) AS 最小年, 
        MAX(年) AS 最大年 
 FROM 車両事故報告_T AS y 
), 

v1 AS 
( 
 SELECT c.年, 
        c.年号, 
        c.和暦年 
 FROM カレンダ_Q AS c 
  INNER JOIN v0 AS v 
   ON c.年 >= v.最小年 
   AND c.年 <= v.最大年 
 GROUP BY c.年, 
          c.年号, 
          c.和暦年 
) 

 SELECT DISTINCT 
        b.年号+CONVERT(varchar(4),b.和暦年)+'年' AS 年集計, 
        CONVERT(int,b.年) AS 年, 
        ISNULL(a.状況,'') AS 状況, 
        ISNULL(a.対策,'') AS 対策, 
        ISNULL(a.考察,'') AS 考察 
 FROM v1 AS b 
  LEFT JOIN 交通事故分析_Tコメント AS a 
   ON a.年 = b.年 

