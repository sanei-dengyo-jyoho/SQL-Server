with 

v9 as 
( 
 select 利用者名, 
        オブジェクト名, 
        コントロール名, 
        CONVERT(int,isnull(キー2,0)) AS 年度, 
        CONVERT(int,isnull(キー3,0)) AS 部門コード, 
        CONVERT(int,isnull(キー4,0)) AS [伝票№] 
 from 汎用一覧_T as v99 
 where キー1 = '600' 
  and オブジェクト名 IN ('備品購入一覧_F','備品購入_F') 
  and コントロール名 IN ('備品購入一覧_F','備品購入_F') 
), 

v0 as 
( 
 select distinct 
        x.利用者名, 
        x.オブジェクト名, 
        x.コントロール名, 
        x.年度, 
        x.部門コード, 
        x.[伝票№], 
        z.行数, 
        a.[行№], 
        a.商品名, 
        a.商品説明, 
        a.品番, 
        a.型番, 
        a.希望納期, 
        a.単位, 
        a.単価, 
        a.数量, 
        a.金額, 
        z.日付, 
        z.年, 
        z.月, 
        z.年月, 
        z.登録部門コード, 
        z.登録社員コード, 
        z.登録区分, 
        z.登録日時 
 from v9 as x 
  LEFT OUTER JOIN 備品購入_T as z 
   on z.年度=x.年度 
   and z.部門コード=x.部門コード 
   and z.[伝票№]=x.[伝票№] 
  LEFT OUTER JOIN 備品購入_T明細印刷 as a 
   on a.年度=z.年度 
   and a.部門コード=z.部門コード 
   and a.[伝票№]=z.[伝票№] 
) 

 select * 
 from v0 as v10 

