with 

v0 AS 
( 
 select top 1 
        min(年) as 最小年, 
        max(年) as 最大年 
 from 節電対策レポート_T as y 
), 

v001 AS 
( 
 SELECT max(年) as 年, 
        年号, 
        和暦年 
 FROM カレンダ_Q AS c001 
 GROUP BY 年号, 
          和暦年 
), 

v1 AS 
( 
 SELECT c.年, 
        c.年号, 
        c.和暦年 
 FROM v001 AS c 
  INNER JOIN v0 AS v 
   ON c.年 >= v.最小年 
   AND c.年 <= v.最大年 
 GROUP BY c.年, 
          c.年号, 
          c.和暦年 
), 

vp1 as 
( 
 select * 
 from 会社住所_Q as p0 
 where 会社コード='10' 
), 

vt1 as 
( 
 select * 
 from 節電対策レポート_T as t0 
) 

 select distinct 
        convert(int,b.年) as 年, 
        a.年号+convert(varchar(4),a.和暦年)+'年' as 年集計, 
        b.所在地コード, 
        isnull(p.場所名,'') as 場所名, 
        isnull(b.ヘッダー,'') as ヘッダー, 
        isnull(b.フッター,'') as フッター 
 from vt1 as b 
  left outer join v1 as a 
   on a.年=b.年 
  left outer join vp1 as p 
   on p.所在地コード=b.所在地コード 

