with v0 as
(
SELECT
	a.日付
,	a.年度
,	a.年
,	a.月
,	a.日
,	a.週
,	a.業務週
,	a.月間週
,	a.曜日
,	a.曜日名
,	a.平日区分
,
	convert(nvarchar(10),
		case
			a.平日区分
			when  0 then N'休日'
			when  1 then N'平日'
		end
	)
	as 平日内容
,	a.稼働区分
,
	convert(nvarchar(10),
		case
			a.稼働区分
			when -1 then N'定休日'
			when  0 then N'公休日'
			when  1 then N'稼働日'
		end
	)
	as 稼働内容
,	d.祝日名
,	b.年号
,	b.年号略称
,	b.年 as 和暦年
,
	convert(nvarchar(100),
		b.年号 +
		convert(nvarchar(4),b.年) +
		N'年'
	)
	as 和暦年表示
,
	convert(nvarchar(100),
		b.年号 +
		convert(nvarchar(4),b.年) +
		N'年' +
		convert(nvarchar(4),month(a.日付)) +
		N'月' +
		convert(nvarchar(4),day(a.日付)) +
		N'日'
	)
	as 和暦日付
,
	convert(nvarchar(100),
		b.年号略称 +
		convert(nvarchar(4),b.年)
	)
	as 和暦年表示略称
,
	convert(nvarchar(100),
		b.年号略称 +
		convert(nvarchar(4),b.年) +
		N'.' +
		convert(nvarchar(4),month(a.日付)) +
		N'.' +
		convert(nvarchar(4),day(a.日付))
	)
	as 和暦日付略称
FROM
	カレンダ_T as a
LEFT OUTER JOIN
	祝日_T as d
	ON d.日付 = a.日付
LEFT OUTER JOIN
	和暦_T as b
	ON b.西暦 = a.年
)

SELECT
	*
FROM
	v0 as v000
