
 select DISTINCT 
        b.年号+CONVERT(varchar(4),b.年)+'年度' AS 年集計, 
        CONVERT(int,a.年度) AS 年, 
        CONVERT(int,a.月) AS 月, 
        CONVERT(int,a.年月) AS 年月, 
        CONVERT(int,a.年度) AS 年度, 
        a.[管理№] AS 番号, 
        CASE isnull(a.[管理№],'') WHEN '' THEN 0 ELSE 1 END AS 値, 
        CASE ISNULL(a.日付,'') WHEN '' THEN '' ELSE CONVERT(varchar(10),a.日付,111) END+CHAR(13)+CHAR(10)+' ('+ISNULL(a.曜日,'')+') '+ISNULL(a.時刻表示,'') as 発生日時, 
        a.天候コード, 
        dbo.FuncGetSectionString(ISNULL(a.本部名,''),ISNULL(a.部名,''),ISNULL(a.部門名,''),DEFAULT,CHAR(13)+CHAR(10)) as 所属, 
        ISNULL(a.氏名,'')+CASE ISNULL(a.協力会社名,'') WHEN '' THEN '' ELSE '（'+a.協力会社名+'）' END as 氏名, 
        ISNULL(a.性別,0) as 性別, 
        ISNULL(a.年齢,'')+CHAR(13)+CHAR(10)+ISNULL(a.経験,'') as [年齢／経験], 
        a.事故種別名 as 事故種別, 
        CASE ISNULL(a.事故種別,'') WHEN '人' THEN 9 ELSE 0 END as 事故区分, 
        a.同乗者の有無 as 同乗者, 
        a.状況詳細 as 事故の概要, 
        ISNULL(a.過失当社,'')+CHAR(13)+CHAR(10)+ISNULL(a.過失相手,'') as 過失, 
        CASE ISNULL(a.事故処理報告書日付,'') WHEN '' THEN '' ELSE CONVERT(varchar(10),a.事故処理報告書日付,111) END as 事故処理, 
        a.原因, 
        a.発生場所 
 from 車両事故報告_Q as a 
  LEFT OUTER JOIN 和暦_T as b 
   on b.西暦=a.年度 


