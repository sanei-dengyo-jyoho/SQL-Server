WITH 

v00 AS 
( 
 select top 1 
        min(年度) as 最小年度, 
        max(年度) as 最大年度 
 from 災害事故報告_T as y00 
 union all 
 select top 1 
        min(年度) as 最小年度, 
        max(年度) as 最大年度 
 from 車両事故報告_T as y01 
), 

v0 AS 
( 
 select top 1 
        min(最小年度) as 最小年度, 
        max(最大年度) as 最大年度 
 from v00 as y01 
), 

v1 AS 
( 
 select c.年度, 
        c.年, 
        c.月, 
        c.年*100+c.月 as 年月 
 from カレンダ_T as c 
  inner join v0 as v 
   on c.年度 >= v.最小年度 
   and c.年度 <= v.最大年度 
 group by c.年度, 
          c.年, 
          c.月 
), 

v2 as 
( 
 select convert(int,x.年度) as 年度, 
        convert(varchar(4),x.年度)+'年度' AS 年度表示, 
        y.年号+convert(varchar(4),y.年)+'年度' AS 和暦年度表示, 
        convert(varchar(4),x.月)+'月' as 月表示, 
        convert(int,x.年) as 年, 
        convert(int,x.月) as 月, 
        convert(int,x.年月) as 年月 
 from v1 as x 
  inner join 和暦_T as y 
   on y.西暦 = x.年度 
), 

v3 as 
( 
 select v21.年度, 
        v21.年度表示, 
        v21.和暦年度表示, 
        v21.月表示, 
        v21.年, 
        v21.月, 
        v21.年月, 
        convert(int,1) as 事故種別コード, 
        '災害事故' as 事故種別, 
        convert(int,isnull(v31.[管理№],0)) as 番号, 
        case isnull(v31.[管理№],0) when 0 then 0 else 1 end as 値 
 from v2 as v21 
  LEFT OUTER JOIN 災害事故報告_T as v31 
  on v31.年度 = v21.年度 
  and v31.年月 = v21.年月 

 union all 

 select v22.年度, 
        v22.年度表示, 
        v22.和暦年度表示, 
        v22.月表示, 
        v22.年, 
        v22.月, 
        v22.年月, 
        convert(int,2) as 事故種別コード, 
        '車両事故' as 事故種別, 
        convert(int,isnull(v32.[管理№],0)) as 番号, 
        case isnull(v32.[管理№],0) when 0 then 0 else 1 end as 値 
 from v2 as v22 
  LEFT OUTER JOIN 車両事故報告_T as v32 
  on v32.年度 = v22.年度 
  and v32.年月 = v22.年月 
), 

v4 as 
( 
 select 年度, 
        年度表示, 
        和暦年度表示, 
        月表示, 
        年, 
        月, 
        年月, 
        convert(int,0) as 事故種別コード, 
        '合計' as 事故種別, 
        max(番号) as 番号, 
        sum(値) as 値 
 from v3 as v33 
 group by 年度, 
          年度表示, 
          和暦年度表示, 
          月表示, 
          年, 
          月, 
          年月 
)

 select * 
 from v3 as q3 

 union all
 
 select * 
 from v4 as q4 

