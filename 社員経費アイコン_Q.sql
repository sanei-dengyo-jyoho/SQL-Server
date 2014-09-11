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
 select 経費 AS 名称, 
        convert(varchar(8),88000+経費コード) AS 名称番号 
 from 経費コード_T as q2 
), 

v3 AS 
( 
 select 経費理由 AS 名称, 
        convert(varchar(8),99000+経費理由コード) AS 名称番号 
 from 経費理由コード_T as q3 
), 

v4 as 
( 
 select * 
 from v1 AS v10 
 union all 
 select * 
 from v2 AS v20 
 union all 
 select * 
 from v3 AS v30 
) 

 select * 
 from v4 as v40 

