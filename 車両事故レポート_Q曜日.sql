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
 select c.年度, 
        c.年号, 
        c.和暦年, 
        c.日付, 
        case c.曜日 when 1 then 7 else c.曜日-1 end as 曜日コード, 
        c.曜日名 as 曜日 
 fROM v001 AS d 
  inner join カレンダ_Q AS c 
   on c.年度 = d.年度 
  inner join v0 as v 
   on c.年度 >= v.最小年 
   and c.年度 <= v.最大年 
) 

 select distinct 
        b.年号+convert(varchar(4),b.和暦年)+'年度' as 年集計, 
        convert(int,b.年度) as 年, 
        a.[管理№] as 番号, 
        case isnull(a.[管理№],'') when '' then 0 else 1 end as 値, 
        b.日付, 
        convert(int,b.曜日コード) as 曜日コード, 
        b.曜日 
 from v1 as b 
  left outer join 車両事故報告_T as a 
   on a.年度=b.年度 
   and a.日付=b.日付 


