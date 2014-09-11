with 

v00 AS 
( 
 select top 1 * 
 from 節電対策レポート_Q会社場所 as v000 
 order by 部コード, 
          所在地コード, 
          部門レベル 
) 

 select * 
 from v00 as v20 


