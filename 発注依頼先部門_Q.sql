with

v0 as
(
select top 1
	s0.年度
,	s0.部門コード
,	s0.部名
,	s0.部門名
,	s0.部門名略称
,
   (
    select top 1
        w0.年号
    from
        和暦_T as w0
    where
        ( w0.西暦 = year(getdate()) )
    ) +
    N'　　　年　　　月　　　日'
    as 承認日付ラベル
from
	発注依頼先部門_T as a0
left outer join
    部門_Q異動履歴_全階層順 as s0
    on s0.年度 >= a0.年度
    and s0.部門コード = a0.部門コード
order by
	s0.年度 desc
,	s0.部門レベル
,	s0.部門コード
)

select
    *
from
    v0 as v000
