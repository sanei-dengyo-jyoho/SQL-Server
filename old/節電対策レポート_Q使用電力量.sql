with 

v0 AS 
( 
 select top 1 
        min(年) as 最小年, 
        max(年) as 最大年 
 from 節電対策レポート_T使用電力量 as y 
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

vt0 as 
( 
 select * 
 from 節電対策レポート_T使用電力量 as t0 
), 

vt1 as 
( 
 select 年, 
        所在地コード, 
        1 as 月, 
        [1月] as 値, 
        備考 
 from vt0 as vt001 
 union all 
 select 年, 
        所在地コード, 
        2 as 月, 
        [2月] as 値, 
        備考 
 from vt0 as vt002 
 union all 
 select 年, 
        所在地コード, 
        3 as 月, 
        [3月] as 値, 
        備考 
 from vt0 as vt003 
 union all 
 select 年, 
        所在地コード, 
        4 as 月, 
        [4月] as 値, 
        備考 
 from vt0 as vt004 
 union all 
 select 年, 
        所在地コード, 
        5 as 月, 
        [5月] as 値, 
        備考 
 from vt0 as vt005 
 union all 
 select 年, 
        所在地コード, 
        6 as 月, 
        [6月] as 値, 
        備考 
 from vt0 as vt006 
 union all 
 select 年, 
        所在地コード, 
        7 as 月, 
        [7月] as 値, 
        備考 
 from vt0 as vt007 
 union all 
 select 年, 
        所在地コード, 
        8 as 月, 
        [8月] as 値, 
        備考 
 from vt0 as vt008 
 union all 
 select 年, 
        所在地コード, 
        9 as 月, 
        [9月] as 値, 
        備考 
 from vt0 as vt009 
 union all 
 select 年, 
        所在地コード, 
        10 as 月, 
        [10月] as 値, 
        備考 
 from vt0 as vt010 
 union all 
 select 年, 
        所在地コード, 
        11 as 月, 
        [11月] as 値, 
        備考 
 from vt0 as vt011 
 union all 
 select 年, 
        所在地コード, 
        12 as 月, 
        [12月] as 値, 
        備考 
 from vt0 as vt012 
) 

 select distinct 
        convert(int,b.年) as 年, 
        a.年号+convert(varchar(4),a.和暦年)+'年' as 年集計, 
        b.所在地コード, 
        isnull(p.場所名,'') as 場所名, 
        convert(int,b.月) as 月, 
        convert(varchar(4),b.月)+'月' as 月集計, 
        convert(money,b.値) as 値, 
        isnull(b.備考,'') as 備考 
 from vt1 as b 
  left outer join v1 as a 
   on a.年=b.年 
  left outer join vp1 as p 
   on p.所在地コード=b.所在地コード 

