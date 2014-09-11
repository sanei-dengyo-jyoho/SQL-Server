with

v0 as
(
select
	ユーザ名
,	ログオン

from
	ログオン履歴_T as a0

where
	( システム名 = 'system' )
	and ( isnull(ユーザ名,'') <> '' )
)
,

v1 as
(
select
	a1.システム名
,	a1.年
,	a1.月
,	a1.日
,	a1.ユーザ名
,	a1.プログラム名
,	a1.コンピュータ名
,	a1.日付
,	a1.年月
,	a1.週
,	a1.時刻

from
	ログオン履歴_Tプログラム名 as a1

where
	( not exists
		(
		select
			1 AS exp
		from
			ログオン履歴_Tプログラム名 as b1
		where
			( b1.システム名 = a1.システム名)
			and ( b1.年 = a1.年 )
			and ( b1.月 = a1.月 )
			and ( b1.日 = a1.日 )
			and ( b1.ユーザ名 = a1.ユーザ名 )
			and ( b1.時刻 > a1.時刻)
		)
	)
)
,

v2 as
(
select
	a2.システム名
,	a2.コンピュータ名
,	a2.ユーザ名
,	b2.社員コード
,	a2.年月
,	a2.週
,	a2.日付
,	c2.曜日名
,	ISNULL(w2.年号,'') + dbo.FuncGetNumberFixed(ISNULL(w2.年,0),DEFAULT) + '年' + dbo.FuncGetNumberFixed(MONTH(a2.日付),DEFAULT) + '月' + dbo.FuncGetNumberFixed(DAY(a2.日付),DEFAULT) + '日' + ' (' + ISNULL(c2.曜日名,'') + ') ' AS 日付表示
,	c2.稼働区分
,	c2.年度
,	a2.開始時刻
,	a2.ログオン時刻
,	a2.ログオフ時刻
,	a2.ログオン時間分
,	a2.ログオン時間分 as ログオン時間
,	x2.ログオン
,	y2.プログラム名

from
	ログオン履歴_T as a2
left outer join
	ユーザ_T as b2
	on b2.ユーザ名 = a2.ユーザ名
left outer join
	カレンダ_T as c2
	on c2.日付 = a2.日付
left outer join
	和暦_T as w2
	ON w2.西暦 = YEAR(a2.日付)
left outer join
	v0 as x2
	on x2.ユーザ名 = a2.ユーザ名
left outer join
	v1 as y2
	on y2.日付 = a2.日付
	and y2.システム名 = a2.システム名
	and y2.ユーザ名 = a2.ユーザ名

where
	( isnull(a2.年月,0) <> 0 )
)

select
	*

from
	v2 as a3

