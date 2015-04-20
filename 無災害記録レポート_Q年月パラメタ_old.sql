with 

v0 as 
( 
 select min(年度) as 年度自, 
        max(年度) as 年度至 
 from 無災害記録レポート_Q年月の範囲 as m0 
), 

v1 as 
( 
 select 年度, 
        年, 
        月,  
        年*100+月 as 年月, 
        max(日付) as 日付 
 from カレンダ_T as c0 
 group by 年度,年,月 
), 

v2 as 
( 
 select a.年月自, 
        m1.和暦年月表示 as 和暦年月表示自, 
        dbo.FuncDateFormatDomestic(convert(varchar(10),c1.日付,111),'','年',DEFAULT,DEFAULT) as 和暦日付自, 
        a.年月至, 
        m2.和暦年月表示 as 和暦年月表示至, 
        dbo.FuncDateFormatDomestic(convert(varchar(10),c2.日付,111),'','年',DEFAULT,DEFAULT) as 和暦日付至 
 from v0 as a 
  LEFT OUTER JOIN 無災害記録レポート_Q年月の範囲 as m1 
   on m1.年月=a.年月自 
  LEFT OUTER JOIN 無災害記録レポート_Q年月の範囲 as m2 
   on m2.年月=a.年月至 
  LEFT OUTER JOIN v1 as c1 
   on c1.年月=a.年月自 
  LEFT OUTER JOIN v1 as c2 
   on c2.年月=a.年月至 
) 

 select * 
 from v2 as v20 


