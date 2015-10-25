with

x0 as
(
SELECT
    システム名
,   数値 as 行数
FROM
    工事管理条件_T as xa0
WHERE
    条件名 = N'請求書内訳の行数'
)
,

x1 as
(
SELECT
	xa1.digit * 10 + xb1.digit as seq
FROM
	digits_T as xa1
CROSS JOIN
	digits_T as xb1
)
,

x2 as
(
SELECT
    xa2.システム名
,	xb2.seq as 行
FROM
	x0 as xa2
CROSS JOIN
	x1 as xb2
WHERE
	( xb2.seq BETWEEN 1 AND xa2.行数 )
)
,

e0 as
(
select
    eb0.年度
,   ea0.会社コード
,   ea0.会社名
,   eb0.住所
,   eb0.TEL
,   eb0.FAX
from
    会社_T as ea0
inner join
    会社住所_T年度 as eb0
    on eb0.会社コード = ea0.会社コード
where
    ( ea0.会社コード = '10' )
    and ( eb0.場所名 = N'本社' )
)
,

q0 as
(
select
    yb0.システム名
,   dbo.FuncMakeConstructNumber(ya0.工事年度,ya0.工事種別,ya0.工事項番) AS 工事番号
,   ya0.工事年度
,   ya0.工事種別
,   ya0.工事項番
,   ya0.請求回数
,   yx0.行
,   yb0.工事種別名
,   yb0.工事種別コード
,   qe0.会社コード
,   qe0.会社名
,   qe0.住所
,   qe0.TEL
,   qe0.FAX
,   g0.銀行名
,   '(' + isnull(g0.銀行コード,'') + ')' as 銀行コード
,   g0.支店名
,   '(' + isnull(g0.支店コード,'') + ')' as 支店コード
,   g0.口座種別
,   N'№ ' + convert(nvarchar(10),isnull(g0.口座番号,'')) as 口座番号
,   g0.口座名義
,   ya0.請求先名
,   ya0.請求日付
,   (
    select
        w0.年号
    from
        和暦_T as w0
    where
        ( w0.西暦 = year(getdate()) )
    ) + N'　　　年　　　月　　　日' as 請求日付ラベル
,   ya0.発行日付
,   qb0.工事件名
,   qb0.工事場所
,   ya0.請求本体金額
,   ya0.請求消費税率
,   ya0.請求消費税額
from
    請求_T as ya0
left outer join
    工事種別_T as yb0
    on yb0.工事種別 = ya0.工事種別
left outer join
    工事台帳_T as qb0
    on qb0.工事年度 = ya0.工事年度
    and qb0.工事種別 = ya0.工事種別
    and qb0.工事項番 = ya0.工事項番
left outer join
    e0 as qe0
    on qe0.年度 = ya0.工事年度
left outer join
    会社_T振込先 as g0
    on g0.会社コード = qe0.会社コード
left outer join
    x2 as yx0
    on yx0.システム名 = yb0.システム名
where
    ( isnull(ya0.振替先部門コード,'') = '' )
)
,

v0 as
(
select
    a0.システム名
,   a0.工事番号
,   a0.工事年度
,   a0.工事種別
,   a0.工事項番
,   a0.請求回数
,   a0.行
,   a0.工事種別名
,   a0.工事種別コード
,   a0.会社コード
,   a0.会社名
,   a0.住所
,   a0.TEL
,   a0.FAX
,   a0.銀行名
,   a0.銀行コード
,   a0.支店名
,   a0.支店コード
,   a0.口座種別
,   a0.口座番号
,   a0.口座名義
,   a0.請求先名
,   a0.請求日付
,   a0.請求日付ラベル
,   a0.発行日付
,   a0.工事件名
,   a0.工事場所
,   a0.請求本体金額
,   a0.請求消費税率
,   a0.請求消費税額
,   s0.名称
,   s0.数量
,   s0.単位
,   s0.単価
,   s0.金額
from
    q0 as a0
left outer join
    請求_T内訳 as s0
    on s0.工事年度 = a0.工事年度
    and s0.工事種別 = a0.工事種別
    and s0.工事項番 = a0.工事項番
    and s0.請求回数 = a0.請求回数
    and s0.行 = a0.行
)

select
    *
from
    v0 as v000
