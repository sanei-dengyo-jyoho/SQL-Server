with

v0 as
(
select
    yb0.システム名
,	dbo.FuncMakeConstructNumber(ya0.工事年度,ya0.工事種別,ya0.工事項番) AS 工事番号
,	ya0.工事年度
,	ya0.工事種別
,	ya0.工事項番
,	ya0.請求回数
,	yx0.行
,	yb0.工事種別名
,	yb0.工事種別コード
,	qe0.会社コード
,	qe0.会社名
,	qe0.住所
,	convert(varchar(50),qe0.TEL) as TEL
,	convert(varchar(50),qe0.FAX) as FAX
,	g0.銀行名
,	concat(N'(',isnull(g0.銀行コード,''),N')') as 銀行コード
,	g0.支店名
,	concat(N'(',isnull(g0.支店コード,''),N')') as 支店コード
,	g0.口座種別
,	concat(N'№ ',convert(nvarchar(10),isnull(g0.口座番号,''))) as 口座番号
,	g0.口座名義
,	ya0.請求先名
,	ya0.請求日付
,
    concat(
       (
        select top 1
            w0.年号
        from
            和暦_T as w0
        where
            ( w0.西暦 = year(getdate()) )
        ),
        N'　　　年　　　月　　　日'
    )
    as 請求日付ラベル
,	ya0.発行日付
,	qb0.工事件名
,	qb0.工事場所
,	ya0.請求本体金額
,	ya0.請求消費税率
,	ya0.請求消費税額
,	ys0.名称
,	ys0.数量
,	ys0.単位
,	ys0.単価
,	ys0.金額
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
    当社_Q内線 as qe0
    on qe0.年度 = ya0.工事年度
left outer join
    会社_T振込先 as g0
    on g0.会社コード = qe0.会社コード
outer apply
    (
    select top 100 percent
        x2.数値 as 行
    from
    	dbo.FuncViewConstConditionsInit(N'請求書内訳の行数') as x2
    where
        ( x2.システム名 = yb0.システム名 )
    order by
        x2.数値
    )
    as yx0
left outer join
    請求_T内訳 as ys0
    on ys0.工事年度 = ya0.工事年度
    and ys0.工事種別 = ya0.工事種別
    and ys0.工事項番 = ya0.工事項番
    and ys0.請求回数 = ya0.請求回数
    and ys0.行 = yx0.行
where
    ( isnull(ya0.振替先部門コード,'') = '' )
)

select
    *
from
    v0 as v000
