WITH 

v0 AS 
( 
 select top 1 
        min(年度) as 最小年, 
        max(年度) as 最大年 
 from 車両事故報告_T as y 
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
 SELECT c.年度, 
        c.年号, 
        c.和暦年 
 FROM v001 AS c 
  INNER JOIN v0 AS v 
   ON c.年度 >= v.最小年 
   AND c.年度 <= v.最大年 
 GROUP BY c.年度, 
          c.年号, 
          c.和暦年 
), 

v2 as 
( 
 select CONVERT(varchar(5),e.時刻,108) AS 時刻, 
        e.時間帯コード, 
        e.時間帯 
 from 事故発生時間帯_Q as e 
), 

v3 as 
( 
 select v10.年度, 
        v10.年号, 
        v10.和暦年, 
        v20.時刻, 
        v20.時間帯コード, 
        v20.時間帯 
 from v1 as v10 
  cross join v2 as v20 
), 

v4 as 
( 
 select CONVERT(varchar(5),時刻,108) AS 時刻, 
        年度, 
        [管理№] 
 from 車両事故報告_T as v40 
) 

 select distinct 
        b.年号+convert(varchar(4),b.和暦年)+'年度' as 年集計, 
        convert(int,b.年度) as 年, 
        a.[管理№] as 番号, 
        case isnull(a.[管理№],'') when '' then 0 else 1 end as 値, 
        convert(int,b.時間帯コード) as 時間帯コード, 
        b.時間帯 
 from v3 as b 
  left outer join v4 as a 
   on a.年度=b.年度 
   and a.時刻=b.時刻 


