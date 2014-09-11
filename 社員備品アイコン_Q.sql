with 
v1 as 
( 
 select 名称, 
        '00'+convert(varchar(8),名称番号) AS 名称番号 
 from 名称_T as q1 
 where 名称コード=130 
  and (名称='男性' or 名称='女性') 
), 

v2 as 
( 
 select 名称, 
        '10'+convert(varchar(8),名称番号) AS 名称番号 
 from 名称_T as q1 
 where 名称コード=138 
), 

v4 as 
( 
 select * 
 from v1 AS v10 
 union all 
 select * 
 from v2 AS v20 
) 

 select * 
 from v4 as v40 

