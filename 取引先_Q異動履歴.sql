 SELECT a.日付, 
        a.取引先コード, 
        a.取引先名, 
        a.取引先名カナ, 
        a.取引先略称, 
        a.取引先略称カナ, 
        e.種別, 
        d.業種, 
        c.請負名 AS 請負, 
        b.履歴, 
        '\' + CONVERT(varchar(2), CASE WHEN isnull(a.登録区分,0) > 0 THEN - 1 ELSE 0 END) AS 区分 
 FROM 取引先_T異動 as a 
  LEFT OUTER JOIN コード登録区分_Q as b 
   ON a.登録区分 = b.登録区分 
  LEFT OUTER JOIN 請負_Q as c 
   ON a.請負コード = c.請負コード 
  LEFT OUTER JOIN 業種_Q as d 
   ON a.業種コード = d.業種コード 
  LEFT OUTER JOIN 取引先種別_T as e 
   ON a.種別コード = e.種別コード 

