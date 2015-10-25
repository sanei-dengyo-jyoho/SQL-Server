with 

vp1 as 
( 
 select * 
 from 会社場所_Q as p0 
 where 会社コード='10' 
), 

vt1 as 
( 
 select 所在地コード 
 from 節電対策レポート_T as t0 
 group by 所在地コード 
) 

 select distinct 
        p.部コード, 
        p.所在地コード, 
        p.部門レベル, 
        isnull(p.場所名,'') as 場所名 
 from vt1 as b 
  left outer join vp1 as p 
   on p.所在地コード=b.所在地コード 
 order by p.部コード, 
          p.所在地コード, 
          p.部門レベル 

