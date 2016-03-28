with

v0 as
(
select distinct
   	a0.年度
,	a0.部門コード
,	s0.部門名
,	s0.部門名略称
,	a0.[伝票№]
,   a0.行数
,   format(GETDATE(),'d') as 発行日付
,   isnull(d0.和暦日付,N'') as 和暦発行日付
,   a0.日付
,   isnull(d1.和暦日付,N'') as 和暦日付
,   a0.年
,   a0.月
,   a0.年月
,   a0.工事年度
,   a0.工事種別
,   a0.工事項番
,   a0.登録部門コード
,	s2.部門名 as 登録部門名
,	s2.部門名略称 as 登録部門名略称
,   a0.登録社員コード
,	e2.氏名 as 登録氏名
from
    備品購入_T as a0
left outer join
    カレンダ_Q AS d0
    on d0.日付 = format(GETDATE(),'d')
left outer join
    カレンダ_Q AS d1
    on d1.日付 = a0.日付
left outer join
    部門_T年度 as s0
    on s0.年度 = a0.年度
    and s0.部門コード = a0.部門コード
left outer join
    部門_T年度 as s2
    on s2.年度 = a0.年度
    and s2.部門コード = a0.登録部門コード
left outer join
    社員_T年度 as e2
    on e2.年度 = a0.年度
    and e2.社員コード = a0.登録社員コード
)

select
    *
from
    v0 as v000
