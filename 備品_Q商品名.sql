with

v0 as
(
 select distinct
    a.部門コード
,   a.大分類コード
,   a.中分類コード
,   a.小分類コード
,   b.分類コード
,   b.大分類名
,   b.中分類名
,   b.小分類名
,   b.分類名
,   a.商品名
,   a.メーカー
,   a.単位
,   a.単価
,   a.安全在庫数量
,   a.備考
,   a.在庫管理
,   a.登録部門コード
,   a.登録社員コード
,   a.登録区分
,   a.登録日時
from
    備品_T商品名 as a
LEFT OUTER JOIN
    備品_Q分類 as b
    on b.大分類コード=a.大分類コード
    and b.中分類コード=a.中分類コード
    and b.小分類コード=a.小分類コード
)

select
    *
from
    v0 as v000
