WITH 

v0 as 
( 
 select min(年度) as 最小年, 
        max(年度) as 最大年 
 from 車両事故報告_T as y0 
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
 select 県コード, 
        県名 
 from 県_Q as e 
), 

v3 as 
( 
 select v10.年度, 
        v10.年号, 
        v10.和暦年, 
        v20.県コード, 
        v20.県名 
 from v1 as v10 
  cross join v2 as v20 
), 

v4 as 
( 
 select isnull(v40.県コード,isnull(v90.県コード,0)) as 県コード, 
        v40.年度, 
        v40.[管理№] 
 from 車両事故報告_T as v40 
  left outer join 部門_T年度 as v80 
   on v80.年度=v40.年度 
   and v80.部門コード=v40.部門コード 
  left outer join 会社住所_T as v90 
   on v90.会社コード=v80.会社コード 
   and v90.所在地コード=v80.所在地コード 
), 

v6 as 
( 
 select distinct 
        b.年号+convert(varchar(4),b.和暦年)+'年度' as 年集計, 
        convert(int,b.年度) as 年, 
        a.[管理№] as 番号, 
        case isnull(a.[管理№],'') when '' then 0 else 1 end as 値, 
        convert(int,b.県コード) as 県コード, 
        b.県名 
 from v3 as b 
  left outer join v4 as a 
   on a.年度=b.年度 
   and a.県コード=b.県コード 
) 

 select 年集計, 
        年, 
        p.県コード, 
        p.県名, 
        sum(p.値) as 件数 
 from v6 as p 
 group by 年集計, 
          年, 
          p.県コード, 
          p.県名 


