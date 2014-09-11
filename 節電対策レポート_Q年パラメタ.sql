with 

v00 AS 
( 
 select top 2 * 
 from 節電対策レポート_Q年の範囲 as v000 
 order by 年 desc 
), 

v0 as 
( 
 select min(年) as 年自, 
        max(年) as 年至 
 from v00 as y0 
), 

v1 as 
( 
 select 年, 
        max(日付) as 日付 
 from カレンダ_T as c0 
 group by 年 
), 

v2 as 
( 
 select a.年自, 
        m1.年集計 as 和暦年表示自, 
        dbo.FuncDateFormatDomestic(convert(varchar(10),c1.日付,111),'','年',DEFAULT,DEFAULT) as 和暦日付自, 
        a.年至, 
        m2.年集計 as 和暦年表示至, 
        dbo.FuncDateFormatDomestic(convert(varchar(10),c2.日付,111),'','年',DEFAULT,DEFAULT) as 和暦日付至 
 from v0 as a 
  left outer join 節電対策レポート_Q年の範囲 as m1 
   on m1.年=a.年自 
  left outer join 節電対策レポート_Q年の範囲 as m2 
   on m2.年=a.年至 
  left outer join v1 as c1 
   on c1.年=a.年自 
  left outer join v1 as c2 
   on c2.年=a.年至 
) 

 select * 
 from v2 as v20 


