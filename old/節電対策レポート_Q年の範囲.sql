WITH 

v0 AS 
( 
 SELECT 年 
 FROM 節電対策レポート_T AS y 
 GROUP BY 年 
), 

v1 AS 
( 
 SELECT c.年, 
        c.年号, 
        c.和暦年 
 FROM カレンダ_Q AS c 
  INNER JOIN v0 AS v 
   ON c.年 = v.年 
 GROUP BY c.年, 
          c.年号, 
          c.和暦年 
) 

 SELECT DISTINCT 
        年号+CONVERT(varchar(4),和暦年)+'年' AS 年集計, 
        CONVERT(int,年) AS 年 
 FROM v1 AS b 

