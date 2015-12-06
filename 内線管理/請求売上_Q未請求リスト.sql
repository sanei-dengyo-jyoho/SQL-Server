with

v0 as
(
select
    a0.システム名
,   a0.工事年度
,   a0.工事種別
,   a0.工事項番
,   a0.工事番号
,   a0.工事種別名
,   a0.工事種別コード
,   a0.取引先コード
,   a0.取引先名
,   a0.取引先名カナ
,   a0.取引先略称
,   a0.取引先略称カナ
,   a0.得意先
,   a0.工事件名
,   a0.工事場所
,   a0.停止日付
,   a0.処理結果
,   a0.受注金額
,   a0.消費税率
,   a0.消費税額
,   0 as 請求回数
,   null as 請求回数最大値
,   null as 工事番号枝番
,   null as 請求日付
,   null as 請求本体金額
,   N'' as 請求本体額
,   null as 請求消費税率
,   NULL as 請求消費税額
,   N'' as 請求消費税
,   N'' as 請求額
,   null as 請求区分
,   N'' as 請求区分名
,   N'' as 請求区分省略
,   null as 入金条件グループ
,   null as 入金条件
,   null as 入金条件索引
,   N'' as 入金条件名
,   N'' as 入金状況
,   null as 確定日付
,   null as 回収日付
,   null as 振込日付
,   null as 振込金額
,   N'' as 振込額
,   null as 振込手数料
,   N'' as 手数料
,   N'' as 現金入金
,   null as 手形金額
,   N'' as 手形入金
,   null as 入金手形サイト
,   null as 手形振出日
,   null as 手形期日
,   null as 手形決済日
,   null as 相殺金額
,   N'' as 相殺額
,   null as 振替先会社コード
,   null as 振替先部門コード
,   N'' as 振替先部門名
,   N'' as 振替先部門名略称
from
    工事台帳_Q as a0
left outer join
    請求売上_Q as d0
    on d0.システム名 = a0.システム名
    and d0.工事年度 = a0.工事年度
    and d0.工事種別 = a0.工事種別
    and d0.工事項番 = a0.工事項番
where
    ( d0.請求回数 is null )
)

select
    *
from
    v0 as v000
