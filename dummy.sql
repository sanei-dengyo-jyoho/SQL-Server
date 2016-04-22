use UserDB
go

-- 管理本部 --
select top 1
    year(dateadd(day,-4524,'2016-03-31')) as 年度
,   -99 as [管理№]
,   dateadd(day,-4524,'2016-03-31') as 日付
,
    year(dateadd(day,-4524,'2016-03-31')) * 100 +
    month(dateadd(day,-4524,'2016-03-31'))
    as 年月
,   year(dateadd(day,-4524,'2016-03-31')) as 年
,   month(dateadd(day,-4524,'2016-03-31')) as 月
,   day(dateadd(day,-4524,'2016-03-31')) as 日
,   '9:00' as 時刻
,   null as 協力会社コード
,   null as 被災者名
,   null as 被災者年齢年
,   null as 被災者年齢月
,   null as 被災者経験年
,   null as 被災者経験月
,   51 as 部門コード
,   null as 社員コード
,   null as 年齢年
,   null as 年齢月
,   null as 経験年
,   null as 経験月
,   1 as 天候コード
,   null as 天候その他
,   0 as 休業コード
,   null as 期間コード
,   null as 期間
,   null as 県コード
,   null as 市町村コード
,   null as 住所
,   null as 種別
,   null as 作業内容
,   null as 障害状況
,   null as 備考
,   1 as 労災認定
,   null as 状況詳細
,   null as 原因詳細
,   null as 対策詳細

union all

-- 品質安全部 --
select top 1
    year(dateadd(day,-4524,'2016-03-31')) as 年度
,   -98 as [管理№]
,   dateadd(day,-4524,'2016-03-31') as 日付
,
    year(dateadd(day,-4524,'2016-03-31')) * 100 +
    month(dateadd(day,-4524,'2016-03-31'))
    as 年月
,   year(dateadd(day,-4524,'2016-03-31')) as 年
,   month(dateadd(day,-4524,'2016-03-31')) as 月
,   day(dateadd(day,-4524,'2016-03-31')) as 日
,   '9:00' as 時刻
,   null as 協力会社コード
,   null as 被災者名
,   null as 被災者年齢年
,   null as 被災者年齢月
,   null as 被災者経験年
,   null as 被災者経験月
,   140 as 部門コード
,   null as 社員コード
,   null as 年齢年
,   null as 年齢月
,   null as 経験年
,   null as 経験月
,   1 as 天候コード
,   null as 天候その他
,   0 as 休業コード
,   null as 期間コード
,   null as 期間
,   null as 県コード
,   null as 市町村コード
,   null as 住所
,   null as 種別
,   null as 作業内容
,   null as 障害状況
,   null as 備考
,   1 as 労災認定
,   null as 状況詳細
,   null as 原因詳細
,   null as 対策詳細

union all

-- 営業部 --
select top 1
    year(dateadd(day,-4524,'2016-03-31')) as 年度
,   -97 as [管理№]
,   dateadd(day,-4524,'2016-03-31') as 日付
,
    year(dateadd(day,-4524,'2016-03-31')) * 100 +
    month(dateadd(day,-4524,'2016-03-31'))
    as 年月
,   year(dateadd(day,-4524,'2016-03-31')) as 年
,   month(dateadd(day,-4524,'2016-03-31')) as 月
,   day(dateadd(day,-4524,'2016-03-31')) as 日
,   '9:00' as 時刻
,   null as 協力会社コード
,   null as 被災者名
,   null as 被災者年齢年
,   null as 被災者年齢月
,   null as 被災者経験年
,   null as 被災者経験月
,   144 as 部門コード
,   null as 社員コード
,   null as 年齢年
,   null as 年齢月
,   null as 経験年
,   null as 経験月
,   1 as 天候コード
,   null as 天候その他
,   0 as 休業コード
,   null as 期間コード
,   null as 期間
,   null as 県コード
,   null as 市町村コード
,   null as 住所
,   null as 種別
,   null as 作業内容
,   null as 障害状況
,   null as 備考
,   1 as 労災認定
,   null as 状況詳細
,   null as 原因詳細
,   null as 対策詳細

union all

-- 電力事業本部 --
select top 1
    year(dateadd(day,-4524,'2016-03-31')) as 年度
,   -96 as [管理№]
,   dateadd(day,-4524,'2016-03-31') as 日付
,
    year(dateadd(day,-4524,'2016-03-31')) * 100 +
    month(dateadd(day,-4524,'2016-03-31'))
    as 年月
,   year(dateadd(day,-4524,'2016-03-31')) as 年
,   month(dateadd(day,-4524,'2016-03-31')) as 月
,   day(dateadd(day,-4524,'2016-03-31')) as 日
,   '9:00' as 時刻
,   null as 協力会社コード
,   null as 被災者名
,   null as 被災者年齢年
,   null as 被災者年齢月
,   null as 被災者経験年
,   null as 被災者経験月
,   58 as 部門コード
,   null as 社員コード
,   null as 年齢年
,   null as 年齢月
,   null as 経験年
,   null as 経験月
,   1 as 天候コード
,   null as 天候その他
,   0 as 休業コード
,   null as 期間コード
,   null as 期間
,   null as 県コード
,   null as 市町村コード
,   null as 住所
,   null as 種別
,   null as 作業内容
,   null as 障害状況
,   null as 備考
,   1 as 労災認定
,   null as 状況詳細
,   null as 原因詳細
,   null as 対策詳細

union all

-- 電力部 --
select top 1
    year(dateadd(day,-4524,'2016-03-31')) as 年度
,   -95 as [管理№]
,   dateadd(day,-4524,'2016-03-31') as 日付
,
    year(dateadd(day,-4524,'2016-03-31')) * 100 +
    month(dateadd(day,-4524,'2016-03-31'))
    as 年月
,   year(dateadd(day,-4524,'2016-03-31')) as 年
,   month(dateadd(day,-4524,'2016-03-31')) as 月
,   day(dateadd(day,-4524,'2016-03-31')) as 日
,   '9:00' as 時刻
,   null as 協力会社コード
,   null as 被災者名
,   null as 被災者年齢年
,   null as 被災者年齢月
,   null as 被災者経験年
,   null as 被災者経験月
,   178 as 部門コード
,   null as 社員コード
,   null as 年齢年
,   null as 年齢月
,   null as 経験年
,   null as 経験月
,   1 as 天候コード
,   null as 天候その他
,   0 as 休業コード
,   null as 期間コード
,   null as 期間
,   null as 県コード
,   null as 市町村コード
,   null as 住所
,   null as 種別
,   null as 作業内容
,   null as 障害状況
,   null as 備考
,   1 as 労災認定
,   null as 状況詳細
,   null as 原因詳細
,   null as 対策詳細

union all

-- 南関東支店 --
select top 1
    year(dateadd(day,-4425,'2016-03-31')) as 年度
,   -94 as [管理№]
,   dateadd(day,-4425,'2016-03-31') as 日付
,
    year(dateadd(day,-4425,'2016-03-31')) * 100 +
    month(dateadd(day,-4425,'2016-03-31'))
    as 年月
,   year(dateadd(day,-4425,'2016-03-31')) as 年
,   month(dateadd(day,-4425,'2016-03-31')) as 月
,   day(dateadd(day,-4425,'2016-03-31')) as 日
,   '9:00' as 時刻
,   null as 協力会社コード
,   null as 被災者名
,   null as 被災者年齢年
,   null as 被災者年齢月
,   null as 被災者経験年
,   null as 被災者経験月
,   173 as 部門コード
,   null as 社員コード
,   null as 年齢年
,   null as 年齢月
,   null as 経験年
,   null as 経験月
,   1 as 天候コード
,   null as 天候その他
,   0 as 休業コード
,   null as 期間コード
,   null as 期間
,   null as 県コード
,   null as 市町村コード
,   null as 住所
,   null as 種別
,   null as 作業内容
,   null as 障害状況
,   null as 備考
,   1 as 労災認定
,   null as 状況詳細
,   null as 原因詳細
,   null as 対策詳細

union all

-- 北関東支店 --
select top 1
    year(dateadd(day,-4881,'2016-03-31')) as 年度
,   -93 as [管理№]
,   dateadd(day,-4881,'2016-03-31') as 日付
,
    year(dateadd(day,-4881,'2016-03-31')) * 100 +
    month(dateadd(day,-4881,'2016-03-31'))
    as 年月
,   year(dateadd(day,-4881,'2016-03-31')) as 年
,   month(dateadd(day,-4881,'2016-03-31')) as 月
,   day(dateadd(day,-4881,'2016-03-31')) as 日
,   '9:00' as 時刻
,   null as 協力会社コード
,   null as 被災者名
,   null as 被災者年齢年
,   null as 被災者年齢月
,   null as 被災者経験年
,   null as 被災者経験月
,   174 as 部門コード
,   null as 社員コード
,   null as 年齢年
,   null as 年齢月
,   null as 経験年
,   null as 経験月
,   1 as 天候コード
,   null as 天候その他
,   0 as 休業コード
,   null as 期間コード
,   null as 期間
,   null as 県コード
,   null as 市町村コード
,   null as 住所
,   null as 種別
,   null as 作業内容
,   null as 障害状況
,   null as 備考
,   1 as 労災認定
,   null as 状況詳細
,   null as 原因詳細
,   null as 対策詳細

union all

-- 埼玉支社 --
select top 1
    year(dateadd(day,-4881,'2016-03-31')) as 年度
,   -92 as [管理№]
,   dateadd(day,-4881,'2016-03-31') as 日付
,
    year(dateadd(day,-4881,'2016-03-31')) * 100 +
    month(dateadd(day,-4881,'2016-03-31'))
    as 年月
,   year(dateadd(day,-4881,'2016-03-31')) as 年
,   month(dateadd(day,-4881,'2016-03-31')) as 月
,   day(dateadd(day,-4881,'2016-03-31')) as 日
,   '9:00' as 時刻
,   null as 協力会社コード
,   null as 被災者名
,   null as 被災者年齢年
,   null as 被災者年齢月
,   null as 被災者経験年
,   null as 被災者経験月
,   405 as 部門コード
,   null as 社員コード
,   null as 年齢年
,   null as 年齢月
,   null as 経験年
,   null as 経験月
,   1 as 天候コード
,   null as 天候その他
,   0 as 休業コード
,   null as 期間コード
,   null as 期間
,   null as 県コード
,   null as 市町村コード
,   null as 住所
,   null as 種別
,   null as 作業内容
,   null as 障害状況
,   null as 備考
,   1 as 労災認定
,   null as 状況詳細
,   null as 原因詳細
,   null as 対策詳細

go
